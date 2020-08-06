function ObjectProcess = trackPath(image_num,objnum)

ObjectProcess = zeros(3,image_num,objnum);   %this example has three objects that are merged together

%% Confirm that some objects are merged together throughout the process
for image = 1:1:image_num-1
    recordRelationFileName = OneOfRelationFileName(image);
    
    clear sym former later fx fy lx ly
    if image == 1
        [sym former later fx fy lx ly] = textread([pwd,'/',recordRelationFileName,'.txt'],'%c %d %d %d %d %d %d');
        for i = 1:1:numel(sym)
            if ObjectProcess(1,image,former(i)) ~= 0 && ObjectProcess(2,image,former(i)) ~= 0
                ObjectProcess(3,image,former(i)) = former(i);
                ObjectProcess(3,image+1,former(i)) = later(i);
            elseif ObjectProcess(1,image,former(i)) ~= 0 && ObjectProcess(2,image,former(i)) == 0
                ObjectProcess(2,image,former(i)) = former(i);
                ObjectProcess(2,image+1,former(i)) = later(i);
            elseif ObjectProcess(1,image,former(i)) == 0
                ObjectProcess(1,image,former(i)) = former(i);
                ObjectProcess(1,image+1,former(i)) = later(i);
            end
        end
    else
        [sym former later fx fy lx ly] = textread([pwd,'/',recordRelationFileName,'.txt'],'%c %d %d %d %d %d %d');
        for i = 1:1:numel(sym)
            for j = 1:1:objnum
                if ObjectProcess(1,image,j) == former(i)
                    if ObjectProcess(1,image+1,j) == 0
                        ObjectProcess(1,image+1,j) = later(i);
                    elseif ObjectProcess(1,image+1,j) ~= 0
                        if ObjectProcess(2,image+1,j) == 0 && ObjectProcess(2,image,j) == 0
                            ObjectProcess(2,image+1,j) = later(i);
                            ObjectProcess(2,image,j) = former(i);
                        elseif ObjectProcess(2,image,j) == former(i) && ObjectProcess(2,image+1,j) == 0
                            ObjectProcess(2,image+1,j) = later(i);
                        elseif ObjectProcess(2,image+1,j) ~= 0 && ObjectProcess(2,image,j) ~= 0
                            if ObjectProcess(2,image,j) == former(i)
                                ObjectProcess(3,image+1,j) = later(i);
                                ObjectProcess(3,image,j) = former(i);
                            elseif ObjectProcess(2,image,j) ~= former(i)
                                ObjectProcess(3,image+1,j) = ObjectProcess(2,image+1,j);
                                ObjectProcess(3,image,j) = ObjectProcess(2,image,j);
                                ObjectProcess(2,image+1,j) = later(i);
                                ObjectProcess(2,image,j) = former(i);
                            end
                        end
                    end
                elseif ObjectProcess(1,image,j) ~= former(i)
                    if ObjectProcess(2,image,j) == former(i)
                        if ObjectProcess(2,image+1,j) == 0
                            ObjectProcess(2,image+1,j) = later(i);
                        elseif ObjectProcess(2,image+1,j) ~= 0
                            if ObjectProcess(3,image,j) == former(i) && ObjectProcess(3,image+1,j) == 0
                                ObjectProcess(3,image+1,j) = later(i);
                            elseif ObjectProcess(3,image+1,j) == 0 && ObjectProcess(3,image,j) == 0
                                ObjectProcess(3,image+1,j) = later(i);
                                ObjectProcess(3,image,j) = former(i);
                            end
                        end
                    elseif ObjectProcess(2,image,j) ~= former(i)
                        if ObjectProcess(3,image,j) == former(i)
                            ObjectProcess(3,image+1,j) = later(i);
                        end
                    end
                end
            end
        end
    end
end

for obj = 1:1:objnum
    if length(num2str(obj)) == 1
        ObjectFileName = ['TrackingProcess/trackPath/Object0',num2str(obj)];
    elseif length(num2str(obj)) == 2
        ObjectFileName = ['TrackingProcess/trackPath/Object',num2str(obj)];
    end
    ObjectFile = fopen([pwd,'/',ObjectFileName,'.txt'],'w');
    for image = 1:1:image_num
        for i = 1:1:3
            if ObjectProcess(i,image,obj) ~= 0
                fprintf(ObjectFile,'%d ', ObjectProcess(i,image,obj));
            end
        end
        fprintf(ObjectFile,'\r\n');
    end
end

fclose('all');
