### Deploying a Cluster of Web Servers

In real-world scenarios, relying on a single server can lead to a single point of failure. To address this, we deploy a cluster of servers capable of adjusting their size based on traffic fluctuations. To achieve this, we utilize the power of AWS Auto Scaling Groups (ASGs). ASGs manage the deployment of our server cluster, monitor instance health, replace failed instances, and dynamically adjust the cluster size to accommodate varying loads (ranging from 2 to 10 instances).

## Key Configuration Steps:

    # Launch Configuration# : We define a launch configuration using `aws_launch_configuration` to specify how each EC2 instance in the ASG should be configured.

    # ASG Resource: The aws_autoscaling_group resource is used to create the ASG. Launch configurations are immutable, so changing any parameter requires replacing the old resource with a new one. To address this, we set the create_before_destroy lifecycle setting to ensure Terraform creates the replacement resource before deleting the old one.

    Subnet Placement: In the data.tf file, we specify subnet_ids to deploy instances across multiple subnets, ensuring service availability even in the event of an AWS datacenter outage.

Deploying the Load Balancer

With our ASG in place, we face the challenge of multiple servers with individual IP addresses while wanting users to access our service through a single IP. We solve this issue by deploying a load balancer, which distributes traffic evenly among our servers. For this purpose, we use Amazon Elastic Load Balancer (ALB).

Key Configuration Steps:

    ALB Resource: We create an Application Load Balancer (ALB) using the aws_lb resource. The ALB automatically scales the number of load balancer servers based on traffic and handles failover if one server becomes unavailable, ensuring scalability and high availability.

    Listener Configuration: We define the listener for the ALB using the aws_lb_listener resource, configuring it to listen on the default HTTP port (port 80) and use HTTP as the protocol. For unmatched requests, we set up a default response to send a 404 error page.

    Security Group: To allow incoming and outgoing traffic, we create a dedicated security group for the ALB using aws_security_group in the sg.tf file. This security group permits incoming requests on port 80 for HTTP access and allows outgoing requests on all ports for health checks.

    Target Group: We create a target group for the ASG using the aws_lb_target_group resource. This group performs health checks by sending periodic HTTP requests to each instance and considering them healthy based on response criteria (matcher = "200").

    Health Check Type: We set the health_check_type of the ELB to "ELB" instead of the default EC2 option. This choice instructs the ASG to use the target group health check, allowing instances to be replaced not only when completely down but also when they are unresponsive due to resource constraints or critical process failures.

    Listener Rules: We configure listener rules using the aws_lb_listener_rule resource to route requests matching any path to the target group containing the ASG, ensuring traffic distribution among the instances.

Feel free to explore and customize these Terraform configurations to suit your infrastructure needs. Be sure to configure your AWS credentials properly and run terraform init, followed by terraform apply, to deploy your infrastructure. Good luck with your Terraform Associate certification preparation!