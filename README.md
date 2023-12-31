# IoT Insert Demo

Provides a demo of IoT insert

## Instructions

### With a local MongoDB instance

(1) Run mongod on localhost (create a directory, and execute this within the new directory)
```
mongod --dbpath .
```

(2) Execute: 
```
docker run -it pockettheories/iotmongodb
```
...or, an alternative for (2) is 
```
git clone https://github.com/pockettheories/iotmongodb.git
cd iotmongodb
./build.sh && ./runme.sh
```

Note: Add the "-e demomode=advanced" parameter to get a more complex document structure and queries.

### Without a local MongoDB instance

```
git clone https://github.com/pockettheories/iotmongodb.git
cd iotmongodb
docker-compose up -d
docker logs iotmongodb-app-1
```
