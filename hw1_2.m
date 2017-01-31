f = imread('C:\Users\IBM\Desktop\dark.tif');
g = imread('C:\Users\IBM\Desktop\bright.tif');
whos f
whos g
fc = f(150:600, 400:1200);
gc = g(150:600, 400:1200);
imshow(fc);
imwrite(fc, 'C:\Users\IBM\Desktop\darkSave.tif');
figure, imshow(gc);
imwrite(gc, 'C:\Users\IBM\Desktop\brightSave.tif');

figure, imhist(fc);
ylim('auto');
fc1 = histeq(fc, 255);
figure, imshow(fc1);
figure, imhist(fc1);
ylim('auto');

figure, imhist(gc);
ylim('auto');
gc1 = histeq(gc, 255);
figure, imshow(gc1);
figure, imhist(gc1);
ylim('auto');