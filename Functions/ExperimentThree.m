%% Created by Tess Barich (2022) Flinders Uni.
% DRM Experiment with Eyetracking and EEG.
function ExperimentThree(ConditionSequence)
global DATA Env Calib  
%% The Adjustables - The Sea of Three
fileDirectory = Env.Loc_Stimuli;
searchString = '.xlsx';
widthX =30;
widthY =4;
LineLength =600; %pixels
LineDivide =LineLength/100;
ResponseBoxandTextColour = Env.Colours.White;
QuestionQuote1 = 'Is this word an old word, or a new word?';
QuestionQuote2 = 'How confident are you that you have or have not seen this word before?';
LowAnchor ='Complete Guess';
HighAnchor ='Definitely Old/New';
[Env.ExperimentThree.Raw.EncodingLists,Env.ExperimentThree.EncodingWords,Env.ExperimentThree.Raw.RecognitionLists,...
    Env.ExperimentThree.RecognitionWords,Env.ExperimentThree.Raw.LureLists,Env.ExperimentThree.SmoothLureLists]=ImportandSortMyLists(fileDirectory,searchString);
CorrectAnswerIdx =contains(Env.ExperimentThree.RecognitionWords,Env.ExperimentThree.EncodingWords,'IgnoreCase',true);

[Env.FixCrossTexture] = BuildMeACross(Env.MainWindow,Env.OffScreenWindow,widthX,widthY,Env.Colours.Black);
[TextXPos,TextYPos] =DrawFormattedText(Env.OffScreenWindow,sprintf('%s',QuestionQuote1),'center',Env.ScreenInfo.Centre(2)+150);
[ResponseBoxCoords,Env.ExperimentThree.ResponseOne,Env.ExperimentThree.ResponseTwo]= BuildMyResponseBoxes(Env.MainWindow,Env.OffScreenWindow,2,["Old";"New"],ResponseBoxandTextColour,3,[Env.ScreenInfo.Centre(1)-60;Env.ScreenInfo.Centre(1)+60],[TextYPos+60;TextYPos+60],100,100,12,16);
nEncodingWords = height(Env.ExperimentThree.EncodingWords);
nRecognitionWords =height(Env.ExperimentThree.RecognitionWords);
EncodingInstructions = 'You are about to be shown a list of words.\nPlease remember them as well as you can';
RecognitionInstructions = ['You are about to be shown another list of words. '...
    'Please indicate whether you have seen this word before in the previous list by selecting old word' ...
    ', or if you have not seen this word in the previous list select new word. '...
    'For each selection, please give a confidence rating on the scale, ranging from 50% (complete guess) to 100% (definitely old/new).'];
BreakQuote ='Have a Break, have a kitkat';
WordPresentationTime =1.7;
nWordPresentationFrames =WordPresentationTime/DATA.FlipInterval;
BackInterval = 0.3;
nBackIntervalFrames =BackInterval/DATA.FlipInterval;
nPhases =width([{'Encoding'},{'Recognition'}]);
nBlocks=3;
%Instructions
DrawFormattedText(Env.MainWindow,sprintf('%s',EncodingInstructions),'center','center');
FlipTime=  Screen('Flip',Env.MainWindow,[]);
Screen('TextSize', Env.MainWindow, 50); %  need to reset pen size after.

