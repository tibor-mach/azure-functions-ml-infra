# azure-functions-ml-infra
Terraform scripts to provision infrastructure for deployment to Azure functions, geared
in particular towards deployment of machine learning models containerized with tools
such as [MLEM](https://mlem.ai/) or [BentoML](https://www.bentoml.com/).

Currently, no CICD is included (neither for the infrastructure, nor for the containers)

An Azure container registry is deployed and a linux azure functions app with pull rights
to get containers from that registry. The app is also connected to a storage account in
case it is needed.

There are two modules currently - one for the container registry and another one for the
app and accompanying resources (a service plan, application insights and a storage account)
# Quickstart

## Infra

1. Set up an azure active directory and a subscription and use [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/) to authenticate.

2. Run
    ```
    terraform init
    ```
    to initialize the configuration

3. Change the variables in `main.tf` (alternatively also those in the modules). You might be required to change certain names which need to be globally unique. it is easiest to do with changing the prefix variables in `variables.tf` of each module.

4. ``terraform apply`` to create the infrastructure
5. Deploy a container to the ACR registry with docker.
6. Profit! (or ``terraform destroy`` the infrastructure)

## Model Deployment

Note: The names of resources, models and containers etc. can vary based on how you change the terraform variables and how you name your models. This is just an illustrative example.

1. You should have a model (`iris_classifier`) at hand and use MLEM, BentoML or other tools to build it into a container with a FastAPI server (other serving options might also work, but I haven't tested it).
2. Login to your container registry (the name can vary based on how you change the terraform variables)
    ``az acr login --name mypreciouscontainers``
3. Tag your local docker image with an alias with a full path to the registry, e.g.
    ```
    docker tag iris_classifier mypreciouscontainers.azurecr.io/iris
    ```
3. push the image to the registry with
    ```
    docker push mypreciouscontainers.azurecr.io/iris:latest
    ```
4. That's it, the service should be accessible at 
    ```
    https://myprecious-skynet-service-test.azurewebsites.net
    ```
    

# TODO
- [ ] Centralize variables in `terraform.tfvars` and add more configuration options to avoid having to rewrite the scripts themselves (at least as long as the usecase is not too far off)
- [ ] Move storage account to a separate module (and make it optional?)
- [ ] Add some example models and recipes for building them into containers
- [ ] After that, also add examples of container deployment with CICD (currently has to be done manually)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>3 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_app"></a> [app](#module\_app) | ./modules/app | n/a |
| <a name="module_container-registry"></a> [container-registry](#module\_container-registry) | ./modules/container-registry | n/a |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->
