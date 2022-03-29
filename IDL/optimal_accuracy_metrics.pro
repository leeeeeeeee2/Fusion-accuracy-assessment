
;---------------------------------------------------------------------------
;     Accuracy assessment for single fused image
;    compute 4 optimal index: AD, RMSE, EDGE, LBP
;    Input: single-band or multi-band images
; Output: metrics of each band plus the average of all bands
;
;      writen by Zhu xiaolin, polyu
;      Email: xlzhu@polyu.edu.hk
;                 24 Jan 2022
;     Copyright belongs to Zhu Xiaolin
;----------------------------------------------------------------------------

;open image

Pro GetData,ImgData = ImgData,ns = ns,nl = nl,nb = nb,Data_Type = Data_Type,$
    FileName = FileName,Map_info = map_Info
    Filter = ['all file;*.*']
    Envi_Open_File,FileName,R_Fid = R_Fid
    Envi_File_Query,R_Fid,ns = ns,nl = nl,nb = nb,Data_Type = Data_Type
    map_info = envi_get_map_info(fid=R_Fid)
    dims = [-1,0,ns - 1 ,0,nl - 1]
    case Data_Type Of
        1:ImgData = BytArr(ns,nl,nb)    ;  BYTE  Byte
        2:ImgData = IntArr(ns,nl,nb)    ;  INT  Integer
        3:ImgData = LonArr(ns,nl,nb)    ;  LONG  Longword integer
        4:ImgData = FltArr(ns,nl,nb)    ;  FLOAT  Floating point
        5:ImgData = DblArr(ns,nl,nb)    ;  DOUBLE  Double-precision floating
    EndCase
    For i = 0,nb-1 Do Begin
       Dt = Envi_Get_Data(Fid = R_Fid,dims = dims,pos=i)
       ImgData[*,*,i] = Dt[*,*]
    EndFor
End


Function LBP_original,data,tolerance
  height=(size(data))[2];number of rows of image
  width=(size(data))[1];number of column of image
  src=data
  dst = data-data
  lbp_value=fltarr(8)
  neighbours=fltarr(8)

  for x=1, width-2, 1 do begin
    for y=1, height-2, 1 do begin

      neighbours[0] = src[x - 1,y - 1]
      neighbours[1] = src[x,y - 1]
      neighbours[2] = src[x + 1,y - 1]
      neighbours[3] = src[x + 1,y]
      neighbours[4] = src[x + 1,y+1]
      neighbours[5] = src[x,y + 1]
      neighbours[6] = src[x-1,y+1]
      neighbours[7] = src[x-1,y]

      center = src[x, y]

      for i=0,7,1 do begin
        if (neighbours[i] gt center+tolerance) then begin
          lbp_value[i] = 1.0
        endif else begin
          lbp_value[i] = 0.0
        endelse
      endfor
      ;  print,lbp_value
      lbp = (2^7*lbp_value[0])+(2^6*lbp_value[1])+(2^5*lbp_value[2])+(2^4*lbp_value[3])+(2^3*lbp_value[4])+(2^2*lbp_value[5])+(2^1*lbp_value[6])+(2^0*lbp_value[7])

      dst[x,y] = lbp
      ; print,lbp
    endfor
  endfor

  return, dst

End


Function Robert_edge,data
  height=(size(data))[2];number of rows of image
  width=(size(data))[1];number of column of image
  edg = data-data
  for x=1, width-2, 1 do begin
    for y=1, height-2, 1 do begin
      edg[x,y]=abs(data[x,y]-data[x+1,y+1])+abs(data[x+1,y]-data[x,y+1])
    endfor
  endfor
  return, edg
End


;-------------------------------------------------------------------
;                  main body of the program
;-------------------------------------------------------------------

pro  optimal_accuracy_metrics

  DN_min=0.0     ;minimal DN values of valid pixels
  DN_max=10000.0 ;maximum DN values of valid pixels
  tolerance=0.005 ;tolerance level for computing LBP feature, which is the noise letter of images
  
;    open reference image
  FileName = Dialog_PickFile(title = 'open the reference fine-resolution image:')
  GetData,ImgData = ImgData,ns = ns,nl = nl,nb = nb,Data_Type = Data_Type,FileName = FileName,Map_info = map_Info
  true=float(ImgData)/DN_max


