# Eks.project
1. create eks with tf
2. connect to the cluster with this command:aws eks --region us-east-1 update-kubeconfig --name my-cluster
3. deploy aws load balancer controller https://docs.aws.amazon.com/eks/latest/userguide/lbc-helm.html (to delete the iamserviceaccount: eksctl delete iamserviceaccount aws-load-balancer-controller --cluster=my-cluster --namespace=kube-system)

 