# Changelog

All notable changes to this project will be documented in this file. See
[Conventional Commits](https://conventionalcommits.org) for commit guidelines.

## [1.3.0](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/compare/v1.2.0...v1.3.0) (2024-07-23)


### Features

* **ecs:** Add inputs for ECS capacity provider ([a25cf77](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/a25cf77318c2296bd39d40b8fa3ba2d07a633b68))
* **outputs:** Add ecs_capacity_provider_name output ([604a2a3](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/604a2a3389042dabcff2e6af261a9b5270d88c3b))

## [1.2.0](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/compare/v1.1.0...v1.2.0) (2024-06-19)


### Features

* **vpc-peering:** Add auto_accept argument to aws_vpc_peering_connection.this ([b131199](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/b131199191a5d26a24ee0764dc5a11003a41923e))
* **vpc-peering:** Add aws_vpc_peering_connection resource ([75fbe71](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/75fbe71ad35022a3e02075f2edaaf000308b5aad))
* **vpc-peering:** Reverse accepter and requester dns resolution options ([fc1f6d3](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/fc1f6d3d720abb36226572c9f0a97060c9faa891))

## [1.1.0](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/compare/v1.0.0...v1.1.0) (2024-06-05)


### Features

* **alb:** Add default HTTPS ALB Listener ([c55c1a0](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/c55c1a0a8580d874823aff2b4bebd0ea29962aeb))
* **outputs:** Add ECS Cluster name output ([1be6d15](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/1be6d152eb4e63383aa2f0e46db7e14daac0860c))
* **outputs:** Add subnet id outputs ([8bfe8c3](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/8bfe8c35c984ecbeb7bb4889de2d142f9575532e))
* **security-group:** Allow egress to S3 on VPC endpoints security group ([f2101ec](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/f2101ec46496f335dd6853270423dbe4ca1f4559))

## 1.0.0 (2024-04-30)


### Features

* **commitlint:** Add .commitlintrc.mjs ([de11a14](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/de11a14363af5c233395af05915c617a4efeec5b))
* **ec2:** Filter AMI using OS architecture ([35f6376](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/35f637653fce0d558d6c2af1292ba4e493d78005))
* **gitignore:** Add .gitignore file ([83c3b4e](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/83c3b4ecd112b9eafa7e26130bbfbeee6b677907))
* **readme:** Update README.md with details of GitHub actions ([74a92d8](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/74a92d8150f4ac8581797bc60f33ece675f243ef))
* **releaserc:** Format .releaserc.json and add missing branches configuration ([485ea3a](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/485ea3a078d4a8164d3a1ff65b6a7e7da4a81dc7))
* **route53:** Add data block to look up an existing hosted zone ([c9af61f](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/c9af61f57baf5a109af700079ac92c2776c50994))
* **s3:** Add s3_bucket_force_destroy input variable ([2b57169](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/2b57169009a5e5e612aab294bdcaf3509ffba10c))
* **terraform:** Add test/sandbox root module for testing ([2811478](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/281147830ce4262acfb5a750bb79249d37ec606c))
* **terraform:** Initial commit of Terraform code ([e4d6019](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/e4d6019e7b601f51e7d77e415e7929c42e815657))
* **workflow:** Add commitlint.yml ([f1122e4](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/f1122e4a81c2323018cfdbf0dd9ce8c89f48a1c0))
* **workflow:** Add release.yml ([16fbb5c](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/16fbb5c603da0ecb2bb55240e6dfed9fee60d393))
* **workflow:** Add terraform-fmt workflow ([81b8420](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/81b8420f7f7c8dbc04d6cd2d35a65c84144f13c2))
* **workflow:** Install conventioncommits. Add .releaserc.json ([c6e9c97](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/c6e9c9769c209e600c92e9d086f3d8520f20b12d))
* **workflow:** Update .releaserc.json and .github/workflows/release.yml ([843d789](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/843d789c91caff451df883cb1b2eded8bf103664))
* **workflow:** Use custom terraform-fmt action ([f227660](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/f227660bcb0b1501cdd7bb508eae54d5d921814f))
