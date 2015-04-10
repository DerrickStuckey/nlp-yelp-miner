## Analysis of Uncle Julio's reviews

library(tm)
library(SnowballC)
library(stats)

uncle_julios <- read.delim("~/Desktop/GW/NLP/NLP Project/uncle_julios.csv")
#docs = Corpus(DataframeSource(uncle_julios))

#uncle_julios <- uncle_julios[1:10,]
docs = Corpus(VectorSource(uncle_julios$content))

## displays available transformations: 
#getTransformations()

docs = tm_map(docs, content_transformer(tolower))
## clean up corpus as well as possible
docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs, removeNumbers)
docs <- tm_map(docs, removeWords, stopwords("english"))

#inspect(docs[0:3])

## requires 'SnowballC' package
docs <- tm_map(docs, stemDocument)

## construct document-term matrix
dtm <- DocumentTermMatrix(docs, control = list(weighting = weightTfIdf))
#inspect(dtm[0:5,0:5])

## just for fun, find associations with words 'good' and 'bad'
#good_assocs <- findAssocs(dtm, "good", corlimit =0.1)
#bad_assocs <- findAssocs(dtm, "bad", corlimit =0.1)

## remove terms occurring less than 10% of the time (may need tweaking)
dtm_dense <- removeSparseTerms(dtm, 0.90)

#inspect(dtm_dense[1:2,])
#dim(dtm_dense)

## Hierarchical clustering (using DEDC text mining example)
dtm_matrix <- as.matrix(dtm_dense)
scaled_dtm <- scale(dtm_matrix)
d <- dist(scaled_dtm,method="canberra")
method_in <- "ward.D" #other option: "ward.D2"
nclust=5
doc_hclust_fit = hclust(d,method=method_in) #clusters documents
## plot a dendrogram
#plot(fit, hang=-1)
plot(doc_hclust_fit,main="Document Hierarchical Clustering")

dtm_transpose <- t(dtm_matrix)
scaled_dtm_t <- scale(dtm_transpose)
d_t <- dist(scaled_dtm_t,method="canberra")
term_hclust_fit <- hclust(d_t,method=method_in) #clusters terms
plot(term_hclust_fit,main="Term Hierarchical Clustering")

## attempt k-means clustering
# K-Means Cluster Analysis
k_means_fit <- kmeans(dtm_matrix, 5) # 5 cluster solution
# append cluster assignment
clustered_docs <- data.frame("cluster"=k_means_fit$cluster, uncle_julios)
View(clustered_docs)

# get cluster means 
cluster_means <- aggregate(dtm_matrix,by=list(k_means_fit$cluster),FUN=mean)
