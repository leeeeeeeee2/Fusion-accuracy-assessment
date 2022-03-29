1. 在 "计算精度指标的IDL代码和样本数据 "的压缩文件夹中，有两个文件。
   (1）一个IDL代码 "optimal_accuracy_metrics.pro"，它可以计算任何融合图像的四个指标，AD、RMSE、edge、LBP。运行该代码时，根据弹出的窗口输入数据。计算结果将以csv文件形式保存在融合图像的文件夹中，并命名为融合图像名称+_accuracy.csv（例如，fused_fine_image_FSDAF.tif_accuracy.csv）。前n行是n个波段的精度，最后一行是多个波段的平均精度。
   请注意：该代码使用了经典ENVI的一些函数，所以在编译代码时应打开经典ENVI! 
   (2) 样本数据：2001年11月25日在CIA站点的3波段参考图像（绿色、红色、nir）；FSDAF的融合图像

1. In the zipped folder "IDL code and sample data for computing accuracy metrics", there are two files:
   (1) an IDL code "optimal_accuracy_metrics.pro" which can compute the four metrics, AD, RMSE, edge, LBP for any fused images. Input the data according to the pop-up window when running the code. The result will be saved as a csv file in the folder of fused image and named as fused image name+_accuracy.csv (e.g.,fused_fine_image_FSDAF.tif_accuracy.csv). The first n rows are accuracies of n bands, and the last row is the average accuracies of multiple bands.
   Please note: the code used some functions from the classic ENVI, so classic ENVI should be open when compiling the code! 
   (2) sample data: a 3-band reference image (green, red, nir) on 25 Nov 2001 in the CIA site; a fused image by FSDAF

2. 在 "计算精度指标的python代码和样本数据 "的压缩文件夹中，有三个文件。
   (1) 一个指令文件 "optimal_accuracy_metrics的指令"：详细介绍了如何实现代码，建议在运行代码前阅读该文件。
   (2）一个python代码 "optimal_accuracy_metrics.py"，它可以计算任何融合图像的四个指标，AD、RMSE、edge、LBP。运行该代码时，根据弹出的窗口输入数据。结果将被保存在输入图像的文件夹中。前n行是n个波段的精度，最后一行是多个波段的平均精度。
   请注意：Python代码的结果与IDL代码的结果略有不同，因为这两个代码处理浮点数的方式不同。
   (3) 样本数据：2001年11月25日在CIA站点的3波段参考图像（绿色、红色、nir）；FSDAF的融合图像

2. In the zipped folder "python code and sample data for computing accuracy metrics", there are three files:
   (1) an instruction file "Instruction of optimal_accuracy_metrics": detailed introduction on how to implement the code, suggesting read this file before running the code.
   (2) a python code "optimal_accuracy_metrics.py" which can compute the four metrics, AD, RMSE, edge, LBP for any fused images. Input the data according to the pop-up window when running the code. The result will be saved in the folder of input images. The first n rows are accuracies of n bands, and the last row is the average accuracies of multiple bands.
   Please note: the result from python code is slightly different with that of IDL code because these two codes process floating-point numbers in different ways.
   (3) sample data: a 3-band reference image (green, red, nir) on 25 Nov 2001 in the CIA site; a fused image by FSDAF
   
3. 在压缩文件夹 "用于绘制类似泰勒图的R代码和样本数据 "中，有两个文件。
   (1)一个R代码 "APA_diagram.R"，它可以绘制全方位性能评估(APA)图，一个类似泰勒的极坐标图，以 "一般 "和 "好 "的范围显示不同融合图像的精度。
   请根据你自己的数据，在代码的开头设置参数并输入数据文件。制作好的图将以你定义的文件名保存在你的工作方向上（例如：APA图例.png）。 
   (2) data_for_APA_diagram.csv：用于测试代码的样本数据，其中包括2001年11月25日在CIA网站上融合图像的6种融合方法的准确性。

3. In the zipped folder "R code and sample data for drawing Taylor like diagram", there are two files:
   (1) a R code "APA_diagram.R" which can draw the all-round performance assessment(APA) diagram, a Taylor-like polar diagram to show the accuracies of different fused images with "fair" and "good" ranges.
   Please set the parameters and input the data file at the beginning of the code based on your own data. The produced diagram will be saved to your working direction with the filename you define (e.g., APA diagram example.png).  
   (2) data_for_APA_diagram.csv: a sample data for testing the code, which includes accuracies of 6 fusion methods for fusing the image on 25 Nov 2001 in the CIA site.


To Cite these codes and dataset in Publications:
Zhu, X., Zhan, W., Zhou, J., Chen, X., Liang, Z., Xu. S., Chen, J.2022. A novel framework to assess all-round performances of spatiotemporal fusion models, Remote Sensing of Environment，274，113002，https://doi.org/10.1016/j.rse.2022.113002
