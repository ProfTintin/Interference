function [Pimg] = HilbertTrans2D(img,xsize,ysize)

% If you ever need to validate variable type: validateattributes(BgImg,{'uint16'},{'real'})
Fimg = fftshift(fft2(img)); %FFT
%figure(901), imagesc(log(abs(Fimg))), axis image; title('Fourier Transform');

[mi,mj]=find(Fimg==max(max(Fimg(:,round(ysize/2+ysize/20):ysize))));
% (mi,mj) : position of maximum point of + order in Fourier space in matrix

mi=round(mi-xsize/2-1);
mj=round(mj-ysize/2-1);
% conversion of position in matrix to coordinate representation.

dc=sqrt(mi.^2+mj.^2)./8;  % original value /8
dc1 = round(dc*4); %% half the distance from oth to 1st order.

%Just force the mi value 
c1mask = ~(mk_ellipse(dc1,dc1,ysize,xsize));
%figure(905), imagesc(c1mask);
c3mask = c1mask.*1;

cmask = conv2(c3mask,ones(round(dc)),'same')/(dc.^2);

% figure(903), imagesc(cmask);
Fimg = circshift(Fimg,[-mi -mj]);
%figure(907), imagesc(log(abs(Fimg))),title('Masked Fourier transform');

Fimg = Fimg.*cmask;
%figure(904), imagesc(log(abs(Fimg))),title('Masked Fourier transform');
Pimg = ifft2(fftshift(Fimg)); %IFFT complex number
return;


function H = mk_ellipse(XR,YR,X,Y)
[XX, YY]=meshgrid(1:X,1:Y);
H=((XX-X/2)./XR).^2+((YY-Y/2)./YR).^2>1.0;
return;