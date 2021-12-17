# Karpenter
This repository consists example codes for **Karpenter Cluster Autoscaler**. 

**Karpenter** is an Open Source Cluster Autoscaler tool developed and published by **AWS**.

## Folder Structure
```
├── README.md
├── karpenter
│   ├── amd64-deployment.yaml
│   ├── amd64-provisioner.yaml
│   ├── arm64-deployment.yaml
│   ├── arm64-provisioner.yaml
│   ├── spot-deployment.yaml
│   └── spot-provisioner.yaml
└── terraform-eks
    ├── eks.tf
    ├── iam.tf
    ├── karpenter.tf
    ├── outputs.tf
    ├── provider.tf
    ├── sg.tf
    ├── terraform.tfstate
    ├── terraform.tfstate.1639490246.backup
    ├── terraform.tfstate.backup
    ├── vars.tf
    └── vpc.tf
```
In the [Terraform folder](https://github.com/eminalemdar/karpenter/tree/master/terraform-eks), you can find the necessary configuration files for deploying a **VPC**, an **EKS Cluster** and **Karpenter Helm Chart** on top of that EKS cluster. Terraform configurations also creates the **IAM** Roles and Instance Profiles. You can change the configurations according to your needs.

In the [Karpenter folder](https://github.com/eminalemdar/karpenter/tree/master/karpenter), you can find the **Provisioner** and **Kubernetes Deployment** yaml files.

## Usage

- First, create the environment with Terraform.
```bash
terraform init
```
```bash
terraform plan
```
```bash
terraform apply
```
- You should update the `config_path` parameter in the [Provider Configuration](https://github.com/eminalemdar/karpenter/tree/master/terraform-eks/provider.tf) file for Helm provider's connection to the EKS cluster.
- Then you need to create the Provisioners and Deployments.
- Finally you can scale the deployments using ``kubectl scale deployment <deployment-name> --replicas=10``
- You can see the logs of the Karpenter Controller using ``kubectl logs -f -n karpenter $(kubectl get pods -n karpenter -l karpenter=controller -o name)``

## Cleanup

- First, you can delete the Deployments with ``kubectl delete deployment <deployment-name>``
- You can delete the Karpenter installation with ``helm uninstall karpenter -n karpenter``
- Finally, you can delete the whole environment with 
```bash
terraform destroy
```
> PS: Do not forget to delete Launch Templates created by Karpenter from your AWS Account.