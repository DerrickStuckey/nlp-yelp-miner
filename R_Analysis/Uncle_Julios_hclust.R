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
plot(term_hclust_fit,main="Term Hierarchical Clustering",xlab="Terms")

