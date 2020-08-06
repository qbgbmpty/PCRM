function calculate_particle_and_cell_distance(image_num,image_row,image_col)

dos(['mkdir ./recordParticleandCellDistance']);
particle_cell_dis = zeros(70,image_num);

ParticleandCellFileName = ['recordParticleandCellDistance/ParticleandCellDistance'];
 
%% Calculate the distance between particles and cells
for image=1:1:image_num
    if length(num2str(image)) == 1
        CellFullFileName = ['recordCoordinate_c3/cell_full/1`60t0',num2str(image),'c3'];
        CellBorderFileName = ['recordCoordinate_c3/cell_border/1`60t0',num2str(image),'c3'];
        ParticleFullFileName = ['recordCoordinate_c2/particle_full/1`60t0',num2str(image),'c2'];
        ParticleBorderFileName = ['recordCoordinate_c2/particle_border/1`60t0',num2str(image),'c2'];
    elseif length(num2str(image)) == 2
        CellFullFileName = ['recordCoordinate_c3/cell_full/1`60t',num2str(image),'c3'];
        CellBorderFileName = ['recordCoordinate_c3/cell_border/1`60t',num2str(image),'c3'];
        ParticleFullFileName = ['recordCoordinate_c2/particle_full/1`60t',num2str(image),'c2'];
        ParticleBorderFileName = ['recordCoordinate_c2/particle_border/1`60t',num2str(image),'c2'];
    end
    cell_full_coordinate = textread([pwd,'/',CellFullFileName,'.txt']); 
    particle_full_coordinate = textread([pwd,'/',ParticleFullFileName,'.txt']);
    
    [cell_full_row cell_full_col] = size(cell_full_coordinate);  % cell_num = (cell_full_col-1)/2
    [particle_full_row particle_full_col] = size(particle_full_coordinate);  % particle_num = (particle_full_col-1)/2
    particle_num = (particle_full_col-1)/2;
    %[num2str(particle_num)]
    %[num2str(cell_full_row),' , ',num2str(cell_full_col)]
    %[num2str(particle_full_row),' , ',num2str(particle_full_col)]
    
    cell_mark = zeros(image_row,image_col);
    particle_mark = zeros(image_row,image_col,particle_num);
    overlap_mark = zeros(particle_num);   %record whether particle and cell overlap or not
    %% mark cell coordinate into array(1040*1392)
    for c_row = 1:1:cell_full_row
        for c_col = 1:2:cell_full_col-2
            if cell_full_coordinate(c_row,c_col) ~= 0
                cell_mark(cell_full_coordinate(c_row,c_col),cell_full_coordinate(c_row,c_col+1)) = 1;
            end
        end
    end
    
    %% mark particle coordinate into array(1040*1392)
    for p_row = 1:1:particle_full_row
        for p_col = 1:2:particle_full_col-2
            if particle_full_coordinate(p_row,p_col) ~= 0
                particle_mark(particle_full_coordinate(p_row,p_col),particle_full_coordinate(p_row,p_col+1),(p_col+1)/2) = 1;
            end
        end
    end
    
    %% mark cell which have overlapped with particle(output:1*cell_num)
    for o = 1:1:particle_num
        area = 0;
        for r = 1:1:image_row
            for c = 1:1:image_col
               if particle_mark(r,c,o) == 1 && cell_mark(r,c) == 1
                   area = area + 1;
               end
            end
        end
        if area >= 1
            overlap_mark(o) = 1;
        end
    end
    
    %% find miniman distance between cell and particle
    cell_border_coordinate = textread([pwd,'/',CellBorderFileName,'.txt']); 
    particle_border_coordinate = textread([pwd,'/',ParticleBorderFileName,'.txt']);
    
    [cell_border_row cell_border_col] = size(cell_border_coordinate);  % cell_num = (cell_border_col-1)/2
    [particle_border_row particle_border_col] = size(particle_border_coordinate);  % particle_num = (particle_border_col-1)/2
    %[num2str(cell_border_row),' , ',num2str(cell_border_col)]
    %[num2str(particle_border_row),' , ',num2str(particle_border_col)]
    min_dis = zeros(particle_num);
    
    for p_col = 1:2:particle_border_col-2
        if overlap_mark((p_col+1)/2) == 0
            for p_row = 1:1:particle_border_row
                if  particle_border_coordinate(p_row,p_col) ~= 0
                    for c_col = 1:2:cell_border_col-2
                        for c_row = 1:1:cell_border_row
                            if cell_border_coordinate(c_row,c_col) ~= 0
                                cx = cell_border_coordinate(c_row,c_col); % cell's x coordinate
                                cy = cell_border_coordinate(c_row,c_col+1); % cell's y coordinate
                                px = particle_border_coordinate(p_row,p_col);  % particle's x coordinate
                                py = particle_border_coordinate(p_row,p_col+1);  %particle's y coordinate
                                dis = norm([px py]-[cx cy]);
                                if p_row == 1 && (c_row == 1 && c_col == 1)
                                    min_dis((p_col+1)/2) = dis;
                                else
                                    if dis < min_dis((p_col+1)/2)
                                        min_dis((p_col+1)/2) = dis;
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        %['p_col ',num2str(p_col), ' finish']
    end
    divParticleandCellFile = fopen([pwd,'/',ParticleandCellFileName,num2str(image),'.txt'],'w');
    for p = 1:1:particle_num
        particle_cell_dis(p,image) = min_dis(p);
        fprintf(divParticleandCellFile,'%s \r\n', num2str(min_dis(p)));
        %['v = ',num2str(p),'min_dis(p) = ',num2str(min_dis(p))]
    end
    ['image_',num2str(image),' finish']
end

%% Record the distances between particles and cells with process
ObjectProcessFileName = ['TrackingProcess/recordObjectProcess/ObjectProcess'];
particle_process = textread([pwd,'/',ObjectProcessFileName,'.txt']);

[obj_num img_num] = size(particle_process);   %The number of objects in the first image is the standard
particle_cell_process_dis = zeros(obj_num,image_num);

ParticleandCellProcessDistanceFileName = ['recordParticleandCellDistance/ParticleandCellProcessDistance'];
ParticleandCellProcessDistanceFile = fopen([pwd,'/',ParticleandCellProcessDistanceFileName,'.txt'],'w');
for obj = 1:1:obj_num
    for image = 1:1:image_num
        particle_cell_process_dis(obj,image) = particle_cell_dis(particle_process(obj,image),image);
        fprintf(ParticleandCellProcessDistanceFile,'%s ', num2str(particle_cell_process_dis(obj,image))); % u is unsighned decimal
    end
    fprintf(ParticleandCellProcessDistanceFile,'\r\n');
end

fclose('all')
