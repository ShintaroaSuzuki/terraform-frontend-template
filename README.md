# terraform-frontend-template

## requirements

-   S3 バケットに tfstate を作成している
-   `terraform/envs/**/main.tf` で作成した tfstate のバケット名を指定している
-   distribution_files リソースに `build/` のパスを指定している
-   dev, stg, prd の 3 環境を用意し、それぞれの ACCESS KEY ID と SECRET ACCESS KEY を用意する（下記の 6 つの GitHub Secrets を登録する）
    -   AWS_ACCESS_KEY_ID_DEV
    -   AWS_SECRET_ACCESS_KEY_DEV
    -   AWS_ACCESS_KEY_ID_STG
    -   AWS_SECRET_ACCESS_KEY_STG
    -   AWS_ACCESS_KEY_ID_PRD
    -   AWS_SECRET_ACCESS_KEY_PRD

```
$ yarn create react-app app --template typescript
```
