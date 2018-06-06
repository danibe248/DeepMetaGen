library("usedist", lib.loc="~/R/x86_64-pc-linux-gnu-library/3.4")
library("entropy", lib.loc="~/R/x86_64-pc-linux-gnu-library/3.4")
library("Rtsne", lib.loc="~/R/x86_64-pc-linux-gnu-library/3.4")
library("reshape2", lib.loc="~/R/x86_64-pc-linux-gnu-library/3.4")
library("ggplot2", lib.loc="~/R/x86_64-pc-linux-gnu-library/3.4")
library("class", lib.loc="/usr/lib/R/library")

kNN.KL <- function(train,test,k) {
  X.train = train[,-1]
  X.test = test[,-1]
  Y.train = train[,1]
  Y.test = test[,1]
  kl.scores = matrix(0, nrow(X.test), nrow(X.train))
  for (ie in 1:nrow(X.test)) {
    for (ia in 1:nrow(X.train)) {
      kl.scores[ie,ia] = KL.plugin(X.train[ia,],X.test[ie,])
    }
  }
  colnames(kl.scores) = Y.train
  rownames(kl.scores) = Y.test
  knn.labels = matrix(0, nrow(X.test), k-1)
  rownames(knn.labels) = Y.test
  colnames(knn.labels) = sprintf("%s%d",rep("Top",(k-1)),1:(k-1))
  for (i in 1:nrow(kl.scores)) {
    knn.labels[i,1:(k-1)] = names(head(sort(kl.scores[i,]),k-1))
  }
  return(knn.labels)
}

topics_vect = c(5,10,15,19,20,25,30)
#kmers_vect = c(3,4,6)
kmers_vect = c(6)

acc.kl = matrix(0,length(kmers_vect),length(topics_vect), dimnames = list(kmers_vect,topics_vect))
acc.e = matrix(0,length(kmers_vect),length(topics_vect), dimnames = list(kmers_vect,topics_vect))
for (k in kmers_vect) {
  for (topics in topics_vect) {
    #topics = 5
    #k = 6
    print(paste("K: ", k, " T: ", topics))
    names = c('aeruginosa','alkylphenolia','antarctica','argentinensis','arsenicoxydans','asplenii','bauzanensis','benzenivorans','brassicacearum','cerasi','chengduensis','cremoricolorata','fragi','frederiksbergensis','granadensis','koreensis','kuykendallii','lini','protegens')
    train = read.csv(paste('/home/ld/MEGA/Tesi_singa/Esperimenti/7ex_23518/',as.character(k),'_mers/',as.character(topics),'t/',as.character(k),'mers_doctopics.txt',sep = ''),header = F,sep = '\t')
    rownames(train) = sprintf("%s.%d",rep(names,each=k-1),1:(k-1))
    train = train[,-c(1,2)]

    #holdout
    # test = read.csv(paste('/home/ld/MEGA/Tesi_singa/Esperimenti/7ex_23518/',as.character(k),'_mers/',as.character(topics),'t/',as.character(k),'mers_doctopics_test.txt',sep = ''),header = F,sep = '\t')
    # test = test[-1,-c(1,2)]
    # test = as.data.frame(cbind(names,test))
    
    #dev set
    test = read.csv(paste('/home/ld/MEGA/Tesi_singa/Esperimenti/7ex_23518/',as.character(k),'_mers/6_mers_devtest/',as.character(topics),'t/',as.character(k),'mers_doctopics_test.txt',sep = ''),header = F,sep = '\t')
    test = test[-1,-c(1,2)]
    test_labels = read.csv('/home/ld/MEGA/Tesi_singa/Esperimenti/5ex_19418/csv/dev_random_10.csv',header = T, sep = ',', row.names = 1)
    test_labels = unlist(lapply(as.character(test_labels[,"class"]),FUN = function(x) {return(unlist(strsplit(x,' '))[2])}))
    test = as.data.frame(cbind(test_labels,test))
    
    #predict KL
    train = as.data.frame(cbind(rep(names,each=k-1),train))
    m = kNN.KL(train,test,k)
    pred.kl = c()
    for (z in 1:nrow(m)) {
      pred.kl = c(pred.kl,names(sort(table(m[z,]),decreasing = T)[1]))
    }
    cm.kl = as.matrix(table(Actual=as.character(test[,1]), Predicted=as.character(pred.kl)))
    acc.kl[as.character(k),as.character(topics)] = sum(diag(cm.kl)) / 30003
    
    #predict euclidean
    pred.e = knn(train = train[,-1], test = test[,-1], cl = train[,1],k-1)
    m.e = cbind(as.character(pred.e),as.character(test[,1]))
    cm.e = as.matrix(table(Actual=as.character(test[,1]), Predicted=as.character(pred.e)))
    acc.e[as.character(k),as.character(topics)] = sum(diag(cm.e)) / 30003
  }
}
#save euclidean holdout
#save(acc.e,file = '/home/ld/MEGA/Tesi_singa/Esperimenti/7ex_23518/Acc_topics_knn_euclidean.Rda')
save(acc.e,file = '/home/ld/MEGA/Tesi_singa/Esperimenti/7ex_23518/Acc_dev_knn_euclidean.Rda')
#save kl holdout
#save(acc.kl,file = '/home/ld/MEGA/Tesi_singa/Esperimenti/7ex_23518/Acc_topics_knn_kl.Rda')
save(acc.e,file = '/home/ld/MEGA/Tesi_singa/Esperimenti/7ex_23518/Acc_dev_knn_kl.Rda')