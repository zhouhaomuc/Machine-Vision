f = imread('C:\Users\IBM\Desktop\dark.jpg');
%Gray = (R*299 + G*587 + B*114 + 500) / 1000
fgrey = 0.299 * f(:,:,1) + 0.587 * f(:,:,2) + 0.114 * f(:,:,3);
imshow(fgrey);

fg = fgrey(200: 500, 200:500);
figure, imshow(fg);
w=2;
h=2;
%img=imread('Corner.png');
%imshow(img);
[m n]=size(fg);
imgn=zeros(h*m,w*n);

rot=[h 0 0;0 w 0;0 0 1];
inv_rot=inv(rot);

for x=1:h*m
    for y=1:w*n
        pix=[x y 1]*inv_rot;                 
        imgn(x,y)=fg(round(pix(1)),round(pix(2)));        
    end
end
figure,imshow(uint8(imgn))
imwrite(uint8(imgn), 'C:\Users\IBM\Desktop\darkZoom.jpg');
fx = uint8(imgn);
fx = imadjust(fx,[],[],2);

figure, imshow(fx);