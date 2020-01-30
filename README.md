

## Using mkdockerize.sh command  

**mkdockerize.sh** : This tool will help to build the mkdocs project, generate the site configuration and serve the mkdocs project over the http port 

```
$ ./mkdockerize.sh -h
mkdockerize for buidling and serving the mkdocs project using Docker 

./mkdockerize.sh
-h --help
--produce=PROJECT-DIR
--serve {For running the mkdocs project inside docker}
--build {For Buidling the Docker Image}
```

### Build Docker Image

```
$ ./mkdockerize.sh --build
```

```
Executing docker build -t mkdocs . 
-------------------
Sending build context to Docker daemon  6.048MB
Step 1/12 : ARG BASE_IMAGE=alpine
Step 2/12 : ARG ALPINE_VERSION=3.10
Step 3/12 : FROM ${BASE_IMAGE}:${ALPINE_VERSION}
 ---> af341ccd2df8
Step 4/12 : LABEL org.label-schema.schema-version="1.0.0-demo"     maintainer="anish2good@yahoo.co.in"     org.label-schema.vcs-description="Alpline mkdocs"     org.label-schema.docker.cmd="docker exec "     image-size="71.6MB"     ram-usage="13.2MB to 70MB"     cpu-usage="Low"
 ---> Using cache
.....
......
 ---> a639d173f98f
Successfully built a639d173f98f
Successfully tagged mkdocs:latest
-------------------
```

### Producing site.tar.gz file

```
$ ./mkdockerize.sh  --produce=my-project
Validating my-project
MKDOCS Directory is Valid Producting site.tar.gz file
[Entrypoint] mkdocs docker image for generating site.tar.gz and serving the file over the HTTP Server
INFO    -  Cleaning site directory 
INFO    -  Building documentation to directory: /var/mkdocs/my-project/site 
mkdocs file generated site.tar.gz and ready to serve
```

### Running the image

```
$ ./mkdockerize.sh  --serve
Starting the mkdocs server on port 8000
c05a40fa0510e3b0f0ec1891b63f5f950f0539aede50d959f5913a72cad248a7
Docker Container c05a40fa0510 started on port 8000
ANINATH-M-91AL:mkdocs aninath$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
c05a40fa0510        mkdocs              "/entrypoint.sh serve"   4 seconds ago       Up 3 seconds        0.0.0.0:8000->8000/tcp   agitated_bhaskara
```

## Using Docker command Directly 

### Producing site.tar.gz file
```
$ docker run -v $PWD:/var/mkdocs mkdocs produce  my-project
[Entrypoint] mkdocs docker image for generating site.tar.gz and serving the file over the HTTP Server
INFO  -  Cleaning site directory
INFO  -  Building documentation to directory: /var/mkdocs/my-project/site
mkdocs file generated site.tar.gz and ready to serve
```

### Running the image

Run the below docker command
```
$ docker run -p 8000:8000 -v $PWD:/var/mkdocs mkdocs serve
[Entrypoint] mkdocs docker image for generating site.tar.gz and serving the file over the HTTP Server
INFO    -  Building documentation... 
INFO    -  Cleaning site directory 
[I 200130 06:59:17 server:296] Serving on http://0.0.0.0:8000
[I 200130 06:59:17 handlers:62] Start watching changes
[I 200130 06:59:17 handlers:64] Start detecting changes
```

Sample Output 
https://imgur.com/dSOzJLH

## Security Consideration

From the threat Model Perspective of Microservices

### Container Security

1. **Non root user** : The process is running with nonroot user **mkdocs**
```console
$ docker exec -it c05a40fa0510 sh
/var/mkdocs $ ps -elf
PID   USER     TIME  COMMAND
    1 mkdocs    0:00 {entrypoint.sh} /bin/sh /entrypoint.sh serve
   10 mkdocs    0:02 {mkdocs} /usr/bin/python3.7 /usr/bin/mkdocs serve --dev-addr=0.0.0.0:8000
   12 mkdocs    0:00 sh
   19 mkdocs    0:00 ps -elf
```
2. **Image Size** : Image size is Minimum for this purpose alpine image is used and whole 

### Vulnerability Scanning

No active Vulnerability SCAN located in this image, I have used opensource scanner **anchore-cli**


