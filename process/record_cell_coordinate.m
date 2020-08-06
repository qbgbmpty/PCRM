function record_cell_coordinate(image_num)

dos(['mkdir ./recordCoordinate_c3']);
dos(['mkdir ./recordCoordinate_c3/all_data']);
dos(['mkdir ./recordCoordinate_c3/cell_center']);
dos(['mkdir ./recordCoordinate_c3/cell_border']);
dos(['mkdir ./recordCoordinate_c3/cell_full']);
dos(['mkdir ./1`60_c3-image-change']);
cell_center_coordinate = zeros(50,image_num*2);

for image = 1:1:image_num
    % Read File and Name the File Name
    if length(num2str(image)) == 1
        B_RGB = imread(['./1`60_c3-image/1`60t0',num2str(image),'c3.tif']);
        B_FileName = ['recordCoordinate_c3/all_data/1`60t0',num2str(image),'c3'];
        B_BorderFileName = ['recordCoordinate_c3/cell_border/1`60t0',num2str(image),'c3'];
        B_FullFileName = ['recordCoordinate_c3/cell_full/1`60t0',num2str(image),'c3'];
        B_ColorFileName = ['1`60_c3-image-change/1`60t0',num2str(image),'c3'];
    elseif length(num2str(image)) == 2
        B_RGB = imread(['./1`60_c3-image/1`60t',num2str(image),'c3.tif']);
        B_FileName = ['recordCoordinate_c3/all_data/1`60t',num2str(image),'c3'];
        B_BorderFileName = ['recordCoordinate_c3/cell_border/1`60t',num2str(image),'c3'];
        B_FullFileName = ['recordCoordinate_c3/cell_full/1`60t',num2str(image),'c3'];
        B_ColorFileName = ['1`60_c3-image-change/1`60t',num2str(image),'c3'];
    end
    
    % Find Binary Image
    B_BinaryImg = findBinaryImg(B_RGB,3,1,30,image);
    
    % Find Object Image
    cell_center_coordinate = findObjectImg(B_RGB,B_BinaryImg,B_FileName,B_BorderFileName,B_FullFileName,B_ColorFileName,cell_center_coordinate,image,12000,6000,100);
end

CenterFileName = ['recordCoordinate_c3/cell_center/cell_center'];
center_object_file = fopen([pwd,'/',CenterFileName,'.txt'],'w');

for i = 1:1:50
    for j = 1:1:image_num*2
        fprintf(center_object_file,'%d ', cell_center_coordinate(i,j));
    end
    fprintf(center_object_file,'\r\n');
end
