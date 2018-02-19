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

* Uses ConfigMap for nginx
* Uses ConfigMap for both TCP & UDP settings
* Tuned to allow large file uploads
* CertManager ready!
* Uses basic auth (username: user, password: pass) by default

## Usage

```sh
$ make help

                                __                 __
   __  ______  ____ ___  ____ _/ /____  ____  ____/ /
  / / / / __ \/ __  __ \/ __  / __/ _ \/ __ \/ __  /
 / /_/ / /_/ / / / / / / /_/ / /_/  __/ /_/ / /_/ /
 \__, /\____/_/ /_/ /_/\__,_/\__/\___/\____/\__,_/
/____
                        yomateo.io, it ain't easy.

Usage: make <target(s)>

Targets:

  git/update           Update submodule(s) to HEAD from origin
  install              Installs manifests to kubernetes using kubectl apply (make manifests to see what will be installed)
  delete               Deletes manifests to kubernetes using kubectl delete (make manifests to see what will be installed)
  get                  Retrieves manifests to kubernetes using kubectl get (make manifests to see what will be installed)
  describe             Describes manifests to kubernetes using kubectl describe (make manifests to see what will be installed)
  context              Globally set the current-context (default namespace)
  shell                Grab a shell in a running container
  dump/logs            Find first pod and follow log output
  dump/manifests       Output manifests detected (used with make install, delete, get, describe, etc)
```

## Install

Installs everything you need, next setup an ingress!
See https://github.com/mateothegreat/k8-byexamples-echoserver

```sh
$ make install LOADBALANCER_IP=35.224.16.183 logs

[ INSTALLING MANIFESTS/DEFAULTBACKEND-SERVICE.YAML ]: service "default-http-backend" created
[ INSTALLING MANIFESTS/CONTROLLER-DEPLOYMENT.YAML ]: deployment "ingress-controller" created
[ INSTALLING MANIFESTS/CONTROLLER-SERVICE.YAML ]: service "ingress-svc" created
[ INSTALLING MANIFESTS/DEFAULTBACKEND-DEPLOYMENT.YAML ]: deployment "default-http-backend" created
[ INSTALLING MANIFESTS/RBAC.YAML ]: serviceaccount "nginx-ingress-serviceaccount" created
clusterrole "nginx-ingress-clusterrole" created
role "nginx-ingress-role" created
rolebinding "nginx-ingress-role-nisa-binding" created
clusterrolebinding "nginx-ingress-clusterrole-nisa-binding" created
[ INSTALLING MANIFESTS/CONFIGMAP.YAML ]: configmap "nginx-configuration" created
```

## Creating new ingress

```sh
$ make new HOST=gitlab.yomateo.io SERVICE_NAME=gitlab SERVICE_PORT=80

ingress "gitlab.yomateo.io" created

$ kubectl describe ing/gitlab.yomateo.io

Name:             gitlab.yomateo.io
Namespace:        default
Address:
Default backend:  default-http-backend:80 (<none>)
TLS:
  tls-gitlab.yomateo.io terminates gitlab.yomateo.io
Rules:
  Host               Path  Backends
  ----               ----  --------
  gitlab.yomateo.io
                     /   gitlab:80 (<none>)
Annotations:
Events:
  Type    Reason  Age   From                Message
  ----    ------  ----  ----                -------
  Normal  CREATE  27s   ingress-controller  Ingress default/gitlab.yomateo.io
```

## Cleanup

```sh

$ make delete

[ DELETING MANIFESTS/DEFAULTBACKEND-SERVICE.YAML ]: service "default-http-backend" deleted
[ DELETING MANIFESTS/CONTROLLER-DEPLOYMENT.YAML ]: deployment "ingress-controller" deleted
[ DELETING MANIFESTS/CONTROLLER-SERVICE.YAML ]: service "ingress-svc" deleted
[ DELETING MANIFESTS/DEFAULTBACKEND-DEPLOYMENT.YAML ]: deployment "default-http-backend" deleted
[ DELETING MANIFESTS/RBAC.YAML ]: serviceaccount "nginx-ingress-serviceaccount" deleted
clusterrole "nginx-ingress-clusterrole" deleted
role "nginx-ingress-role" deleted
rolebinding "nginx-ingress-role-nisa-binding" deleted
clusterrolebinding "nginx-ingress-clusterrole-nisa-binding" deleted
[ DELETING MANIFESTS/CONFIGMAP.YAML ]: configmap "nginx-configuration" deleted

```

## See also

* https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/annotations.md
* https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/configmap.md
* https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/exposing-tcp-udp-services.md
