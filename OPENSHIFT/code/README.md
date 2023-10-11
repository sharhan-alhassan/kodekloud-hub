# OPENSHIFT

- A RedHat container orchestration platform that eases the deployment of container applications

- A `Project` is a collection of Applications

- When creating an Application, you only add your application code from Source Control Management(SCM) like `GitHub, GitLab, BitBucket` etc. 

- The rest of the work is automated for you:

```sh
1. A build Job is automatically created
2. The Source code is download from the SCM code
3. A build Image is triggered
4. The Application Image is pushed to OCR (Openshift container registry)
5. The Image is Deployed
```

## Image Builds

- There are different ways of building docker images in Openshift

1. Normal Docker build: YOu specify the commands to build an image in a Dockerfile

```dockerfile
FROM ubuntu:18
RUN apt-get install python
RUN pip install Flask
COPY ./ /opt/app
...
```

2. Source-To-Image (S2I): Automatically build an Image with build configuration

3. Image Streams: This is an abstract way of pointing to pre-built images. So when the pre-built images change, the image stream will keep an idea of a particular image that was reference so your applications won't be affected by changes in images from the pre-built repositories