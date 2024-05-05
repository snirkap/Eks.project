# Eks.project
## Overview:
This project is designed to showcase a real-world DevOps scenario involving a Kubernetes cluster hosted on Amazon EKS, incorporating industry-standard tools like the External Secrets Operator, AWS Load Balancer Controller, and Infrastructure as Code (IaC) management via Terraform. The architecture ensures secure, scalable, and efficient management of secrets and load balancing.
## Here you can see a diagram explaining the project:
![eks_project drawio (1)](https://github.com/snirkap/Eks.project/assets/120733215/4626aad7-850f-45d1-810d-843739d274a5)
### Architecture Diagram Explanation:
* **VPC:** The entire infrastructure is encapsulated within an AWS Virtual Private Cloud (VPC) to ensure network isolation.
* **Kubernetes Cluster(EKS):** Hosts the application workloads with managed Kubernetes services.
* **Secrets Manager:** Securely manages secrets needed by the Kubernetes applications, using encryption for secret storage.
* **External Secrets Operator:** Fetches secrets from AWS Secrets Manager and syncs them as Kubernetes secrets.
* **Nginx Deployment & Service:** Handles HTTP server responsibilities within the cluster, managed by Nginx.
* **HPA (Horizontal Pod Autoscaler):** Automatically scales the number of Nginx pod replicas based on observed CPU utilization or other selected metrics.
* **AWS Load Balancer Controller:** Manages the lifecycle of AWS Load Balancers, which are used to route external traffic to the Nginx service inside the cluster.
* **Application Load Balancer (ALB):** Distributes incoming application traffic across multiple targets, such as EC2 instances, in multiple Availability Zones, which increases the fault tolerance of your applications.
* **Ingress:** Manages external access to the services in the cluster, typically HTTP and HTTPS traffic.
* **Users:** Represent the clients or external users accessing the application hosted on the Kubernetes cluster.
## requirements:
1. aws account
2. Installed on your local machine:
   * awscli
   * eksctl
   * kubectl
   * git
### setup:
1. ⁠first clone the repo:
```
git clone "https://github.com/snirkap/Eks.project.git"
cd Eks.project
```
2. configure to your aws account:
```
aws configure
```
3. in the eks.tf file change:
   * vpc id
   * subnet_ids
   * control_plane_subnet_ids
4. in the remote_state.tf file change:
   * bucket to yours bucket name
5. deploy the eks cluster:
```
terraform apply  
```
6. connect to the cluster with this command:
```
aws eks --region us-east-1 update-kubeconfig --name my-cluster
```
7. deploy aws load balancer controller:
```
1. curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.7.2/docs/install/iam_policy.json

2. aws iam create-policy \
   --policy-name AWSLoadBalancerControllerIAMPolicy \
   --policy-document file://iam_policy.json

3. eksctl create iamserviceaccount \
  --cluster=my-cluster \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --role-name AmazonEKSLoadBalancerControllerRole \
  --attach-policy-arn=arn:aws:iam::111122223333:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve

(replace 111122223333 with your account ID)
(to delete the iamserviceaccount: eksctl delete iamserviceaccount aws-load-balancer-controller --cluster=my-cluster --namespace=kube-system)

4. helm repo add eks https://aws.github.io/eks-charts
5. helm repo update eks
6. helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=my-cluster \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller 
```
8. create a secret in the secret manager called "AWS-SECRET-PASSWORD" with the key called "password"
9. create a user with the role to read form the secret manager
10. create a secret with the access key and the secret accesskey of the user that you created for the secret store
```
kubectl create secret generic awssm-secret --from-literal=access-key=123456789 --from-literal=secret-access-key=123456789
```
11. deploy External Secrets Operator:
```
kubectl apply -k "https://github.com/external-secrets/external-secrets//config/crds/bases?ref=v0.9.11"
```
12. deploy the secret store:
```
kubectl apply -f src/secret-store.yml
```
13. deploy the external secret:
```
kubectl apply -f src/external-secret.yml
```
14. deploy the nginx deployment and service:
```
kubectl apply -f src/configmap.yml
kubectl apply -f src/nginx.yml
```
15. deploy hap and metrics-server for the deployment
```
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
kubectl apply -f src/hpa.yml
```

 
