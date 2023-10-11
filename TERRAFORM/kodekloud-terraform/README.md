# Syntax

```sh
resource "provider_type" "resource_name" {
    arg1 = "value1"
}
```

2. `variables` -- use the `variables.tf` to pass arguments to resource blocks 

- variable blocks take 3 arguments

```sh
1. default -- the default value
2. type -- can be string, number, bool, any (default value)
3. description

# examples of more types
-- list
-- map
-- object
-- tuple    # Is like a list but can take different types unlike list. 
-- set      # This type of variable is like list, just that it can't take duplicat values
```

## Type constraints for variables

```sh
# variables.tf

# type: list
variable "prefix" {
    default = [ 1, 2, 3 ]
    type = list(number)
}

# type map(string)
variable "file-content" {
    default = {
        "statement1" = "my pet 1"
        "statement2" = "my pet 2"
    }
    type = map(string)

# type set(string)
variable "food" {
    default = [ "chicken", "fish", "fish" ]      # WRONG! fish can't appear twice
    type = set(string)
}

# type: object(string) -- complex data structures by combining all other types
variable "pet" {
    type = object ({
        name = string
        color = string
        age = number
        food = list(string)
        favorite_pet = bool
    })

default = {
    name = "bella"
    color = "brown"
    age = 5
    food = ["chicken", "fish"]
    favorite_pet = true
    }
}

variable "kitty" {
    type = tuple([string, number, boolean])
    default = ["cat", 5, true]
}
```

```sh

# main.tf
resource "local_file" "my-pet" {
    filename = "/root/pet.txt"
    prefix = var.prefix[0]  # value of 1
    content = var.file-content["statement2"]    # my pet 2
    food = var.food
}

# reference variables below
# variable.tf
variable "prefix" {
    default = [ 1, 2, 3 ]
    type = list(number)
}

variable "file-content" {
    default = {
        "statement1" = "my pet 1"
        "statement2" = "my pet 2"
    }
    type = list(string)
```

## Terraform Documentation search guide

1. `Argument Reference`: This section of each resource documentation states the types (required or optional) arguments that a resource can take. Arguments go into the `{}` of the `resource` block. Example 

```sh
resource "aws_instance" "web_server" {
    argument1 = "value1"
    argument2 = "value2"
}
```

2. `Attributes Reference`: This section states what can be exported from a resource to another resource as output. Example of `Attribute reference` for AWS Instance is `public_ip`. 

`NB: All reference attributes of aws instance can be found in the documentation in terraform.io`
Example usage in an output:

```sh
output "web_server_public_ip" {
    public_ip = aws_intance.web_server.public_ip
}
```

## Terraform Lifecycle Rules

- `Lifecycle rules` spells out how resources lifecycle are managed. It's a separate block that you can add in the resource. Example of such rules are:

1. `create_before_destroy`: on `terraform apply` command, create the new resource before deleting the old resource

2. `prevent_destroy`: Don't delete the old resource at all on `terraform apply`

3. `ignore_changes`: This takes a list of other arguments that when changes are made to those arguments, terraform should ignore changes when `terraform apply` is performed. Eg

```sh
resource "aws_instance" "webserver" {
    instance_type = "t2.micro"
    tags = {
        Name = "webserver A"
    }
    lifecycle = {
        ignore_changes = [
            tags,
        ]
    }
}
```
YOu can pass `all` to the argument to prevent any changes at all: Eg
`ignore_changes = all`


## Data Sources

- `Data Sources`: Allow terraform to read `data/reference attributes` from external sources that are not managed by terraform

- Key differences b/n `Resource block` and `Data block`.
- `Resource` is created, updated, destroyed and managed by terraform
- `Data` is Read Only

## Terraform Resource Meta Arguments

- These are any configuration that are called withing `{}` of a resource. Example of such meta arguments are:

```sh
1. lifecycle
2. depends_on
3. Count 
4. for_each
```

## How to use Count Meta Argument

- Terraform will create the file three times by looping through the filename variable and create each file with the name in the list

- `Count` resources are created as a list

```sh
# variables.tf
variable "filename" {
    default = [
        "/root/dog.txt",
        "/root/cat.txt",
        "/root/parrot.txt"
    ]
}

# main.tf
resource "local_file" "pets" {
    filename = var.filename[count.index]    # to loop all the filenames

    count = length(var.filename)            # return the size of var.filename list
}

```

