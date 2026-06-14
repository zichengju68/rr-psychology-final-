###Reopening Openness to Experience:
###A Network Analysis of Four Openness to Experience Inventories

###install necessary packages
devtools::install_github("AlexChristensen/NetworkToolbox")
install.packages(qgraph)
install.packages(igraph)

###load packages
library(NetworkToolbox)
library(qgraph)
library(igraph)

###read in data
data <- read.csv(file.choose(),header=TRUE,sep=",")

###construct network
tmfg <- TMFG(data)$A

###perform walktrap community detection algorithm
walktrap <- convert2igraph(tmfg)

#check walktrap robustness
rand<-.Random.seed
walkcheck<-matrix(0,nrow=138,ncol=10)

for(i in 1:10)
{
    set.seed(rand[i])
    walkcheck[,i]<-walktrap.community(walktrap)$membership
}

set.seed(0)
wc<-walktrap.community(walktrap)
wc$membership
max(wc$membership)

###name communities
for (i in 1:length(wc$membership))
    if (wc$membership[i] == 1)
    {wc$membership[i]<-c("Intellectual Curiosity")
    }else if (wc$membership[i] == 2)
    {wc$membership[i]<-c("Aesthetic Appreciation")
    }else if (wc$membership[i] == 3)
    {wc$membership[i]<-c("Self-Assessed Intelligence")
    }else if (wc$membership[i] == 4)
    {wc$membership[i]<-c("Openness to Emotions")
    }else if (wc$membership[i] == 5)
    {wc$membership[i]<-c("Intellectual Interests")
    }else if (wc$membership[i] == 6)
    {wc$membership[i]<-c("Imaginative")
    }else if (wc$membership[i] == 7)
    {wc$membership[i]<-c("Non-Traditionalism")
    }else if (wc$membership[i] == 8)
    {wc$membership[i]<-c("Diversity")
    }else if (wc$membership[i] == 9)
    {wc$membership[i]<-c("Variety-Seeking")
    }else if (wc$membership[i] == 10)
    {wc$membership[i]<-c("Fantasy")}
###Full Network
layout(matrix(c(1,1)))
shapes<-c(rep("circle",48),rep("square",20),rep("diamond",16),rep("triangle",54))
plot.ega <- qgraph(tmfg, label.prop=1.5, layout = "spring", vsize = 2.5, esize = 10, groups = as.factor(wc$membership),GLratio=1.5,shape=shapes,palette="ggplot2")

####Layout the four Openness to Experience inventories
layout(matrix(c(1,3,2,4),nrow=2))

#BFAS Network
BFAS<-as.factor(c(rep(NA,48),wc$membership[49:68]))
plot.egab <- qgraph(tmfg, title = "BFAS", groups = BFAS, layout = "spring", vsize = 4, esize = 10,GLratio=1.5,labels=FALSE,shape=shapes,palette="ggplot2")

#HEXACO Network
HEX<-as.factor(c(rep(NA,68),wc$membership[69:84]))
plot.egah <- qgraph(tmfg, title = "HEXACO-100", groups = HEX, layout = "spring", vsize = 4, esize = 10,GLratio=1.5,labels=FALSE,shape=shapes,palette="ggplot2")

#NEO Network
NEO<-as.factor(wc$membership[1:48])
plot.egan <- qgraph(tmfg, title = "NEO-PI-3", groups = NEO, layout = "spring", vsize = 4, esize = 10,GLratio=1.5,labels=FALSE,shape=shapes,palette="ggplot2")

#Woo Network
WOO<-as.factor(c(rep(NA,84),wc$membership[85:138]))
plot.egaw <- qgraph(tmfg, title = "Woo et al. (2014)", groups = WOO, layout = "spring", vsize = 4, esize = 10, GLratio=1.5,labels=FALSE,shape=shapes,palette="ggplot2")


