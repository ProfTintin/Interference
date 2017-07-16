clear all; close all; clc


%%loading mask
 mask = double(imread('mask.tif'));
 mask = mask(:,:,1);
 mask = mat2gray(mask);
%%


tic

range=1:1:1;   %total number of images to load
total_Number=1;


for i=range ;        
  
    imgRaw = double(imread(strcat('Jun30_2017_151421first_',num2str(i,'%03d'),'.tif')));
    
    fprintf('%i\n',i)
    imgRaw=imgRaw(:,:);
    [xsize,ysize] = size(imgRaw);

    [imgHilbertTrans] = HilbertTrans2D(imgRaw,xsize,ysize);
    imgAngle = angle(imgHilbertTrans);
    [imgUnwrap] = unwrap2(imgAngle);
    
   
    imgUnwrapMask = imgUnwrap.*mask ;
  
    
  %Cut Region  
   startx=001;
   stopx=1024;
   starty=001;
   stopy=1024;
   
   
   counter1=1:size(range,2);
   counter2=counter1(total_Number);
    
   imgUnwrapMaskCut(:,:,counter2) = imgUnwrapMask(startx:stopx,starty:stopy);
   total_Number=total_Number+1;
end


imgHeight = imgUnwrapMaskCut*532/(4*pi*1.33);
%save('un_ph.mat','imgHeight','-v7.3');

image(imgHeight);


%End