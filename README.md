# Play Trading
Play Economy Trading microservice

## Build the Docker image
```powershell
$version="1.0.2"
$env:GH_OWNER="waikahu"
$env:GH_PAT="[PAT HERE]"
$appname="wbplayeconomy"
docker build --secret id=GH_OWNER --secret id=GH_PAT -t "$appname.azurecr.io/play.trading:$version" .
```

## Run the docker image
```powershell
$cosmosDbConnString="[Conn HERE]"
$serviceBusConnString="[Conn HERE]"
docker run -it --rm -p 5006:5006 --name trading -e MongoDbSettings__ConnectionString=$cosmosDbConnString -e ServiceBusSettings__ConnectionString=$serviceBusConnString -e ServiceSettings__MessageBroker="SERVICEBUS" play.trading:$version
```

## Publishing the Docker image
```powershell
az acr login --name $appname
docker push "$appname.azurecr.io/play.trading:$version"
```

## Create the Kubernetes namespace
```powershell
$namespace="trading"
kubectl create namespace $namespace
```

## Create the Kubernetes pod
```powershell
kubectl apply -f .\kubernetes\trading.yaml -n $namespace

# to see list of pods
kubectl get pods -n $namespace -w
# to see list of services
kubectl get services -n $namespace
# to see the logs of pod
kubectl logs <name of pod> -n $namespace
# to see datailed pod
kubectl describe pod <name of pod> -n $namespace

kubectl rollout restart deployment trading-deployment -n trading
```

## Creating the Azure Managed Identity and granting it access to the Key Vault secrets
```powershell
$appname="wbplayeconomy"
$namespace="trading"
az identity create --resource-group $appname --name $namespace
$IDENTITY_CLIENT_ID=az identity show -g $appname -n $namespace --query clientId -otsv
# i've to put the appid manually in the Azure Key Vault # 
az keyvault set-policy -n $appname --secret-permissions get list --spn $IDENTITY_CLIENT_ID
```

## Establish the federated identity credential
```powershell
$AKS_OIDC_ISSUER=az aks show -n $appname -g $appname --query "oidcIssuerProfile.issuerUrl" -otsv

az identity federated-credential create --name $namespace --identity-name $namespace --resource-group $appname --issuer $AKS_OIDC_ISSUER --subject "system:serviceaccount:${namespace}:${namespace}-serviceaccount"
```