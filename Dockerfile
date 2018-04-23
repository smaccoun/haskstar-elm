FROM debian:latest

# prepare
RUN apt-get -y update
RUN apt-get -y install apt-utils

# install curl, http://stackoverflow.com/questions/27273412/cannot-install-packages-inside-docker-ubuntu-image
RUN apt-get -y install curl

# node + npm, https://nodejs.org/en/download/package-manager/ (no sudo on debian)
RUN apt-get -y install gnupg2
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash
RUN apt-get install -y nodejs # check with node: --version

# elm, https://www.npmjs.com/package/elm, https://github.com/rtfeldman/node-test-runner
RUN npm install yarn -g
RUN yarn global add elm

# nginx, https://www.linode.com/docs/websites/nodejs/how-to-install-nodejs-and-nginx-on-debian
RUN apt-get install -y nginx

# make elm reactor and nginx accessible
EXPOSE 3000 
