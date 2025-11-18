# Command for syntax + structure validation of helm chart:
```
helm lint ./frontend-chart
```

# Command to render helm chart templates:
```
helm template frontend ./frontend-chart
```

# Comands to create and manage namespace:
```
kubectl create namespace resume
kubectl config set-context --current --namespace=resume
kubectl config view --minify | grep namespace:
```

# Command to install or upgrade helm chart:
```
helm upgrade --install frontend ./frontend-chart
helm upgrade --install resume-api ./resume-api-chart
helm upgrade --install llm-service ./llm-service-chart
```
# Command to uninstall helm release:
```
helm uninstall resume-api
```
# Command to apply deployment:
```
kubectl apply -f deployment.yaml
```

# Commands to manage deployment and helm chart:
```
kubectl get pods
kubectl get svc
helm list
```

# Command to list helm releases in resume namespace:
```
helm list -n resume
```
# Command to get deployments in resume namespace:
```
kubectl get deploy -n resume
```

# Commands to apply secrets:
```
kubectl apply -f resume-api-secrets.yaml
kubectl apply -f chatbot-service-secrets.yaml
```

# Command to view logs of a pod:
```
kubectl logs <pod-name>
``` 
# Command to view detailed information about a pod:
```
kubectl describe pod <pod-name> -n resume
```