## HELM

- `Helm` is a package manager for kubernetes. It takes an application as a package and manages each individual objects for you such as secrets, deployments, PVC, etc

- Most important thing about `helm` is that, it makes you treat our kubernetes apps as `apps` and not `objects`

- Helm uses `charts`. Charts are collection of files

## Syntax

- `Repos` are pulled into clusters and `releases` are created from them

- A `repo` has a collection of `charts` you can install from 

```sh
# Add a chart repo
helm repo add [Name] [URL]

# Add bitnami chart repo
helm repo add bitnami https://charts.bitnami.com/bitnami

# Install a release called "my-nginx" from the bitnami repo using the nginx chart
helm install my-nginx bitnamic/nginx

# list all releases for a specified namespace
helm list

controlplane ~ ➜  helm list
NAME            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
my-nginx    default         3               2022-03-31 23:56:44.000945715 +0000 UTC deployed        nginx-8.9.1     1.19.10  


# upgrades the my-nginx release to 1.21 from the nginx chart in bitnami repo (bitnami/nginx)
# syntax: helm upgrade [release] [chart] [flags]
helm upgrade my-nginx bitnami/nginx --version 9


# Installs a wordpress application including all its objects
helm install wordpress  

# rollback the release "my-nginx" to previous version
# syntax: helm rollback <RELEASE> [REVISION] [flags]
# do "helm history my-nginx" and see the revisions and revert to the previous b4 current one
helm rollback my-nginx 3

# uninstall an app
helm uninstall wordpress

# chart takes a full path with the repo preceding it
bitnami/nginx               # Is the nginx chart
```

## Installation and Configuration

```sh
# Using snap
$ sudo snap install helm --classic

# For Debian
$ curl https://baltocdn.com/helm/signing.asc | sudo apt-key add –
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.lisudo apt-get update
sudo apt-get install helm

# For package systems
$ pkg install helm
```

# Helm 2 vs Helm 3

- `Helm 2` largely depends on `Tiller`, an intermidiary or middleman between helm client and kubernetes to execute commands. This was because, RBAC(role based access control) and CRD(custom resource definitions) didn't exist in kubernetes back then 

- `Helm 3` no longer uses `Tiller` because of integrated RBAC and CRDs into kuberentes


# Helm install with Releases

```sh
helm install [release-name] [chart-name]

```

# Helm Search

```sh
# Searching for charts outside in the `artefact` repository is term as `hub`

helm search hub <name-of-chart>

# Searching for already downloaded charts on your machine are termed as `repo`

helm search repo <nginx>        # search for nginx repo locally
```

# Helm Charts Anatomy

# Create your Own charts

# 1. Create a directory structure using helm

```sh
helm create nginx-chart

# outcome
📦hello-world-chart
 ┣ 📂templates
 ┣ 📜Chart.yml
 ┣ 📜LICENSE
 ┣ 📜README.md
 ┗ 📜values.yml
```

# 2. Remove all files in `template/` and populate it with `service.yml` and `deployment.yml`

```yaml
# deployment.yml: ➜ kubectl create deployment hello-world --image nginx --replicas 2 -o yaml --dry-run=client              

apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: hello-world
  name: hello-world
spec:
  replicas: 2
  selector:
    matchLabels:
      app: hello-world
  template:
    metadata:
      labels:
        app: hello-world
    spec:
      containers:
      - image: nginx
        name: nginx
        resources: {}
---
# service.yml: ➜ kubectl create service nodeport hello-world --tcp=5678:8080 --node-port=56565 -o yaml --dry-run=client 

apiVersion: v1
kind: Service
metadata:
  labels:
    app: hello-world
  name: hello-world
spec:
  ports:
  - name: 5678-8080
    nodePort: 56565
    port: 5678
    protocol: TCP
    targetPort: 8080
  selector:
    app: hello-world
  type: NodePort
```

# 3. Dynamically inject values into manifests

```yaml
# deployment.yml
...
Kind: Deployment
metadata:
  name: {{ .Release.Name }}-nginx         # use the release name from "helm install <release-name>"
spec:
  replicas: {{ Values.replicaCount }}

  ...
       image: {{ Values.image }}
...
Kind: Service
metadata:
  name: {{ .Release.Name }}-service
```

- Examples of `Release` and `Chart` properties
```sh
# Release properties
Release.Name
Release.Namespace
Release.IsUpgrade
Release.IsInstall
Release.Revision
Release.Service

# Chart properties
Chart.Name
Chart.ApiVersion
Chart.Version
Chart.Type
Chart.Keywords
Chart.Home

# Values from the kubernetes cluster itself using "Capabilities"
Capabilities.KubeVersion
Capabilities.ApiVersions
Capabilities.HelmVersion
Capabilities.GitCommit


# Using values from the "values.yml" file created from "helm create" command
Values.image
Values.replicaCount

...

```

# 4. Passing values

- You either pass values through the `--set` command on CLI or via the `values.yml` file

```sh
# Via --set
helm install hello-world-1 ./nginx-chart \
--set replicaCount=2 \
--set image=nginx
```

