#                                 __                 __
#    __  ______  ____ ___  ____ _/ /____  ____  ____/ /
#   / / / / __ \/ __ `__ \/ __ `/ __/ _ \/ __ \/ __  /
#  / /_/ / /_/ / / / / / / /_/ / /_/  __/ /_/ / /_/ /
#  \__, /\____/_/ /_/ /_/\__,_/\__/\___/\____/\__,_/
# /____                     matthewdavis.io, holla!
#
include .make/Makefile.inc

NS      		?= default
APP     		?= ingress-controller
USERNAME        ?= user
PASSWORD        ?= pass
LOADBALANCER_IP	?= 35.224.16.183 
SERVICE_TYPE	?= LoadBalancer
export

issue:              ingress-issue certificate-issue
revoke:				ingress-delete certificate-delete

ingress-issue:      guard-HOST guard-SERVICE_NAME guard-SERVICE_PORT; @envsubst < templates/ingress.yaml | kubectl -n $$NS apply -f -
ingress-htpasswd:   guard-HOST guard-SERVICE_NAME guard-SERVICE_PORT htpasswd; @envsubst < templates/ingress.yaml | kubectl -n $$NS apply -f -
ingress-delete:		guard-HOST secret-delete; @envsubst < templates/ingress.yaml | kubectl -n $$NS delete --ignore-not-found -f -

certificate-issue:  guard-HOST; @envsubst < templates/certificate.yaml | kubectl -n $$NS apply -f -
certificate-delete:	guard-HOST; @envsubst < templates/certificate.yaml | kubectl -n $$NS delete --ignore-not-found -f -

secret-create:		; @envsubst < templates/certificate.yaml | kubectl -n $$NS apply -f -
secret-delete:		; kubectl delete secret nginx-ingress-basic-auth | true

install:			guard-LOADBALANCER_IP

htpasswd: secret-delete

	test ! -f /usr/bin/htpasswd || echo "htpasswd does not exist!"
	
	# bcrypt is not supported within auth_basic, using md5
	# docker run --rm appsoa/docker-alpine-htpasswd --entrypoint="htpasswd -b" $(USERNAME) $(PASSWORD) > auth
	htpasswd -cb auth $(USERNAME) $(PASSWORD)

	kubectl delete secret nginx-ingress-basic-auth | true
	kubectl create secret generic nginx-ingress-basic-auth --from-file=auth
	
	@rm -rf auth