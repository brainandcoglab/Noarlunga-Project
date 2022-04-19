%Created by Tess Barich 2022 - Flinders University
function [ResponseBoxCoords,ResponseOne,ResponseTwo]= BuildMyResponseBoxes(window,window2,NumResponses,ResponseOptions,ResponseTextColour,FrameWidth,Xpos,Ypos,sizeX,sizeY,textwrap,textsize,fillcolour)
global Env  
Screen('TextSize',window2,textsize);
for Building = 1:NumResponses
    ResponseBoxCoords(Building,:)= (my_centreTexture(sizeX,sizeY,Xpos(Building),Ypos(Building)));
    switch true
        case exist('fillcolour','var')==1
            Screen('FillRect',window2,fillcolour(:,Building),[ResponseBoxCoords(Building,:)]');
    end
    DrawFormattedText(window2,sprintf('%s',ResponseOptions(Building,:)),'center','center',ResponseTextColour,textwrap,[],[],[],[],[ResponseBoxCoords(Building,:)]);
end
ResponseBoxCoords=ResponseBoxCoords';

Screen('FrameRect',window2,ResponseTextColour,ResponseBoxCoords,FrameWidth);

ResponseBoxCoords=ResponseBoxCoords';

switch true 
    case height(ResponseBoxCoords)==2
ResponseBoxOne=Screen('GetImage',window2,[ResponseBoxCoords(1,:)],[],[],4);
ResponseOne=Screen('MakeTexture',window,ResponseBoxOne,[]);
ResponseBoxTwo =Screen('GetImage',window2,[ResponseBoxCoords(2,:)],[],[],4);
ResponseTwo=Screen('MakeTexture',window,ResponseBoxTwo,[]);

    case height(ResponseBoxCoords)>2
        for saving =1:height(ResponseBoxCoords)
        ResponseBoxOne=Screen('GetImage',window2,[ResponseBoxCoords(saving,:)],[],[],4);
ResponseOne(saving)=Screen('MakeTexture',window,ResponseBoxOne,[]);
        end
        ResponseBoxCoords=ResponseBoxCoords';

        ResponseTwo =[];
end


Screen('Close',window2) ;%cannot flip the offscreen window, instead need to close the window and reopen it.
[window2]= Screen('OpenOffscreenWindow',window,Env.Colours.Alpha);
Env.OffScreenWindow =window2;%open new offscreen window for second drawing
Screen('BlendFunction', window2, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');% Set up alpha-blending for smooth (anti-aliased) lines specifically to repeat this process of drawing to the offscreen window


end