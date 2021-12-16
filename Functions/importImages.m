%Created By Tess Barich 2021 Flinders University
function importImages(directory,str)
global Env %Load globals 
%% Search the pathway for the wanted stimuli
dir = dir(directory); %pull directory contents
dir = dir(find(~cellfun(@isdir,{dir(:).name})));%Filter out all the folders.
A = contains([{dir(:).name}],str); %Search for the common term used in exp stimuli sets.
%%Load the images and create texture pointers. 
for MakeImages =1: length(dir) %for 1 to length of our dir
    if A(1,MakeImages)==1 %If A(1,i) does contain the search term, import the image
        [img,~,alpha] = imread(dir(MakeImages,1).name); %Read the image into matlab, read in alpha
        img(:,:,4) = alpha; %Add Alpha channel to the RGB image. 
        %[img] = imresize(img,[size,size]); %Resizes image if needed
        Env.Stimuli(MakeImages).Name = dir(MakeImages,1).name; %Log the image's name in global environment 
        Env.Stimuli(MakeImages).TexturePointer= Screen('MakeTexture', Env.MainWindow,img,[],4); %Create the texture and save pointer to the global environment 
        Env.Stimuli(MakeImages).ImageMade = img; %log the image data into the global environment. 
    end
end


end
