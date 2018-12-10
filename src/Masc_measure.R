#!/usr/bin/env

args = commandArgs(trailingOnly=TRUE)
print(args)
# python face_landmark_features.py shape_predictor_68_face_landmarks.dat /Users/Robinhuang/Documents/OneDrive/ML/Masculinity_measure/data test.txt

if(length(args) > 0){
  
  pheno <- read.table(paste(getwd(),paste("/",args[2],sep = ""),sep = ""),header = T,stringsAsFactors=FALSE,colClasses = c("character"))
  
  if(!file.exists(args[1])){
    stop("image file not found, plz provide full path of your image folder")
  }else if(!file.exists(args[2])){
    stop(paste(args[2],"not found"),sep=" ")
  }else if(!is.element("Age",colnames(pheno))|!is.element("Sex",colnames(pheno))){
    stop("check your phenotype file colnames")
  }else{
    c <- paste("python face_landmark_features.py shape_predictor_68_face_landmarks.dat",args[1],sep = " ")
    c <- paste(c,"raw_dlib_output.txt",sep = " ")
    system(c) 

output <- paste(getwd(),"raw_dlib_output.txt",sep = "/")

#----------------------------------------------------#
# Source converting DLIB output in data.frame format #
#----------------------------------------------------#

convert2R <- function(inputfile){
  # read DLIB output file
  x = read.table(inputfile,as.is = TRUE,sep='\t')
  # filter duplicated lines
  idx = which(duplicated(x[,1]))
  # if there is at least a duplicated line
  if(length(idx) > 0){
    # get duplicated IDs
    tmp= apply(x[,c(3,20)],2,function(i)gsub(pattern = '\\(|\\)|\\,',replacement = '',i))
    tmp2 = apply(tmp,2,function(i) unlist(lapply(strsplit(i,split=' '),function(x)as.numeric(x)[1])))
    # compute jaw left and right distance, in order to keep the smallest one among the duplicates
    tmp3 = tmp2[,2]-tmp2[,1]
    # loop over duplicates
    filt = idx
    for(i in 1:length(idx)){
      if(tmp3[idx[i]] > tmp3[idx[i]-1]) filt[i] = idx[i] - 1
    }
    #duplicates removal
    new.x = x[-filt,]
    x = new.x
  }
  # process row names
  rowN = x[,1]
  z = gsub(pattern = '.*\\/',replacement='',rowN)
  z =  gsub(pattern = '\\..*', replacement = '', z)
  x = x[,-1]
  if(any(is.na(x[,ncol(x)]))) x = x[,-ncol(x)]
  row.names(x) = z
  
  tmp= apply(x[,-1],2,function(i)gsub(pattern = '\\(|\\)|\\,',replacement = '',i))
  tmp2 = lapply(1:ncol(tmp),function(i) matrix(unlist(lapply(strsplit(tmp[,i],split=' '),as.numeric)),ncol=2,byrow=TRUE))
  #remove number of channels column
  tmp3 = matrix(unlist(lapply(strsplit(gsub(pattern = '\\(|\\)|\\,',replacement = '',x[,1]),split=' '),as.numeric)),ncol=3,byrow=TRUE)
  tmp3 = tmp3[,-3]
  
  #merge
  tmp4 = do.call(cbind,tmp2)
  tmp = cbind(tmp3, tmp4)
  row.names(tmp) = row.names(x)
  
  #colnames
  #keypoint index (based on people left and right)
  
  idx = c('height','width','top_left_jaw_x','top_left_jaw_y','top_left_jaw_2_x','top_left_jaw_2_y','mid_left_jaw_x','mid_left_jaw_y',
          'mid_left_jaw_2_x','mid_left_jaw_2_y','mid_left_jaw_3_x','mid_left_jaw_3_y','bot_left_jaw_x','bot_left_jaw_y',
          'top_left_chin_x','top_left_chin_y','mid_left_chin_x','mid_left_chin_y','bot_chin_x','bot_chin_y',
          'mid_right_chin_x','mid_right_chin_y','top_right_chin_x','top_right_chin_y',
          'bot_right_jaw_x','bot_right_jaw_y','mid_right_jaw_3_x','mid_right_jaw_3_y','mid_right_jaw_2_x','mid_right_jaw_2_y',
          'mid_right_jaw_x','mid_right_jaw_y','top_right_jaw_2_x','top_right_jaw_2_y','top_right_jaw_x','top_right_jaw_y',
          'outer_left_eyebrow_x','outer_left_eyebrow_y','mid_left_eyebrow_x','mid_left_eyebrow_y',
          'mid_left_eyebrow_2_x','mid_left_eyebrow_2_y','mid_left_eyebrow_3_x','mid_left_eyebrow_3_y','inner_left_eyebrow_x','inner_left_eyebrow_y',
          'inner_right_eyebrow_x','inner_right_eyebrow_y','mid_right_eyebrow_3_x','mid_right_eyebrow_3_y','mid_right_eyebrow_2_x','mid_right_eyebrow_2_y',
          'mid_right_eyebrow_x','mid_right_eyebrow_y','outer_right_eyebrow_x','outer_right_eyebrow_y','top_nose_x','top_nose_y','top_nose_2_x','top_nose_2_y',
          'mid_nose_x','mid_nose_y','nose_tip_x','nose_tip_y','bot_left_nose_x','bot_left_nose_y','bot_left_nose_2_x','bot_left_nose_2_y',
          'bot_mid_nose_x','bot_mid_nose_y','bot_right_nose_2_x','bot_right_nose_2_y','bot_right_nose_x','bot_right_nose_y','outer_left_eye_corner_x','outer_left_eye_corner_y',
          'top_left_eye_x','top_left_eye_y','top_left_eye_2_x','top_left_eye_2_y','inner_left_eye_corner_x','inner_left_eye_corner_y',
          'bot_left_eye_x','bot_left_eye_y','bot_left_eye_2_x','bot_left_eye_2_y','inner_right_eye_corner_x','inner_right_eye_corner_y',
          'top_right_eye_2_x','top_right_eye_2_y','top_right_eye_x','top_right_eye_y','outer_right_eye_corner_x','outer_right_eye_corner_y',
          'bot_right_eye_x','bot_right_eye_y','bot_right_eye_2_x','bot_right_eye_2_y','left_mouth_corner_x','left_mouth_corner_y',
          'top_left_lip_x','top_left_lip_y','top_left_lip_2_x','top_left_lip_2_y','top_center_lip_x','top_center_lip_y',
          'top_right_lip_2_x','top_right_lip_2_y','top_right_lip_x','top_right_lip_y','right_mouth_corner_x','right_mouth_corner_y',
          'bot_right_lip_x','bot_right_lip_y','bot_right_lip_2_x','bot_right_lip_2_y','bot_center_lip_x','bot_center_lip_y',
          'bot_left_lip_2_x','bot_left_lip_2_y','bot_left_lip_x','bot_left_lip_y','mid_left_upper_lip_x','mid_left_upper_lip_y',
          'mid_left_upper_lip_2_x','mid_left_upper_lip_2_y','mid_center_upper_lip_x','mid_center_upper_lip_y','mid_right_upper_lip_2_x','mid_right_upper_lip_2_y',
          'mid_right_upper_lip_x','mid_right_upper_lip_y','mid_right_lower_lip_x','mid_right_lower_lip_y','mid_left_lower_lip_x','mid_left_lower_lip_y')
  
  
  colnames(tmp) = idx
  row.names(tmp) = z
  return(tmp)
}


inputfile = output
data = convert2R(inputfile = inputfile)
write.csv(data[,c('height','width','outer_left_eyebrow_x','outer_left_eyebrow_y','inner_left_eyebrow_x','inner_left_eyebrow_y','inner_right_eyebrow_x','inner_right_eyebrow_y',
                  'outer_right_eyebrow_x','outer_right_eyebrow_y','top_nose_x','top_nose_y','nose_tip_x','nose_tip_y','outer_left_eye_corner_x','outer_left_eye_corner_y',
                  'inner_left_eye_corner_x','inner_left_eye_corner_y','inner_right_eye_corner_x','inner_right_eye_corner_y','outer_right_eye_corner_x','outer_right_eye_corner_y',
                  'left_mouth_corner_x','left_mouth_corner_y','right_mouth_corner_x','right_mouth_corner_y')],file=paste(getwd(),'/dlib_output.csv',sep=""))

####  Scaling the coordinates
face_coordinates <- read.csv(paste(getwd(),"/dlib_output.csv",sep=""))
dimension <- face_coordinates[,2:3]
scales <- as.vector(t(dimension))
coordinates <- face_coordinates[,4:27]
scaled_coordinates <- sapply(1:nrow(coordinates),function(i) coordinates[i,] / scales[(2*i):(2*(i-1)+1)] )
scaled_coordinates <-t(scaled_coordinates)

row.names(scaled_coordinates) <- face_coordinates$X

write.csv(scaled_coordinates,paste(getwd(),"/scaled_coordinates.csv",sep=""))

xy <- scaled_coordinates

### for each individual, we should normalize the coords on a 0,1 interval
xx = xy[,grepl("x",colnames(xy))]
yy = xy[,!grepl("x",colnames(xy))]

f = function(x){
  x = as.numeric(x)
  x = (x-min(x))/(max(x)-min(x))
  return(x)
}

xx = t(apply(xx,1,f))
yy = t(apply(yy,1,f))


ll = lapply(1:nrow(xx),function(i) cbind(xx[i,],yy[i,]))

dd = sapply(ll,function(x) as.numeric(dist(x)))
dd = t(dd)

library(randomForest)
### Loading the pre-trained model (577 devgene conhort)
rf_dev <- readRDS(paste(getwd(),"/devgene_model.rds",sep = ""))
load(paste(getwd(),"/devGenes_TD_age_lowess_curves_fmasc.Rdata",sep = ""))
     
masc <- predict(rf_dev,cbind(pheno$Age,dd) ,type = "prob")[,2]
p_label <- predict(rf_dev,cbind(pheno$Age,dd))

print("Confusion matrix")
print(table(as.character(pheno$Sex),p_label))

### correct for age effects within each sex separately (using lowess);
masc_cor = masc
idx = which(pheno$Sex=="F")
if(length(idx)>0){
  #l = lowess(log2(as.integer(pheno$Age[idx])+1),masc[idx])
  masc_cor[idx] = masc[idx]-approx(l_female,xout=log2(as.integer(pheno$Age[idx])+1))$y
}

idx = which(pheno$Sex=="M")
if(length(idx)>0){
  #l = lowess(log2(as.integer(pheno$Age[idx])+1),masc[idx])
  masc_cor[idx] = masc[idx]-approx(l_male,xout=log2(as.integer(pheno$Age[idx])+1))$y
}



final_output <- cbind(rownames(scaled_coordinates),masc_cor)
colnames(final_output)<- c("ID","masc_cor")
write.table(final_output,paste(getwd(),args[3],sep = "/"),row.names = F,quote = F,sep = "\t")

### clean the work enviroment

system(paste("rm","raw_dlib_output.txt",sep = " "))
system(paste("rm","scaled_coordinates.csv",sep = " "))
system(paste("rm","dlib_output.csv",sep = " "))

  }
}