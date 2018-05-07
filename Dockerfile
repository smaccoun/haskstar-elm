FROM node:9

WORKDIR /app/
COPY ./ ./

RUN ["apt-get", "update"]
RUN apt-get install -y \
  ca-certificates \
  libgmp-dev libnss3 netbase libnss-lwres libnss-mdns
RUN ["yarn", "add", "global", "elm"]

RUN ["yarn", "build"]

#CLEANUP
RUN ["mv", "./build", "/"]
RUN ["rm", "-rf", "/app"]

RUN npm install -g serve | cat

EXPOSE 5000 5000

CMD serve -s /build -p 5000


