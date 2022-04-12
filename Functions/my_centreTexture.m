%Written by Tess Barich 2020)
function centeredRect = my_centreTexture(size1,size2,x,y)
baseRect = [0 ,0, size1,size2]; 
centeredRect = CenterRectOnPointd(baseRect,x,y);
end 