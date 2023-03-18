terraform {
  backend "s3" {
    bucket = "dev-example-tfstate"
    region = "ap-northeast-1"
    key    = "terraform.tfstate"
  }
}

# デフォルトプロバイダ
provider "aws" {
  region = "ap-northeast-1"
}

# モジュールの呼び出し
module "common" {
  source                             = "../../common"
  env_name                           = "dev"
  domain                             = "example-dev.com"
}
