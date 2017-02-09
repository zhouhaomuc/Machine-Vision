% fOriginal is the original image
fOriginal = imread('Shapes-blurred.png');
thre = 77;
for i=1:55
    for j = 1:54
        if fOriginal(i,j)<thre
            fOriginal(i,j) = 0;
        else
            fOriginal(i,j) = 255;
        end
    end
end

fOriginal = logical(fOriginal);
fOriginal
imshow(fOriginal);
imwrite(fOriginal, 'seperate.png');

% f is the metrix of the binary image
% flabel is the label metrix in the further steps
% com is a metrix which indicates the equvalence of multiple labels
f = imread('seperate.png');
flabel = zeros(55,54);
flag = 0;
global com;
com = [];
if f(1,1) == 1
    f(1,1) = flag;
end

% label each pixel in the original image
% store labels in the flabel
for i=2:55
    for j=2:54
        if f(i,j)==1
            if f(i,j-1)>0
                flabel(i,j) = flabel(i,j-1);
            elseif f(i-1,j)>0
                flabel(i,j) = flabel(i-1,j);
            else
                flag = flag+1;
                flabel(i,j) = flag;      
            end
            
            if flabel(i,j)>0 && flabel(i-1,j)>0
                if flabel(i,j)~=flabel(i-1,j) && flabel(i-1,j-1)==0
                    r=[flabel(i-1,j),flabel(i,j),0];
                    com = [com;r];
                end
            end
        end
    end
end
AfterFirstPath = flabel;
AfterFirstPath
% use global to do Depth-first Search in the further steps
% level is the lebel of each pair in the com
global level;
level =0;
com(1,3) = 1;
global row;
[row,col] = size(com);

% using Depth-First Search
% label the pixels that have the connected labels
% function DFS is in the bottom of the file
for i = 1:row
    if com(i,3)==0
        level = level+1;
        DFS(i);
    end
end    

%find the biggest level in the com
max = 1;
for i = 1:row
    if com(i,3)>max
        max = com(i,3);
    end
end

% replace labels in the label metrix 
% use identical labels for connected pixels
% imRow is the numbers of row in the image
% imCol is the numbers of column in the image
[imRow, imCol] = size(flabel);
for i = 1:imRow
    for j = 1:imCol
        for m = 1:row
            if flabel(i,j) == com(m,1) || flabel(i,j) == com(m,2)
                flabel(i,j) = com(m,3);
            end
        end
    end
end
FinalLabel = flabel;
FinalLabel

% get the repeat times of every label
% to count the label which is less than 10
valueCount = [1,0];
for i = 1:imRow
    for j = 1:imCol
        if flabel(i,j)>0
            [tempRow, tempCol] = size(valueCount);
            flag=0;
            for m = 1:tempRow
                if flabel(i,j)==valueCount(m,1)
                    valueCount(m,2)  = valueCount(m,2) + 1;
                    flag = 1;
                    break;
                end
            end
            if flag == 0
                temp = [flabel(i,j),1];
                valueCount = [valueCount;temp];
            end
        end
    end
end

% get label which should be deleted
deleteValue = [];
[vcRow, vcCol] = size(valueCount);
for i = 1:vcRow
    if valueCount(i, 2) < 10
        deleteValue = [deleteValue; valueCount(i,1)];
    end
end

% delete label which is less than 10 in the flabel metric
[delRow, delCol] = size(deleteValue);
for i = 1:imRow
    for j = 1:imCol
        for m = 1:delRow
            if(flabel(i,j) == deleteValue(m))
                flabel(i,j) = 0;
            end
        end
    end
end            
imwrite(flabel,'MoreThan10.png');

% get a metrix which stores the labels after deletion of 
% less than 10 pixels
reservedValue = [];
for i = 1:vcRow
    flag = 0;
    for j = 1:delRow
        if valueCount(i,1) == deleteValue(j,1)
            flag = 1;
            break;
        end
    end
    if flag == 0
        reservedValue = [reservedValue; valueCount(i,1)];
    end
end

