############################################################ 
#Code to make a Taylor-like diagram to display the accuracies
#  coded by Zhu Xiaolin, The Hong Kong Polytechnic University
#      version: 8 March 2022
#    Please contact xlzhu@polyu.edu.hk
#   Copyright belongs to Zhu Xiaolin
############################################################

######## set the following parameters
## set the working direction
setwd("C:/Users/lsxlzhu.LSGI/Desktop/R code and sample data for drawing APA diagram")
## number of methods in the comparison
num_methods=6 
## png file name for saving the diagram to the working direction
finename<-"APA diagram example.png"  
##readin data
data<-read.csv("data_for_APA_diagram.csv")  #readin sample tables

######## run the program to draw the diagram
png(file=finename,width=20,height=15,units="cm",res=600) #define the png file size

#get the bottom line values 
max_rmse=max(data$RMSE)*1.2
F0_rmse=data[num_methods+1,3]
Cp_rmse=data[num_methods+2,3]
min_NDEI=data[num_methods+2,4]
MAX_NDEI=data[num_methods+4,4]
F0_NDEI=data[num_methods+1,4]


# NDEI and tick marks (only major will have a line to the center)
# minor will have a tick mark
correlation_major <- c(seq(-1,1,0.1),-0.95,0.95)
correlation_minor <- c(seq(-1,-0.95,0.01),seq(-0.9,9,0.05),seq(0.95,1,0.01))

# RMSE tick marks (only major will have a line)
rmse_range=ceiling(max_rmse*1.0*100)/100
sigma_test_major=seq(0,rmse_range,rmse_range/5.0)
sigma_test_minor <- seq(0,rmse_range,0.01)


# color schemes for the liens
correlation_color <- 'black'
sigma_test_color <- 'blue'
rms_color <- 'red'

# line types
correlation_type <- 2
sigma_test_type <- 2
rms_type <- 2

# plot parameters
par(pty='s')
par(mar=c(3,3,5,3)+0.1)

# creating plot with correct space based on the sigma_test limits
plot(NA
     ,NA
     ,xlim=c(-1*max(sigma_test_major),max(sigma_test_major))
     ,ylim=c(-1*max(sigma_test_major),max(sigma_test_major))
     ,xaxt='n'
     ,yaxt='n'
     ,xlab=''
     ,ylab=''
     ,bty='n')

#### adding sigma_test (standard deviation)
# adding semicircles
sigma_test_color_line <- rgb(50, 50, 255, max = 255, alpha = 100)
for(i in 1:length(sigma_test_major)){
  lines(sigma_test_major[i]*cos(seq(0,pi,pi/1000))
       ,sigma_test_major[i]*sin(seq(0,pi,pi/1000))
       ,col=sigma_test_color_line
       ,lty=sigma_test_type
       ,lwd=1
    )
}

# adding horizontal axis
lines(c(-1*max(sigma_test_major),max(sigma_test_major))
     ,c(0,0)
     ,col=sigma_test_color
     ,lty=1
     ,lwd=1)

# adding labels
text(c(-1*sigma_test_major,0,sigma_test_major)
     ,-0.2*rmse_range/5.0
     ,as.character(c(sigma_test_major,0,sigma_test_major))
     ,col=sigma_test_color
     ,cex=0.7)



# adding title
text(0
     ,-0.5*rmse_range/5.0
     ,"RMSE"
     ,col=sigma_test_color
     ,cex=1.0)

#### adding correlation lines, tick marks, and lables
# adding lines
correlation_color_line <- rgb(80, 80, 80, max = 255, alpha = 100)
for(i in 1:length(correlation_major)){

  lines(c(0,1.02*max(sigma_test_major)*cos(acos(correlation_major[i])))
        ,c(0,1.02*max(sigma_test_major)*sin(acos(correlation_major[i])))
        ,lwd=1
        ,lty=correlation_type
        ,col=correlation_color_line
  )
}

# adding minor tick marks for correlation
for(i in 1:length(correlation_minor)){

  lines(max(sigma_test_major)*cos(acos(correlation_minor[i]))*c(1,1.01)
        ,max(sigma_test_major)*sin(acos(correlation_minor[i]))*c(1,1.01)
        ,lwd=1
        ,lty=correlation_type
        ,col=correlation_color
  )
}

# adding labels for correlation
text(1.05*max(sigma_test_major)*cos(acos(correlation_major))
     ,1.05*max(sigma_test_major)*sin(acos(correlation_major))
     ,as.character(correlation_major)
     ,col=correlation_color
     ,cex=0.7)

# adding correlation title
text(1.15*max(sigma_test_major)*cos(acos(0.7))
     ,1.15*max(sigma_test_major)*sin(acos(0.7))
     ,"Edge"
     ,col=correlation_color
     ,cex=1.0)


##draw the fair range
range_ndei=seq(min_NDEI,MAX_NDEI,0.01)
std_names=c(0,rep(F0_rmse,length(range_ndei)),0)
correl_names=c(0,range_ndei,0)
cord.x=std_names*cos(acos(correl_names))
cord.y=std_names*sin(acos(correl_names))
mycol <- rgb(150, 150, 150, max = 255, alpha = 100, names = "grey50")
polygon(cord.x,cord.y,col=mycol)

