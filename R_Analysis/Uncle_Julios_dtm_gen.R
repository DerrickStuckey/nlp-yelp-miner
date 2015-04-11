##Generates Document-Term matrix for Uncle Julio's

library(tm)
library(SnowballC)

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