#Supplementary
#BFAS Network
layout(matrix(c(1,1)))
BFAS<-as.factor(c(rep(NA,48),wc$membership[49:68]))
plot.egab <- qgraph(tmfg, title="BFAS",label.prop=1.5,groups = BFAS, layout = "spring", vsize = 2.5, esize = 10,GLratio=1.5,shape=shapes,palette="ggplot2")

#HEXACO Network
HEX<-as.factor(c(rep(NA,68),wc$membership[69:84]))
plot.egah <- qgraph(tmfg, title="HEXACO-100",label.prop=1.5,groups = HEX, layout = "spring", vsize = 2.5, esize = 10,GLratio=1.5,shape=shapes,palette="ggplot2")

#NEO Network
NEO<-as.factor(wc$membership[1:48])
plot.egan <- qgraph(tmfg, title="NEO-PI-3",label.prop=1.5,groups = NEO, layout = "spring", vsize = 2.5, esize = 10,GLratio=1.5,shape=shapes,palette="ggplot2")

#Woo Network
WOO<-as.factor(c(rep(NA,84),wc$membership[85:138]))
plot.egaw <- qgraph(tmfg, title="Woo et al. (2014)",label.prop=1.5,groups = WOO, layout = "spring", vsize = 2.5, esize = 10, GLratio=1.5,shape=shapes,palette="ggplot2")

#MANOVA
data<-read.csv(file.choose())
data[,1]<-as.factor(data[,1])

#equal sample sizes
one<-subset(data,Group==1)
two<-subset(data,Group==2)
three<-subset(data,Group==3)

#across all
equals<-rbind(one,two,three)

openman<-manova(cbind(
      neo_03,   neo_08,   neo_13,   neo_18,   neo_23,   neo_28,   neo_33,  
      neo_38,   neo_43,   neo_48,   neo_53,   neo_58,   neo_63,   neo_68,   neo_73,  
      neo_78,   neo_83,   neo_88,   neo_93,   neo_98,   neo_103,  neo_108,  neo_113, 
      neo_118,  neo_123,  neo_128,  neo_133,  neo_138,  neo_143,  neo_148,  neo_153, 
      neo_158,  neo_163,  neo_168,  neo_173,  neo_178,  neo_183,  neo_188,  neo_193, 
      neo_198,  neo_203,  neo_208,  neo_213,  neo_218,  neo_223,  neo_228,  neo_233, 
      neo_238,  bfasi01,  bfaso01,  bfasi02,  bfaso02,  bfasi03,  bfaso03,  bfasi04, 
      bfaso04,  bfasi05,  bfaso05,  bfasi06,  bfaso06,  bfasi07,  bfaso07,  bfasi08, 
      bfaso08,  bfasi09,  bfaso09,  bfasi10,  bfaso10,  o_aes01,  o_aes02,  o_aes03, 
      o_aes04,  o_inq01,  o_inq02,  o_inq03,  o_inq04,  o_cre01,  o_cre02,  o_cre03, 
      o_cre04,  o_unc01,  o_unc02,  o_unc03,  o_unc04,  woo_tol1, woo_tol2, woo_tol3,
      woo_tol4, woo_tol5, woo_tol6, woo_tol7, woo_tol8, woo_tol9, woo_dep1, woo_dep2,
      woo_dep3, woo_dep4, woo_dep5, woo_dep6, woo_dep7, woo_dep8, woo_dep9, woo_eff1,
      woo_eff2, woo_eff3, woo_eff4, woo_eff5, woo_eff6, woo_eff7, woo_eff8, woo_eff9,
      woo_ing1, woo_ing2, woo_ing3, woo_ing4, woo_ing5, woo_ing6, woo_ing7, woo_ing8,
      woo_ing9, woo_cur1, woo_cur2, woo_cur3, woo_cur4, woo_cur5, woo_cur6, woo_cur7,
      woo_cur8, woo_cur9, woo_aes1, woo_aes2, woo_aes3, woo_aes4, woo_aes5, woo_aes6,
      woo_aes7, woo_aes8, woo_aes9
      ) ~ Group, data)

