df <- read.csv(file.choose(), header = FALSE, sep = "\n", skip = 1)

str(df)

df$V1 <- as.character(df$V1)
df$V1

library(stringr)

df1 <- str_remove(df$V1, "^M.+EnergizedForSafety")

df1 <- str_remove(df1, "^(\\s)?(.){6}R")
df1 <- str_remove(df1, "^(1)(.){6}7")
df1 <- str_remove(df1, "^\\s1030-987")

df1

#grabbing account numbers
acc_nbr <- str_match(df1,"^(\\s)*(\\d)+(\\s)")
acc_nbr <- str_remove_all(acc_nbr[,1], "\\s")

acc_nbr

#grabbing PremIDs
df1 <- str_remove(df1,"^(\\s)*(\\d)+(\\s)")
prem_IDs <- str_match(df1, "^[\\d\\s]\\d+\\s")
prem_IDs <- str_remove_all(prem_IDs, "\\s")
prem_IDs
df1 <- str_remove(df1,"^(.)+]")
df1

#grabbing names
name <- str_match(df1,"^(\\s)*([:alpha:]|\\s|\\&)+((22|23) LLC)?")
name <- str_remove_all(name[,1], "^\\s+")
name <- str_remove_all(name, "\\s+$")
name

df1 <- str_match(df1,"(\\d).+")[1:397,1]
str(df1)

#grabbing addresses
address <- str_match(df1, "^(.)*CA\\s")[,1]
address <- str_remove_all(address, "\\s+$")
address

df1 <- str_remove(df1, "^.+CA\\s")

#grabbing zip codes
zip_code <- str_match(df1, "^(\\d)+")[,1]
zip_code


df1 <- str_remove(df1, "^\\d+\\s")

#grabbing attempted contact
attempted <- str_match(df1, "^Yes|No")
attempted

df1 <- str_remove(df1, "^(Yes|No)\\s")

#grabbing confirmed contact
confirmed <- str_match(df1, "^Yes|No")
confirmed

df1 <- str_remove(df1, "^(Yes|No)\\s")

#PickupDate
pickupDate <- str_match(df1, "^\\d.+(AM|PM)")
pickupDate <- pickupDate[,1]
pickupDate
pickupDate <- str_remove(pickupDate, "\\s[EHC].+$")
pickupDate

df1 <- str_remove(df1, "^\\d.+(AM|PM)\\s")

df1
#devicedetail
device_detail <- str_match(df1, "^.+")
device_detail <- str_remove(device_detail, "\\s$")
device_detail
length(acc_nbr)#
length(name)
length(address)
length(pickupDate)
length(device_detail)

device_detail <- gsub(" ", "", device_detail)
device_detail <- gsub("\\+", " \\+", device_detail)
device_detail <- gsub("^E", "E ", device_detail)
device_detail

#grab contact type
contact_type <- substr(device_detail, 1, 1)
contact_type

device_detail <- str_remove(device_detail, "^[:alpha:]\\s")
device_detail

reenergize_list <- data.frame(ACC_NBR = acc_nbr[1:397], PREM_ID = prem_IDs[1:397], NAME = name[1:397], ADDRESS = address, ZIP_CODE = zip_code, 
                              ATTEMPTED = attempted, CONTACTED = confirmed, PICKUP_DATE = pickupDate, 
                              CONTACT_TYPE = contact_type, DEVICE_DETAIL = device_detail)
reenergize_list

write.csv(reenergize_list, "C:\\temp\\reenergize_list_v2.csv", row.names = FALSE)


library(mice)
md.pattern(reenergize_list)
