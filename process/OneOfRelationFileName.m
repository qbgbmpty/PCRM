function RelationFileName = OneOfRelationFileName(image)

if length(num2str(image)) == 1 && length(num2str(image+1)) == 1
    RelationFileName = ['TrackingProcess/recordRelation/1`60t0',num2str(image),'_0',num2str(image+1),'c2'];
elseif length(num2str(image)) == 1  && length(num2str(image+1)) == 2
    RelationFileName = ['TrackingProcess/recordRelation/1`60t0',num2str(image),'_',num2str(image+1),'c2'];
elseif length(num2str(image)) == 2 && length(num2str(image+1)) == 1
    RelationFileName = ['TrackingProcess/recordRelation/1`60t',num2str(image),'_0',num2str(image+1),'c2'];
elseif length(num2str(image)) == 2 && length(num2str(image+1)) == 2
    RelationFileName = ['TrackingProcess/recordRelation/1`60t',num2str(image),'_',num2str(image+1),'c2'];
end
