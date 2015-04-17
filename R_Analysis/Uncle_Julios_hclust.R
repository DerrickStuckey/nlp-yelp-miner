## Uses Document-Term Matrix to obtain hierarchical clustering of terms and documents

library(stats)

# get Document-Term Matrix 'dtm'
source("./Uncle_Julios_dtm_gen.R")

## remove terms occurring less than 1-n% of the time (may need tweaking)
dtm_dense <- removeSparseTerms(dtm, 0.95)

#inspect(dtm_dense[1:2,])
#dim(dtm_dense)

#get dtm as matrix
dtm_matrix <- as.matrix(dtm_dense)

# ## Hierarchical clustering (using DEDC text mining example)
# scaled_dtm <- scale(dtm_matrix)
# d <- dist(scaled_dtm,method="canberra")
# method_in <- "ward.D" #other option: "ward.D2"
# nclust=5
# doc_hclust_fit = hclust(d,method=method_in) #clusters documents
# ## plot a dendrogram
# #plot(fit, hang=-1)
# plot(doc_hclust_fit,main="Document Hierarchical Clustering")

dtm_transpose <- t(dtm_matrix)
scaled_dtm_t <- scale(dtm_transpose)
d_t <- dist(scaled_dtm_t,method="canberra")
term_hclust_fit <- hclust(d_t,method=method_in) #clusters terms

# plot the dendrogram
plot(term_hclust_fit,main="Term Hierarchical Clustering",xlab="Terms")

# plot dendrogram with some cuts
#op = par(mfrow = c(2, 1)) #???
hcd = as.dendrogram(term_hclust_fit)
plot(cut(hcd, h = 2000)$upper, main = "Upper tree of cut at h=2000")
plot(cut(hcd, h = 2000)$lower[[1]], main = "First branch of lower tree with cut at h=2000")
plot(cut(hcd, h = 2000)$lower[[2]], main = "Second branch of lower tree with cut at h=2000")
plot(cut(hcd, h = 2000)$lower[[3]], main = "Third branch of lower tree with cut at h=2000")
plot(cut(hcd, h = 2000)$lower[[4]], main = "Fourth branch of lower tree with cut at h=2000")

fourth_cut <- cut(hcd, h = 2000)$lower[[4]]
plot(cut(fourth_cut, h=800)$lower[[1]], main= "Branch 1 of branch 4")
plot(cut(fourth_cut, h=800)$lower[[2]], main= "Branch 2 of branch 4")
plot(cut(fourth_cut, h=800)$lower[[3]], main= "Branch 3 of branch 4")

first_cut <- cut(hcd, h = 2000)$lower[[1]]
plot(cut(first_cut, h=200)$lower[[1]], main= "Branch 1 of branch 4")
plot(cut(first_cut, h=200)$lower[[2]], main= "Branch 2 of branch 4")
plot(cut(first_cut, h=200)$lower[[3]], main= "Branch 3 of branch 4")
plot(cut(first_cut, h=200)$lower[[4]], main= "Branch 4 of branch 4")
plot(cut(first_cut, h=200)$lower[[5]], main= "Branch 5 of branch 4")
plot(cut(first_cut, h=200)$lower[[6]], main= "Branch 6 of branch 4")


