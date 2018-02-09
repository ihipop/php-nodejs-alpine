A base  [Alipne](https://alpinelinux.org/)  image, contains `PHP` `NodeJS` `NPM` `GIT` `curl` , first intent for [**deployer-toolkit**](https://github.com/ihipop/deployer-toolkit) 

Docker Hub: https://hub.docker.com/r/ihipop/php-nodejs-alpine/tags/ 

Source Repo: https://github.com/ihipop/php-nodejs-alpine

[含有`china`标签镜像的中文优化项说明](https://github.com/ihipop/php-nodejs-alpine/blob/master/README_CN.md)

# Cmd Usage

```bash
docker run --rm -it -v $(pwd):'/project' ihipop/php-nodejs-alpine:php7.1-node8.9 php -v
docker run --rm -it -v $(pwd):'/project' ihipop/php-nodejs-alpine:php7.1-node8.9 node -v
docker run --rm -it -v $(pwd):'/project' ihipop/php-nodejs-alpine:php7.1-node8.9.npm npm -v
#...
```



# Tags Instruction

> php`{version}`-node`{version}`_`{specialtag}`

For example :

>  php`7.1`-node`8.9`_`china`

Means `PHP` at  version `7.1.x` , `NodeJs` at  version `8.9.x` ,and contains [some special optimise](https://github.com/ihipop/php-nodejs-alpine/blob/master/README_CN.md) for users from `China`

>  node`8.9`.npm

Means the `nodejs` is build **dynamicly linked**,with `npm` and `yarn` installed ,Contains some Dev libs,a little more big in size, Ussally useful in `CI`

>  node`8.9`

Means the `nodejs` is build **staticly linked** ,ie, the build flag contains  `--fully-static --without-npm`, Ussally useful in `Production`


**If you won't to use  this image in `china`, please choose those docker image without the `china` specialtag**

# Build 

## Build behind a Proxy

```bash
docker build -t ihipop/php-nodejs-alpine:php7.1-node8.9 . --build-arg HTTP_PROXY=http://172.17.0.1:8123 --build-arg HTTPS_PROXY=http://172.17.0.1:8123
```

## Build `specialtag` for china

```bash
docker build -t ihipop/php-nodejs-alpine:php7.1-node8.9_china . --build-arg IN_CHINA=true
```

