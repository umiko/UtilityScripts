#!/bin/bash
#
#   AUTHOR:
#   umiko (https://github.com/umiko)
#   Permission to copy and modify is granted under the MIT license
#   
#   DESCRIPTION:
#   A small script to create the ideal CMake Project structure according to https://cliutils.gitlab.io/modern-cmake/
#

#
# Forward Declarations
#

function usage () {
    printf "Usage: CreateCMakeProject [ProjectName] [Options]\n";
}

#
# Parameter Parsing
#

# check if there are parameters
if [[ $# -ge 1 ]]; then
    PROJECT_NAME=$1;
    # iterate over other parameters
    while [ "$1" != "" ]; do
        case $1 in
            -g | --git )            usage
                                    exit
                                    ;;
            -h | --help )           usage
                                    exit
                                    ;;
            * )                     if [[ $PROJECT_NAME != $1 ]]; then
                                        usage
                                        exit 1
                                    fi
                                    ;;
        esac
        shift
    done
    
else
    usage;
fi

#
# Project Creation
#

# check if name already exists
if [[ ! -e $PROJECT_NAME ]]; then

    printf "Directory does not exist yet, creating...\n"
    mkdir $PROJECT_NAME;
    cd $PROJECT_NAME;
    printf "Entered new directory, creating default structure...\n"

else
    printf "A file or directory named \"$PROJECT_NAME\" already exists. Please specify an unused name."
fi