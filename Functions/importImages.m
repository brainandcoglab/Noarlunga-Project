%Created By Tess Barich 2021 Flinders University
function importImages(directory,str,window)
AssertOpenGL;

global Env %Load globals 
%% Search the pathway for the wanted stimuli
directMe = dir(directory); %pull directory contents
directMe = directMe(find(~cellfun(@isdir,{directMe(:).name})));%Filter out all the folders. <- Like our sample folder file
A = contains([{directMe(:).name}],str); %Search for the common term used in exp stimuli sets.
%%Load the images and create texture pointers. 
Pointer =0;
for MakeImages =1: length(directMe) %for 1 to length of our dir
    if A(1,MakeImages)==1 %If A(1,i) does contain the search term, import the image
        [img,~,alpha] = imread(directMe(MakeImages,1).name); %Read the image into matlab, read in alpha
        img(:,:,4) = alpha; %Add Alpha channel to the RGB image. 
        %[img] = imresize(img,[size,size]); %Resizes image if needed
        Pointer=Pointer+1;
        Env.Stimuli(Pointer).Name = directMe(MakeImages,1).name; %Log the image's name in global environment 
        Env.Stimuli(Pointer).TexturePointer= Screen('MakeTexture', window,img,[],4); %Create the texture and save pointer to the global environment 
        Env.Stimuli(Pointer).ImageMade = img; %log the image data into the global environment. 
        Env.Stimuli(Pointer).Size = [width(Env.Stimuli(Pointer).ImageMade),height(Env.Stimuli(Pointer).ImageMade)];
        Env.Stimuli(Pointer).OriginalSize =[width(Env.Stimuli(Pointer).ImageMade),height(Env.Stimuli(Pointer).ImageMade)];
    end
end


end