DATA.FlipTime =FlipTime;
KbWait([],2);
%trigger here
phases=2;
%for phases = 1:nPhases
switch phases
    case 1
        for blocks =1:nBlocks
            FrameIndex = 1;


            for EncodingPhase = 1:nEncodingWords
                DATA.ExperimentThree(phases).Phase(blocks).Blocks(EncodingPhase).JitterAlphabet=randi([750,1250],1);
                JitterinSecs= DATA.ExperimentThree(phases).Phase(blocks).Blocks(EncodingPhase).JitterAlphabet/1000;
                nFixFrames = ceil(JitterinSecs/DATA.FlipInterval);
                for fixpresentation = 1:nFixFrames
                    Screen('DrawTextures',Env.MainWindow,12);
                    Screen('DrawingFinished',Env.MainWindow);
                    ScreenFlipTime = FlipTime+(DATA.WaitFrameInput-0.5)*DATA.FlipInterval;
                    FlipTime=  Screen('Flip',Env.MainWindow,ScreenFlipTime);
                    FrameIndex = FrameIndex+1;

                end
                for WordPresentation =1:nWordPresentationFrames
                    DrawFormattedText(Env.MainWindow,sprintf('%s',Env.ExperimentThree.EncodingWords{EncodingPhase,blocks}),'center','center');
                    Screen('DrawingFinished',Env.MainWindow);
                    ScreenFlipTime = FlipTime+(DATA.WaitFrameInput-0.5)*DATA.FlipInterval;
                    FlipTime=  Screen('Flip',Env.MainWindow,ScreenFlipTime);
                    FrameIndex = FrameIndex+1;

                end
                for backInterval =1:nBackIntervalFrames
                    FlipTime=  Screen('Flip',Env.MainWindow,ScreenFlipTime);
                    FrameIndex = FrameIndex+1;

                end
            end
            Screen('TextSize', Env.MainWindow, 12); %  need to reset pen size after.
            DrawFormattedText(Env.MainWindow,sprintf('%s',BreakQuote),'center','center');
            Screen('DrawingFinished',Env.MainWindow);
            ScreenFlipTime = FlipTime+(DATA.WaitFrameInput-0.5)*DATA.FlipInterval;

            FlipTime=  Screen('Flip',Env.MainWindow,ScreenFlipTime);
            KbWait([],2);

        end

    case 2
        Screen('TextSize', Env.MainWindow, 25); %  need to reset pen size after.


        DrawFormattedText(Env.MainWindow,sprintf('%s',RecognitionInstructions),'center','center',[],70);
        Screen('DrawingFinished',Env.MainWindow);
        ScreenFlipTime = FlipTime+(DATA.WaitFrameInput-0.5)*DATA.FlipInterval;
        FlipTime=  Screen('Flip',Env.MainWindow,ScreenFlipTime);
        %FrameIndex = FrameIndex+1;

        KbWait([],2);

        for blocks =1:nBlocks
            FrameIndex =1;
            for RecognitionPhase = 1:nRecognitionWords

                DATA.ExperimentThree(phases).Phase(blocks).Blocks(RecognitionPhase).JitterAlphabet=randi([750,1250],1);
                JitterinSecs= DATA.ExperimentThree(phases).Phase(blocks).Blocks(RecognitionPhase).JitterAlphabet/1000;
                switch CorrectAnswerIdx(RecognitionPhase,blocks)
                    case 0
                        DATA.ExperimentThree(phases).Phase(blocks).Blocks(RecognitionPhase).CorrectAnswerStr = "New";
                        DATA.ExperimentThree(phases).Phase(blocks).Blocks(RecognitionPhase).CorrectAnswer = 2;

                    case 1
                        DATA.ExperimentThree(phases).Phase(blocks).Blocks(RecognitionPhase).CorrectAnswerStr = "Old";
                        DATA.ExperimentThree(phases).Phase(blocks).Blocks(RecognitionPhase).CorrectAnswer = 1;
                end
                nFixFrames = ceil(JitterinSecs/DATA.FlipInterval);
                for fixpresentation = 1:nFixFrames
                    Screen('DrawTextures',Env.MainWindow,12);
                    Screen('DrawingFinished',Env.MainWindow);
                    ScreenFlipTime = FlipTime+(DATA.WaitFrameInput-0.5)*DATA.FlipInterval;
                    FlipTime=  Screen('Flip',Env.MainWindow,ScreenFlipTime);
                    FrameIndex = FrameIndex+1;
                end
                LodgeAResponse =0;
                Response = 1;
                ResponseHighlighter1 = Env.Colours.Black;
                ResponseHighlighter2 = Env.Colours.Black;
                KbQueueCreate(Env.MouseInfo{1,1}.index,[],2);
                KbQueueStart(Env.MouseInfo{1,1}.index);
                CurrentSample =[];
                start =GetSecs;
                while LodgeAResponse<2
                    [keyIsDown]= KbQueueCheck(Env.MouseInfo{1,1}.index);
                    [x,y] = GetMouse(Env.MainWindow);
                    Screen('TextSize', Env.MainWindow, 20); %  need to reset pen size after.

                    switch Response
                        case 1
                            DrawFormattedText(Env.MainWindow,sprintf('%s',QuestionQuote1),'center',Env.ScreenInfo.Centre(2)+100);

                        case 2
                            DrawFormattedText(Env.MainWindow,sprintf('%s',QuestionQuote2),'center',Env.ScreenInfo.Centre(2)+100);
                    end

                    switch true
                        case (ismembertol(x,ResponseBoxCoords(1,1):ResponseBoxCoords(1,3))&& ismembertol(y,ResponseBoxCoords(1,2):ResponseBoxCoords(1,4)))
                            ResponseHighlighter1 = Env.Colours.Red;

                        case (ismembertol(x,ResponseBoxCoords(2,1):ResponseBoxCoords(2,3))&& ismembertol(y,ResponseBoxCoords(2,2):ResponseBoxCoords(2,4)))
                            ResponseHighlighter2 = Env.Colours.Red;

                    end

                    switch true
                        case Response ==2
                            Screen('FillRect',Env.MainWindow,Env.Colours.White,[Env.ScreenInfo.Centre(1)-(LineLength/2),Env.ScreenInfo.Centre(2)+120,Env.ScreenInfo.Centre(1)+(LineLength/2),Env.ScreenInfo.Centre(2)+125]);
                            TotalLengthLine = LineLength;
                            LineDetails = [(Env.ScreenInfo.Centre(1)-(LineLength/2)),Env.ScreenInfo.Centre(2)+120,(Env.ScreenInfo.Centre(1)+(LineLength/2)),Env.ScreenInfo.Centre(2)+125];
                            DrawFormattedText(Env.MainWindow,sprintf('%s',LowAnchor),LineDetails(1)-200,Env.ScreenInfo.Centre(2)+125);
                            DrawFormattedText(Env.MainWindow,sprintf('%s',HighAnchor),LineDetails(3)+50,Env.ScreenInfo.Centre(2)+125);
                            if ismembertol(x,LineDetails(1)-10:LineDetails(3))&& ismembertol(y,LineDetails(2)-20:LineDetails(4)+20)
                                Difference = (LineDetails(3) -x)/2;
                                NumberToDisplay = ceil((TotalLengthLine-Difference)/LineDivide);
                                DrawFormattedText(Env.MainWindow,sprintf('%i',NumberToDisplay),'center',Env.ScreenInfo.Centre(2)+150);

                            end
                        otherwise
                            Screen('DrawTextures',Env.MainWindow,[Env.ExperimentThree.ResponseOne(Response);Env.ExperimentThree.ResponseTwo(Response)],[],[ResponseBoxCoords]',[],[],[],[ResponseHighlighter1;ResponseHighlighter2]');
                    end

                    Screen('TextSize', Env.MainWindow, 50); %  need to reset pen size after.

                    DrawFormattedText(Env.MainWindow,sprintf('%s',Env.ExperimentThree.RecognitionWords{RecognitionPhase,blocks}),'center','center');


                    Screen('DrawingFinished',Env.MainWindow);

                    switch true

                        case (Response ==1 && any(keyIsDown==1) && ismembertol(x,ResponseBoxCoords(1,1):ResponseBoxCoords(1,3))&& ismembertol(y,ResponseBoxCoords(1,2):ResponseBoxCoords(1,4)) &&LodgeAResponse==0);
                            DATA.ExperimentThree(blocks).EyeData(FrameIndex).Trigger = 114; % Response Given 14 - 1 represents experiment number and 4 represents Response of A in each block
                            DATA.ExperimentThree(phases).Phase(blocks).Blocks(RecognitionPhase).ResponseWordStr="Old";
                             switch DATA.ExperimentThree(phases).Phase(blocks).Blocks(RecognitionPhase).CorrectAnswer
                                case 1

                                    DATA.ExperimentThree(phases).Phase(blocks).Blocks(RecognitionPhase).ResponseAnswer=1;
                                case 2
                                    DATA.ExperimentThree(phases).Phase(blocks).Blocks(RecognitionPhase).ResponseAnswer=0;
                            end
                            DATA.ExperimentThree(phases).Phase(blocks).Blocks(RecognitionPhase).OldNewRT=GetSecs-start;
                            OldNewResponseSystemTime=GetSecs;
                            LodgeAResponse =1;
                            Response =2;

                        case (Response ==1 && any(keyIsDown==1) && ismembertol(x,ResponseBoxCoords(2,1):ResponseBoxCoords(2,3))&& ismembertol(y,ResponseBoxCoords(2,2):ResponseBoxCoords(2,4)) &&  LodgeAResponse==0);
                            DATA.ExperimentThree(blocks).EyeData(FrameIndex).Trigger = 115; % Response Given 15 - 1 represents experiment number and 5 represents Response of B for each trial in each block
                            DATA.ExperimentThree(phases).Phase(blocks).Blocks(RecognitionPhase).ResponseWordStr="New";
                            switch DATA.ExperimentThree(phases).Phase(blocks).Blocks(RecognitionPhase).CorrectAnswer
                                case 1

                                    DATA.ExperimentThree(phases).Phase(blocks).Blocks(RecognitionPhase).ResponseAnswer=0;
                                case 2
                                    DATA.ExperimentThree(phases).Phase(blocks).Blocks(RecognitionPhase).ResponseAnswer=1;
                            end
                            DATA.ExperimentThree(phases).Phase(blocks).Blocks(RecognitionPhase).OldNewRT=GetSecs-start;
                            OldNewResponseSystemTime=GetSecs;
                            Response =2;
                            LodgeAResponse =1;

                        case (Response ==2 && any(keyIsDown==1) && ismembertol(x,LineDetails(1)-10:LineDetails(3))&& ismembertol(y,LineDetails(2)-20:LineDetails(4)+20)&& LodgeAResponse==1)
                            DATA.ExperimentThree(phases).Phase(blocks).Blocks(RecognitionPhase).Confidence = NumberToDisplay;
                            DATA.ExperimentThree(phases).Phase(blocks).Blocks(RecognitionPhase).ConfidenceRT = GetSecs-OldNewResponseSystemTime;
                            DATA.ExperimentThree(blocks).EyeData(FrameIndex).Trigger = 116; % Response Given 16 - 1 represents experiment number and 6 represents confidence Response for each trial in each block
                            LodgeAResponse =2;

                    end
                    ResponseHighlighter1 = Env.Colours.Black;
                    ResponseHighlighter2 = Env.Colours.Black;

                    switch DATA.useET
                        case 0
                            DATA.ExperimentThree(blocks).EyeData(FrameIndex).SystemTime = GetSecs;
                            DATA.ExperimentThree(blocks).EyeData(FrameIndex).OnsetTime =   DATA.ExperimentThree(blocks).EyeData(FrameIndex).SystemTime  -start;

                        case 1
                            switch true
                                case isempty(CurrentSample)==1

                                    DATA.ExperimentThree(blocks).EyeData(FrameIndex).TobiiLeftEyePos = FirstPassET(1,end).LeftEye.GazePoint.OnDisplayArea;
                                    DATA.ExperimentThree(blocks).EyeData(FrameIndex).TobiiRightEyePos = FirstPassET(1,end).RightEye.GazePoint.OnDisplayArea;
                                    DATA.ExperimentThree(blocks).EyeData(FrameIndex).TobiiLeftEyePupil = FirstPassET(1,end).LeftEye.Pupil.Diameter;
                                    DATA.ExperimentThree(blocks).EyeData(FrameIndex).TobiiRightEyePupil = FirstPassET(1,end).LeftEye.Pupil.Diameter;
                                    DATA.ExperimentThree(blocks).EyeData(FrameIndex).TobiiTime = FirstPassET(1,end).SystemTimeStamp;

                                case isempty(CurrentSample)==0
                                    DATA.ExperimentThree(blocks).EyeData(FrameIndex).TobiiLeftEyePos= CurrentSample(1,end).LeftEye.GazePoint.OnDisplayArea;
                                    DATA.ExperimentThree(blocks).EyeData(FrameIndex).TobiiRightEyePos  = CurrentSample(1,end).RightEye.GazePoint.OnDisplayArea;
                                    DATA.ExperimentThree(blocks).EyeData(FrameIndex).TobiiLeftEyePupil = CurrentSample(1,end).LeftEye.Pupil.Diameter;
                                    DATA.ExperimentThree(blocks).EyeData(FrameIndex).TobiiRightEyePupil = CurrentSample(1,end).LeftEye.Pupil.Diameter;
                                    DATA.ExperimentThree(blocks).EyeData(FrameIndex).TobiiTime = CurrentSample(1,end).SystemTimeStamp;
                            end
                            CurrentSample = my_eyetracker.get_gaze_data();

                    end

                    ScreenFlipTime = FlipTime+(DATA.WaitFrameInput-0.5)*DATA.FlipInterval;
                    FlipTime=  Screen('Flip',Env.MainWindow,ScreenFlipTime);
                    %BIOSEMI HERE
                    DATA.ExperimentThree(blocks).EyeData(FrameIndex).FrameIndex =FrameIndex;
                    DATA.ExperimentThree(blocks).EyeData(FrameIndex).FlipTimeStamp=FlipTime;
                    FrameIndex=FrameIndex+1;

                end

                for backInterval =1:nBackIntervalFrames
                    FlipTime=  Screen('Flip',Env.MainWindow,ScreenFlipTime);
                    FrameIndex=FrameIndex+1;

                end
            end
            Screen('TextSize', Env.MainWindow, 16); %  need to reset pen size after.
            DrawFormattedText(Env.MainWindow,sprintf('%s',BreakQuote),'center','center');
            Screen('DrawingFinished',Env.MainWindow);
            ScreenFlipTime = FlipTime+(DATA.WaitFrameInput-0.5)*DATA.FlipInterval;

            FlipTime=  Screen('Flip',Env.MainWindow,ScreenFlipTime);
            KbWait([],2);

        end

end
end
%end