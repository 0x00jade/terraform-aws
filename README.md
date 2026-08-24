# terraform-script

Terraform configuration that provisions a small AWS environment: an EC2
instance with Docker pre-installed, a security group, an auto-generated SSH
key pair, and an ECR repository.

## What it creates

| File | Resource | Purpose |
|---|---|---|
| [instance.tf](instance.tf) | `aws_instance.anpupu` | EC2 instance (`t3a.small`, AMI `ami-0532913178263be11`). `user_data` installs Docker, AWS CLI v2, and the Docker Compose CLI plugin on boot. |
| [instance.tf](instance.tf) | `aws_security_group.demo-sg` | Allows inbound SSH (22), HTTP (80), HTTPS (443) from anywhere; allows all egress. |
| [keypair.tf](keypair.tf) | `tls_private_key.rsa-4096-key`, `aws_key_pair.demo-key-pair-tf`, `local_file.tf_key` | Generates a 4096-bit RSA key pair, registers the public key with AWS, and writes the private key locally so you can SSH into the instance. |
| [main.tf](main.tf) | `aws_ecr_repository.anpupu`, `aws_ecr_lifecycle_policy.my_policy` | Private ECR repo (immutable tags, scan-on-push) with a lifecycle policy that expires older `main`-tagged images beyond the 5 most recent. |
| [provider.tf](provider.tf) | `aws` provider | Pins the AWS provider to `6.15.0`, configured via variables. |
| [output.tf](output.tf) | outputs | Prints the instance's public IP and public DNS after apply. |
| [variables.tf](variables.tf) | input variables | See below. |

## Prerequisites

- Terraform >= 1.0
- An AWS account and credentials (access key / secret key)

## Variables

| Name | Required | Default | Description |
|---|---|---|---|
| `access_key` | yes | — | AWS access key |
| `secret_key` | yes | — | AWS secret key |
| `region` | no | `ap-southeast-1` | AWS region |
| `file_name` | yes | — | Local path to write the generated private key (e.g. `demo-key.pem`) |
| `instance_type` | no | `t3a.small` | EC2 instance size |

Provide the required values in a `terraform.tfvars` file (already gitignored)
or via `-var` / environment variables — do not commit credentials.

```hcl
# terraform.tfvars (not committed)
access_key = "..."
secret_key = "..."
file_name  = "demo-key.pem"
```

## Usage

```bash
terraform init
terraform plan
terraform apply
```

SSH into the instance using the generated key and the `public_ip` output:

```bash
chmod 400 demo-key.pem
ssh -i demo-key.pem ubuntu@$(terraform output -raw aws_instance_public_ip)
```

Tear down everything with:

```bash
terraform destroy
```

## Notes

- The private key file, `*.tfvars`, and Terraform state are excluded from
  version control via [.gitignore](.gitignore) — never commit them.
- The security group opens SSH/HTTP/HTTPS to `0.0.0.0/0`; restrict
  `cidr_blocks` for anything beyond local testing.
