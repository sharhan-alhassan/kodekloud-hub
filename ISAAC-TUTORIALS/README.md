# Tour of Terraform Registry
`registry.terraform.io`
`https://learn.hashicorp.com/tutorials`

```sh
1. Providers
2. Modules
```

# 1. Getting started

```sh
1. Terraform installation in a docker container

docker run -it --rm -v ${HOME}:/root/ -v ${PWD}:/work -w /work --net host alpine sh
wget https://releases.hashicorp.com/terraform/0.12.21/terraform_0.12.21_linux_amd64.zip
unzip terraform_0.12.21_linux_amd64.zip && rm terraform_0.12.21_linux_amd64.zip
mv terraform /usr/bin/terraform

```

```yaml
2. Common commands
a. terrafrom init
b. terraform fmt
c. terraform validate
d. terraform plan
e. terraform apply 
f. terrafrom apply -auto-approve

```

# 2. Basics

```yaml
# Major files names in any project
main.tf
variables.tf
providers.tf
outputs.tf
backend.tf

1. Terraform Providers

2. Input Variables

3. Output Variables

4. Attributes

```

# 3. State
```yaml
1. Remote state

2. Local state
```