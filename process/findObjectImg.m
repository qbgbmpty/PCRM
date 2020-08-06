function center_coordinate = findObjectImg(rgbX,BinaryImg,FileName,BorderFileName,FullFileName,ColorFileName,center_coordinate,image,full_num,border_num,size_threshold)

[im_row im_col dim] = size(rgbX);
ObjectImg = zeros(im_row,im_col);
ColoredObjectImg(:,:,:) = rgbX(:,:,:);
borderObjectImg = bwperim(BinaryImg,8);
[L, num] = bwlabel(BinaryImg);
full_coordinate = zeros(full_num, 2*num);
border_coordinate = zeros(border_num, 2*num);
object_file = fopen([pwd,'/',FileName,'.txt'],'w');
border_object_file = fopen([pwd,'/',BorderFileName,'.txt'],'w');
full_object_file = fopen([pwd,'/',FullFileName,'.txt'],'w');

index = 0;
for k = 1:1:num
    [x, y] = find(L == k);
    Xmin = min(x);
    Ymin = min(y);
    Xmax = max(x);
    Ymax = max(y);
    Xcenter = round((Xmin+Xmax)/2);
    Ycenter = round((Ymin+Ymax)/2);
    object_size = numel(x);
    for i = 1:1:numel(x);
        ObjectImg(x(i), y(i)) = 1;
    end
    if numel(x) > size_threshold
        index = index + 1;
        fprintf(object_file,'> object %d - %d %d %d %d %d %d %d %d \r\n',index,Xmin,Ymin,Xmax,Ymax,Xcenter,Ycenter,object_size);
        %fprintf(object_file,'\r\n');
        center_coordinate(index, 2*image-1) = Xcenter;
        center_coordinate(index, 2*image) = Ycenter;
		border_index = 0;
        for j = 1:1:numel(x)
            fprintf(object_file,'| %d %d \r\n',x(j),y(j));
            full_coordinate(j,2*index-1) = x(j);
            full_coordinate(j,2*index) = y(j);
            if borderObjectImg(x(j),y(j)) == 1;
				border_index = border_index + 1;
                border_coordinate(border_index,2*index-1) = x(j);
                border_coordinate(border_index,2*index) = y(j);
                ColoredObjectImg(x(j),y(j),1) = 255;
                ColoredObjectImg(x(j),y(j),2) = 255;
                ColoredObjectImg(x(j),y(j),3) = 0;
            end
        end
    end
end

%% circle real object
imwrite(ColoredObjectImg,[pwd,'/',ColorFileName,'.tif'],'tiff');

%% object's border coordinate
for i = 1:1:border_num
    for j = 1:1:2*index
        fprintf(border_object_file,'%d ', border_coordinate(i,j));
    end
    fprintf(border_object_file,'\r\n');
end

%% virus's full coordinate
for i = 1:1:full_num
    for j = 1:1:2*index
        fprintf(full_object_file,'%d ', full_coordinate(i,j));
    end
    fprintf(full_object_file,'\r\n');
end

fclose('all');
