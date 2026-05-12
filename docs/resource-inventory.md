# Resource Inventory From Portal Exports

## Native Terraform Modules Included

- Azure Container Registry: `SMSACRDEV`
- Key Vault: `metacode-kyvlt-dev`
- Key Vault: `metacode-kyvlt-qa`
- Virtual network: `sms-net`
- Subnets: `appgw-subnet`, `jumpbox-subnet`, `aks-subnet`, `private-endpoints-subnet`, `ado-agents-subnet`
- VNet peering: `sms-nonprod-agent-dev-aks`
- AKS cluster: `sms-aks-dev-cluster`
- AKS node pools: `agentpool`, `userpool`, `uipool`

## Placeholder Modules Included

These are intentionally represented as placeholders first because the ARM exports are large and include generated child resources, certificates, routes, listeners, or VM hardware attachment state. Convert them to native Terraform one module at a time after import planning.

- Application Gateway: `sms-appgw-nonprod`
- Front Door Standard/Premium profile: `sms-frontdoor-nonprod`
- VM: `sms-jumpbox`
- VM: `SMS-Non-Prod-1`

## Key Vault Secrets Expected Per Environment

- `AppSettings-AppConString`
- `AppSettings-ApplicationInsights-InstrumentationKey`
- `AppSettings-AppManagerDbConStr`
- `AppSettings-AzureBlobStorage-ConnectionString`
- `AppSettings-AzureDirectory-ClientId`
- `AppSettings-AzureDirectory-ClientSecret`
- `AppSettings-AzureDirectory-TenantId`
- `AppSettings-AzureRedisCache-ConnectionString`
- `AppSettings-AzureServiceBus-ConnectionString`
- `AppSettings-AzureServiceBus-QueueMenuBuildName`
- `AppSettings-AzureServiceBus-QueueName`
- `AppSettings-AzureServiceBus-QueueNotificationName`
- `AppSettings-AzureServiceBus-QueueUserBuildName`
- `AppSettings-AzureServiceBus-QueueWorkFlowBuildName`
- `AppSettings-AzureServiceBus-TopicName`
- `AppSettings-JwtSettings-Key`
- `AppSettings-Settings-EncryptDecryptKey`
- `AppSettings-SmsDatabasePasswd`
- `AppSettings-SmsDatabaseUser`
- `AppSettings-SmsSmtpPasswd`
- `AppSettings-SmsSubscriptionId`
