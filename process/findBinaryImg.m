function BinaryImg = findBinaryImg(rgbX,ctype,minRange,maxRange,image)

[im_row im_col dim] = size(rgbX);
BinaryImg = ones(im_row,im_col);
expansionMask = [0 1 0; 1 1 1; 0 1 0];

for r = 1:1:im_row
    for c = 1:1:im_col
        if rgbX(r,c,ctype)>=minRange && rgbX(r,c,ctype)<=maxRange
            BinaryImg(r,c) = 0;
        end
    end
end

if ctype == 2
    if image == 27 || image == 31 || image == 32 || image == 34 || image == 35 || image == 36 || image == 39
        for r = 320:350
            for c = 80:105
                if rgbX(r,c,ctype) >= 20 && rgbX(r,c,ctype) <= 25
                    BinaryImg(r,c) = 1;
                end
            end
        end
    end

    if image == 17 || image == 22 || image == 25 || image == 27
        for r = 460:510
            for c = 1:15
                if rgbX(r,c,ctype) >= 18 && rgbX(r,c,ctype) <= 25
                    BinaryImg(r,c) = 1;
                end
            end
        end
    end
end

BinaryImg = imdilate(BinaryImg, expansionMask);