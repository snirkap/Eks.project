# Eks.project
## Overview:
This project is designed to showcase a real-world DevOps scenario involving a Kubernetes cluster hosted on Amazon EKS, incorporating industry-standard tools like the External Secrets Operator, AWS Load Balancer Controller, and Infrastructure as Code (IaC) management via Terraform. The architecture ensures secure, scalable, and efficient management of secrets and load balancing.
## Here you can see a diagram explaining the project:
![eks_project drawio](https://github.com/snirkap/Eks.project/assets/120733215/bee4a226-1ac2-4b50-b58c-c510ec03d9e1)
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
2. installed in your local machine:
   * awscli
   * eksctl
   * kubectl
   * git
### setup:
1. git clone "https://github.com/snirkap/Eks.project.git"
2. cd Eks.project
3. configure to your aws account with the "aws configure" command.
4. change in the eks.tf file: vpc id, subnet_ids, control_plane_subnet_ids.
5. in the remote_state.tf file change: bucket to yours bucket name
6. do the "terraform apply" command to deploy the eks cluster.  
8. connect to the cluster with this command: aws eks --region us-east-1 update-kubeconfig --name my-cluster
9. deploy aws load balancer controller:
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
9. install the External Secrets Operator with this https://external-secrets.io/latest/introduction/getting-started/ 
14. create a user with the role to read form the secret manager
15. create a secret with the access key and the secret accesskey of the user that you created for the secret store (kubectl create secret generic awssm-secret --from-literal=access-key=123456789 --from-literal=secret-access-key=123456789)
16. deploy the secret store
17. deploy the external secret store
18. deploy the nginx deployment and service
19. add hap and metrics-server for the deployment


 
