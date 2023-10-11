# ELK Stack

- A open-source tool for centralizing log data and searching them

## Terms

1. `Document`: It's the unit storage of information/data/log. It's equivalent to a `Row` in RDMS

- A Document contains `fields` similar to columns in RDMS

2. `Index`: A collection of similar documents. In RDMS, Index is like `Database`  

3. `Shard`: It is a logical way of storing a collection of indexes. It can be stored in single or multiple machines for HA

4. `Replicas`: There are exact copies of shards for redundancy


## EFK Architecture:

```sh
# generate data/logs
kuberenetes

# collect, filter, butter & send data to ES
Fluentd

# store store
elasticsearch

# visualize data
kibana
```

## Create Elasticsearch Index

- You can use a rest api to interact with elasticsearch running on default `port 9200`

- Create `Index` in elasticsearch named `logstash-2022`

```sh
# Elasticsearch deployed in a VM
curl -X PUT <elasticsearch-public-IP>:9200/logstash-2022
```

- If the elasticsearch is deployed in the kubernetes cluster, then use the FQDN

```sh
curl -X PUT <elasticsearch-pod-name>.namespace.svc.cluster.local:9200/logstash-2022
```

## Push Data to a document in Elasticsearch Index

- Take node of the `_doc`. This is the document (row-like in RDMS) that the data will be stored in the Index

```sh
curl -X PUT <elasticsearch-public-IP>:9200/logstash-2022/_doc/1 -H 'Content-Type: application/json' -d "{"@timestamp":29032022}"
```