#!/bin/bash

#
# a simple way to parse shell script arguments
# 
# please edit and use to your hearts content
# 



MKDOCS="my-project"

function usage()
{
    echo "mkdockerize for buidling and serving the mkdocs project using Docker "
    echo ""
    echo "./mkdockerize.sh"
    echo -e "-h --help"
    echo -e "--produce=PROJECT-DIR"
    echo -e "--serve {For running the mkdocs project inside docker}"
    echo -e "--build {For Buidling the Docker Image}"
    echo ""
}

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        -h | --help)
            usage
            exit
            ;;
        --produce)
            WORK_DIR=$PWD
            if [ ! -d "$VALUE" ]; then
                echo -e 'Unable to Locate Mkdocs Directory. Please Use the Correct Argument'
                echo -e '=================================================================='
                echo -e 'docker run -v $PWD:/var/mkdocs mkdocs produce <directoryName>'
                echo -e 'docker run -v $PWD:/var/mkdocs mkdocs produce my-project'
                echo -e '=================================================================='
                exit 1
            fi

            echo -e "Validating $VALUE"

            #Switch to mkdocs Directory
            cd "$VALUE"
            #Check mkdocs.yml file exist 
            if [ ! -f "mkdocs.yml" ]; then
                echo 'Unable to Locate mkdocs.yml config file '
                exit 1
            fi

            cd ..
            echo "MKDOCS Directory is Valid Producting site.tar.gz file"
            docker run -v $PWD:/var/mkdocs mkdocs produce  $VALUE

            ;;
        --serve)
            if [ ! -f "site.tar.gz" ]; then
                echo -e 'Unable to locate mkdocs [site.tar.gz] tar file, Please generate it by issuing the below command '
                echo -e '=================================================================='
                echo -e './mkdockerize.sh  --produce=my-project'
                echo -e '=================================================================='
                exit 1
            fi
            echo -e "Starting the mkdocs server on port 8000"

            CONTAINER=`docker ps | grep mkdocs | awk -F" " '{print $1}'`

            if [ -z "$CONTAINER" ]
                then
                     docker run -d -p 8000:8000 -v $PWD:/var/mkdocs mkdocs serve
                     CONTAINER=`docker ps | grep mkdocs | awk -F" " '{print $1}'`
                     echo -e "Docker Container $CONTAINER started on port 8000" 
                else
                      
                      docker kill $CONTAINER
                      docker run -d -p 8000:8000 -v $PWD:/var/mkdocs mkdocs serve
                      CONTAINER=`docker ps | grep mkdocs | awk -F" " '{print $1}'`
                      echo -e "Docker Container $CONTAINER started on port 8000" 

            fi

            ;;
         --build)
            echo  "Executing docker build -t mkdocs . "
            echo  "-------------------"
            docker build -t mkdocs .
            echo  "-------------------"
            ;;    
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            usage
            exit 1
            ;;
    esac
    shift
done
