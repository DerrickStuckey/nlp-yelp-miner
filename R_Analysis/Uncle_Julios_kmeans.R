## Uses Document-Term Matrix to perform k-means clustering on documents

# get Document-Term Matrix 'dtm'
source("./Uncle_Julios_dtm_gen.R")

## remove terms occurring less than 1-n% of the time (may need tweaking)
dtm_dense <- removeSparseTerms(dtm, 0.95)

## Perform k-means clustering

k <- 5
k_means_fit <- kmeans(dtm_matrix, k) # 5 cluster solution
# append cluster assignment
clustered_docs <- data.frame("cluster"=k_means_fit$cluster, uncle_julios)
#View(clustered_docs)

## Obtain list of top-weighted terms for each cluster center

cluster_means <- k_means_fit$centers

#initialize data frame w/ group 1
group_terms_1 <- names(sort(cluster_means[1,],decreasing=TRUE)[1:10])
group_name_1 <- "Group 1"
top_terms <- data.frame(group_name_1=group_terms_1)

#add each other group's top terms to the data frame
for (j in 2:k) {
  group_terms <- names(sort(cluster_means[j,],decreasing=TRUE)[1:10])
  group_name <- paste("Group",as.character(j),sep=" ")
  top_terms <- cbind(top_terms,group_name=group_terms)
}

View(top_terms)
