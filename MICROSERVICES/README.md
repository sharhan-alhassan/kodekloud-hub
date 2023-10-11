
# Deploy a microservices

# Architecture

```sh
***************                     **************
*  Voting App *                     * Result App *             
***************                     **************
       *                                   *
       *                                   *
       v                                   v
***************                     **************                    
*   Redis     *                     *    db(psql)*
***************                     **************
       *                                   *
       *************         ***************              
                   *         ^
                   v         *
                ********************
                *     Worker       *
                ********************

```

# Architecture synopsis

```readme
1. Voting app is a frontend to vote for a cat
2. Redis db stores the voting results to in-memory
3. The worker app fetches the data from Redis and Process it
4. The Worker app stores the result in Postgres DB
5. The Result app is a frontend that displays the results of the voting
```

# Docker Architecture

1. ## Assuming all the images are creted for all the services
```sh
redis as the Redis image
postgres:9.2 as the postgres db
voting-app as the Voting image
result-app as the result image
worker as the worker app image
```

2. ## Running all Containers
```sh
# NB: --link flag is used to enable connectivity between services in Docker
docker run -d --name=redis redis            # on port 6379
docker run -d --name=db postgres:9.2        # on port 5432
docker run -d -p 5000:80 --name=vote --link redis:redis voting-app
docker run -d -p 5001:80 --name=result --link db:db result-app
docker run -d --name=worker --link redis:redis --link db:db worker
```

# Kubernetes Architecture

```yaml
1. Deploy Pods
2. Create Services (ClusterIP)
    1. redis
    2. db
3. Create Services (NodePort)
    1. voting-app
    2. result-app
```

## NB: The worker app do not have any Port or Service because it's not accessed by any other
## service. It rather accesses other services