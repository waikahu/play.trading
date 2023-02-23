# Play Trading
Play Economy Trading microservice

## Build the Docker image
```powershell
$version="1.0.0"
$env:GH_OWNER="waikahu"
$env:GH_PAT="[PAT HERE]"
docker build --secret id=GH_OWNER --secret id=GH_PAT -t play.trading:$version .
```

## Run the docker image
```powershell
docker run -it --rm -p 5006:5006 --name trading -e MongoDbSettings__Host=mongo -e RabbitMQSettings__Host=rabbitmq --network playinfra_default play.trading:$version
```