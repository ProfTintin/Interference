clear all; close all; clc


%%loading mask
 mask = double(imread('mask.tif'));
 mask = mask(:,:,1);
 mask = mat2gray(mask);
%%


tic

range=1:1:99;   %total number of images to load
total_Number=1;


for i=range ;        
  
    imgRaw = double(imread(strcat('Jun30_2017_151421first_',num2str(i,'%03d'),'.tif')));
    
    fprintf('%i\n',i)
    imgRaw=imgRaw(:,:);
    [xsize,ysize] = size(imgRaw);

    [imgHilbertTrans] = HilbertTrans2D(imgRaw,xsize,ysize);
    imgAngle = angle(imgHilbertTrans);
    [imgUnwrap] = unwrap2(imgAngle);
    
    %ph11 = ph_img1.*mask;
    imgUnwrapMask = imgUnwrap.*mask ;
   % un_ph11 = un_ph1;
    
    %ph11 = ph_img1;
    
    
   startx=001;
   stopx=1024;
   starty=001;
   stopy=1024;
   
   
   counter1=1:size(range,2);
   counter2=counter1(total_Number);
    
   imgUnwrapMaskCut(:,:,counter2) = imgUnwrapMask(startx:stopx,starty:stopy);
    %ph(:,:,i) = ph11(startx:stopx,starty:stopy);
total_Number=total_Number+1;
end
%save('ph.mat','ph','-v7.3');


save('un_ph.mat','imgUnwrapMaskCut','-v7.3');
% save('un_ph_b.mat','un_ph_b','-v7.3');
%%
%[ysize,xsize] = size(imgRaw(:,:,1));
%X = (1:ysize)*0.03; Y = (1:xsize)*0.03;
% figure; imagesc(X,Y,imgRaw); colormap gray; axis equal; colorbar;
% xlabel('X (\mum)','FontSize',24);
% ylabel('Y (\mum)','FontSize',24);
% h = gca; set(h,'FontSize',24);

%% 3d map
% cd('results\sequence');

imgHeight = imgUnwrapMaskCut*532/(4*pi*1.33);
L = floor(min(min(min(imgHeight))));
H = ceil(max(max(max(imgHeight))));
[ysize,xsize] = size(imgHeight(:,:,1));
X = (1:ysize)*0.03;
Y = (1:xsize)*0.03;

filename = 'test.gif';

figure
for i = 1:size(imgHeight,3)

    ph_m_nm = imgHeight(:,:,i);
    

  
 
    s = surf(Y,X,ph_m_nm);
    %view([95 95]);
    colormap jet;
    xlim([0 max(Y)]); ylim([0 max(X)]); zlim([L H])
    shading interp
    xlabel('X (\mum)','FontSize',24);
    ylabel('Y (\mum)','FontSize',24);
    zlabel('nm','FontSize',24);
    f = getframe(gcf);
    im = frame2im(f);
    [Im,map] = rgb2ind(im,256);
    if i == 1
        imwrite(Im,map,filename,'gif','LoopCount',Inf,'DelayTime',0);
    else
        imwrite(Im,map,filename,'gif','WriteMode','append','DelayTime',0);
    end
    
%     h = gca; set(h,'FontSize',24);
%     saveas(h,['map' num2str(i),'.png']);
%     pause(0.05)     % pause to control animation speed
end
toc

