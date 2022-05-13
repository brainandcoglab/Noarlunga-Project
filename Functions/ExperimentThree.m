%% Created by Tess Barich (2022) Flinders Uni.
% DRM Experiment with Eyetracking and EEG.
function ExperimentThree(ConditionSequence)
global DATA Env Calib
global MyEyeTracker sp TimeStamps OverallGazeData TobiiOperations

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
Experiment3EndTxt ="Experiment Complete, thank-you. Press ENTER to continue";
Screen('TextColor',Env.MainWindow,Env.Colours.Black);

[Env.ExperimentThree.Raw.EncodingLists,Env.ExperimentThree.EncodingWords,Env.ExperimentThree.Raw.RecognitionLists,...
    Env.ExperimentThree.RecognitionWords,Env.ExperimentThree.Raw.LureLists,Env.ExperimentThree.SmoothLureLists]=ImportandSortMyLists(fileDirectory,searchString);
CorrectAnswerIdx =contains(Env.ExperimentThree.RecognitionWords,Env.ExperimentThree.EncodingWords,'IgnoreCase',true);

[Env.FixCrossTexture] = BuildMeACross(Env.MainWindow,Env.OffScreenWindow,widthX,widthY,Env.Colours.Black);
[TextXPos,TextYPos] =DrawFormattedText(Env.OffScreenWindow,sprintf('%s',QuestionQuote1),'center',Env.ScreenInfo.Centre(2)+150);
[ResponseBoxCoords4,Env.ExperimentThree.ResponseOne,Env.ExperimentThree.ResponseTwo]= BuildMyResponseBoxes(Env.MainWindow,Env.OffScreenWindow,2,["Old";"New"],ResponseBoxandTextColour,3,[Env.ScreenInfo.Centre(1)-60;Env.ScreenInfo.Centre(1)+60],[TextYPos+60;TextYPos+60],100,100,12,16);
nEncodingWords = height(Env.ExperimentThree.EncodingWords);
nRecognitionWords =height(Env.ExperimentThree.RecognitionWords);
EncodingInstructions = 'You are about to be shown a list of words.\nPlease remember them as well as you can';
RecognitionInstructions = ['You are about to be shown another list of words. '...
    'Please indicate whether you have seen this word before in the previous list by selecting old word' ...
    ', or if you have not seen this word in the previous list select new word. '...
    'For each selection, please give a confidence rating on the scale, ranging from 50% (complete guess) to 100% (definitely old/new).'];
BreakQuote ='Please take a short break, when you are ready to continue, press ENTER';
WordPresentationTime =1.7;
nWordPresentationFrames =WordPresentationTime/DATA.FlipInterval;
BackInterval = 0.3;
nBackIntervalFrames =BackInterval/DATA.FlipInterval;
nPhases =width([{'Encoding'},{'Recognition'}]);
nBlocks=3;
%Instructions
Screen('TextSize', Env.MainWindow, 30); %  need to reset pen size after.

TriggerToSend = Env.Triggers.Exp3.Start;
DrawFormattedText(Env.MainWindow,sprintf('%s',EncodingInstructions),'center','center');
FlipTime=  Screen('Flip',Env.MainWindow,[]);
switch DATA.useEEG
    case 1
        sp.sendTrigger(TriggerToSend); % trigger
end
switch DATA.useET
    case 1
        TimeStamps(end+1,1) =TobiiOperations.get_system_time_stamp;
        TimeStamps(end,2)= TriggerToSend;
end
Screen('TextSize', Env.MainWindow, 75); %  need to reset pen size after.

DATA.FlipTime =FlipTime;

KbWait([],2);
% phases=2;
TriggerToSend = Env.Triggers.Exp3.StartEncoding;

FlipTime=  Screen('Flip',Env.MainWindow,[]);
switch DATA.useEEG
    case 1
        sp.sendTrigger(TriggerToSend); % trigger
end
switch DATA.useET
    case 1
        TimeStamps(end+1,1) =TobiiOperations.get_system_time_stamp;
        TimeStamps(end,2)= TriggerToSend;
end

