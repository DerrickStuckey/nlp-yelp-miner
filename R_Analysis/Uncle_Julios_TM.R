## Analysis of Uncle Julio's reviews

uncle_julios <- read.delim("~/Desktop/GW/NLP/NLP Project/uncle_julios.csv")
library(tm)
docs = Corpus(DataframeSource(uncle_julios))

## displays available transformations: 
#getTransformations()

## clean up corpus as well as possible
docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs, removeNumbers)

## throwing errors and fouling up subsequent operations
#docs <- tm_map(docs, stemDocument)

## construct document-term matrix
dtm <- DocumentTermMatrix(docs, control = list(weighting = weightTfIdf))

## just for fun, find associations with words 'good' and 'bad'
#good_assocs <- findAssocs(dtm, "good", corlimit =0.1)
#bad_assocs <- findAssocs(dtm, "bad", corlimit =0.1)

## remove terms occurring less than 5% of the time (1-95%)
dtm_dense <- removeSparseTerms(dtm, 0.95)
#inspect(dtm_dense[1:2,])
#dim(dtm_dense)

## Hierarchical clustering (using DEDC text mining example)
library(stats)

dtm_matrix <- as.matrix(dtm_dense)
scale_ch = scale(dtm_matrix)
d=dist(scale_ch,method="canberra")
method_in = "ward"
nclust=5
fit = hclust(d,method=method_in)

## plot a dendrogram
#plot(fit, hang=-1)
plot(fit)

## attempt k-means clustering
# K-Means Cluster Analysis
k_means_fit <- kmeans(dtm_matrix, 5) # 5 cluster solution
# get cluster means 
aggregate(dtm_matrix,by=list(k_means_fit$cluster),FUN=mean)
# append cluster assignment
mydata <- data.frame(mydata, fit$cluster)

