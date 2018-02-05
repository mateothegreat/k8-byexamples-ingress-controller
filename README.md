<!--
#                                 __                 __
#    __  ______  ____ ___  ____ _/ /____  ____  ____/ /
#   / / / / __ \/ __ `__ \/ __ `/ __/ _ \/ __ \/ __  /
#  / /_/ / /_/ / / / / / / /_/ / /_/  __/ /_/ / /_/ /
#  \__, /\____/_/ /_/ /_/\__,_/\__/\___/\____/\__,_/
# /____                     matthewdavis.io, holla!
#
#-->

[![Clickity click](https://img.shields.io/badge/k8s%20by%20example%20yo-limit%20time-ff69b4.svg?style=flat-square)](https://k8.matthewdavis.io)
[![Twitter Follow](https://img.shields.io/twitter/follow/yomateod.svg?label=Follow&style=flat-square)](https://twitter.com/yomateod) [![Skype Contact](https://img.shields.io/badge/skype%20id-appsoa-blue.svg?style=flat-square)](skype:appsoa?chat)

# NGINX Ingress Controller

> k8 by example -- straight to the point, simple execution.

Setup the nginx ingress controller.
For GKE users, you can use this controller instead of the default ingress controller that
comes pre-installed with your cluster. The nginx class annotation is used to support this.

You must disable the ingress controller when you're creating GKE clusters.

## Usage

```sh
Usage:

  make <target>

Targets:

  install              Install Everything (Default Backend + Ingress Controller)
  delete               Delete Everything
  dump                 Output plaintext yamls

  install-backend      Install default-http-backend (Deployment & Service)
  delete-backend       Install default-http-backend (Deployment & Service)
  install-controller   Install nginx ingress controller (Deployment & Service
  delete-controller    Delete nginx ingress controller (Deployment & Service)
  logs                 Find first pod and follow log output
```

## Example

Installs everything you need, next setup an ingress!
See https://github.com/mateothegreat/k8-byexamples-echoserver

```sh
$ make install NS=infra-ingress

    deployment "default-http-backend" created
    service "default-http-backend" created
    service "ingress-svc" created
    deployment "ingress-controller" created

$ make delete NS=infra-ingress

    deployment "default-http-backend" deleted
    service "default-http-backend" deleted
    deployment "ingress-controller" deleted
    service "ingress-svc" deleted
```

## Dump the yamls!

```sh
$ make dump

envsubst < default-backend-deployment.yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: default-http-backend
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: default-http-backend
    spec:
      containers:
      - name: default-http-backend
        # Any image is permissable as long as:
        # 1. It serves a 404 page at /
        # 2. It serves 200 on a /healthz endpoint
        image: gcr.io/google_containers/defaultbackend:1.0
        livenessProbe:
          httpGet:
            path: /healthz
            port: 8080
            scheme: HTTP
          initialDelaySeconds: 30
          timeoutSeconds: 5
        ports:
        - containerPort: 8080
        resources:
          limits:
            cpu: 10m
            memory: 20Mi
          requests:
            cpu: 10m
            memory: 20Mi
envsubst < default-backend-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: default-http-backend
spec:
  ports:
  - port: 80
    targetPort: 8080
    protocol: TCP
  selector:
    app: default-http-backend
envsubst < controller-service.yaml
apiVersion: v1
kind: Service
metadata:

  name: ingress-svc

  labels:
    app: ingress-svc

spec:

  type: LoadBalancer
  ports:

  - port:       80
    targetPort: 80
    name:       http

  - port:       443
    targetPort: 443
    name:       https

  selector:
    k8s-app: ingress-controller
envsubst < controller-deployment.yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: ingress-controller
  labels:
    k8s-app: ingress-controller
spec:
  replicas: 1
  template:
    metadata:
      labels:
        k8s-app: ingress-controller
    spec:
      # hostNetwork makes it possible to use ipv6 and to preserve the source IP correctly regardless of docker configuration
      # however, it is not a hard dependency of the nginx-ingress-monitoring itself and it may cause issues if port 10254 already is taken on the host
      # that said, since hostPort is broken on CNI (https://github.com/kubernetes/kubernetes/issues/31307) we have to use hostNetwork where CNI is used
      # like with kubeadm
      # hostNetwork: true
      terminationGracePeriodSeconds: 60
      containers:
      - image: gcr.io/google_containers/nginx-ingress-controller:0.9.0-beta.11
        name: ingress-controller
        readinessProbe:
          httpGet:
            path: /healthz
            port: 10254
            scheme: HTTP
        livenessProbe:
          httpGet:
            path: /healthz
            port: 10254
            scheme: HTTP
          initialDelaySeconds: 10
          timeoutSeconds: 1
        ports:
        - containerPort: 80
          hostPort: 81
        - containerPort: 443
          hostPort: 444
        env:
          - name: POD_NAME
            valueFrom:
              fieldRef:
                fieldPath: metadata.name
          - name: POD_NAMESPACE
            valueFrom:
              fieldRef:
                fieldPath: metadata.namespace
        args:
        - /nginx-ingress-controller
        - --default-backend-service=$(POD_NAMESPACE)/default-http-backend
        - --publish-service=$(POD_NAMESPACE)/ingress-svc
```
