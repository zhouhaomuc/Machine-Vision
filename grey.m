f = imread('C:\Users\IBM\Desktop\dark.jpg');
%Gray = (R*299 + G*587 + B*114 + 500) / 1000
fg = 0.299 * f(:,:,1) + 0.587 * f(:,:,2) + 0.114 * f(:,:,3);
imshow(fg);
