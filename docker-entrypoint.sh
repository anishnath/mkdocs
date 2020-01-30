#!/bin/sh

set -e

echo -e "[Entrypoint] mkdocs docker image for generating site.tar.gz and serving the file over the HTTP Server"


if [ "$1" = 'produce' ]; then

  echo $2
  
  if [ ! -d "$2" ]; then
    echo -e 'Unable to Locate Mkdocs Directory. Please Use the Correct Argument'
    echo -e '=================================================================='
    echo -e 'docker run -v $PWD:/var/mkdocs mkdocs produce <directoryName>'
    echo -e '=================================================================='
    exit 1
  fi

  #Switch to mkdocs Directory
  cd "$2"

  #Check mkdocs.yml file exist 
  if [ ! -f "mkdocs.yml" ]; then
    echo -e 'Unable to Locate mkdocs.yml config file '
    exit 1
  fi

  #Build the mkdocs dirctory 
  mkdocs build --clean

  if [ ! -f "site.tar.gz" ]; then
    #Clean it
    rm -rf site.tar.gz
  fi
  
  #Create the TAR Arhive
  tar czf site.tar.gz *

  #Place the TAR Arhive in the ROOT mount LOcation

  mv site.tar.gz ../


  echo -e 'mkdocs file generated site.tar.gz and ready to serve'

elif  [ "$1" = 'serve' ]; then

  if [ ! -f "site.tar.gz" ]; then
    echo -e 'Unable to locate mkdocs [site.tar.gz] tar file, Please generate it by issuing the below command '
    echo -e '=================================================================='
    echo -e 'docker run -v $PWD:/var/mkdocs mkdocs produce <directoryName>'
    echo -e '=================================================================='
    exit 1
  fi

  # Create Location for the html file where mkdocs will be served
  mkdir -p /opt/www

  #Clean the Directory 
  rm -rf /opt/www/*
  # Extract the tar gz file to a new www Location
  tar xf site.tar.gz -C /opt/www
  # Switch to the WWW directory 
  cd /opt/www 
  # Server the file  
  mkdocs serve --dev-addr=0.0.0.0:8000


else
  exec "$@"
fi