;open fused image 
  FileName0 = Dialog_PickFile(title = 'open the fused fine-resolution image:')
  GetData,ImgData=imagei,ns = ns,nl = nl,nb = nb,Data_Type = Data_Type,FileName = FileName0
  predict=float(imagei)/DN_max 
       
 t0=systime(1)                  ;the initial time of program running
 
 v_result=fltarr(4,nb+1)


; compute RMSE and AD indices
    for iband=0,nb-1,1 do begin
      x=reform(true[*,*,iband],1.0*ns*nl)
      y=reform(predict[*,*,iband],1.0*ns*nl)  
      line_reg= REGRESS(x,y,CONST=con,CORRELATION=r)
      diff=abs(x-y)
      diff_r=100.0*abs(x-y)/x
      v_result[0,iband]=mean(y-x);AD 
      v_result[1,iband]=(total(diff^2)/(1.0*ns*nl))^0.5            ;rmse   
    endfor



reference=true

 ;compute edge and LBP features for the reference image
 ;
 ;compute edge
 edge_reference=reference
 for iband=0,nb-1,1 do begin
   predict_i=reference[*,*,iband]
   edge_reference[*,*,iband]=Robert_edge(predict_i)
 endfor

 ;compute LBP Texture
 lbp_reference=reference
 for iband=0,nb-1,1 do begin
   predict_i=reference[*,*,iband]
   lbp_reference[*,*,iband]=LBP_original(predict_i,tolerance)
 endfor
       

;compute edge and LBP features for the fused image and compute the normalized difference

    ;compute edge
    edge_predict=predict
    for iband=0,nb-1,1 do begin
      predict_i=predict[*,*,iband]
      edge_predict[*,*,iband]=Robert_edge(predict_i)
    endfor
    ;compute the r of edge images
    ture_cutedge=edge_reference[1:ns-2,1:nl-2,*]
    predict_cutedge=edge_predict[1:ns-2,1:nl-2,*]
    for iband=0,nb-1,1 do begin
      x=reform(ture_cutedge[*,*,iband],1.0*(ns-2)*(nl-2))  
      ;only use 0.9 quantile above pixels which represents edges in an image
      num_pure1=(ns-2.0)*(nl-2.0)
      sortIndex = Sort(x)
      sortIndices = (Findgen(num_pure1+1))/float(num_pure1)
      Percentiles=[0.9]
      dataIndices = Value_Locate(sortIndices, Percentiles)
      data_90= x[sortIndex[dataIndices]]
      ;print,'90% edge:',data_90
      ind_realedge=where(x ge data_90[0])
      x=x[ind_realedge]
      y=reform(predict_cutedge[*,*,iband],1.0*(ns-2)*(nl-2))
      y=y[ind_realedge]            
      NDSI=(y-x)/(abs(y+x)+0.00001)
      v_result[2,iband]=mean(NDSI)     
    endfor
    
;compute LBP Texture
lbp_predict=predict
for iband=0,nb-1,1 do begin
  predict_i=predict[*,*,iband]
  lbp_predict[*,*,iband]=LBP_original(predict_i,tolerance)
endfor
predict_cutedge=lbp_predict[1:ns-2,1:nl-2,*]/255.0
ture_cutedge=lbp_reference[1:ns-2,1:nl-2,*]/255.0
for iband=0,nb-1,1 do begin
  x=reform(ture_cutedge[*,*,iband],1.0*(ns-2)*(nl-2)) 
  x[where(x ne x)]=0  ;correct NAN
  y=reform(predict_cutedge[*,*,iband],1.0*(ns-2)*(nl-2))
  Y[where(Y ne Y)]=0  ;correct NAN
  NDSI=(y-x)/(abs(y+x)+0.00001)
    v_result[3,iband]=mean(NDSI)
endfor

;compute average of all bands for each index
for iind=0,3,1 do begin
  v_result[iind,nb]=mean(v_result[iind,0:nb-1])
endfor

print,'accuracy assessment results: AD, RMSE, EDGE, LBP'
Print,v_result

;Output the result to the folder of the fused image
Filename1=FileName0+'_accuracy.csv'
variable=['AD','RMSE','EDGE','LBP']
WRITE_CSV, Filename1, v_result,HEADER=variable

print, 'time used:', floor((systime(1)-t0)/3600), 'h',floor(((systime(1)-t0) mod 3600)/60),'m',(systime(1)-t0) mod 60,'s'

end