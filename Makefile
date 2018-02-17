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
LOADBALANCER_IP	?= 35.224.16.183 
export

new:                new-ingress new-certificate
new-ingress:        ; @envsubst < templates/ingress.yaml | kubectl -n $$NS apply -f -
new-certificate:    ; @envsubst < templates/certificate.yaml | kubectl -n $$NS apply -f -

install:			guard-LOADBALANCER_IP