for phases = 1:nPhases
    switch phases
        case 1
            for blocks =1:nBlocks
                FrameIndex = 1;
                TriggerToSend = Env.Triggers.Exp3.StartBlock;

                FlipTime=  Screen('Flip',Env.MainWindow,[]);
                switch DATA.useEEG
                    case 1
                        sp.sendTrigger(TriggerToSend); % trigger
                end
                switch DATA.useET
                    case 1
                        TimeStamps(end+1,1) =TobiiOperations.get_system_time_stamp;
                        TimeStamps(end,2)= TriggerToSend;
                end

                for EncodingPhase = 1:nEncodingWords
                    DATA.ExperimentThree(phases).Phase(blocks).Blocks(EncodingPhase).JitterAlphabet=randi([750,1250],1);
                    JitterinSecs= DATA.ExperimentThree(phases).Phase(blocks).Blocks(EncodingPhase).JitterAlphabet/1000;
                    nFixFrames = ceil(JitterinSecs/DATA.FlipInterval);

                    for fixpresentation = 1:nFixFrames
                        switch fixpresentation
                            case 1
                                TriggerToSend = Env.Triggers.Exp3.JitterStart;

                            case nFixFrames
                                TriggerToSend = Env.Triggers.Exp3.JitterEnd;
                            otherwise
                                TriggerToSend=0;
                        end


                        Screen('DrawTextures',Env.MainWindow,Env.FixCrossTexture);
                        Screen('DrawingFinished',Env.MainWindow);
                        ScreenFlipTime = FlipTime+(DATA.WaitFrameInput-0.5)*DATA.FlipInterval;
                        FlipTime=  Screen('Flip',Env.MainWindow,ScreenFlipTime);
                        switch DATA.useEEG
                            case 1
                                switch fixpresentation
                                    case 1
                                        sp.sendTrigger(TriggerToSend); % trigger

                                    case nFixFrames
                                        sp.sendTrigger(TriggerToSend); % trigger
                                end
                        end

                        switch DATA.useET
                            case 1
                                switch fixpresentation
                                    case 1
                                        TimeStamps(end+1,1) =TobiiOperations.get_system_time_stamp;
                                        TimeStamps(end,2)= TriggerToSend;
                                    case nFixFrames
                                        TimeStamps(end+1,1) =TobiiOperations.get_system_time_stamp;
                                        TimeStamps(end,2)= TriggerToSend;
                                end
                        end

                        FrameIndex = FrameIndex+1;

                    end
                    Screen('TextSize', Env.MainWindow, 75); %  need to reset pen size after.

                    for WordPresentation =1:nWordPresentationFrames
                        switch WordPresentation
                            case 1
                                TriggerToSend = Env.Triggers.Exp3.WordShownStart;

                            case nWordPresentationFrames
                                TriggerToSend = Env.Triggers.Exp3.WordShownEnd;
                            otherwise
                                TriggerToSend=0;
                        end

                        DrawFormattedText(Env.MainWindow,sprintf('%s',Env.ExperimentThree.EncodingWords{EncodingPhase,blocks}),'center','center');
                        Screen('DrawingFinished',Env.MainWindow);
                        ScreenFlipTime = FlipTime+(DATA.WaitFrameInput-0.5)*DATA.FlipInterval;
                        FlipTime=  Screen('Flip',Env.MainWindow,ScreenFlipTime);
                        switch DATA.useEEG
                            case 1
                                switch WordPresentation
                                    case 1
                                        sp.sendTrigger(TriggerToSend); % trigger

                                    case nWordPresentationFrames
                                        sp.sendTrigger(TriggerToSend); % trigger

                                end
                        end
                        switch DATA.useET
                            case 1
                                switch WordPresentation
                                    case 1
                                        TimeStamps(end+1,1) =TobiiOperations.get_system_time_stamp;
                                        TimeStamps(end,2)= TriggerToSend;
                                    case nWordPresentationFrames
                                        TimeStamps(end+1,1) =TobiiOperations.get_system_time_stamp;
                                        TimeStamps(end,2)= TriggerToSend;
                                end
                        end


                        FrameIndex = FrameIndex+1;
                    end

                    for backInterval =1:nBackIntervalFrames
                        switch backInterval
                            case 1
                                TriggerToSend = Env.Triggers.Exp3.BackBufferStart;

                            case nBackIntervalFrames
                                TriggerToSend = Env.Triggers.Exp3.BackBufferEnd;
                            otherwise
                                TriggerToSend=0;
                        end
                        FlipTime=  Screen('Flip',Env.MainWindow,ScreenFlipTime);
                        switch DATA.useEEG
                            case 1
                                switch backInterval
                                    case 1
                                        sp.sendTrigger(TriggerToSend); % trigger

                                    case nBackIntervalFrames
                                        sp.sendTrigger(TriggerToSend); % trigger
                                end
                        end
                        switch DATA.useET
                            case 1
                                switch backInterval
                                    case 1
                                        TimeStamps(end+1,1) =TobiiOperations.get_system_time_stamp;
                                        TimeStamps(end,2)= TriggerToSend;
                                    case nBackIntervalFrames
                                        TimeStamps(end+1,1) =TobiiOperations.get_system_time_stamp;
                                        TimeStamps(end,2)= TriggerToSend;
                                end
                        end


                        FrameIndex = FrameIndex+1;

                    end
                end

                Screen('TextSize', Env.MainWindow, 30); %  need to reset pen size after.
                DrawFormattedText(Env.MainWindow,sprintf('%s',BreakQuote),'center','center');
                Screen('DrawingFinished',Env.MainWindow);
                TriggerToSend = Env.Triggers.Exp3.EndBlock;

                ScreenFlipTime = FlipTime+(DATA.WaitFrameInput-0.5)*DATA.FlipInterval;

                FlipTime=  Screen('Flip',Env.MainWindow,ScreenFlipTime);
                switch DATA.useEEG
                    case 1
                        sp.sendTrigger(TriggerToSend); % trigger
                end
                switch DATA.useET
                    case 1
                        TimeStamps(end+1,1) =TobiiOperations.get_system_time_stamp;
                        TimeStamps(end,2)= TriggerToSend;
                end
                KbWait([],2);



            end



        case 2
            TriggerToSend = Env.Triggers.Exp3.StartRecognition;

            Screen('TextSize', Env.MainWindow, 30); %  need to reset pen size after.
            DrawFormattedText(Env.MainWindow,sprintf('%s',RecognitionInstructions),'center','center',[],70);
            Screen('DrawingFinished',Env.MainWindow);
            ScreenFlipTime = FlipTime+(DATA.WaitFrameInput-0.5)*DATA.FlipInterval;
            FlipTime=  Screen('Flip',Env.MainWindow,ScreenFlipTime);
            switch DATA.useEEG
                case 1
                    sp.sendTrigger(TriggerToSend); % trigger
            end
            switch DATA.useET
                case 1
                    TimeStamps(end+1,1) =TobiiOperations.get_system_time_stamp;
                    TimeStamps(end,2)= TriggerToSend;
            end
            %FrameIndex = FrameIndex+1;

            KbWait([],2);

            for blocks =1:nBlocks
                FrameIndex =1;
                TriggerToSend = Env.Triggers.Exp3.StartBlock;

                FlipTime=  Screen('Flip',Env.MainWindow,[]);
                switch DATA.useEEG
                    case 1
                        sp.sendTrigger(TriggerToSend); % trigger
                end
                switch DATA.useET
                    case 1
                        TimeStamps(end+1,1) =TobiiOperations.get_system_time_stamp;
                        TimeStamps(end,2)= TriggerToSend;
                end
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
                        switch fixpresentation
                            case 1
                                TriggerToSend = Env.Triggers.Exp3.JitterStart;

                            case nFixFrames
                                TriggerToSend = Env.Triggers.Exp3.JitterEnd;
                            otherwise
                                TriggerToSend=0;
                        end
                        Screen('DrawTextures',Env.MainWindow,Env.FixCrossTexture);
                        Screen('DrawingFinished',Env.MainWindow);
                        ScreenFlipTime = FlipTime+(DATA.WaitFrameInput-0.5)*DATA.FlipInterval;
                        FlipTime=  Screen('Flip',Env.MainWindow,ScreenFlipTime);
                        switch DATA.useEEG
                            case 1
                                switch fixpresentation
                                    case 1
                                        sp.sendTrigger(TriggerToSend); % trigger

                                    case nFixFrames
                                        sp.sendTrigger(TriggerToSend); % trigger

                                end
                        end
                        switch DATA.useET
                            case 1
                                switch fixpresentation
                                    case 1
                                        TimeStamps(end+1,1) =TobiiOperations.get_system_time_stamp;
                                        TimeStamps(end,2)= TriggerToSend;
                                    case nFixFrames
                                        TimeStamps(end+1,1) =TobiiOperations.get_system_time_stamp;
                                        TimeStamps(end,2)= TriggerToSend;
                                end
                        end

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
                    FrameIndex=1;
                    EEGPass=0;

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
                            case (ismembertol(x,ResponseBoxCoords4(1,1):ResponseBoxCoords4(1,3))&& ismembertol(y,ResponseBoxCoords4(1,2):ResponseBoxCoords4(1,4)))
                                ResponseHighlighter1 = Env.Colours.Red;

                            case (ismembertol(x,ResponseBoxCoords4(2,1):ResponseBoxCoords4(2,3))&& ismembertol(y,ResponseBoxCoords4(2,2):ResponseBoxCoords4(2,4)))
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

                                Screen('DrawTextures',Env.MainWindow,[Env.ExperimentThree.ResponseOne(Response);Env.ExperimentThree.ResponseTwo(Response)],[],[ResponseBoxCoords4]',[],[],[],[ResponseHighlighter1;ResponseHighlighter2]');
                        end

                        Screen('TextSize', Env.MainWindow, 75); %  need to reset pen size after.

                        DrawFormattedText(Env.MainWindow,sprintf('%s',Env.ExperimentThree.RecognitionWords{RecognitionPhase,blocks}),'center','center');


                        Screen('DrawingFinished',Env.MainWindow);

                        switch true

                            case (Response ==1 && any(keyIsDown==1) && ismembertol(x,ResponseBoxCoords4(1,1):ResponseBoxCoords4(1,3))&& ismembertol(y,ResponseBoxCoords4(1,2):ResponseBoxCoords4(1,4)) &&LodgeAResponse==0);
                                TriggerToSend = Env.Triggers.Exp3.ResponseOldTrial;
                                EEGPass=1;
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

                            case (Response ==1 && any(keyIsDown==1) && ismembertol(x,ResponseBoxCoords4(2,1):ResponseBoxCoords4(2,3))&& ismembertol(y,ResponseBoxCoords4(2,2):ResponseBoxCoords4(2,4)) &&  LodgeAResponse==0);
                                TriggerToSend = Env.Triggers.Exp3.ResponseNewTrial;
                                EEGPass=1;

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
                                TriggerToSend = Env.Triggers.Exp3.ConfidenceResponse;
                                EEGPass=1;

                                DATA.ExperimentThree(phases).Phase(blocks).Blocks(RecognitionPhase).Confidence = NumberToDisplay;
                                DATA.ExperimentThree(phases).Phase(blocks).Blocks(RecognitionPhase).ConfidenceRT = GetSecs-OldNewResponseSystemTime;
                                LodgeAResponse =2;

                        end
                        ResponseHighlighter1 = Env.Colours.Black;
                        ResponseHighlighter2 = Env.Colours.Black;



                        ScreenFlipTime = FlipTime+(DATA.WaitFrameInput-0.5)*DATA.FlipInterval;
                        FlipTime=  Screen('Flip',Env.MainWindow,ScreenFlipTime);
                        switch  DATA.useEEG
                            case 1
                                switch true
                                    case FrameIndex==1
                                        sp.sendTrigger(TriggerToSend); % trigger
                                    case (Response==1 && EEGPass==1)
                                        sp.sendTrigger(TriggerToSend); % trigger
                                    case (Response==2 &&EEGPass==1)
                                        sp.sendTrigger(TriggerToSend); % trigger

                                end
                        end
                        switch DATA.useET
                            case 1
                                switch true
                                    case FrameIndex==1
                                        TimeStamps(end+1,1) =TobiiOperations.get_system_time_stamp;
                                        TimeStamps(end,2)=TriggerToSend;
                                    case (Response==1 && EEGPass==1)
                                        TimeStamps(end+1,1) =TobiiOperations.get_system_time_stamp;
                                        TimeStamps(end,2)=TriggerToSend;
                                    case (Response==2 &&EEGPass==1)
                                        TimeStamps(end+1,1) =TobiiOperations.get_system_time_stamp;
                                        TimeStamps(end,2)=TriggerToSend;

                                end
                        end

                        FrameIndex = FrameIndex+1;
                        EEGPass=0;
                        TriggerToSend=0;

                    end

                    for backInterval =1:nBackIntervalFrames
                        switch backInterval
                            case 1
                                TriggerToSend = Env.Triggers.Exp3.BackBufferStart;

                            case nBackIntervalFrames
                                TriggerToSend = Env.Triggers.Exp3.BackBufferEnd;
                            otherwise
                                TriggerToSend=0;
                        end
                        FlipTime=  Screen('Flip',Env.MainWindow,ScreenFlipTime);
                        switch DATA.useEEG
                            case 1
                                switch backInterval
                                    case 1
                                        sp.sendTrigger(TriggerToSend); % trigger

                                    case nBackIntervalFrames
                                        sp.sendTrigger(TriggerToSend); % trigger

                                end
                        end
                        switch DATA.useET
                            case 1
                                switch backInterval
                                    case 1
                                        TimeStamps(end+1,1) =TobiiOperations.get_system_time_stamp;
                                        TimeStamps(end,2)= TriggerToSend;
                                    case nBackIntervalFrames
                                        TimeStamps(end+1,1) =TobiiOperations.get_system_time_stamp;
                                        TimeStamps(end,2)= TriggerToSend;
                                end
                        end

                    end

                end
                Screen('TextSize', Env.MainWindow, 30); %  need to reset pen size after.
                DrawFormattedText(Env.MainWindow,sprintf('%s',BreakQuote),'center','center');
                Screen('DrawingFinished',Env.MainWindow);
                ScreenFlipTime = FlipTime+(DATA.WaitFrameInput-0.5)*DATA.FlipInterval;
                TriggerToSend = Env.Triggers.Exp3.EndBlock;
                FlipTime=  Screen('Flip',Env.MainWindow,ScreenFlipTime);
                switch DATA.useEEG
                    case 1
                        sp.sendTrigger(TriggerToSend); % trigger
                end
                switch DATA.useET
                    case 1
                        TimeStamps(end+1,1) =TobiiOperations.get_system_time_stamp;
                        TimeStamps(end,2)= TriggerToSend;
                end
                KbWait([],2);



                if exist('ExptData', 'dir') == 0
                    mkdir('ExptData\EXP3');
                end
                if exist('ExptData\EXP3\combined','dir')==0
                    mkdir('ExptData\EXP3\combined');
                end

                ExcelFile = ['ExptData\EXP3\myBehaviouralDataP', num2str(DATA.participantNum), '_B', num2str(blocks),'_Data', '.xlsx'];
                if isfile(ExcelFile)==1
                    ExcelFile = ['ExptData\EXP3\myBehaviouralDataP', num2str(DATA.participantNum),'_B',num2str(blocks),'_Data','DOUBLECHANGEPNUM', '.xlsx'];
                end
                writetable(struct2table(DATA.ExperimentThree(blocks).Phase), ExcelFile);
                if exist('OutputData', 'var')==1
                    OutputData = [OutputData,DATA.ExperimentThree(blocks).Phase];
                else
                    OutputData = DATA.ExperimentThree(blocks).Phase;
                end

            end

    end
end
TriggerToSend = Env.Triggers.Exp3.End;

DrawFormattedText(Env.MainWindow,sprintf('%s',Experiment3EndTxt),'center','center',[],120,[],[],2);
Screen('DrawingFinished',Env.MainWindow);
[FlipTime,~,EndFlip]=Screen('Flip',Env.MainWindow,[]);
switch DATA.useEEG
    case 1
        sp.sendTrigger(TriggerToSend); % trigger
end
switch DATA.useET
    case 1
        TimeStamps(end+1,1) =TobiiOperations.get_system_time_stamp;
        TimeStamps(end,2)= TriggerToSend;
end
FileName = ['ExptData\EXP3_',num2str(DATA.participantNum),'.mat'];
save(FileName)
ExcelFile = ['ExptData\EXP3\combined\myBehaviouralDataP', num2str(DATA.participantNum), '_B', num2str(blocks),'_Combined', '.xlsx'];

if isfile(ExcelFile)==1
    ExcelFile = ['ExptData\EXP3\combined\myBehaviouralDataP', num2str(DATA.participantNum),'_B',num2str(blocks),'_Combined','DOUBLECHANGEPNUM', '.xlsx'];
end
writetable(struct2table(OutputData), ExcelFile);

KbWait([],2)
end