cluster: _cluster _argo _lb _apps
	kubectl wait deployment -n argocd --for condition=Available=True --timeout=240s --all

cleanup:
	kind delete clusters --all

rebuild: cleanup cluster

_cluster:
	./kind.sh
	kubectl create namespace argocd

_argo:
	helm install argo -n argocd \
	--create-namespace \
	-f environments/local/argo/values.yaml argo/argo-cd 

_lb:					
	helm install metallb -n metallb-system \
	--create-namespace \
	-f environments/local/metallb/values.yaml metallb/metallb 

	kubectl wait deployment -n metallb-system --for condition=Available=True --timeout=240s --all

	kubectl apply -f '{{justfile_directory()}}/charts/metal-lb/ip-pool.yaml'

_apps:
	helm install -n argocd apps '{{justfile_directory()}}/charts/apps/'
