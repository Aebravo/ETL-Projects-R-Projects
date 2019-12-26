library(dplyr)
library(data.table)

url <- "https://sapcrm.sempra.com:60001/sap/bc/contentserver/800?get&pVersion=0046&contRep=CRMORDER&docId=5DE6FEDAA5E80EB0E10080000AC07826&compId=Target%20Group%20Export%20File.txt&accessMode=r&authId=CN%3Dsapcrm.sempra.com,OU%3DIT,O%3DSempraEnergyUtilities,L%3DSanDiego,C%3DUS&expiration=20191203221758&secKey=MIIBWQYJKoZIhvcNAQcCoIIBSjCCAUYCAQExCzAJBgUrDgMCGgUAMAsGCSqGSIb3DQEHATGCASUwggEhAgEBMHcwbDELMAkGA1UEBhMCVVMxEjAQBgNVBAcTCVNhbiBEaWVnbzEgMB4GA1UEChMXU2VtcHJhIEVuZXJneSBVdGlsaXRpZXMxCzAJBgNVBAsTAklUMRowGAYDVQQDExFzYXBjcm0uc2VtcHJhLmNvbQIHIBIEAQEHBDAJBgUrDgMCGgUAoF0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTkxMjAzMjAxNzU4WjAjBgkqhkiG9w0BCQQxFgQUgn%2BrJ1ffnrWCE67IWzr4FkLtkaUwCQYHKoZIzjgEAwQuMCwCFAPK4CWchG6i%2BnZ9wxN7JB9pVrrxAhRzHncJmyksOV7FyDor4LvVUneLcA%3D%3D"
df <- fread(url, header = T, sep = "|")
df <- as.data.frame(df)


new_df <- df %>% select('Communication Details') %>% unique()

write.csv(new_df, file = "C:\\temp\\MSL12032019.csv",row.names=FALSE, quote = F)

