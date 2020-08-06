function record_particle_process(image_num)

dos(['mkdir ./TrackingProcess']);
dos(['mkdir ./TrackingProcess/recordRelation']);
dos(['mkdir ./TrackingProcess/trackPath']);
dos(['mkdir ./TrackingProcess/recordObjectProcess']);
CenterFileName = ['recordCoordinate_c2/particle_center/particle_center'];
particle_center_coordinate = textread([pwd,'/',CenterFileName,'.txt']);

for image = 1:1:image_num
    % Read File
    if length(num2str(image)) == 1
        G_RGB = imread(['./1`60_c2-image/1`60t0',num2str(image),'c2.tif']);
        G_FullFileName = ['recordCoordinate_c2/particle_full/1`60t0',num2str(image),'c2'];
    elseif length(num2str(image)) == 2
        G_RGB = imread(['./1`60_c2-image/1`60t',num2str(image),'c2.tif']);
        G_FullFileName = ['recordCoordinate_c2/particle_full/1`60t',num2str(image),'c2'];
    end
    
    % Record Object Relation
    if image ~= 1
        if length(num2str(image-1)) == 1
            formerFileName = ['recordCoordinate_c2/particle_full/1`60t0',num2str(image-1),'c2'];
        elseif length(num2str(image-1)) == 2
            formerFileName = ['recordCoordinate_c2/particle_full/1`60t',num2str(image-1),'c2'];
        end
        if length(num2str(image-1)) == 1 && length(num2str(image)) == 1
            recordRelationFileName = ['TrackingProcess/recordRelation/1`60t0',num2str(image-1),'_0',num2str(image),'c2'];
        elseif length(num2str(image-1)) == 1  && length(num2str(image)) == 2
            recordRelationFileName = ['TrackingProcess/recordRelation/1`60t0',num2str(image-1),'_',num2str(image),'c2'];
        elseif length(num2str(image-1)) == 2 && length(num2str(image)) == 1
            recordRelationFileName = ['TrackingProcess/recordRelation/1`60t',num2str(image-1),'_0',num2str(image),'c2'];
        elseif length(num2str(image-1)) == 2 && length(num2str(image)) == 2
            recordRelationFileName = ['TrackingProcess/recordRelation/1`60t',num2str(image-1),'_',num2str(image),'c2'];
        end
        recordObjectRelation(G_RGB,G_FullFileName,formerFileName,recordRelationFileName,particle_center_coordinate,image);
    end
end

%% Confirm the number of objects based on the first image
firstFullFileName = ['recordCoordinate_c2/particle_full/1`60t01c2'];
particle_full_coordinate = textread([pwd,'/',firstFullFileName,'.txt']);
[full_row full_col] = size(particle_full_coordinate);
objnum = (full_col-1) / 2;

ObjectProcess = trackPath(image_num,objnum);

recordObjectProcess(image_num,objnum,ObjectProcess);

fclose('all')
