# eShopOnWeb - running locally with Docker and in Azure with AKS

Welcome to eShop on Web!

This source code was scaffolded by a [Docker Application Template](https://github.com/sixeyed/eshoponweb-template) which also generated:

- a [Dockerfile](./src/Web/Dockerfile) to build, test and package the web app;
- a [Docker Compose](../docker-compose.yaml) file to run the app locally in containers;
- a [Docker Compose](../docker-compose.production.yaml) file to run the app in Azure.

> The output includes GitHub actions for creating an Azure Kubernetes Service cluster and a SQL Azure database, and for deploying the app to the cluster.

## Push this repo to create your AKS cluster & SQL Azure database

Your GitHub repo should have been set up in advance by your admins.

Open a terminal for this folder and set up the GitHub remote:

```
git init
git add --all
git commit -m "A template built all this!"
git remote add origin {{range .Services}}{{if eq "github" .ID}}https://github.com/{{.Parameters.username}}/{{.Parameters.repoName}}.git{{end}}{{end}}
```

Push the code to GitHub. This will start workflows to create your Azure resources:

```
git push -u origin master
```

[You can check on the workflows here]({{range .Services}}{{if eq "github" .ID}}https://github.com/{{.Parameters.username}}/{{.Parameters.repoName}}/actions{{end}}{{end}}). The actions use secrets from your repo to connect to Azure. Then they:

- create an AKS cluster
- deploy [Helm](https://helm.sh) on the cluster
- deploy [Compose on Kubernetes](https://github.com/docker/compose-on-kubernetes) on the cluster
- create a SQL Server instance with two databases

## Meanwhile... run the app locally

Docker Application Designer uses the [docker-compose.yaml](../docker-compose.yaml) manifest to build and run the app locally.

Click _Start_ in Application Designer in the app isn't already running. Then browse to:

- http://localhost:{{.Parameters.externalPort}}

And you can also connect to your local SQL Server container using a SQL client:

- server address: `localhost:{{range .Services}}{{if eq "sql-server" .ID}}{{.Parameters.externalPort}}{{end}}{{end}}`
- username: `sa`
- password: `{{range .Services}}{{if eq "sql-server" .ID}}{{.Parameters.saPassword}}{{end}}{{end}}`

## Check the Code

The app is an ASP .NET Core MVC web app, with some core best practices for running in Docker and Kubernetes:

- the [Dockerfile](./src/Web/Dockerfile) is a multi-stage build which compiles, tests and packages the app
- [configuration files](./src/Web/Program.cs) are loaded from multiple locations, so they can be provided by the platform
- there are [healthchecks](./src/Web/HealthChecks/ApiHealthCheck.cs) in the code which tell the container platform if the app is healthy

You can edit the source code and click _Restart_ from Docker Application Designer to see your changes - try a simple UI change in [_Layout.cshtml](./src/Web/Views/Shared/_Layout.cshtml).

## Deploy to Kubernetes

Your AKS cluster has been provisioned with [Compose on Kubernetes](https://github.com/docker/compose-on-kubernetes), so you can use **the exact same** Docker Compose format to deploy to AKS.

And your GitHub repo has another Action which deploys your app using the generated [docker-compose.production.yaml](../docker-compose.production.yaml) file when you push changes.

Now that you've edited the UI, push your changes to deploy the app to AKS:

```
git add --all
git commit -m 'I edited this myself'
git push origin master
```

## Browse to the app on AKS

Your app is running now in Azure and you can browse to the Kubernetes dashboard on AKS to see the deployment.

Launch an [Azure Cloud Shell](https://shell.azure.com) session, then run the AKS dashboard:

```
az aks browse --resource-group {{range .Services}}{{if eq "azure" .ID}}{{.Parameters.resourceGroup}}{{end}}{{end}} --name {{range .Services}}{{if eq "aks" .ID}}{{.Parameters.clusterName}}{{end}}{{end}}
```

From here you can see:

- the deployment generated from the Docker Compose file
- the secret containing the CosmosDB connection string
- the pod running the demo app
- the service with an external endpoint to access the app

> You can continue to work on the code locally, push to GitHub and your changes will be deployed to AKS

### Credits

Original source code: [dotnet-architecture/eShopOnWeb](https://github.com/dotnet-architecture/eShopOnWeb).
