#!/bin/bash

# Flags
m_flag=''
v_flag=''
d_flag=''
f_flag=''
c_flag=''
p_flag=''
e_flag=''
while getopts 'm:v:f:c:d:p:e:' flag; do
  case "${flag}" in
  m) m_flag="${OPTARG}" ;;
  v) v_flag="${OPTARG}" ;;
  d) d_flag="${OPTARG}" ;;
  f) f_flag="${OPTARG}" ;;
  c) c_flag="${OPTARG}" ;;
  p) p_flag="${OPTARG}" ;;
  e) e_flag="${OPTARG}" ;;
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
  local singleChoice=$4

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

    if [[ $singleChoice == "true" ]]; then
      for ((i = 0; i < ${#selected[@]}; i++)); do
        if [[ ${selected[i]} == "true" ]]; then
          selected[i]="false"
        fi
      done
    fi

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

###############
# Development #
###############
function devBuildWebserver {
  printf "$(tput setaf 2)\n\nBuilding Webserver...$(tput sgr0)\n\n"
  docker build -t webserver . 0>/dev/null
}
function devRunWebserver {
  printf "$(tput setaf 2)\n\nStating Webserver...$(tput sgr0)\n\n"

  # If v_flag is set, use the path specified by the user
  local frontendPath=$f_flag
  local configPath=$c_flag
  local domain=$d_flag
  local port=$p_flag

  # Display error message if webserver is already running
  if [ $(docker ps -a -f name=webserver | wc -l) -gt 1 ]; then
    echo "$(tput bold)$(tput setaf 1)Webserver already running$(tput sgr0)"
    return 1
  fi

  while true; do
    # If domain is not set, ask the user for the path
    if [ -z "$domain" ]; then
      read -e -p "$(tput setaf 4)What is your domain: $(tput sgr0)" domain
      printf "\n"
    fi

    # If frontendPath is not set, ask the user for the path
    if [ -z "$frontendPath" ]; then
      echo "$(tput setaf 3)Enter the path to the frontend"
      read -e -p "$(tput setaf 4)Leave blank for CWD ($( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/frontend/): $(tput sgr0)" frontendPath
      printf "\n"
    fi

    # If configPath is not set, ask the user for the path
    if [ -z "$configPath" ]; then
      echo "$(tput setaf 3)Enter the path to the config"
      read -e -p "$(tput setaf 4)Leave blank for CWD ($( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/nginx/webserver.conf): $(tput sgr0)" configPath
      printf "\n"
    fi

    # If port is not set, ask the user for the path
    if [ -z "$port" ]; then
      echo "$(tput setaf 3)What port should the webserver listen on?"
      read -e -p "$(tput setaf 4)Leave blank for port 8080: $(tput sgr0)" port
      printf "\n"
    fi


    # Check agian if frontendPath is not set, if so set it to the CWD
    if [ -z "$frontendPath" ]; then
      frontendPath=$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"/frontend/"
    fi

    # Check agian if configPath is not set, if so set it to the CWD
    if [ -z "$configPath" ]; then
      configPath=$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"/nginx/webserver.conf"
    fi

    # Check agian if port is not set, if so set it to the default
    if [ -z "$port" ]; then
      port=8080
    fi


    # If domain is not a file, ask the user for the path again
    if [ -z "$domain" ]; then
      printf "$(tput bold)$(tput setaf 1)$domain is not a valid domain$(tput sgr0)\n\n"
      unset domain
      continue
    fi

    # If frontendPath is not a directory, ask the user for the path again
    if [ ! -d "$frontendPath" ]; then
      printf "$(tput bold)$(tput setaf 1)$frontendPath is not a directory$(tput sgr0)\n\n"
      unset frontendPath
      continue
    fi

    # If configPath is not a file, ask the user for the path again
    if [ ! -f "$configPath" ]; then
      printf "$(tput bold)$(tput setaf 1)$configPath is not a file$(tput sgr0)\n\n"
      unset configPath
      continue
    fi

    # If port is not a file, ask the user for the path again
    if ! [[ $port =~ ^[0-9]+$ && $port -lt 10000  ]]; then
      printf "$(tput bold)$(tput setaf 1)$port is not a valid port$(tput sgr0)\n\n"
      unset port
      continue
    fi

    # If domain is valid, frontendPath is a directory, configPath is a file and port is valid, break the loop
    break
  done

  # If frontendPath is a directory, start the webserver
  docker run -it --rm -d -p ${port}:80 --name webserver -v ${frontendPath}:/var/www/${domain} -v ${configPath}:/etc/nginx/sites-enabled/${domain} webserver
}
function devReloadWebserver {
  printf "$(tput setaf 2)\n\nReloading Webserver...$(tput sgr0)\n\n"
  docker kill -s HUP webserver
}
function devStopWebserver {
  printf "$(tput setaf 2)\n\nStopping Webserver...$(tput sgr0)\n\n"
  docker stop webserver
}
function devPruneDocker {
  printf "$(tput setaf 2)\n\nPruning Docker...$(tput sgr0)\n\n"
  docker system prune -a -f
}
function devMenu {
  my_options=("Build webserver,Run webserver,Reload webserver,Stop webserver,Prune docker")
  preselection=("false,false,false,false")
  multiselect result "\${my_options}" "\${preselection}"

  for ((i = 0; i < ${#result[@]}; i++)); do
    if [[ ${result[i]} = "true" ]]; then
      case ${i} in
      0)
        devBuildWebserver
        ;;
      1)
        devRunWebserver
        ;;
      2)
        devReloadWebserver
        ;;
      3)
        devStopWebserver
        ;;
      4)
        devPruneDocker
        ;;
      esac
    fi
  done
}

##############
# Production #
##############
function prodBuildWebserver {
  printf "$(tput setaf 2)\n\nBuilding Webserver...$(tput sgr0)\n\n"
  docker build -t webserver . 0>/dev/null
}
function prodRunWebserver {
  printf "$(tput setaf 2)\n\nStating Webserver...$(tput sgr0)\n\n"

  # If v_flag is set, use the path specified by the user
  local frontendPath=$f_flag
  local configPath=$c_flag
  local domain=$d_flag

  # Display error message if webserver is already running
  if [ $(docker ps -a -f name=webserver | wc -l) -gt 1 ]; then
    echo "$(tput bold)$(tput setaf 1)Webserver already running$(tput sgr0)"
    return 1
  fi

  while true; do
    # If domain is not set, ask the user for it
    if [ -z "$domain" ]; then
      read -e -p "$(tput setaf 4)What is your domain: $(tput sgr0)" domain
      printf "\n"
    fi

    # If frontendPath is not set, ask the user for the path
    if [ -z "$frontendPath" ]; then
      echo "$(tput setaf 3)Enter the path to the frontend"
      read -e -p "$(tput setaf 4)Leave blank for CWD ($( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/frontend/): $(tput sgr0)" frontendPath
      printf "\n"
    fi

    # If configPath is not set, ask the user for the path
    if [ -z "$configPath" ]; then
      echo "$(tput setaf 3)Enter the path to the config"
      read -e -p "$(tput setaf 4)Leave blank for CWD ($( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/nginx/webserver.conf): $(tput sgr0)" configPath
      printf "\n"
    fi


    # Check agian if frontendPath is not set, if so set it to the CWD
    if [ -z "$frontendPath" ]; then
      frontendPath=$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"/frontend/"
    fi

    # Check agian if configPath is not set, if so set it to the CWD
    if [ -z "$configPath" ]; then
      configPath=$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"/nginx/webserver.conf"
    fi


    # If domain is not a file, ask the user for the path again
    if [ -z "$domain" ]; then
      printf "$(tput bold)$(tput setaf 1)$domain is not a valid domain$(tput sgr0)\n\n"
      unset domain
      continue
    fi

    # If frontendPath is not a directory, ask the user for the path again
    if [ ! -d "$frontendPath" ]; then
      printf "$(tput bold)$(tput setaf 1)$frontendPath is not a directory$(tput sgr0)\n\n"
      unset frontendPath
      continue
    fi

    # If configPath is not a file, ask the user for the path again
    if [ ! -f "$configPath" ]; then
      printf "$(tput bold)$(tput setaf 1)$configPath is not a file$(tput sgr0)\n\n"
      unset configPath
      continue
    fi

    # If domain is valid, frontendPath is a directory and configPath is a file, break the loop
    break
  done

  # If domain is valid, frontendPath is a directory, configPath is a file, break the loop
  docker run -it --rm -d -p 80:80 -p 443:443 --name webserver -v ${frontendPath}:/var/www/${domain} -v ${configPath}:/etc/nginx/sites-enabled/${domain} webserver
}
function prodInstallCert {
  printf "$(tput setaf 2)\n\nInstalling Certificate...$(tput sgr0)\n\n"

  local domain=$d_flag
  local email=$e_flag

  while true; do
    # If domain is not set, ask the user for it
    if [ -z "$domain" ]; then
      read -e -p "$(tput setaf 4)What is your domain: $(tput sgr0)" domain
      printf "\n"
    fi

    # If email is not set, ask the user for the it
    if [ -z "$email" ]; then
      read -e -p "$(tput setaf 4)What is your email: $(tput sgr0)" email
      printf "\n"
    fi


    # If domain is not valid, ask the user for it
    if [ -z "$domain" ]; then
      printf "$(tput bold)$(tput setaf 1)$domain is not a valid domain$(tput sgr0)\n\n"
      unset domain
      continue
    fi

    # If email is not valid, ask the user for it
    if [[ ! "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$ ]]; then
      printf "$(tput bold)$(tput setaf 1)$email is not a valid email$(tput sgr0)\n\n"
      unset email
      continue
    fi

    # If domain is valid and email is valid, break the loop
    break
  done

  # If domain is valid and email is valid, break the loop
  docker exec -ti webserver certbot --nginx --email ${email} --agree-tos --no-eff-email --redirect -d ${domain}
}
function prodReloadWebserver {
  printf "$(tput setaf 2)\n\nReloading Webserver...$(tput sgr0)\n\n"
  docker kill -s HUP webserver
}
function prodStopWebserver {
  printf "$(tput setaf 2)\n\nStopping Webserver...$(tput sgr0)\n\n"
  docker stop webserver
}
function prodPruneDocker {
  printf "$(tput setaf 2)\n\nPruning Docker...$(tput sgr0)\n\n"
  docker system prune -a -f
}
function prodMenu {
  my_options=("Build webserver,Run webserver,Install Certificate,Reload webserver,Stop webserver,Prune docker")
  preselection=("false,false,false,false,false")
  multiselect result "\${my_options}" "\${preselection}"

  for ((i = 0; i < ${#result[@]}; i++)); do
    if [[ ${result[i]} = "true" ]]; then
      case ${i} in
      0)
        prodBuildWebserver
        ;;
      1)
        prodRunWebserver
        ;;
      2)
        prodInstallCert
        ;;
      3)
        prodReloadWebserver
        ;;
      4)
        prodStopWebserver
        ;;
      5)
        prodPruneDocker
        ;;
      esac
    fi
  done
}
function chooseEnv {
  my_options=("Development Webserver,Production Webserver")
  preselection=("false,false")
  multiselect result "\${my_options}" "\${preselection}" true

  for ((i = 0; i < ${#result[@]}; i++)); do
    if [[ ${result[i]} = "true" ]]; then
      case ${i} in
      0)
        printf "$(tput bold)$(tput setaf 3)\n\nDevelopment Menu$(tput sgr0)\n\n"
        devMenu
        ;;
      1)
        printf "$(tput bold)$(tput setaf 3)\n\nProduction Menu$(tput sgr0)\n\n"
        prodMenu
        ;;
      esac
    fi
  done
}

case $m_flag in
dev | development)
  devMenu
  ;;
prod | production)
  prodMenu
  ;;
*)
  chooseEnv
  ;;
esac
