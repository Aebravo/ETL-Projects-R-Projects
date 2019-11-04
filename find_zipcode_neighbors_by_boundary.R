# load libraries
#install.packages("xlsx")
#install.packages("dplyr")
#install.packages(c("rgdal","spdep"))
#install.packages('spDataLarge', repos='https://nowosad.github.io/drat/', type='source')
#install.packages("hashmap")
library(rgdal)
library(spdep)
library(reshape2)
library(xlsx)
library(dplyr)
library(tidyr)
library(hashmap)

# download, unzip and import shapefile
#download input file at https://www2.census.gov/geo/tiger/TIGER2019/ (file name is zcta5/)
#change unzip() with your own path to zip file

unzip("C:\\Users\\Abrave\\OneDrive - Sempra Energy\\User Folders\\Downloads\\tl_2019_us_zcta510.zip", exdir=tempdir())
shp <- readOGR(tempdir(), "tl_2019_us_zcta510")
str(shp)

# identify neighbors for each poly
nbs <- setNames(poly2nb(shp), shp$ZCTA5CE10)

# convert to a binary neighbor matrix
nbs.mat <- nb2mat(nbs, zero.policy=TRUE, style='B')

# adding metadata: assign zip codes as dimension names

dimnames(nbs.mat) <- list(shp$ZCTA5CE10, shp$ZCTA5CE10)

str(shp$ZCTA5CE10)

#import sdge zip codes
sdge_zips <- read.csv("C:\\Users\\Abrave\\OneDrive - Sempra Energy\\Documents\\hftd_zips.csv", header = TRUE) #choose sdge zip code file


sdge_zips <- sdge_zips %>% 
  filter(zip_code %in% shp$ZCTA5CE10)
sdge_zips$zip_code <- as.character(sdge_zips$zip_code)

hftd_zips <- sdge_zips %>% 
  filter(points == -1)
hftd_zips$zip_code <- as.character(hftd_zips$zip_code)

df <- subset(melt(nbs.mat[sdge_zips$zip_code, sdge_zips$zip_code]), value == 1)


neighboring_zips.df <- data.frame(zip_code = df$Var2, neighbor = df$Var1)
neighboring_zips.df$zip_code <- as.character(neighboring_zips.df$zip_code)
neighboring_zips.df$neighbor <- as.character(neighboring_zips.df$neighbor)


zip_count <- neighboring_zips.df %>% 
  group_by(zip_code) %>% 
  summarize(count = count(neighbor))

zip_count
#create an empty matrix to fill with zip_codes and neighbors
ncols <- max(zip_count$count$freq, na.rm = T) + 1
nrows <- length(zip_count$count$freq)
mat <- matrix(, nrow = nrows, ncol = ncols)
dimnames(mat) <- list(zip_count$count$x, c("Zip Code", "Neighbor", "Neighbor","Neighbor","Neighbor","Neighbor","Neighbor","Neighbor","Neighbor", "Neighbor"))

#filling in matrix
mat[,1] <- as.character(zip_count$count$x)
count <- 2
for (i in 1:nrow(neighboring_zips.df)) {
  if (i >= 2) {
    if (neighboring_zips.df$zip_code[i] != neighboring_zips.df$zip_code[i-1]) {
      count <- 2 
    }
  }
  mat[neighboring_zips.df$zip_code[i], count] <- as.character(neighboring_zips.df$neighbor[i])
  count <- count + 1
}


hftd_zips <- sdge_zips %>% filter(zip_code %in% hftd_zips$zip_code)

sdge_zips_matrix <- mat
hftd_zips_matrix <- sdge_zips_matrix[hftd_zips$zip_code,]


write.table(sdge_zips_matrix,file="C:\\temp\\sdge_zipcode_neighbors.csv", sep = ",")
write.table(hftd_zips_matrix,file="C:\\temp\\hftd_zipcode_neighbors.csv", sep = ",")