summary(openman)

#mturk and first college
onetwo<-rbind(one,two)

otman<-manova(cbind(
    neo_03,   neo_08,   neo_13,   neo_18,   neo_23,   neo_28,   neo_33,  
    neo_38,   neo_43,   neo_48,   neo_53,   neo_58,   neo_63,   neo_68,   neo_73,  
    neo_78,   neo_83,   neo_88,   neo_93,   neo_98,   neo_103,  neo_108,  neo_113, 
    neo_118,  neo_123,  neo_128,  neo_133,  neo_138,  neo_143,  neo_148,  neo_153, 
    neo_158,  neo_163,  neo_168,  neo_173,  neo_178,  neo_183,  neo_188,  neo_193, 
    neo_198,  neo_203,  neo_208,  neo_213,  neo_218,  neo_223,  neo_228,  neo_233, 
    neo_238,  bfasi01,  bfaso01,  bfasi02,  bfaso02,  bfasi03,  bfaso03,  bfasi04, 
    bfaso04,  bfasi05,  bfaso05,  bfasi06,  bfaso06,  bfasi07,  bfaso07,  bfasi08, 
    bfaso08,  bfasi09,  bfaso09,  bfasi10,  bfaso10,  o_aes01,  o_aes02,  o_aes03, 
    o_aes04,  o_inq01,  o_inq02,  o_inq03,  o_inq04,  o_cre01,  o_cre02,  o_cre03, 
    o_cre04,  o_unc01,  o_unc02,  o_unc03,  o_unc04,  woo_tol1, woo_tol2, woo_tol3,
    woo_tol4, woo_tol5, woo_tol6, woo_tol7, woo_tol8, woo_tol9, woo_dep1, woo_dep2,
    woo_dep3, woo_dep4, woo_dep5, woo_dep6, woo_dep7, woo_dep8, woo_dep9, woo_eff1,
    woo_eff2, woo_eff3, woo_eff4, woo_eff5, woo_eff6, woo_eff7, woo_eff8, woo_eff9,
    woo_ing1, woo_ing2, woo_ing3, woo_ing4, woo_ing5, woo_ing6, woo_ing7, woo_ing8,
    woo_ing9, woo_cur1, woo_cur2, woo_cur3, woo_cur4, woo_cur5, woo_cur6, woo_cur7,
    woo_cur8, woo_cur9, woo_aes1, woo_aes2, woo_aes3, woo_aes4, woo_aes5, woo_aes6,
    woo_aes7, woo_aes8, woo_aes9
) ~ Group, onetwo)

summary(otman)

#mturk and second college
onethree<-rbind(one,three)

