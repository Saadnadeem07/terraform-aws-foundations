module "dev-infra" {
    env = "dev"
    source = "./infra"
    instance_count = 2
    instance_type = "t2.micro"
    ami_id = "ami-0303e2e4a29f041a3"
    volume_size = 8
    volume_type = "gp3"
}

module "prod-infra" {
    env = "prod"
    source = "./infra"
    instance_count = 2
    instance_type = "t2.micro"
    ami_id = "ami-0303e2e4a29f041a3"
    volume_size = 8
    volume_type = "gp3"
}

module "staging-infra" {
    env = "staging"
    source = "./infra"
    instance_count = 2
    instance_type = "t2.micro"
    ami_id = "ami-0303e2e4a29f041a3"
    volume_size = 8
    volume_type = "gp3"
}
