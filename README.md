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
