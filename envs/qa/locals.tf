locals {
  tags = {
    Environment = "qa"
    Project     = "SMS"
    ManagedBy   = "Terraform"
  }

  sms_secret_names = toset([
    "AppSettings-AppConString",
    "AppSettings-ApplicationInsights-InstrumentationKey",
    "AppSettings-AppManagerDbConStr",
    "AppSettings-AzureBlobStorage-ConnectionString",
    "AppSettings-AzureDirectory-ClientId",
    "AppSettings-AzureDirectory-ClientSecret",
    "AppSettings-AzureDirectory-TenantId",
    "AppSettings-AzureRedisCache-ConnectionString",
    "AppSettings-AzureServiceBus-ConnectionString",
    "AppSettings-AzureServiceBus-QueueMenuBuildName",
    "AppSettings-AzureServiceBus-QueueName",
    "AppSettings-AzureServiceBus-QueueNotificationName",
    "AppSettings-AzureServiceBus-QueueUserBuildName",
    "AppSettings-AzureServiceBus-QueueWorkFlowBuildName",
    "AppSettings-AzureServiceBus-TopicName",
    "AppSettings-JwtSettings-Key",
    "AppSettings-Settings-EncryptDecryptKey",
    "AppSettings-SmsDatabasePasswd",
    "AppSettings-SmsDatabaseUser",
    "AppSettings-SmsSmtpPasswd",
    "AppSettings-SmsSubscriptionId"
  ])
}
