% Created by Tess Barich 2022

function [FixCross] = BuildMeACross(window, window2,widthX,widthY,colour)
global Env Pointer
switch true
    case exist('Pointer','var')==1
        Pointer =Pointer+1;
    case  exist('Pointer','var')==0
        Pointer =1;
end
Screen('FillRect',window2,colour,[Env.ScreenInfo.Centre(1)-(widthX/2),Env.ScreenInfo.Centre(2)-(widthY/2),Env.ScreenInfo.Centre(1)+(widthX/2),Env.ScreenInfo.Centre(2)+(widthY/2)])
Screen('FillRect',window2,colour,[Env.ScreenInfo.Centre(1)-(widthY/2),Env.ScreenInfo.Centre(2)-(widthX/2),Env.ScreenInfo.Centre(1)+(widthY/2),Env.ScreenInfo.Centre(2)+(widthX/2)])
img=Screen('GetImage',window2,[Env.ScreenInfo.Centre(1)-ceil(widthX/1.5),Env.ScreenInfo.Centre(2)-ceil(widthX/1.5),Env.ScreenInfo.Centre(1)+ceil(widthX/1.5),Env.ScreenInfo.Centre(2)+ceil(widthX/1.5)],[],[],4);
Env.Stimuli(Pointer).Name = 'EXP3_FixCross.png';
Env.Stimuli(Pointer).TexturePointer= Screen('MakeTexture', window,img,[],4); %Create the texture and save pointer to the global environment
Env.Stimuli(Pointer).ImageMade = img; %log the image data into the global environment.
Env.Stimuli(Pointer).Size = [width(Env.Stimuli(Pointer).ImageMade),height(Env.Stimuli(Pointer).ImageMade)];
Env.Stimuli(Pointer).OriginalSize =[width(Env.Stimuli(Pointer).ImageMade),height(Env.Stimuli(Pointer).ImageMade)];
FixCross =Env.Stimuli(Pointer).TexturePointer;
end