oteman<-manova(cbind(
    neo_03,   neo_08,   neo_13,   neo_18,   neo_23,   neo_28,   neo_33,  
    neo_38,   neo_43,   neo_48,   neo_53,   neo_58,   neo_63,   neo_68,   neo_73,  
    neo_78,   neo_83,   neo_88,   neo_93,   neo_98,   neo_103,  neo_108,  neo_113, 
    neo_118,  neo_123,  neo_128,  neo_133,  neo_138,  neo_143,  neo_148,  neo_153, 
    neo_158,  neo_163,  neo_168,  neo_173,  neo_178,  neo_183,  neo_188,  neo_193, 
    neo_198,  neo_203,  neo_208,  neo_213,  neo_218,  neo_223,  neo_228,  neo_233, 
    neo_238,  bfasi01,  bfaso01,  bfasi02,  bfaso02,  bfasi03,  bfaso03,  bfasi04, 
    bfaso04,  bfasi05,  bfaso05,  bfasi06,  bfaso06,  bfasi07,  bfaso07,  bfasi08, 
    bfaso08,  bfasi09,  bfaso09,  bfasi10,  bfaso10,  o_aes01,  o_aes02,  o_aes03, 
    o_aes04,  o_inq01,  o_inq02,  o_inq03,  o_inq04,  o_cre01,  o_cre02,  o_cre03, 
    o_cre04,  o_unc01,  o_unc02,  o_unc03,  o_unc04,  woo_tol1, woo_tol2, woo_tol3,
    woo_tol4, woo_tol5, woo_tol6, woo_tol7, woo_tol8, woo_tol9, woo_dep1, woo_dep2,
    woo_dep3, woo_dep4, woo_dep5, woo_dep6, woo_dep7, woo_dep8, woo_dep9, woo_eff1,
    woo_eff2, woo_eff3, woo_eff4, woo_eff5, woo_eff6, woo_eff7, woo_eff8, woo_eff9,
    woo_ing1, woo_ing2, woo_ing3, woo_ing4, woo_ing5, woo_ing6, woo_ing7, woo_ing8,
    woo_ing9, woo_cur1, woo_cur2, woo_cur3, woo_cur4, woo_cur5, woo_cur6, woo_cur7,
    woo_cur8, woo_cur9, woo_aes1, woo_aes2, woo_aes3, woo_aes4, woo_aes5, woo_aes6,
    woo_aes7, woo_aes8, woo_aes9
) ~ Group, onethree)

summary(oteman)

#first and second college
twothree<-rbind(two,three)

ttman<-manova(cbind(
    neo_03,   neo_08,   neo_13,   neo_18,   neo_23,   neo_28,   neo_33,  
    neo_38,   neo_43,   neo_48,   neo_53,   neo_58,   neo_63,   neo_68,   neo_73,  
    neo_78,   neo_83,   neo_88,   neo_93,   neo_98,   neo_103,  neo_108,  neo_113, 
    neo_118,  neo_123,  neo_128,  neo_133,  neo_138,  neo_143,  neo_148,  neo_153, 
    neo_158,  neo_163,  neo_168,  neo_173,  neo_178,  neo_183,  neo_188,  neo_193, 
    neo_198,  neo_203,  neo_208,  neo_213,  neo_218,  neo_223,  neo_228,  neo_233, 
    neo_238,  bfasi01,  bfaso01,  bfasi02,  bfaso02,  bfasi03,  bfaso03,  bfasi04, 
    bfaso04,  bfasi05,  bfaso05,  bfasi06,  bfaso06,  bfasi07,  bfaso07,  bfasi08, 
    bfaso08,  bfasi09,  bfaso09,  bfasi10,  bfaso10,  o_aes01,  o_aes02,  o_aes03, 
    o_aes04,  o_inq01,  o_inq02,  o_inq03,  o_inq04,  o_cre01,  o_cre02,  o_cre03, 
    o_cre04,  o_unc01,  o_unc02,  o_unc03,  o_unc04,  woo_tol1, woo_tol2, woo_tol3,
    woo_tol4, woo_tol5, woo_tol6, woo_tol7, woo_tol8, woo_tol9, woo_dep1, woo_dep2,
    woo_dep3, woo_dep4, woo_dep5, woo_dep6, woo_dep7, woo_dep8, woo_dep9, woo_eff1,
    woo_eff2, woo_eff3, woo_eff4, woo_eff5, woo_eff6, woo_eff7, woo_eff8, woo_eff9,
    woo_ing1, woo_ing2, woo_ing3, woo_ing4, woo_ing5, woo_ing6, woo_ing7, woo_ing8,
    woo_ing9, woo_cur1, woo_cur2, woo_cur3, woo_cur4, woo_cur5, woo_cur6, woo_cur7,
    woo_cur8, woo_cur9, woo_aes1, woo_aes2, woo_aes3, woo_aes4, woo_aes5, woo_aes6,
    woo_aes7, woo_aes8, woo_aes9
) ~ Group, twothree)

summary(ttman)

library(biotools)
dat<-onetwo[,-1]
grouping<-onetwo[,1]

boxM(dat,grouping)