# IoT Insert Demo

Provides a demo of IoT insert

## Instructions

(1) Run mongod on localhost
```
mongod --dbpath . --logpath ./mongod.log
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
