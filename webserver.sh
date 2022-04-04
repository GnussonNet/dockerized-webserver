#!/bin/bash

function multiselect {
  # little helpers for terminal print control and key input
  ESC=$(printf "\033")
  cursor_blink_on() { printf "$ESC[?25h"; }
  cursor_blink_off() { printf "$ESC[?25l"; }
  cursor_to() { printf "$ESC[$1;${2:-1}H"; }
  print_inactive() { printf "$2   $1 "; }
  print_active() { printf "$2  $ESC[7m $1 $ESC[27m"; }
  get_cursor_row() {
    IFS=';' read -sdR -p $'\E[6n' ROW COL
    echo ${ROW#*[}
  }

  local return_value=$1
  eval my_options="$2"
  eval preselection="$3"

  IFS=',' read -r -a options <<<"$my_options"
  IFS=',' read -r -a defaults <<<"$preselection"

  local selected=()
  for ((i = 0; i < ${#options[@]}; i++)); do
    if [[ ${defaults[i]} = "true" ]]; then
      selected+=("true")
    else
      selected+=("false")
    fi
    printf "\n"
  done

  # determine current screen position for overwriting the options
  local lastrow=$(get_cursor_row)
  local startrow=$(($lastrow - ${#options[@]}))

  # ensure cursor and input echoing back on upon a ctrl+c during read -s
  trap "cursor_blink_on; stty echo; printf '\n'; exit" 2
  cursor_blink_off

  key_input() {
    local key
    IFS= read -rsn1 key 2>/dev/null >&2
    if [[ $key = "" ]]; then echo enter; fi
    if [[ $key = $'\x20' ]]; then echo space; fi
    if [[ $key = "k" ]]; then echo up; fi
    if [[ $key = "j" ]]; then echo down; fi
    if [[ $key = $'\x1b' ]]; then
      read -rsn2 key
      if [[ $key = [A || $key = k ]]; then echo up; fi
      if [[ $key = [B || $key = j ]]; then echo down; fi
    fi
  }

  toggle_option() {
    local option=$1
    if [[ ${selected[option]} == true ]]; then
      selected[option]=false
    else
      selected[option]=true
    fi
  }

  print_options() {
    # print options by overwriting the last lines
    local idx=0
    for option in "${options[@]}"; do
      local prefix="[ ]"
      if [[ ${selected[idx]} == true ]]; then
        prefix="[\e[38;5;46m✔\e[0m]"
      fi

      cursor_to $(($startrow + $idx))
      if [ $idx -eq $1 ]; then
        print_active "$option" "$prefix"
      else
        print_inactive "$option" "$prefix"
      fi
      ((idx++))
    done
  }

  local active=0
  while true; do
    print_options $active

    # user key control
    case $(key_input) in
    space)
      toggle_option $active
      ;;
    enter)
      quantityOfSelected=0
      for ((i = 0; i < ${#selected[@]}; i++)); do
        if [[ ${selected[i]} == "true" ]]; then
          quantityOfSelected+=1
        fi
      done
      if [[ $quantityOfSelected != 0 ]]; then
        print_options -1
        break
      fi
      ;;
    up)
      ((active--))
      if [ $active -lt 0 ]; then active=$((${#options[@]} - 1)); fi
      ;;
    down)
      ((active++))
      if [ $active -ge ${#options[@]} ]; then active=0; fi
      ;;
    esac
  done

  # cursor position back to normal
  cursor_to $lastrow
  printf "\n"
  printf "\n"
  cursor_blink_on

  eval $return_value='("${selected[@]}")'
}

##########################
#                        #
#       Functions        #
#                        #
##########################
function buildWebserver {
  docker build -t webserver .
}
function runWebserver {
  docker run -it --rm -d -p 80:80 --name webserver --mount type=bind,source="$(pwd)"/frontend/,target=/var/www/icebear.se webserver
}
function stopWebserver {
  docker stop webserver
}
function pruneDocker {
  docker system prune -a -f
}
function advancedMode {
  printf "\n"
  printf "\n"
  echo "This is the advanced mode. Please select the options you want to use."
  printf "\n"

  my_options=("Build webserver,Run webserver,Stop webserver")
  preselection=("false,false,false,false")

  # Call menu function
  multiselect result "\${my_options}" "\${preselection}"
}

my_options=("Build webserver,Run webserver,Stop webserver,Prune docker,Advanced Mode")
preselection=("false,false,false,false")

# Print instructions
printf "\n"
echo "↑/↓ (arrow keys) or j/k to navigate up or down
⎵ (Space) to toggle the selection
⏎ (Enter) to confirm the selections
CTL+C to quit"
printf "\n"
printf "\n"

multiselect result "\${my_options}" "\${preselection}"

for ((i = 0; i < ${#result[@]}; i++)); do
  if [[ ${result[i]} = "true" ]]; then
    case ${i} in
    0)
      buildWebserver
      ;;
    1)
      runWebserver
      ;;
    2)
      stopWebserver
      ;;
    3)
      pruneDocker
      ;;
    4)
      advancedMode
      ;;
    esac
  fi
done