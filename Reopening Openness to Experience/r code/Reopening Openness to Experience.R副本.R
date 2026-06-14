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

#补充修正
table(wc$membership)                       # 现在这 8 类各有多少题
igraph::modularity(walktrap, wc$membership)# 8 类时的模块度

m10 <- igraph::cut_at(wc, no = 10)         # 强制切到 10 个社区
max(m10); table(m10)                       # 确认变成 10，看各类大小
igraph::modularity(walktrap, m10)          # 10 类时的模块度


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

#补充修正 分支
# 用强制10社区的解 + 正确的"编号→facet名"映射（来自与论文SI2逐题核对）
m10 <- igraph::cut_at(wc, no = 10)          # 你已经跑过，确认在内存里
facet_names <- c(
  "Self-Assessed Intelligence",  # 1
  "Aesthetic Appreciation",      # 2
  "Intellectual Interests",      # 3
  "Diversity",                   # 4
  "Openness to Emotions",        # 5
  "Non-Traditionalism",          # 6
  "Imaginative",                 # 7
  "Intellectual Curiosity",      # 8
  "Fantasy",                     # 9
  "Variety-Seeking"              # 10
)
wc$membership <- facet_names[m10]           # 直接替换成正确facet名(138维,按列顺序)
table(wc$membership)                        # 核对各facet题数

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

#补充修改
# ================== MANOVA（含 Group 重建）==================
setwd("D:/R语言/期末大作业/Reopening Openness to Experience")
library(haven); library(biotools)

## 0) 138个题目列：既当MANOVA因变量，也用来做指纹
dv <- c(
  "neo_03","neo_08","neo_13","neo_18","neo_23","neo_28","neo_33","neo_38","neo_43","neo_48",
  "neo_53","neo_58","neo_63","neo_68","neo_73","neo_78","neo_83","neo_88","neo_93","neo_98",
  "neo_103","neo_108","neo_113","neo_118","neo_123","neo_128","neo_133","neo_138","neo_143","neo_148",
  "neo_153","neo_158","neo_163","neo_168","neo_173","neo_178","neo_183","neo_188","neo_193","neo_198",
  "neo_203","neo_208","neo_213","neo_218","neo_223","neo_228","neo_233","neo_238",
  "bfasi01","bfaso01","bfasi02","bfaso02","bfasi03","bfaso03","bfasi04","bfaso04","bfasi05","bfaso05",
  "bfasi06","bfaso06","bfasi07","bfaso07","bfasi08","bfaso08","bfasi09","bfaso09","bfasi10","bfaso10",
  "o_aes01","o_aes02","o_aes03","o_aes04","o_inq01","o_inq02","o_inq03","o_inq04",
  "o_cre01","o_cre02","o_cre03","o_cre04","o_unc01","o_unc02","o_unc03","o_unc04",
  "woo_tol1","woo_tol2","woo_tol3","woo_tol4","woo_tol5","woo_tol6","woo_tol7","woo_tol8","woo_tol9",
  "woo_dep1","woo_dep2","woo_dep3","woo_dep4","woo_dep5","woo_dep6","woo_dep7","woo_dep8","woo_dep9",
  "woo_eff1","woo_eff2","woo_eff3","woo_eff4","woo_eff5","woo_eff6","woo_eff7","woo_eff8","woo_eff9",
  "woo_ing1","woo_ing2","woo_ing3","woo_ing4","woo_ing5","woo_ing6","woo_ing7","woo_ing8","woo_ing9",
  "woo_cur1","woo_cur2","woo_cur3","woo_cur4","woo_cur5","woo_cur6","woo_cur7","woo_cur8","woo_cur9",
  "woo_aes1","woo_aes2","woo_aes3","woo_aes4","woo_aes5","woo_aes6","woo_aes7","woo_aes8","woo_aes9"
)

## 1) 读分析文件 + 三个源文件
data <- as.data.frame(read_sav("data/Openness Only_ANALYSIS FILE.sav"))
s1 <- as.data.frame(read_sav("data/Openness Only, Fall 2015, Openness Facets.sav"))  # 样本1
s2 <- as.data.frame(read_sav("data/Openness Only, Spring 2017, Creative L2.sav"))     # 样本2
s3 <- as.data.frame(read_sav("data/Openness Only, Summer 2017, Mturk.sav"))           # 样本3
stopifnot(all(dv %in% names(data)))

## 2) 按138题响应指纹，把每个人匹配回源文件 → 重建 Group
fp_cols <- Reduce(intersect, list(dv, names(s1), names(s2), names(s3)))
fp  <- function(df) apply(sapply(df[fp_cols], as.numeric), 1, paste, collapse = "|")
fpA <- fp(data)
data$Group <- NA_integer_
data$Group[fpA %in% fp(s1)] <- 1
data$Group[fpA %in% fp(s2)] <- 2
data$Group[fpA %in% fp(s3)] <- 3
data$Group <- factor(data$Group)

## ★检查点：应为 176 / 108 / 518，无 NA
cat("重建Group：\n"); print(table(data$Group, useNA = "ifany"))
stopifnot(identical(as.integer(table(data$Group)), c(176L,108L,518L)))
cat("✔ Group 重建成功，与论文 SI 7 一致\n\n")

## 3) 因变量转纯数值
data[dv] <- lapply(data[dv], as.numeric)
f <- as.formula(paste0("cbind(", paste(dv, collapse = ","), ") ~ Group"))

## 4) 三组整体 MANOVA（靶子 Pillai = .960）
cat("===== 三组整体 MANOVA (Pillai) =====\n")
print(summary(manova(f, data = data), test = "Pillai"))

## 5) 两两比较（靶子 Pillai：1vs2=.650, 1vs3=.675, 2vs3=.614）
cat("\n-- 1 vs 2 --\n"); print(summary(manova(f, data=droplevels(subset(data, Group %in% c(1,2)))), test="Pillai"))
cat("\n-- 1 vs 3 --\n"); print(summary(manova(f, data=droplevels(subset(data, Group %in% c(1,3)))), test="Pillai"))
cat("\n-- 2 vs 3 --\n"); print(summary(manova(f, data=droplevels(subset(data, Group %in% c(2,3)))), test="Pillai"))

## 6) Box's M：用 1 vs 3（两组人数都 >138，可算；靶子 F=1.292, df=9591）
cat("\n===== Box's M (1 vs 3) =====\n")
s13 <- droplevels(subset(data, Group %in% c(1,3)))
print(boxM(s13[, dv], s13$Group))
# ===========================================================

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