## for_each Meta Argument

- `for_each` resources are created as a map
Example 

```sh
# variables.tf
variable "filename" {
    defautl = ["/root/dog.txt","/root/cat.text","/root/parrot.txt"]
}

# main.tf
resource "local_file" "pet" {
    filename = each.value

    for_each = toset(var.filename)      # set the var.filename list to set if it's a list

# Or you can set the type = set(string)
}
```

## Terraform Provisioners

- A way to connect and send commands (CLI) to a server. It could be remotely or locally. 

- Provisioners are created after the resources are created 

- Two provisioners by Terraform are

1. `remote-exec` -- to send commands to a remote server

2. `local-exec` -- to send commands to a local server

Example code for AWS in a resource block

```sh
provisioner "remote-exec" {
    inline = [
        "sudo apt update",
        "sudo apt install nginx -y",
        "sudo systemctl enable nginx",
        "sudo systemctl start nginx,
    ]
}

provisioner "local-exec" {
    when = destroy              # Run this command when abou to destroy this resource (EC2)
    command = "echo Instance with IP ${aws_instance.webserver.public_ip} created >> /tmp/ips.txt"
}

```

** NB:

- Use Provisioners as last resort. 

- Go with `user_data` if possbile

- `provisioner` and `user_data` Meta Arguments all go into the resource `{}` block

```sh
user_data = << EOF
    #!/bin/bash
    sudo apt update 
    sudo apt install nginx -y
    EOF
```

## Connection Meta Argument

- A way to establish connection with a remote instance

- This Meta Argument also goes into the resource `{}` block
Example code 

```sh
connection {
    type = "ssh"
    host = "self.pulic_ip"
    user = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
}
```

## Terraform Logs

- Types of Terraform logs levels values are:

```sh
1. INFO
2. WARNING
3. ERROR
4. DEBUG
5. TRACE
```

- You can set a Log level with an environment variable using any of the Logs Levels. 
- Then run your terraform commands thereafter

```sh
export TF_LOG=TRACE         # For TRACE logs
export TF_LOG=DEBUG         # For Debug logs
export TF_LOG=WARNING       # For Warning logs

etc
```

- To send the Logs to a file permanently

```sh
export TF_LOG_PATH=/tmp/terraform.log
```

- To disable Logging

```sh
unset TF_LOG_PATH
```

## Terraform import

- Terraform `import` is a command used in importing/bringing in resources created out of terraform into terraform for it to manage it. First, ensure the resource to import is created outside of terraform (eg; an EC2 instance created using the consolde)

```sh
# Inspect resource exists
aws ec2 describe-instances --endpoint http://***

# Create empty resource block (the ec2 instance is called webserver)
resource "aws_instance" "webserver" {
    # empty
}

# Now import the resource into terraform state
terraform import aws_instance.webserver
```

## Terraform Functions and Conditionals

```sh
# split converts string to list
variable users {
    default = "am:good:boy"
}

# Use terraform console
> split(":", var.users)
> [
    "am",
    "good",
    "boy",
]

# join converts list to string
perform "split" vice versa


```

### Terraform "lookup", "index", "element" functions

- `lookup`: lookup a key in a map
- `index`: Use the element to find the index -- `index(var.region, "us-east-1"`
- `element`: Use an index to find the element -- `element(var.region, 2)`

```sh
# variables.tf 
variable "region" {
    type = map
    default = {
        "us-payroll" = "us-east-1"
        "uk-payroll" = "eu-west-2"
        "india-payroll" = "ap-south-1"
    }
}

# main.tf
resource "aws_instance" "web-server" {
    region = lookup(var.region, "us-payroll")
}

```

### Using split to create IAM users

```sh
# variables.tf
variable "cloud_users" {
    default = "andrew:james:sharhan:sam"
    type = string
}

# main.tf
resource "aws_iam_user" "user" {
    name = split(":", var.cloud_users)[count.index]
    count = lenghth(split(":", var.cloud_users))
}

```


## Terraform Workspaces

- Workspaces isolate different environments (eg; dev, qa, prod, etc) while using the same terraform code

```sh
# List all workspaces
terraform workspace list

# Create new workspace -- dev-environment
terraform workspace new dev-environment 

# Switch to a workspace -- dev-environment
terraform workspace select dev-environment 

# Show the name of current workspace
terraform workspace show

```
