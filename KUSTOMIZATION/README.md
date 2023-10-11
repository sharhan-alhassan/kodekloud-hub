
# Kustomize Components
```sh
# Components come in handy when dealing with applications that support multiple optional features and you wish to enable only a subset of them in different overlays, i.e., different features for different environments or audiences.

```

# Problem Statement
```yml
You want to deploy a community edition of this application as SaaS, so you add support for persistence (e.g. an external database), and bot detection (e.g. Google reCAPTCHA).

You’ve now attracted enterprise customers who want to deploy it on-premises, so you add LDAP support, and disable Google reCAPTCHA. At the same time, the devs need to be able to test parts of the application, so they want to deploy it with some features enabled and others not.

Here’s a matrix with the deployments of this application and the features enabled for each one:

        External_DB	    LDAP	reCAPTCHA
Community	✔️		                ✔️
Enterprise	✔️	          ✔️	
Dev	        ✅	        ✅	    ✅

(✔️ enabled, ✅: optional)

So, you want to make it easy to deploy your application in any of the above three environments. Here’s how you can do this with Kustomize components: each opt-in feature gets packaged as a component, so that it can be referred to from multiple higher-level overlays.
```


# Create Components
1. Define an `external_db component`, using kind: Component, that creates a Secret for the DB password and a new entry in the ConfigMap:

2. Define an `ldap component`, that creates a Secret for the LDAP password and a new entry in the ConfigMap:

3. Define a `recaptcha component`, that creates a Secret for the reCAPTCHA site/secret keys and a new entry in the ConfigMap:

4. Define a `community variant`, that bundles the external DB and reCAPTCHA components:

5. Define an `enterprise overlay`, that bundles the external DB and LDAP components:

6. Define a `dev overlay`, that points to all the components and has LDAP disabled:


# Components Architecture
```sh

├── base
│   ├── deployment.yaml
│   └── kustomization.yaml
├── components
│   ├── external_db
│   │   ├── configmap.yaml
│   │   ├── dbpass.txt
│   │   ├── deployment.yaml
│   │   └── kustomization.yaml
│   ├── ldap
│   │   ├── configmap.yaml
│   │   ├── deployment.yaml
│   │   ├── kustomization.yaml
│   │   └── ldappass.txt
│   └── recaptcha
│       ├── deployment.yaml
│       ├── kustomization.yaml
│       ├── secret_key.txt
│       └── site_key.txt
└── overlays
    ├── community
    │   └── kustomization.yaml
    ├── dev
    │   └── kustomization.yaml
    └── enterprise
        └── kustomization.yaml

```

# Different Patches Levels
## 1. Patches:
- Use it if you wan to Target a whole Object Kind. Eg; All Deployments, or Namespaces, or StatefulSets

## 2. StrategicMergePatch:
- Use if you want to introduce new set of items, eg; annotations or labels etc that do not exist already in the base file

## 3. patchesJson6902:
- It support modifying arbitrary fields in arbitrary Resources, Kustomize offers applying JSON patch through patchesJson6902