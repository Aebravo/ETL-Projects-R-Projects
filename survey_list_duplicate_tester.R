re_energized <- read.csv(file.choose(), header = T)
all_contacted <- read.csv(file.choose(), header = T)

re_energized$list_type <- rep("re-energized", nrow(re_energized))
all_contacted$list_type <- rep("all-contacted", nrow(all_contacted))

df <- rbind(re_energized, all_contacted)
str(re_energized)



?rbind

?rep
n_occur <- data.frame(table(df$TX_EMAIL_ADDR))

n_occur[!(n_occur$Freq == 1),]

df[df$TX_EMAIL_ADDR %in% n_occur$Var1[n_occur$Freq > 1],]

