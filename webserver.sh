#!/bin/bash

# Flags
e_flag=''
v_flag=''
while getopts 'e:v:' flag; do
  case "${flag}" in
  e) e_flag="${OPTARG}" ;;
  v) v_flag="${OPTARG}" ;;
  esac
done

# Print instructions
echo "$(tput setaf 3)"
printf "\n"
echo "↑/↓     (arrow keys) or j/k to navigate up or down
⎵       (Space) to toggle the selection
⏎       (Enter) to confirm the selections
CTL+C   (CTL+Z) to exit the script"
echo $(tput sgr0)

# This is a costomized script of https://unix.stackexchange.com/a/673436
function multiselect {
  printf "$(tput setaf 4)"
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
        prefix="[$(tput setaf 2)✔$(tput setaf 4)]"
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
  cursor_blink_on

  eval $return_value='("${selected[@]}")'
  printf $(tput sgr0)
}

# Functions
function buildWebserver {
  printf "$(tput setaf 2)\n\nBuilding Webserver...$(tput sgr0)\n\n"
  docker build -t webserver . 0>/dev/null
}
function runWebserver {
  printf "$(tput setaf 2)\n\nStating Webserver...$(tput sgr0)\n\n"
  if [[ -d $v_flag || -f $v_flag ]]; then
    docker run -it --rm -d -p 80:80 -p 443:443 --name webserver --mount type=bind,source=$v_flag,target=/var/www/icebear.se webserver
  elif [[ $v_flag == '' ]]; then
    docker run -it --rm -d -p 80:80 -p 443:443 --name webserver --mount type=bind,source="$(pwd)"/frontend/,target=/var/www/icebear.se webserver
  else
    printf "$(tput bold)$(tput setaf 1)Please provide a valid path to the frontend folder$(tput sgr0)\n"
    printf "\n"
    exit 1
  fi
}
function installCert {
  printf "$(tput setaf 2)\n\nInstalling Certificate...$(tput sgr0)\n\n"
  docker exec -ti webserver certbot --nginx --email admin@gnusson.net --agree-tos --no-eff-email --redirect -d icebear.se
}
function stopWebserver {
  printf "$(tput setaf 2)\n\nStopping Webserver...$(tput sgr0)\n\n"
  docker stop webserver
}
function pruneDocker {
  printf "$(tput setaf 2)\n\nPruning Docker...$(tput sgr0)\n\n"
  docker system prune -a -f
}
function devMenu {
  my_options=("Build webserver,Run webserver,Install Certificate,Stop webserver,Prune docker")
  preselection=("false,false,false,false")
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
        installCert
        ;;
      3)
        stopWebserver
        ;;
      4)
        pruneDocker
        ;;
      esac
    fi
  done
}
function chooseEnv {
  my_options=("Development,Production")
  preselection=("false,false")
  multiselect result "\${my_options}" "\${preselection}"

  for ((i = 0; i < ${#result[@]}; i++)); do
    if [[ ${result[i]} = "true" ]]; then
      case ${i} in
      0)
        printf "$(tput bold)$(tput setaf 3)\n\nDevelopment Menu$(tput sgr0)\n\n"
        devMenu
        ;;
      1)
        printf "$(tput bold)$(tput setaf 3)\n\nProduction Menu$(tput sgr0)\n\n"
        devMenu
        ;;
      esac
    fi
  done
}

case $e_flag in
dev | development)
  devMenu
  ;;
prod | production)
  devMenu
  ;;
*)
  chooseEnv
  ;;
esac