```yaml
# via the values.yml 
replicaCount: 2
image:
  repository: nginx
  pullPolicy: IfNotPresent
  tag: "1.12.0"

```

# Verify Chart -- 3 ways

# 1. Lint: --> check format

```sh
helm lint ./nginx-chart
```

# 2. Template: --> Verify what would be generate from the template

```sh
helm template ./nginx-chart

# pass the release name in the template verification
helm template hello-world-1 ./nginx-chart

# use --debug to see errors
helm template ./nginx-chart --debug
``` 

# 3. Dry-run: --> Verify if the chart is error-free to be deployed in kubernetes

```sh
helm install hello-world-1 ./nginx-chart --dry-run

```


# Helm Functions

- `Funxtions` in `Helm` transforms data from one form to the other

- Each `function` takes an `argument`

- There are different types of functions. These include:

```sh
1. File Path
2. String
3. Date
4. Dictionaries
5. Chart
6. Kubernetes
7. Lists
8. Math
9. Regex
10. URL and many more
```
# Examples of some Helm String functions

```yaml
# upper: converts to uppercase
{{ upper .Values.image.repository }}  --> image: NGINX

# quote: put quotes arround argument
{{ quote .Values.image.repository }}  --> image: "nginx"

# replace: replace all "x" with "y"
{{ replace "x" "y" .Values.image.repository }}  --> image: nginy

# shuffle: randomly shuffle alphabets
{{ shuffle .Values.image.repository }} --> image: gnxin


```

# Setting Default values

- `Default` function automatically sets a default value if there is no value assigned in the `values.yml` file

- The value should be in quotes

```yaml
{{ default "nginx" .Values.image.repository }}  --> image: nginx
```

# Using Pipes

```yaml
{{ .Values.image.repository | upper | quote }}  --> image: "NGINX"
```


# Helm Conditionals (IF)

- Set a value in the manifest yaml file if the value is not empty in the `values.yml` file

```yaml
# service.yml
{{- if .Values.orgLable }}
labels:
  org: {{ .Values.orgLabel }}
{{- else if eq .Values.orgLabel "hr" }}
labels:
  org: human resources
{{- end }}
```
      
- The `-` before the `{{` in the `IF` conditional statment to clear the whitespacing that comes after the the conditional is implemented. The space that is left after `{{ - if .Values.orgLable }} and {{- end }}` is cleared

```yaml
# values.yml
replicaCount: 3
image: nginx

orgLabel: payroll
```

- Other conditionals are

```sh
ne -- not equal
lt -- less than
le -- less than or equal to
ge -- greater than or equal to
not -- negation
empty -- value is empty
```

# Examples Conditionals

```yaml
# 1. Now update the configmap.yaml in such a way that the APP_COLOR should take the values based on the environment defined in values.yaml .

if environment is production, value should be pink.

else if environment is development, value should be darkblue.

else, value should be green.

# Solution
apiVersion: v1
metadata:
  name: {{ .Values.configMap.name }}
  namespace: default
kind: ConfigMap
data:
  {{- if eq .Values.environment "development" }}
  APP_COLOR: darkblue
  {{- else if eq .Values.environment "production" }}
  APP_COLOR: pink
  {{- else }}
  APP_COLOR: green
  {{- end }}

```

# Conditionals for Creating Objects of some "Kind"

- You can decide to create or not create a kubernetes object base on the boolean state of the object name in `values.yml`

### serviceaccount.yml
```yaml
{{- if .Values.serviceaccount.create }}
apiVersion: v1
kind: ServiceAccount
metadaba:
  name: {{ .Release.Name }}-nginx
{{- end }}
```


### values.yml
```yaml
# specify whether a serviceaccount should be created or not
serviceaccount:
  create: true
```

# Scopes -- "With" Blocks

- This is a way of accessing nested values from the `values.yml` file without repeating yourself (DRY)

- Example

```yaml
# values.yml
app:
  ui:
    bg: red
    fg: black
  db:
    name: "users"
    conn: "mongodb://localhost:27020/mydb"
```

- Injecting values into a `configmap`

```yaml
# configmap.yaml

apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}
data:
  background: {{ .Values.app.ui.bg }}
  foreground: {{ .Values.app.ui.fg }}
  dbname: {{ .Values.app.db.name }}
  connection: {{ .Values.app.db.conn }}
```

## Using the "With" Scope for DRY

```yaml
# configmap.yaml

apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}
data:
  {{- with .Values.app }}
    {{- with .ui }}
      background:   {{    .bg }}
      foreground:   {{    .fg }}
    {{- end }}
    {{- with .db }}
      dbname:       {{    .name }}
      connection:   {{    .conn  }}
    {{- end }}
  release: {{ $.Release.Name }}    # To use a Root value inside a scope(with) use "$" sign infront of it
  {{- end }}
```

# Loops and Ranges

- In conventional programming, it's 

```sh
for i in 10:
  print(i)
end
```

- To implement a Loop use a `{{ . }}` to loop through a list 