% count width and height of each label
% purpose: preparation for deleting skinny shapes
[reserRow, reserCol] = size(reservedValue);
skinnyInfo = [];
for value = 1:reserRow
    minWidth = imCol;
    maxWidth=0;
    minHight=imRow;
    maxHight=0;
    for i = 1:imRow
        for j = 1:imCol
            if flabel(i,j) == reservedValue(value,1);
                if j<minWidth
                    minWidth = j;
                end
                if j>maxWidth
                    maxWidth = j;
                end
                if i<minHight
                    minHight = i;
                end
                if i>maxHight
                    maxHight = i;
                end
            end
        end
    end
    width = maxWidth - minWidth;
    hight = maxHight - minHight;
    info = [reservedValue(value,1), width, hight, minWidth, maxWidth, minHight, maxHight];
    skinnyInfo = [skinnyInfo; info];
end
            
%count label which is skinny
skinnyLabel = [];
[skinRow, skinCol] = size(skinnyInfo);
for i = 1:skinRow
    if skinnyInfo(i,2) > (3 * skinnyInfo(i,3)) || skinnyInfo(i,3) > (3 * skinnyInfo(i,2))
        skinnyLabel = [skinnyLabel;skinnyInfo(i,1)];
    end
end

% delete skinny label
[delSkiRow, delSkiCol] = size(skinnyLabel);
for i = 1:imRow
    for j = 1:imCol
        for m = 1:delSkiRow
            if flabel(i,j) == skinnyLabel(m,1)
                flabel(i,j) = 0;
            end
        end
    end
end
imwrite(flabel,'NotSkinny.png');
NotSkinnyLabel = flabel;
NotSkinnyLabel

% get lebels which is not skinny
notSkinny = [];
for i = 1:skinRow
    flag = 0;
    for j = 1:delSkiRow
        if skinnyInfo(i,1) == skinnyLabel(j,1)
            flag = 1;
            break;
        end
    end
    if flag == 0
        notSkinny = [notSkinny; skinnyInfo(i,:)];
    end
end

% detect the heart shape from notSkinny label
% method: 
% get the width of the shape for one single row
% get width for 10 times
% from upper parts to lower parts EVENLY
%
% for a heart shape
% in the upper parts: width will get larger gradualy
% in the lower parts: width will get smaller gradualy
% this pattern is not suitable for other shapes
[NSkiRow, NSkiCol] = size(notSkinny);
interCept = [];
for i = 1:NSkiRow
    num = 10;
    shapeHight = notSkinny(i,3);
    pieceHight = floor(shapeHight / num);
    curRow = notSkinny(i, 6);
    temp = [notSkinny(i,1)];
    for j = 0:num
        left = 0;
        right = 0;
        curRow = curRow + pieceHight;
        for m = 1:imCol
            if flabel(curRow, m) == notSkinny(i,1)
                left = m;
                break;
            end
        end
        for m = 1:imCol
            if flabel(curRow, imCol-m+1) == notSkinny(i,1)
                right = imCol-m+1;
                break;
            end
        end
        temp = [temp, right-left];
    end
    interCept = [interCept; temp];
end

% analyze the intercepts of each shape
% get the heart shape label
[interRow, interCol] = size(interCept);
target = [];
for i = 1:interRow
    pre = interCept(i,2);
    flag = 1;
    for j = 3:interCol
        if j<=3
            if interCept(i,j) <= pre
                flag = 0;
                break;
            end
        end
        if j>=6
            if interCept(i,j) >= pre
                flag = 0;
                break;
            end
        end
        pre = interCept(i,j);
    end
    if flag == 1
        target = [target;interCept(i,1)];
    end
end

% delete other label than heart shape
for i = 1:imRow
    for j = 1:imCol
        if flabel(i,j) ~= target(1,1)
            flabel(i,j) = 0;
        end
    end
end
imwrite(flabel,'heart.png');
HeartLabel = flabel;
HeartLabel

% DFS funtion is the DFS function when deleting repeated labels
function DFS(cur)
    global row;
    global com;
    global level;
    for i = 2:row
        if(com(cur,1)==com(i,1) || com(cur,1)==com(i,2) || com(cur,2)==com(i,1) || com(cur,2)==com(i,2))
            if com(i,3)==0
                com(i,3) = level;
                DFS(i);
            end
        end
    end
end




