%Created by Tess Barich 2021
function [CreatedJarOne,CreatedJarTwo] =CreateJar(directory,window,window2,MainColourStr,SecondaryColourStr,MainNumber,SecondaryNumber,experimentStr)

global Env Jar Bead JarSize BeadSize BeadXplacement BeadYplacement BeadXY SortXYBead BeadOrder

importImages(directory,experimentStr,window)


Jar =contains([{Env.Stimuli.Name}],'Jar');
[~,Jar]= max([Jar(:)]);
Bead = contains([{Env.Stimuli.Name}],'Bead');
[~,Bead]=max([Bead(:)]);
JarSize =Env.Stimuli(Jar).Size;
BeadSize = Env.Stimuli(Bead).Size;
JarTexture = Env.Stimuli(Jar).TexturePointer;
BeadTexture = repmat({Env.Stimuli(Bead).TexturePointer},(MainNumber+SecondaryNumber),1);
centredJarRect = cell({my_centreTexture(JarSize(1),JarSize(2),Env.ScreenInfo.Centre(1),Env.ScreenInfo.Centre(2))});
SizeOfJar = [Env.ScreenInfo.Centre(1)-(Env.Stimuli(Jar).Size(1)/2),...
    Env.ScreenInfo.Centre(2)-(Env.Stimuli(Jar).Size(2)/2),...
    Env.ScreenInfo.Centre(1)+(Env.Stimuli(Jar).Size(1)/2),...
    Env.ScreenInfo.Centre(2)+(Env.Stimuli(Jar).Size(2)/2)];
SpaceInsideJar = [Env.ScreenInfo.Centre(1)-(Env.Stimuli(Jar).Size(1)/2)+43,...
    Env.ScreenInfo.Centre(2)-(Env.Stimuli(Jar).Size(2)/2)+30,...
    Env.ScreenInfo.Centre(1)+(Env.Stimuli(Jar).Size(1)/2)-43,...
    Env.ScreenInfo.Centre(2)+(Env.Stimuli(Jar).Size(2)/2)-30];


   centredJarRect = cell2mat(centredJarRect);


for MakeMyPair = 1:2
    BeadXplacement =0;
while length(BeadXplacement)~=(MainNumber+SecondaryNumber)
    BeadXplacement = SpaceInsideJar(1):SpaceInsideJar(3);
    BeadYplacement = SpaceInsideJar(2):SpaceInsideJar(4);
    BeadXIdx = randperm(length(BeadXplacement),(MainNumber+SecondaryNumber));
    BeadYIdx = randperm(length(BeadYplacement),(MainNumber+SecondaryNumber));
    BeadXplacement = BeadXplacement(:,BeadXIdx);
    BeadYplacement = BeadYplacement(:,BeadYIdx);
    [BeadXY,BeadOrder] = unique([BeadXplacement;BeadYplacement]','rows','first');
    SortXYBead= sortrows([BeadXY,BeadOrder],3)';
    BeadXplacement = SortXYBead(1,:);
    BeadYplacement =SortXYBead(2,:);

end

BeadOrder = Shuffle(BeadOrder);
SortXYBead = sortrows([BeadXY,BeadOrder],3)';
BeadXplacement = SortXYBead(1,:);
BeadYplacement =SortXYBead(2,:);
ColourPlacement=randperm((MainNumber+SecondaryNumber),SecondaryNumber);
Idx2 = ismember(SortXYBead(3,:),[ColourPlacement]);
for BeadMaking = 1:(MainNumber+SecondaryNumber)
    centredBeadRect(BeadMaking,1)=cell({my_centreTexture(BeadSize(1),BeadSize(2),BeadXplacement(BeadMaking),BeadYplacement(BeadMaking))});
end
    switch MakeMyPair
        case 1
ColourStr = repmat({MainColourStr},length(Idx2),1);
ColourStr(Idx2)={[SecondaryColourStr]};

        case 2
ColourStr = repmat({SecondaryColourStr},length(Idx2),1);         
ColourStr(Idx2)={[MainColourStr]};
             end

   DispStim=[BeadTexture,centredBeadRect,[ColourStr]];

if size(DispStim)>1

      objecttype = cell2mat(DispStim(:, 1));
            coordinates = cell2mat(DispStim(:, 2));
            coordinates= transpose(coordinates);
            colourmask = cell2mat(DispStim(:, 3));
            colourmask= transpose(colourmask);
         
            
end
Screen('DrawTextures',window2,objecttype,[],coordinates,[],[],[],colourmask);
Screen('DrawTextures',window2,JarTexture,[],[centredJarRect]);




if MakeMyPair ==1
    test=Screen('GetImage',window2,[960,540,1060,640],[],[],4);
OffScreenTextureOneOne = Screen('GetImage',window2,[SizeOfJar],[],[],4);
OffScreenTextureOne= Screen('MakeTexture',window,OffScreenTextureOneOne,[]);
CreatedJarOne = OffScreenTextureOne;
Env.JarOne = CreatedJarOne;

elseif MakeMyPair==2
    OffScreenTextureOneTwo = Screen('GetImage',window2,[SizeOfJar],[],[],4);
OffScreenTextureTwo= Screen('MakeTexture',window,OffScreenTextureOneTwo,[]);
CreatedJarTwo = OffScreenTextureTwo;
Env.JarTwo = CreatedJarTwo;
end 
Screen('Flip',window);
Screen('Close',window2) %cannot flip the offscreen window, instead need to close the window and reopen it. 
[window2]= Screen('OpenOffscreenWindow',window,Env.Colours.Alpha); %open new offscreen window for second drawing
Screen('BlendFunction', window2, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');% Set up alpha-blending for smooth (anti-aliased) lines specifically to repeat this process of drawing to the offscreen window

end 

end
