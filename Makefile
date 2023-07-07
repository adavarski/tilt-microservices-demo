.PHONY: all build-all build help install_kind install_kubectl \
	create_kind_cluster create_docker_registry connect_registry_to_kind_network \
	connect_registry_to_kind create_kind_cluster_with_registry delete_kind_cluster \
	delete_docker_registry  build_docker_image \
	install_nginx_ingress clean_up 


# Dependencies

install_nginx_ingress:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml && \
	  kubectl wait --namespace ingress-nginx \
  		--for=condition=ready pod \
  		--selector=app.kubernetes.io/component=controller \
  		--timeout=120s || true

# Create cluster
create_kind_cluster: 
	kind create cluster --name microservices --config kind_config.yml || true && \
	  kubectl get nodes

up: create_kind_cluster 
	$(MAKE) install_nginx_ingress 


# Clean up

delete_kind_cluster: 
	kind delete cluster --name microservices

clean:
	$(MAKE) delete_kind_cluster


help:
	@echo '*** Usage of this file:'
	@echo 'make up          : Setup local dev environment (k8s cluster and registry) using kind'
	@echo 'make clean      : Teardown local dev environment'

