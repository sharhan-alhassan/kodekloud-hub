# Introduction

## Docker compose

- convert imperative docker commands to services bundled in a single yaml file

## 1. Migrate `app` service to `docker-compose`

```sh
 docker run -dp 3000:3000 \
  -w /app -v "$(pwd):/app" \
  --network todo-app \
  -e MYSQL_HOST=mysql \
  -e MYSQL_USER=root \
  -e MYSQL_PASSWORD=secret \
  -e MYSQL_DB=todos \
  node:12-alpine \
  sh -c "yarn install && yarn run dev"
```

```dockerfile
version: '3.7'

services:
  app:
    image: alpine
    command: sh -c "yarn install && yarn dev"
    ports:
      - 3000:3000
    working_dir: /app
    volumes:
      - ./:/app
    environment:
      MYSQL_HOST: mysql
      MYSQL_USER: root 
      MYSQL_PASSWORD: secret 
      MYSQL_DB: todos
```

## 2. Migrate DB (MySQL service) to docker-compose

```sh
 docker run -d \
  --network todo-app --network-alias mysql \
  -v todo-mysql-data:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=secret \
  -e MYSQL_DATABASE=todos \
  mysql:5.7
```

```dockerfile
...
mysql:
    image: mysql:5.7
    volumes:
      - todo-mysql-data/:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: secret
      MYSQL_DATABASE: todos

...
```

## Basic commands

```sh
# start all services -- in detached mode
docker-compose up -d

# view logs
docker-compose logs -f 

# view logs -- for a single service
docker-compose logs -f app

# Tear it down: include --volumes flag to remove volumes
docker-compose down --volumes

```

## Image Building

1. Copy the dependencies into the container first

```sh
# using node as example 
FROM node:12-alpine
WORKDIR /app
COPY package.json yarn.lock ./
```

2. Install the dependencies
```sh
RUN yarn install --production
```

3. Copy Everythin else
```sh
COPY . ./
CMD ["node", "src/index.js"]
```