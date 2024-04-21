variable "region" {
    type = string
    description = "AWS region"
    default = "us-east-1"
}

variable "cluster_name" {
    type = string
    description = "cluster name"
    default = "my-cluster"
}

variable "vpc_name" {
    type = string
    description = "vpc name"
    default = "my_vpc"
}

variable "cluster_version" {
    type = string
    description = "k8s cluster version"
    default = "1.29"
}