- To put each item in the list as quote, pipe it with `quote`
```yaml
# values.yml

regions:
 - ohio
 - newyork
 - chicago
 - london
```

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}
region:
  {{- range .Values.regions }}
    - {{ . | quote }} 
  {{- end }}

```

# Named Templates -- using "template" keyword

- Named Templates are standalone templates used in injecting a set/group of repetitve values into yaml files

- Eg; of same code(labels) appearing in both `service.yml` and `deployment.yaml`

```yaml
# service.yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    app.kubernetes.io/name: nginx
    app.kubernetes.io/instance: nginx

# deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app.kubernetes.io/name: nginx
    app.kubernetes.io/instance: nginx
spec:
  selector:
    matchlabels:
      app.kubernetes.io/name: nginx
      app.kubernetes.io/instance: nginx
  template:
    metadata:
      labels:
        app.kubernetes.io/name: nginx
        app.kubernetes.io/instance: nginx
```

- You can remove the repeating lines, i.e `(labels)` and put it into a file called `_helpers.tpl` and define it this way

```yaml
{{- define "labels" . }}        # labels is the name of the template. The dot (.) is added to specify the scope
  app.kubernetes.io/name: {{ .Release.Name }}
  app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
```
- These lines i.e labels can then be imported into any yaml file and prefix with template and the name of the template you want to use

- Eg; of using the template
```yaml
# service.yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    {{- template "labels" }}
```

# Named Templates -- using "include" keyword
- Refering to the `deployemnt.yml`, the `template` is used correctly with the first appearance of the `labels`, but for subsequent appearance of `labels`, it needs to be indented to 2 spaces and third appearance to 4 spaces

- The `template` output cannot be piped to a function like `indent` to solve the issue. That's where `include` function comes in. It's output can be piped to the `indent` function

- deployment.yml import of the template file now becomes:

```yaml
# deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    {{- include "labels" . | indent 2 }}
spec:
  selector:
    matchlabels:
      {{- include "labels" . | indent 4 }}
  template:
    metadata:
      labels:
        {{- include "labels" . | indent 6 }}
```


# Chart Hooks
### `Hooks` are extra activities you want to perform when performing a helm activity such as before upgrade, you want to back-up the DB first. The `DB backup activity `is termed as a helm hook

### 1. Say you want to perform a DB backup before you upgrade your helm chart, then you use the `pre-upgrade` hook

### 2. Say after the upgrade you want to perform some post clean up or send some sort of notifications, then you use the `post-upgrade` hook

### 3. Other Hooks are `pre-install` and `post-install` hooks used during `helm install` process

### 4. `pre-delete` and `post-delete` are used during `helm delete` activity

### 5. `pre-rollback` and `post-rollback` are used during `helm rollback` process


# Determine which manifests are Hooks

- You add an `annotation` to the manifest that you want to run as a Hook.

- Example of such annotations are: In this case, helm will first run this Job first before performing an upgrade

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ .Release.Name}}
  annotations:
    "helm.sh/hooks": pre-upgrade
```

# Order of Hooks

- You can specify the order of Hooks, which one gets executed before the other by adding another annotation

```yaml
...
metadata
  annotation:
    "helm.sh/hook-weight: "3"
```
  
- Helm arranges all manifests with Hooks based on ascending order and execute them

- `"-3"` gets to be exectued before `"-2"` and then followed by `"-1"` and then `"1"` and `"2" `and `"3" `and that order 


# Hooks Deletion POlicies

- These are annotations added to determine what happens after the execution is done

```yaml
annotation:
  "helm.sh/hook-delete-policy": hook-succeeded
```

1. `hook-succedded` -- Delete the hook after it's run successfully
2. `hook-failed` -- 
3. `before-hook-creation` --


# Packaging and Signing Charts

## Package it
```sh
# To package the chart -- converts it to .tgz
helm package ./ubuntu-chart

# It appends the version number to the end ubuntu-chart-0.1.0.tgz
```

## Sign it before uploading to any chart repository

```sh
# First generate the private and public key using gpg
gpg --quick-generate-key "Sharhan Alhassan"

# For production enviroment use
gpg --full-generate-key "Sharhan Alhassan"

# migrate old file format
gpg --export-secret-keys >~/.gnupg/secring.gpg

# Package the helm chart with the sign option
helm package --sign --key "Sharhan Alhassan" --keyring ~/.gnupg/secring.gpg ./ubuntu-chart

# Now both ubuntu-chart-0.1.0.tgz and ubuntu-chart-0.1.0.tgz.prov are created 

# If you forgot keys
gpg --list-keys 
```

# Uploading Charts

1. Make a directory and put all the helm files in there, the ubuntu-chart, the .tgz and .prov files
```sh
mkdir ubuntu-chart-files

cp ubuntu-chart-0.1.0.tgz ubuntu-chart-0.1.0.tgz.prov ubuntu-chart-files/
``` 

2. Create an index file
```sh
helm repo index nginx-chart-files/ --url https://chart-url/charts

```

3. Then upload the ubuntu-chart-files to the url