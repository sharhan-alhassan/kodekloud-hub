## VAULT

## Start Vault Dev Server

-  The dev server is a built-in, pre-configured server that is not very secure but useful for playing with Vault locally

```sh
vault server -dev
```

## Set you environment variables

- Open a new terminal session. Copy and paste the details from the `vault server -dev` command output

```sh
export VAULT_ADDR='http://127.0.0.1:8200'                           # vault address
echo 8flHEngQQUSomWEjyWOuozvl51iypE0Tm/sGYl3cFEk= > unseal.key      # save unseal key
export VAULT_TOKEN='s.oritkl5HRe2iSXdXhnXTcRhI'

```

## CRUD with Vault Secret

- When running Vault in dev mode, Key/Value secrets engine is enabled at `secret/ path`. 

- All arbitrary secrets are stored in the `secret/path`

- The prefix `secret/` tells vault which secret engine to use

- By default vault enables a secret engine `kv` at `secret/` path

- Other secret engines are `aws` for IAM access keys, `database` for time-limited credentials

```sh
# create secret
vault kv put secret/hello host=localhost

# multiple secrets 
vault kv put secret/hello host=localhost password=passwrd123

# read key/values from file (use "@" with filename)
vault kv put secret/hello @data.json

# read value into key from stdin (use "-")
echo "bar" | vault kv put secret/hello foo=-

# read value from a key in a path
vault kv get -field=host secret/hello       # prints "localhost" : from line 30 above

# retrieve secret in optional json
vault kv get -format=json secret/hello | jq -r .data.data.localhost

# Delete secrete
vault kv delete secret/hello
Success! Data deleted (if it existed) at: secret/hello

# Deletion output: Trying to read secret after deletion
======= Metadata =======
Key                Value
---                -----
created_time       2022-03-15T18:34:02.009313189Z
custom_metadata    <nil>
deletion_time      2022-03-15T18:41:37.379212306Z
destroyed          false
version            1

1. Deletion time means the secret/hello has been deleted
2. destroyed=false means the secret can be recovered (if accidental deletion)

# Recover deleted secret
vault kv undelete -versions=2 secret/hello

```

## Secret Engines

- You can enable, disable, list, move or tune any of vault's secret engines

- By default, secret engines are enabled at the path corresponding to their TYPE


```sh
# enable the aws secret engine
vault secrets enable aws

# enable ssh engine at a path ssh-prod/
vault secrets enable ssh -path=ssh-prod
```

- You can enable a single secret engine at different paths 

- Each path is completely isolated and cannot talk to other paths. For example, a kv secrets engine enabled at foo has no ability to communicate with a kv secrets engine enabled at bar.

```sh
# enable kv engine at "/users-service" path
vault secrets -path=users-service kv

# enable kv engine at "/news-service" path
vault secrets -path=news-service kv

# Disable secret engine
vault secrets disable users-service/

```

## Dynamic Secrets

- `Dynamic secrets` are generated when they are accessed. 
 
- Dynamic secrets do not exist until they are read, so there is no risk of someone stealing them or another client using the same secrets.

```sh
# enable aws secret engine
vault secrets enable -path=aws aws

# export aws keys
export AWS_ACCESS_KEY_ID=<aws_access_key_id>
export AWS_SECRET_ACCESS_KEY=<aws_secret_key>

# configure aws secrets engine -- now vault has access to your AWS account
vault write aws/config/root \
access_key=$AWS_ACCESS_KEY_ID \
secret_key=$AWS_SECRET_ACCESS_KEY \
region=us-east-1

# create an IAM role and attach a sample policy to it
vault write aws/roles/my-role \ 
credential_type=iam_user \
policy_documetn=-<<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1426528957000",
      "Effect": "Allow",
      "Action": [
        "ec2:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF

```

- Now that the AWS secrets engine is enabled and configured with a role, you can ask Vault to generate an access key pair for that role by reading from `aws/creds/:name`, where `:name` corresponds to the name of an existing role:

```sh
vault read aws/creds/my-role

# sample output
Key                Value
---                -----
lease_id           aws/creds/my-role/0bce0782-32aa-25ec-f61d-c026ff22106e
lease_duration     768h
lease_renewable    true
access_key         AKIAJELUDIANQGRXCTZQ
secret_key         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
security_token     <nil>

```

- You can revoke this secret witht the command:

```sh
# syntax
vault lease revoke <lease-id>

# using the above
vault least revoke aws/creds/my-role/0bce0782-32aa-25ec-f61d-c026ff22106e
```

## Token Authentication

```sh
# create new token
vault token create

# output 
Key                  Value
---                  -----
token                s.TeXTHz1lv7rkDO87W4MZYmmb
token_accessor       2pS078oM3Z0Q5gCyOlr4plaD
token_duration       ∞
token_renewable      false
token_policies       ["root"]
identity_policies    []
policies             ["root"]

# login with token
vault login <token>

# revoke a token 
vault token revoke <token>