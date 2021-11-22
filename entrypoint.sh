#!/bin/bash

###### GLOBAL VARS ######
args=($@) #arguments $1 $2 $3 ...
AUTHOR=RO #Author
LOG_FILE=./logs/entrypoint.log
VERSION=1.0                #Version using Semantic Versioning
COMMAND_NAME=ro-cli-docker #Command name

#Associative Array
declare -A environment=(
  [-n]="REPOSITORY"
  [-p]="PASSWORD"
  [-u]="USERNAME"
  [-v]="version"
  [-b]="build"
  [-h]="usage"
  [-t]="TAG"
  [-ph]="push_repository"
  [-bph]="Build and push repository"
)
#Contains the arguments that are required flags
declare -A required_fields=(
  [-n]=true
  [-u]=true
  [-p]=true
  [-t]=true
)

#Contains the arguments thar are optional flags
#The actions are process that will be executed
declare -A actions=(
  [-h]=usage
  [-b]=building_stage
  [-v]=version
  [-ph]=push_repository
  [--help]=usage
  [--build]=build
  [--version]=version
  [-bph]=build_push_image
  [--push]=push_repository
  [--name_repository]=build
  [--build_push]=push_repository
)

declare -A commands=(
  [--help]="usage"
  [--build]="build"
  [--version]="version"
  [-b]="Build the image"
  [-ph]="Push the repository"
  [--push]="push_repository"
  [-bph]="build and push_repository"
  [--build_push]="build and push_repository"
)

declare -A vars
###### FUNCTIONS ######

version() {
  cat <<EOT
  _____   ____     _____ _      _____      _____   ____   _____ _  ________ _____  
 |  __ \ / __ \   / ____| |    |_   _|    |  __ \ / __ \ / ____| |/ /  ____|  __ \ 
 | |__) | |  | | | |    | |      | |______| |  | | |  | | |    | ' /| |__  | |__) |
 |  _  /| |  | | | |    | |      | |______| |  | | |  | | |    |  < |  __| |  _  / 
 | | \ \| |__| | | |____| |____ _| |_     | |__| | |__| | |____| . \| |____| | \ \ 
 |_|  \_\ ____/   \_____|______|_____|    |_____/ \____/ \_____|_|\_\______|_|  \_\
                                                                                                                                    
                                                                              
  ###### VERSION $VERSION ######
  Using $COMMAND_NAME $VERSION ($AUTHOR)
EOT
}

usage() {

  cat <<EOT

  +++++++++++++ USAGE +++++++++++++

  Usage:  $COMMAND_NAME [COMMAND] [ARGUMENTS]  (RO)

  Options: 
  
  - #BUILD IMAGE: $COMMAND_NAME -b -n $COMMAND_NAME -u ro -p xxxx -t v1.0.0

  - #PUSH REPOSITORY: $COMMAND_NAME -ph -n $COMMAND_NAME -u ro -p xxxx -t v1.0.0
  
  - #BUILD AND PUSH: $COMMAND_NAME -bph -n $COMMAND_NAME -u ro -p xxxx -t v1.0.0

  Options:

    -n,   --name-repository     string     Name of the repository
    -t,   --tag                 string     Tag for repository
    -p,   --docker_password     string     Password from Dockerhub
    -u,   --docker_username     string     Username from Dockerhub
    -h,   --help                command    Show usage for $COMMAND_NAME
    -v,   --version             command    Print version of $COMMAND_NAME information and quit
    -b,   --build               command    Build image using Dockerfile
    -ph,  --push                command    Push repository to DockerHub
    -bph, --build_push          command    Mix command build and Push command
EOT
}

# --------------- Start validation stage ---------------
validate_argumets() {
  declare -i length=${#args[@]} #length of the arguments array
  regex='^-'                    #regex to validate if current argument has a - simbol

  for ((i = 1; i <= $((length - 1)); i++)); do

    current_argument=${args[$i]}
    next_argument=${args[$i + 1]}

    #validates if the current argument is a flag, that means it's position must be odd
    if $([[ $((i % 2)) -eq 1 ]]); then
      #validates if the current argument has a - simbol
      if ! [[ $current_argument =~ $regex ]]; then
        echo "MSG: invalid argument $current_argument"
        echo "Line: #${LINENO} MSG: invalid argument $current_argument" >>$LOG_FILE
        exit 1
      fi

      validate_required_fileds $current_argument $next_argument
    fi
  done
}

#Validates if the argument is a required field
validate_required_fileds() {
  current_arg=$1 #current argument examp: -n
  value=$2       #value from current arg  example: -n=my_repo

  # checks if the current arg is required

  if ! [[ -v "required_fields[$current_arg]" ]]; then
    echo "$current_arg is not an option:  ${!required_fields[@]} are required"
    echo "Line: #${LINENO} -  $current_arg is not an option: ${!required_fields[@]} are required" >>$LOG_FILE
    exit 1
  fi

  # if it is required, checks if the value is not empty
  if [[ -z $value ]]; then
    echo "MSG: $current_arg needs a value "
    echo "Line: #${LINENO} MSG: $current_arg needs a value " >>$LOG_FILE
    exit 1
  fi

  # push the value to the associative array
  vars[${environment[$current_arg]}]=$value #associates the value to the key
}
# --------------- End validation stage ---------------

# --------------- Start create Vars---------------
# create the vars array with the values from the arguments
setVars() {
  check_required_variables
  for var in "${!vars[@]}"; do
    declare -g "$var"="${vars[$var]}" #declare the variable in global scope
  done
}

check_required_variables() {
  command=${args[0]}
  if ! [[ ${#vars[@]} -eq ${#required_fields[@]} ]]; then
    echo "MSG: To ${commands[$command]} it needs flags ${!required_fields[@]}"
    echo "Line: #${LINENO} MSG: To ${commands[$command]} it needs flags ${!required_fields[@]}" >>$LOG_FILE

    exit 1
  fi
}
# --------------- End create Vars---------------

# --------------- Start building stage ---------------
building_stage() {
  version
  build_image
}

build_image() {
  docker build -t $USERNAME/$REPOSITORY:$TAG .
}

build_push_image() {
  building_stage
  push_repository
}
# --------------- End building stage ---------------

push_repository() {
  login_dockerhub
  docker push $USERNAME/$REPOSITORY:$TAG
}

# --------------- Start credentials ---------------
login_dockerhub() {
  echo "Logging in dockerhub"
  echo $PASSWORD | docker login -u $USERNAME --password-stdin
}
# End Login
log_out() {
  echo "Logging out from dockerhub"
  docker logout
}

# --------------- Start Commands stage---------------
use_command() {
  check_command_syntax
  validate_argumets
  setVars
  command=${args[0]} #current tag argument example: -b
  execute_action $command
}

check_command_syntax() {

  if ! [[ -v "environment[${args[0]}]" ]]; then

    # If the command does not exists will throw error.
    echo " Argument: << ${args[0]} >> is not a $COMMAND_NAME command, please see the usage."
    echo "Syntax Error on line: #${LINENO} - Argument: << ${args[0]} >> is not a $COMMAND_NAME command, please see the usage. " >>$LOG_FILE

    usage # Prints the usage
    exit 1
  fi
}

execute_action() {
  command_name=$1
  ${actions[$command_name]} #Execute action function. Action function is defined in actions array.
}
# --------------- End Commands stage---------------

# --------------- Init stage ---------------
init() {
  log_out
  use_command
}
# --------------- End Init stage ---------------

init
