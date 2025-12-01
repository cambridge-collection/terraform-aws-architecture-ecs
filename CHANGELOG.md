# Changelog

All notable changes to this project will be documented in this file. See
[Conventional Commits](https://conventionalcommits.org) for commit guidelines.

## [4.2.0](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/compare/v4.1.0...v4.2.0) (2025-12-01)


### Features

* **ecs:** Add ability for ECS capacity provider to manage instances ([43c18a7](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/43c18a7674a75f2f5d4c1e6ff686caaadefc7305))
* **iam:** Add extra IAM policy for infrastructure role ([b8ea84d](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/b8ea84d0bf3224a601a62385ebe0fe097de8e481))

## [4.1.0](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/compare/v4.0.0...v4.1.0) (2025-06-16)


### Features

* **s3:** Allow name of S3 bucket to be overridden ([5ed57b1](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/5ed57b1f9cf81095a5f1e0fdfbd2462adac9b10c))
* **s3:** Make S3 bucket creation optional ([dc0bacf](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/dc0bacf5935119165de77cf0af2c16d0f1f37e14))

## [4.0.0](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/compare/v3.1.0...v4.0.0) (2025-06-12)


### ⚠ BREAKING CHANGES

* **vpc:** Resource labels have changed requiring moved blocks
* **tf:** Requires providers argument to be passed to the module

### Features

* **asg:** Add desired_capacity to ignore_changes argument of ASG ([6dd46c2](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/6dd46c26de4bccd7b36f3b11e8c495659d3a834d))
* **ec2:** Allow additional configuration for ECS agent ([507cc30](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/507cc306a3d46dcfc315b110e29f59b4e2a9f168))
* **ecs:** Add default capacity provider strategy to ECS cluster ([ffcf2a6](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/ffcf2a6f37f52f4d5f67ca9d8c76837c35a4844c))
* **logs:** Add ability to create a cloudwatch log group ([86e7fef](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/86e7fefeaf195595f4f1b07778fda0bf0ed6c9f6))
* **vpc:** Build subnets by count ([59716e4](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/59716e4a80cb65149db84a355d30cad75b3cb981))


### Bug Fixes

* **tf:** Remove provider.tf allowing us-east-1 provider to be overridden ([90acf1b](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/90acf1bc2b400c26c6420ef7c70fb2ee3e211c2a))

## [3.1.0](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/compare/v3.0.0...v3.1.0) (2025-02-19)


### Features

* Add a variable to allow overriding of some WAF action to challenge from captcha ([8f13e75](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/8f13e75e966b1b968a72453fe79b17b53f2e0f31))
* Update the override actions for WAF to list ([29f424c](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/29f424cfd82a1b3ad4523c7f9292cd2f27b7acfc))


### Bug Fixes

* **waf:** Add default value to waf_bot_control_exclusions input ([26912a3](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/26912a38e45252a98dee611054efd5e031488367))

## [3.0.0](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/compare/v2.5.1...v3.0.0) (2025-02-04)


### ⚠ BREAKING CHANGES

* replace variables with waf_bot_control_exclusions list of objects

### Features

* Updating to add exclusion type header or uri to WAF bot settings ([a902672](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/a902672e3e7baeba81e9e5020fb70f0205211da7))

## [2.5.1](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/compare/v2.5.0...v2.5.1) (2025-01-24)


### Bug Fixes

* **waf:** Fix mangled managed_rule_group_statement block ([58294fe](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/58294fef34395eec5774016d561afc0ca9e40bc4))

## [2.5.0](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/compare/v2.4.0...v2.5.0) (2025-01-23)


### Features

* **waf:** Add ability to exclude certain headers from bot control ([585434d](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/585434d9f343fa253c0cbbcbc3471d87746ae9c6))

## [2.4.0](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/compare/v2.3.0...v2.4.0) (2025-01-23)


### Features

* **waf:** Add bot control WAF rule ([bef9d5c](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/bef9d5c8d9625ca881a39c8955fd9462822a9f64))

## [2.3.0](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/compare/v2.2.0...v2.3.0) (2025-01-20)


### Features

* **vpc:** Add aws_security_group_rule.vpc_egress_http ([ee38903](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/ee38903ce9c703a664d73be91e2419f12a157daa))

## [2.2.0](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/compare/v2.1.0...v2.2.0) (2025-01-13)


### Features

* **waf:** Add dynamic forwarded_ip_config block to rate limiting rule ([20292d3](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/20292d37bdb1d2e7df3b695152e7fc7c167059c9))
* **waf:** Add optional rate limiting block on aws_wafv2_web_acl.this ([e3b2ec5](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/e3b2ec5ccbc3bec7955a0e39651989d075d5b8e3))
* **waf:** Reorder WAF rules so ip restriction allow rule comes last ([cc71261](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/cc71261a880ec8a8531b8edf5b865da85fd341d0))

## [2.1.0](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/compare/v2.0.0...v2.1.0) (2024-11-08)


### Features

* **ec2:** Allow additional userdata ([1c47314](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/1c4731495e0c6a0451063f1ed5d7bcf998e9d878))

## [2.0.0](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/compare/v1.7.2...v2.0.0) (2024-10-23)


### ⚠ BREAKING CHANGES

* **vpc:** Input asg_allow_all_egress has been removed

### Features

* **vpc:** Add aws_security_group.egress_https ([921c30c](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/921c30c62170ebda5b3ad92b27ed7fc94e3f55cc))
* **vpc:** Make VPC Endpoints conditional ([12eea02](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/12eea02edabbb382e0d9dbcb1da12edc396f6f45))

## [1.7.2](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/compare/v1.7.1...v1.7.2) (2024-10-14)


### Bug Fixes

* **waf:** Update default_action block to use dynamic blocks ([24a354b](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/24a354b7fb5b8f64101efdb3edc432a00340ba1a))

## [1.7.1](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/compare/v1.7.0...v1.7.1) (2024-10-14)


### Bug Fixes

* **waf:** Update WAF to turn off IP set restrictions by default ([8741c20](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/8741c20d5ee6e3b1345496c9a5335e5321199157))

## [1.7.0](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/compare/v1.6.0...v1.7.0) (2024-10-02)


### Features

* **acm:** Add ability to use existing certificate ([ea03c9e](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/ea03c9e24bcaf7102c97972ce556da272dd268f5))
* **acm:** Add reference to existing ACM certificate ([139774d](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/139774d5909a41a517dfa0847a78e6ffe73c777e))

## [1.6.0](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/compare/v1.5.1...v1.6.0) (2024-09-20)


### Features

* **security:** Add aws_security_group_rule.asg_egress_all resource ([df2eae8](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/df2eae8d25395a5967f2872516b7da4a2bbe4b6d))

## [1.5.1](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/compare/v1.5.0...v1.5.1) (2024-09-20)


### Bug Fixes

* **asg:** Fix error creating ECS capacity provider ([dec8ff9](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/dec8ff96a3ad757edffefa8ede4d163ff49bc060))

## [1.5.0](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/compare/v1.4.0...v1.5.0) (2024-09-20)


### Features

* **output:** Add vpc_endpoint_security_group_id output ([39b0cda](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/39b0cdab0d8f86d61551ead4121409124e0f5f92))

## [1.4.0](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/compare/v1.3.0...v1.4.0) (2024-09-05)


### Features

* **vpc:** Add NAT gateway in B subnets ([5acedb0](https://github.com/cambridge-collection/terraform-aws-architecture-ecs/commit/5acedb0509dff42c67355fd125ce82b0ffa14af0))

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
