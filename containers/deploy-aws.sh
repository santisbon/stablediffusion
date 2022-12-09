BUCKET="stable-diffusion-models"

aws cloudformation create-stack \
--stack-name stable-diffusion-uploads \
--template-body file://containers/aws-uploads-infra.yml  \
--parameters ParameterKey=BucketName,ParameterValue=$BUCKET 

aws s3 cp ~/Downloads/models s3://$BUCKET/ --recursive

---

Based on:
[VPC template](https://s3.us-west-2.amazonaws.com/amazon-eks/cloudformation/2020-10-29/amazon-eks-vpc-private-subnets.yaml)  
[EKS self-managed worker nodes template](https://s3.us-west-2.amazonaws.com/amazon-eks/cloudformation/2020-10-29/amazon-eks-nodegroup.yaml)  

1. Deploy the AWS VPC and EKS control plane stack.
2. Follow [Step 2: Configure your computer to communicate with your cluster](https://docs.aws.amazon.com/eks/latest/userguide/getting-started-console.html).
3. Create EC2 key pair
4. Deploy the [worker node stack]
  [Managed node groups] (https://docs.aws.amazon.com/eks/latest/userguide/managed-node-groups.html).
  [Self-managed node groups](https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html).
