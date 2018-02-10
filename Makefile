# include $(MAKE_INCLUDE)/Makefile.inc
NS          ?= infra-ingress


all:        help
## Install Everything (Default Backend + Ingress Controller)
install:    install-backend install-controller
## Delete Everything
delete:     delete-backend delete-controller
## Output plaintext yaml's
dump:       _dump-default-backend-deployment _dump-default-backend-service _dump-controller-service _dump-controller-deployment
## Install default-http-backend (Deployment & Service)
install-backend:        _apply-default-backend-deployment _apply-default-backend-service
## Install default-http-backend (Deployment & Service)
delete-backend:         _delete-default-backend-deployment _delete-default-backend-service
## Install nginx ingress controller (Deployment & Service
install-controller:      _apply-controller-service _apply-controller-deployment
## Delete nginx ingress controller (Deployment & Service)
delete-controller:      _delete-controller-deployment _delete-controller-service

# install-dns: _apply-externaldns

_apply-%:

	@envsubst < $*.yaml | kubectl --namespace $(NS) apply -f -

_delete-%:

	@envsubst < $*.yaml | kubectl --namespace $(NS) delete --ignore-not-found -f -

_dump-%:

	envsubst < $*.yaml

# Help Outputs
GREEN  		:= $(shell tput -Txterm setaf 2)
YELLOW 		:= $(shell tput -Txterm setaf 3)
WHITE  		:= $(shell tput -Txterm setaf 7)
RESET  		:= $(shell tput -Txterm sgr0)
help:

	@echo "\nUsage:\n\n  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}\n\nTargets:\n"
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "  ${YELLOW}%-20s${RESET} ${GREEN}%s${RESET}\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)

## Find first pod and follow log output
logs:

	@$(eval POD:=$(shell kubectl get pods --all-namespaces -lk8s-app=ingress-controller -o jsonpath='{.items[0].metadata.name}'))
	echo $(POD)

	kubectl --namespace $(NS) logs -f $(POD)
