# KUBEBUILDER
```sh
# Kubebuilder is an SDK for quickly and easily building and publishing Kubernetes APIs in Golang. It is built on top of the Kubernetes existing canonical technique to provide simple abstractions to reduce the need for boilerplate.
```

# Install Kubebuilder
```sh
# download kubebuilder and install locally.
curl -L -o kubebuilder https://go.kubebuilder.io/dl/latest/$(go env GOOS)/$(go env GOARCH)
chmod +x kubebuilder && mv kubebuilder /usr/local/bin/

# enable kubebuilder autocompletion
kubebuilder completion <bash|zsh>
```

# Create a Project
```sh
mkdir -p ~/projects/guestbook
cd ~/projects/guestbook

# create go module
go mod init sharhan/guestbook

# initialize kubebuilder 
kubebuilder init --domain sharhan.link --repo sharhan/guestbook
```

# Create an API
```sh
# Run the following command to create a new API (group/version) as webapp/v1 and the new Kind(CRD) Guestbook on it:
kubebuilder create api --group webapp --version v1 --kind Guestbook

```


# [Reference-link](https://book.kubebuilder.io/quick-start.html#test-it-out)