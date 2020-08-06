function record_particle_coordinate(image_num)

dos(['mkdir ./recordCoordinate_c2']);
dos(['mkdir ./recordCoordinate_c2/all_data']);
dos(['mkdir ./recordCoordinate_c2/particle_center']);
dos(['mkdir ./recordCoordinate_c2/particle_border']);
dos(['mkdir ./recordCoordinate_c2/particle_full']);
dos(['mkdir ./1`60_c2-image-change']);
particle_center_coordinate = zeros(70,image_num*2);

for image = 1:1:image_num
    % Read File and Name the File Name
    if length(num2str(image)) == 1
        G_RGB = imread(['./1`60_c2-image/1`60t0',num2str(image),'c2.tif']);
        G_FileName = ['recordCoordinate_c2/all_data/1`60t0',num2str(image),'c2'];
		G_BorderFileName = ['recordCoordinate_c2/particle_border/1`60t0',num2str(image),'c2'];
        G_FullFileName = ['recordCoordinate_c2/particle_full/1`60t0',num2str(image),'c2'];
        G_ColorFileName = ['1`60_c2-image-change/1`60t0',num2str(image),'c2'];
    elseif length(num2str(image)) == 2
        G_RGB = imread(['./1`60_c2-image/1`60t',num2str(image),'c2.tif']);
        G_FileName = ['recordCoordinate_c2/all_data/1`60t',num2str(image),'c2'];
		G_BorderFileName = ['recordCoordinate_c2/particle_border/1`60t',num2str(image),'c2'];
        G_FullFileName = ['recordCoordinate_c2/particle_full/1`60t',num2str(image),'c2'];
        G_ColorFileName = ['1`60_c2-image-change/1`60t',num2str(image),'c2'];
    end
    
    % Find Binary Image
    G_BinaryImg = findBinaryImg(G_RGB,2,1,25,image);
    
    % Find Object Image
    particle_center_coordinate = findObjectImg(G_RGB,G_BinaryImg,G_FileName,G_BorderFileName,G_FullFileName,G_ColorFileName,particle_center_coordinate,image,24000,12000,50);
end

G_CenterFileName = ['recordCoordinate_c2/particle_center/particle_center'];
center_object_file = fopen([pwd,'/',G_CenterFileName,'.txt'],'w');

for i = 1:1:70
    for j = 1:1:image_num*2
        fprintf(center_object_file,'%d ', particle_center_coordinate(i,j));
    end
    fprintf(center_object_file,'\r\n');
end