##draw the good range
adjust_F0_NDEI=min(c(0,F0_NDEI))
range_ndei=seq(max(c(adjust_F0_NDEI,min_NDEI)),MAX_NDEI,0.01)
std_names=c(0,rep(min(c(Cp_rmse,F0_rmse)),length(range_ndei)),0)
correl_names=c(0,range_ndei,0)
cord.x=std_names*cos(acos(correl_names))
cord.y=std_names*sin(acos(correl_names))
mycol <- rgb(150, 250, 150, max = 255, alpha = 100, names = "grey50")
polygon(cord.x,cord.y,col=mycol)


##add fair and good range legend
#fair
point1x=-1*max(sigma_test_major)
point2x=-1*max(sigma_test_major)+rmse_range/5.0
point3x=-1*max(sigma_test_major)+rmse_range/5.0
point4x=-1*max(sigma_test_major)
point1y=-0.5*rmse_range/5.0
point2y=-0.5*rmse_range/5.0
point3y=-0.75*rmse_range/5.0
point4y=-0.75*rmse_range/5.0
cord.x=c(point1x,point2x,point3x,point4x)
cord.y=c(point1y,point2y,point3y,point4y)
mycol <- rgb(150, 150, 150, max = 255, alpha = 100, names = "grey50")
polygon(cord.x,cord.y,col=mycol)
text(point2x+0.5*rmse_range/5.0
     ,(point1y+point3y)/2.0
     ,"Fair"
     ,cex=1)

#good
point1x=3*rmse_range/5.0
point2x=3*rmse_range/5.0+rmse_range/5.0
point3x=3*rmse_range/5.0+rmse_range/5.0
point4x=3*rmse_range/5.0
point1y=-0.5*rmse_range/5.0
point2y=-0.5*rmse_range/5.0
point3y=-0.75*rmse_range/5.0
point4y=-0.75*rmse_range/5.0
cord.x=c(point1x,point2x,point3x,point4x)
cord.y=c(point1y,point2y,point3y,point4y)
mycol <- rgb(150, 250, 150, max = 255, alpha = 100, names = "green50")
polygon(cord.x,cord.y,col=mycol)
text(point2x+0.6*rmse_range/5.0
     ,(point1y+point3y)/2.0
     ,"Good"
     ,cex=1)


###################### adding points #####################
#names <- c("UBDF","OPDL","LMGM","STARFM","Fit-FC","FSDAF")
names<-(data$Method)[1:num_methods]

#input edge
correl_names <-(data$ND_EDGE)[1:num_methods]

#input rmse
std_names <- (data$RMSE)[1:num_methods]

#input AD
AD<- (data$AD)[1:num_methods]


##give color to different AD
colAD1 <- rgb(0, 0, 255, max = 255)
colAD2 <- rgb(0, 150, 255, max = 255)
colAD3 <- rgb(0, 0, 0, max = 255)
colAD4 <- rgb(255, 150, 0, max = 255)
colAD5 <- rgb(255, 0, 0, max = 255)
colad=c(colAD1,colAD2,colAD3,colAD4,colAD5)
adrange=c(-1,-0.002,-0.001,0.001,0.002,1)
labelad=c(1:num_methods)
color_AD=topo.colors(length(names))
for (i in 1:length(names)){
   ADi=AD[i]-adrange
   indi=(ADi <= 0)
   labeladi=min(labelad[indi])
   color_AD[i]=colad[labeladi-1]
}


color_names <- color_AD
points(std_names*cos(acos(correl_names))
       ,std_names*sin(acos(correl_names))
       ,col=color_names
       ,pch=19
       ,cex=1.0)

#Add labels to points
text( std_names*cos(acos(correl_names))
     ,0.25*rmse_range/5.0+std_names*sin(acos(correl_names))
     ,as.character(labelad)
     ,col=correlation_color
     ,cex=0.8)

#add lengend of model
text(seq(-1*rmse_range,rmse_range-2*rmse_range/num_methods,2*rmse_range/num_methods)+0.5*rmse_range/5.0
     ,rep(1.15*rmse_range,num_methods)
     ,paste(as.character(labelad),names)
     ,col=correlation_color
     ,cex=0.8,font=2,xpd=NA)


# making legend of ad
text(0
     ,-1.1*rmse_range/5.0
     ,"Legend of AD"
     ,cex=0.8)

par(xpd=TRUE)
adcolor_names=c("<-0.002")
legend(-1.1*max(sigma_test_major),-1.3*rmse_range/5.0
       ,adcolor_names
       ,pc=19
       ,col=colad[1]
       ,ncol=5
       ,bty='n'
       ,xjust=0
       ,cex=0.7)

adcolor_names=c("-0.002 to -0.001","-0.001 to 0.001","0.001 to 0.002",">0.002")
legend(-1.1*max(sigma_test_major)+1.5*rmse_range/5.0,-1.3*rmse_range/5.0
       ,adcolor_names
       ,pc=19
       ,col=colad[2:5]
       ,ncol=5
       ,bty='n'
       ,xjust=0
       ,cex=0.7)

dev.off()

