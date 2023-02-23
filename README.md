# Play Trading
Play Economy Trading microservice

## Build the Docker image
```powershell
$version="1.0.1"
$env:GH_OWNER="waikahu"
$env:GH_PAT="[PAT HERE]"
$crname="wbplayeconomy"
docker build --secret id=GH_OWNER --secret id=GH_PAT -t "$crname.azurecr.io/play.trading:$version" .
```

## Run the docker image
```powershell
$cosmosDbConnString="[Conn HERE]"
$serviceBusConnString="[Conn HERE]"
docker run -it --rm -p 5006:5006 --name trading -e MongoDbSettings__ConnectionString=$cosmosDbConnString -e ServiceBusSettings__ConnectionString=$serviceBusConnString -e ServiceSettings__MessageBroker="SERVICEBUS" play.trading:$version
```

## Publishing the Docker image
```powershell
az acr login --name $crname
docker push "$crname.azurecr.io/play.trading:$version"
```