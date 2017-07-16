close all; 
clear all;
clc

counter_To_Delete_Membrane=1;counter_To_Delete_Background=1;

to_Delete_Membrane=zeros(10);
to_Delete_Background=zeros(10);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rowNumberSampleBackground=4;
columnNumberSampleBackground=3;
locationStartBackgroundX=200;
locationStartBackgroundY=200;

rowNumberSampleMembrane=3;
columnNumberSampleMembrane=4;
locationStartMembraneX=500;
locationStartMembraneY=500;

sampleRegion=5;


un_ph =  loadSingleVariableMATFile('un_ph.mat');

%delete unwanted frame here
% un_ph(:,:,[66:99])=[];



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:size(un_ph,3)
 
    ph_m_nm = ((un_ph(:,:,i)*532)/(4*pi*1.33));
    
  % Calculate background  
  for m = 1:rowNumberSampleBackground
      for n = 1:columnNumberSampleBackground
    xBackgroundPoint((m-1)*columnNumberSampleBackground+n)=locationStartBackgroundX+sampleRegion*(m-1);
    yBackgroundPoint((m-1)*columnNumberSampleBackground+n)=locationStartBackgroundY+sampleRegion*(n-1);

      end
  end          
    
    for pointCounter = 1:size(xBackgroundPoint,2)   
    background(i,pointCounter) = mean2(ph_m_nm(xBackgroundPoint(pointCounter):xBackgroundPoint(pointCounter)+sampleRegion,yBackgroundPoint(pointCounter):yBackgroundPoint(pointCounter)+sampleRegion));
    
    end         
    % Find abnormal frames
    if ((background(i,1)> 150) || (background(i)< -50))
        to_Delete_Background(counter_To_Delete_Background)=i;
        counter_To_Delete_Background=counter_To_Delete_Background+1;
    end
    

   %for i = 1:size(un_ph,3) 
    
    % Calculate membrane
  for m = 1:rowNumberSampleMembrane
      for n = 1:columnNumberSampleMembrane
    xMembranePoint((m-1)*columnNumberSampleMembrane+n)=locationStartMembraneX+sampleRegion*(m-1);
    yMembranePoint((m-1)*columnNumberSampleMembrane+n)=locationStartMembraneY+sampleRegion*(n-1);

      end
  end          
   %end
    
    for pointCounter = 1:size(xMembranePoint,2)
    membrane(i, pointCounter) = mean2(ph_m_nm(xMembranePoint(pointCounter):xMembranePoint(pointCounter)+sampleRegion,yMembranePoint(pointCounter):yMembranePoint(pointCounter)+sampleRegion));

    end
   

    if (membrane(i,1)> 500 || membrane(i,1)< 15)
        to_Delete_Membrane(counter_To_Delete_Membrane)=i;
        counter_To_Delete_Membrane=counter_To_Delete_Membrane+1;
    end
    
    
    %%%%remove backgrond from membrane
    
      
end

    %Calculate average of background to remove
for sampleCounter = 1:size(background,1)   
biasBackground(sampleCounter)= mean2(background(sampleCounter,1:size(xBackgroundPoint,2)));
end

biasBackgroundAverage=mean(biasBackground);

for pointCounter = 1:size(xMembranePoint,2)   
standard_Devision_Membrane(pointCounter)= std(membrane(:,pointCounter)-biasBackground(:));
end


for pointCounter = 1:size(xBackgroundPoint,2)   
standard_Devision_Background(pointCounter) = std(background(:,pointCounter)-biasBackground(:));
end

% mean_Membrane = mean(membrane);
% mean_Background = mean (background);

x1=1:i;

legend_Membrane = {strcat('Membrane = '  )} ;
legend_Background = {strcat('Background = ' )} ;

figure

for pointCounter = 1:size(xMembranePoint,2)  
      
       p1= plot (x1*28.8,membrane(:,pointCounter)-mean(membrane(:,pointCounter))-biasBackground(:)+biasBackgroundAverage,'r');
        hold on;
end

for pointCounter = 1: size(xBackgroundPoint,2) 
     
       p2= plot (x1*28.8,background(:,pointCounter)-mean(background(:,pointCounter))-biasBackground(:)+biasBackgroundAverage,'g');
        hold on;
end

hold off;


xlabel('Time (ms)')
ylabel('Hight (nm)')
legend([p1,p2],'Membrane','Background','Location','southwest')
legend ('boxoff')
savefig('Fluctuation.fig')
%%%%%%%%%%%%%%%%%%%
figure
x2=1:size(xMembranePoint,2) ;
scatter(x2,standard_Devision_Membrane,'filled','r')
hold on;
x3=1+size(xMembranePoint,2)*2:size(xMembranePoint,2)*2+size(xBackgroundPoint,2) ;
scatter(x3,standard_Devision_Background,'filled','g')
hold on;




%plot average
plot(x2,repmat(mean(standard_Devision_Membrane),size(x2,1),size(x2,2)),'m-')
plot(x3,repmat(mean(standard_Devision_Background),size(x3,1),size(x3,2)),'m-')

%ylim([0 1.5])
ylabel('Deviation')
legend_Membrane = {strcat('Membrane = ' , num2str(mean(standard_Devision_Membrane),'%.3f'))};
legend_Background = {strcat('Background = ',num2str(mean(standard_Devision_Background),'%.3f'))} ;

legend(legend_Membrane{:},legend_Background{:})
set(gca,'XTickLabel',{})
savefig('Deviation.fig')

