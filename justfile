cluster: _cluster _argo _lb _apps
	kubectl wait deployment -n argocd --for condition=Available=True --timeout=240s --all
	
dashboard:
	kubectl port-forward -n argocd deployment/argo-argocd-server 8080:8080
	argocd login localhost:8080 --username admin --password password --insecure

cleanup:
	kind delete clusters --all
	argocd logout localhost:8080

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
