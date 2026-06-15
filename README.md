# Terraform Learning

Hands-on Terraform examples on AWS, organized into two independent stacks:

1. **`backend-bootstrap/`** — provisions the remote-state backend (S3 bucket + DynamoDB lock table).
2. **`multi-env/`** — a reusable module deployed across multiple environments (`dev`, `prod`, `staging`).

## Repository layout

```
.
├── backend-bootstrap/          # S3 + DynamoDB for Terraform remote state
│   ├── s3.tf                    # state bucket
│   ├── dynamo_db.tf            # state-lock table
│   ├── provider.tf
│   ├── terraform.tf
│   └── variables.tf
│
└── multi-env/                  # Multi-environment deployment
    ├── main.tf                 # calls the module once per environment
    ├── provider.tf
    ├── terraform.tf
    └── modules/
        └── app-infra/          # Reusable module: EC2 + security group + key pair + S3
            ├── ec2.tf
            ├── s3.tf
            └── variables.tf
```

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) `>= 1.x`
- AWS provider `~> 6.0`
- AWS credentials configured (e.g. `aws configure` or environment variables)
- Default region: `eu-central-1`

## Stacks

### 1. `backend-bootstrap/`

Creates the shared infrastructure used to store and lock Terraform state:

| Resource | Purpose |
| --- | --- |
| `aws_s3_bucket` | Stores the `.tfstate` file remotely |
| `aws_dynamodb_table` | Provides state locking to prevent concurrent applies |

```bash
cd backend-bootstrap
terraform init
terraform plan
terraform apply
```

> Run this stack first if you want to wire a remote `backend "s3"` block into the other stacks.

### 2. `multi-env/`

Deploys the `app-infra` module across three environments from a single configuration. Each module call provisions:

- An EC2 instance (count configurable) with a root block device
- A security group (SSH / HTTP / HTTPS in, all out)
- An EC2 key pair
- An S3 bucket

Resources are name-prefixed by environment (e.g. `dev-infra-app-ec2`, `prod-infra-app-s3`).

```bash
cd multi-env
terraform init
terraform plan
terraform apply
```

#### Module inputs (`modules/app-infra`)

| Variable | Type | Description |
| --- | --- | --- |
| `env` | `string` | Environment name (`dev` / `prod` / `staging`); used as a resource name prefix |
| `region` | `string` | AWS region |
| `instance_count` | `number` | Number of EC2 instances |
| `instance_type` | `string` | EC2 instance type (e.g. `t2.micro`) |
| `ami_id` | `string` | AMI ID for the instances |
| `volume_size` | `number` | Root volume size (GiB) |
| `volume_type` | `string` | Root volume type (e.g. `gp3`) |

#### SSH key

The module expects a public key at `multi-env/my-tf-key.pub`. Generate a key pair before applying:

```bash
cd multi-env
ssh-keygen -t rsa -b 4096 -f my-tf-key
```

The private key (`my-tf-key`) is gitignored and must never be committed.

## Notes

- `.terraform/`, `*.tfstate*`, `*.tfvars`, and SSH private keys are excluded via `.gitignore`.
- Each directory is a separate Terraform root — run `terraform` commands from within the stack folder.
- This is a learning repository; resource names and AMI IDs are examples and should be reviewed before any real deployment.
