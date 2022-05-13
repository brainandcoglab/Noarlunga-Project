%Written By Tess Barich 2022
function [AttentionCheckStim] = DrawASmile(colour,window,window2)
global Env 
EyeCoords = [890,905;460,460];
SmileCoords =[860,400,940,500];

Screen('DrawDots',window2,EyeCoords,8.5,colour,[],1);
    Screen('FrameArc',window2,colour,[SmileCoords],110,140,3);

  img2save =Screen('GetImage',window2,[SmileCoords],[],[],4);
 img2save= imresize(img2save,[50,50]);
   Env.Img = img2save;

AttentionCheckStim=Screen('MakeTexture',window,img2save,[]);
Screen('Close',window2) ;%cannot flip the offscreen window, instead need to close the window and reopen it.
[window2]= Screen('OpenOffscreenWindow',window,Env.Colours.Alpha);
Env.OffScreenWindow =window2;%open new offscreen window for second drawing
Screen('BlendFunction', window2, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');% Set up alpha-blending for smooth (anti-aliased) lines specifically to repeat this process of drawing to the offscreen window

