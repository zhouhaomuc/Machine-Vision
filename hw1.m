f = imread('C:\Users\IBM\Desktop\dark.jpg');
g = imread('C:\Users\IBM\Desktop\bright.jpg');
%ftif = imread('C:\Users\IBM\Desktop\darkcom.tif');

%fc = f(20:2000, 20:2000);
%fp = fc(end:-1:1, :);
%fs = fc(1:10:end, 1:10:end);
%imshow(fp);
%figure;
%imshow(fc);
%figure;
%imshow(fs);
%whos f
%size(f)
fc = f(1000:2500, 1000:2500);
g1 = imadjust(fc, [0 1], [1 0]);
g2 = imadjust(fc, [0 0.8], [0 1]);
g3 = imadjust(fc, [  ], [  ], 2);
%imshow(fc);
%figure, imshow(g1);
%figure, imshow(g2);
%figure, %imshow(g3);
%h = imhist(fc);
%h1 = h(1:10:256);
%horz = (1:10:256);
%figure, bar(horz, h1);
%figure, imhist(fc);
imshow(fc);
figure, imhist(fc);
ylim('auto');
fc1 = histeq(fc, 255);
figure, imshow(fc1);
figure, imhist(fc1);
ylim('auto');




