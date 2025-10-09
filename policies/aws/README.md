
# AWS Policy Pack (AWS Config)

Sets up AWS Config (recorder + delivery channel) and enables managed rules:
- S3 public read prohibited
- S3 public write prohibited
- EC2 detailed monitoring enabled

Usage:
```bash
terraform -chdir=policies/aws/config init
terraform -chdir=policies/aws/config apply -var="region=us-east-1" -var="bucket_name=<unique-bucket>" -var="delivery_channel_name=default"
```
