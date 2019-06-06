#!/bin/bash

#   AUTHOR:
#   umiko (https://github.com/umiko)
#   Permission to copy and modify is granted under the MIT license
#   
#   DESCRIPTION:
#   A small script to create the ideal CMake Project structure according to https://cliutils.gitlab.io/modern-cmake/


#
# Forward Declarations
#

function usage () {
    printf "Usage: CreateCMakeProject [ProjectName] [Options]\n";
}

PROJECT_NAME="";
CREATE_CMAKE_BOILERPLATE=false;
CREATE_DOCUMENTATION_DIRECTORY=false;
CREATE_EXTERN_DIRECTORY=false;
CREATE_GIT_REPOSITORY=false;
CREATE_SCRIPTS_DIRECTORY=false;
CREATE_TESTS_DIRECTORY=false;
CMAKE_VERSION=$(cmake --version | awk '{print $3}' | grep -m1 "");

#
# Parameter Parsing
#

# check if there are parameters
if [[ $# -ge 1 ]]; then
    PROJECT_NAME=$1;
    shift;
    # iterate over parameters and set flags for project creation
    while [ "$1" != "" ]; do
        case $1 in
            -a | --all )            CREATE_CMAKE_BOILERPLATE=true;
                                    CREATE_DOCUMENTATION_DIRECTORY=true;
                                    CREATE_EXTERN_DIRECTORY=true;
                                    CREATE_GIT_REPOSITORY=true;
                                    CREATE_SCRIPTS_DIRECTORY=true;
                                    CREATE_TESTS_DIRECTORY=true;
                                    ;;

            -c | --cmake )          CREATE_CMAKE_BOILERPLATE=true;
                                    ;;

            -cv | --cmake-version ) shift;
                                    CMAKE_VERSION=$1;
                                    ;;

            -d | --docs )           CREATE_DOCUMENTATION_DIRECTORY=true;
                                    ;;

            -e | --extern )         CREATE_EXTERN_DIRECTORY=true;
                                    ;;

            -g | --git )            CREATE_GIT_REPOSITORY=true;
                                    ;;

            -h | --help )           usage;
                                    exit;
                                    ;;

            -s | --scripts )        CREATE_SCRIPTS_DIRECTORY=true;
                                    ;;

            -t | --tests )          CREATE_TESTS_DIRECTORY=true;
                                    ;;

            * )                     usage;
                                    exit;
                                    ;;
        esac
        shift;
    done
    
else
    usage;
    exit;
fi

#
# Project Creation
#

# check if name already exists
if [[ ! -e $PROJECT_NAME ]]; then
    printf "Project does not exist yet, creating project directory structure...\n"
    mkdir $PROJECT_NAME;
    mkdir $PROJECT_NAME/cmake;
    mkdir $PROJECT_NAME/include;
    mkdir $PROJECT_NAME/include/$PROJECT_NAME;
    mkdir $PROJECT_NAME/src;
    mkdir $PROJECT_NAME/apps;

    printf "Directory structure created, touching files...\n"
    touch $PROJECT_NAME/CMakeLists.txt;
    touch $PROJECT_NAME/src/CMakeLists.txt;
    touch $PROJECT_NAME/apps/CMakeLists.txt;

    if [ "$CREATE_DOCUMENTATION_DIRECTORY" = true ] ; then
        mkdir $PROJECT_NAME/docs;
    fi

    if [ "$CREATE_TESTS_DIRECTORY" = true ] ; then
        mkdir $PROJECT_NAME/tests;
    fi

    if [ "$CREATE_SCRIPTS_DIRECTORY" = true ] ; then
        mkdir $PROJECT_NAME/scripts;
    fi

    if [ "$CREATE_EXTERN_DIRECTORY" = true ] ; then
        mkdir $PROJECT_NAME/extern;
    fi

    # write top level cmake boilerplate
    if [ "$CREATE_CMAKE_BOILERPLATE" = true ] ; then
        cd $PROJECT_NAME;
        echo "cmake_minimum_required(VERSION $CMAKE_VERSION)" >> CMakeLists.txt;
        echo "project($PROJECT_NAME VERSION 1.0)" >> CMakeLists.txt;
        echo "set(CMAKE_MODULE_PATH \"\${PROJECT_SOURCE_DIR}/cmake\" \${CMAKE_MODULE_PATH})" >> CMakeLists.txt;
        cd ..;
    fi

    # do the git repo last, so all things are included
    if [ "$CREATE_GIT_REPOSITORY" = true ] ; then
        cd $PROJECT_NAME;
        echo "/build*" >> .gitignore;
        git init;
        git add .;
        git commit -m "Created CMake project structure."
        cd ..;
    fi;
else
    printf "A file or directory named \"$PROJECT_NAME\" already exists. Please specify an unused name."
fi
