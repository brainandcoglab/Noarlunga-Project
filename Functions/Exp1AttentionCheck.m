%Written by Tess Barich 2022 
function [AttentionScore]=Exp1AttentionCheck(Directory,window,window2,PracticeColourA,PracticeColourB,MainColourNumber,SecondaryColour,experimentStr,Question1,Question2,ResponseOpts1,ResponseOpts2,PracticeIntructs,ResponseBoxColour)
global Env 

    [Env.PracticeJarTexture1, Env.PracticeJarTexture2] =CreateJar(Directory,window, window2,PracticeColourA,PracticeColourB ,MainColourNumber,SecondaryColour,experimentStr);
 Xposi(1:height(ResponseOpts2),1)=Env.ScreenInfo.Centre(1);
for NumofQs =1:2
[TextXPos,TextYPos] =DrawFormattedText(Env.OffScreenWindow,sprintf('%s',Question1),'center',Env.ScreenInfo.Centre(2)-100);
addY=100;
   for NumofResponses =1: height(ResponseOpts2)
Yposi(NumofResponses)= TextYPos+addY;
addY=addY+100;
   end 
[ResponseBoxCoords,Env.ExperimentOneAttention.ResponseOne]= BuildMyResponseBoxes(Env.MainWindow,Env.OffScreenWindow,2,[ResponseOpts1],ResponseBoxColour,3,[Xposi],[Yposi],400,100,NumofQs,16);
[ResponseBoxCoords,Env.ExperimentOneAttention.ResponseTwo]= BuildMyResponseBoxes(Env.MainWindow,Env.OffScreenWindow,5,[ResponseOpts2],ResponseBoxColour,3,[Xposi],[Yposi],400,100,NumofQs,16);

end 

AttentionScore =1;
end 