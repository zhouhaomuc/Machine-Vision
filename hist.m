% File Information
brightFile = imread('C:\Users\IBM\Desktop\bright.jpg');
darkFile = imread('C:\Users\IBM\Desktop\dark.jpg');

% Calculation
greyDarkFile = grey(darkFile);
greyBrightFile = grey(brightFile);
zoomDarkFile = zoom(greyDarkFile, 100, 800, 2, 1.7);
zoomBrightFile = zoom(greyBrightFile, 100, 800, 2, 1.7);
equaDark = histEqua(zoomDarkFile);
equaBright = histEqua(zoomBrightFile);

% Display
imshow(greyDarkFile);
figure, imshow(greyBrightFile);
figure, imshow(zoomDarkFile);
figure, imshow(zoomBrightFile);
getHist(zoomDarkFile);
getHist(zoomBrightFile);
figure, imshow(equaDark);
figure, imshow(equaBright);
getHist(equaDark);
getHist(equaBright);

% Save into File
imwrite(greyDarkFile, 'C:\Users\IBM\Desktop\greyDarkFile.jpg');
imwrite(greyBrightFile, 'C:\Users\IBM\Desktop\greyBrightFile.jpg');
imwrite(zoomDarkFile, 'C:\Users\IBM\Desktop\zoomDarkFile.jpg');
imwrite(zoomBrightFile, 'C:\Users\IBM\Desktop\zoomBrightFile.jpg');


function [fg] = grey(file)
    %Gray = (R*299 + G*587 + B*114 + 500) / 1000
    fg = 0.299 * file(:,:,1) + 0.587 * file(:,:,2) + 0.114 * file(:,:,3);
end

function [] = getHist(pic)
    plot = zeros(1 , 256);

    for i = 1:256
        plot(1 , i) = length(find(pic == i));
    end

    figure, bar(1:256 , plot , 'grouped');
    title('Grey Scale Histogram');
    xlabel('Grey Scale');
    ylabel('Frequency');
end

function [saved] = zoom(img, x, y, wSize, hSize)
    fg = img(x: y, x:y);
    w=wSize;
    h=hSize;
    [m, n]=size(fg);
    newPic=zeros(round(h*m),round(w*n));
    rot=[h 0 0;0 w 0;0 0 1];
    inv_rot=inv(rot);

    for x=1:h*m
        for y=1:w*n
            pix=[x y 1]*inv_rot;                 
            newPic(x,y)=fg(round(pix(1)),round(pix(2)));        
        end
    end
    saved= uint8(newPic);
end

function [eqPic] = histEqua(pic)
    %ylim('auto');
    eqPic = histeq(pic, 255);
end
