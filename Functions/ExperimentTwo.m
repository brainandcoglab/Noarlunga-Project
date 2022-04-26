%Written by Tess Barich 2022
function ExperimentTwo(ConditionSequence)
global Env DATA  Calib colour ResponseBoxCoords4 QuestionQuote ConfidenceQuote LowAnchor HighAnchor LineLength LineDivide
%% The Adjustables - Paired Fates
NumOfX =5;
NumOfY=5;
StimuliSizeX=50;
StimuliSizeY=50;
GapBetween =20;
BlankX=300;
BlankY =100;
BlankYP =-15;
nBlocks =4;
nTrials =4;
nMaxAttempts =26;
QuestionQuote = "Which colour is occuring more frequently?";
ConfidenceQuote = "On a scale of 50-100, How confident are you in this decision?";
LowAnchor ='Complete Guess';
HighAnchor ='I am sure\n I am right';
nTrials =4;
nBlocks =4;
ConditionSequence = randperm(4);
SequenceOrder = [1,2,3,4]; % Built this in incase you ever want to change  the sequence presentation order. randperm(4);
targetseq= SequenceOrder(2);
distractorseqone= SequenceOrder(1);
distractorseqtwo=SequenceOrder(3);
distractorseqthree =SequenceOrder(4);
Sequence =[{},{},{},{}];
intertrialinterval =0.5;
BoxColour =Env.Colours.Grey;
BoxHighlight =Env.Colours.DarkGrey;
PResponseBoxandTextColour = Env.Colours.White;
ResponseBoxandTextColour = Env.Colours.Black;

LineLength =600; %pixels
LineDivide =LineLength/100; %pixels
WaitFrames =1;
PracticeInstructions =["You will see 25 squares on the screen ('boxes'). Each box conceals one of two colours shown at the bottom of the screen for each trial. " + ...
    "One of these colours is always in the majority (80% of boxes), the other colour in the minority (15%% of boxes)." + ...
    "At the beginning of each trial, all boxes are closed (grey). Your task is to estimate which colour is in the majority (i.e., 85% of boxes). " + ...
    "To this end, you can open as many boxes as you want, and in whatever order you like, by clicking on them with the left mouse button. " + ...
    "As soon as you have reached a decision, please click on the respective colour box at the bottom of the screen." + ...
    "There are 16 trials in total (made of four sets of four colour-pair trials). For all trials, you will be able to open up to 25 boxes (i.e., the maximum number boxes available) before making a decision. " + ...
    "If you have NOT made a response after opening all 25 boxes, the task will ask you to make a decision on the primary colour. " + ...
    "For each trial, you will also be asked to provide a confidence rating between 50% - (complete guess) to 100% (I am sure I am right) on your colour choice. "];
PracticeColourA = Env.Colours.Purple; 
PracticeColourB =Env.Colours.Magenta;
PracticeColourAStr = "purple";
PracticeColourBStr = "magenta";
PracticeAnswer1= ["Yes";"No"];
PracticeAnswer2 =[sprintf("They would all be %s boxes",PracticeColourAStr);sprintf("They would all be %s boxes",PracticeColourBStr);sprintf("They would probably be a random mix of approx 50%% %s and 50%% %s boxes",PracticeColourAStr,PracticeColourBStr);...
    sprintf("They would probably be a random mix of approx 85%% %s and 15%% %s boxes",PracticeColourAStr,PracticeColourBStr);sprintf("They would probably be a random mix of approx 15%% %s and 85%% %s boxes",PracticeColourAStr,PracticeColourBStr)];
Question1 =["Will the boxes ever close during a game?"];
Question2 =["Will the boxes change colour once they're opened?"];
Question3 =[sprintf("If a large number of boxes were opened on a %s game, what might you expect?", PracticeColourAStr)];
   TranslateCorrectColourBoxAAnswerIdx= zeros([nTrials,nBlocks],'logical');
         TranslateCorrectColourBoxBAnswerIdx = zeros([nTrials,nBlocks],'logical');
        TranslateCorrectBoxAnswer(1:nTrials,1:nBlocks)="0";
        BoxAnswer=zeros([nTrials,nBlocks]);

%% Get the X and Y coordinates for the boxes
[Env.ExperimentTwoPractice.Coordinates,Env.ExperimentTwoPractice.MinMaxXY]=DetermineXYCoords(Env.MainWindow,Env.MainWindow,NumOfX,NumOfY,StimuliSizeX,StimuliSizeY,GapBetween,BlankX,BlankYP);
[Env.ExperimentTwo.Coordinates,Env.ExperimentTwo.MinMaxXY]=DetermineXYCoords(Env.MainWindow,Env.MainWindow,NumOfX,NumOfY,StimuliSizeX,StimuliSizeY,GapBetween,BlankX,BlankY);
[ResponseBoxCoords4,Env.ExperimentTwoPractice.ResponseThree,Env.ExperimentTwoPractice.ResponseFour]= BuildMyResponseBoxes(Env.MainWindow,Env.OffScreenWindow,2,[PracticeColourAStr;PracticeColourBStr],ResponseBoxandTextColour,3,[Env.ExperimentTwo.MinMaxXY(1,1);Env.ExperimentTwo.MinMaxXY(3,1)],[Env.ExperimentTwo.MinMaxXY(4,1)+230;Env.ExperimentTwo.MinMaxXY(4,1)+230],200,100,12,16,[PracticeColourA;PracticeColourB]');
Exp2ComprehensionCheck(Env.MainWindow,Env.OffScreenWindow,PracticeColourA,PracticeColourAStr,BoxColour,PracticeColourB,PracticeColourBStr,Question1,Question2,Question3,PracticeAnswer1,PracticeAnswer2,PracticeInstructions,PResponseBoxandTextColour);
[Env.ExperimentTwo.Coordinates,Env.ExperimentTwo.MinMaxXY]=DetermineXYCoords(Env.MainWindow,Env.MainWindow,NumOfX,NumOfY,StimuliSizeX,StimuliSizeY,GapBetween,BlankX,BlankY);

%% Build the sequences
if DATA.useET ==1;
    RubbishET = my_eyetracker.get_gaze_data();
end
for blocks = 1: nBlocks

    BoxAnswer(:,blocks) = randi(2,[4,1]); % 1 = original sequence, 2 inverted sequence
    Env.BoxAnswer = BoxAnswer;
    for SequenceBuilding = 1:nBlocks
        switch SequenceOrder(SequenceBuilding)
            case distractorseqone
                switch BoxAnswer(SequenceBuilding,blocks)
                    case 1
                        Sequence(:,SequenceOrder(1)) = [{'A'};{'A'};{'B'};{'A'};{'A'};{'A'};{'B'};{'A'};{'A'};{'A'};{'A'};{'A'};{'B'};{'A'};{'A'};{'A'};{'B'};{'A'};{'A'};{'A'};{'A'};{'A'};{'B'};{'A'};{'A'}];
                    case 2
                        Sequence(:,SequenceOrder(1)) = [{'B'};{'B'};{'A'};{'B'};{'B'};{'B'};{'A'};{'B'};{'B'};{'B'};{'B'};{'B'};{'A'};{'B'};{'B'};{'B'};{'A'};{'B'};{'B'};{'B'};{'B'};{'B'};{'A'};{'B'};{'B'}];
                end

            case targetseq
                switch BoxAnswer(SequenceBuilding,blocks)
                    case 1
                        Sequence(:,SequenceOrder(2)) = [{'A'};{'A'};{'A'};{'B'};{'A'};{'A'};{'A'};{'A'};{'B'};{'A'};{'A'};{'A'};{'A'};{'B'};{'A'};{'A'};{'A'};{'A'};{'B'};{'A'};{'A'};{'A'};{'A'};{'B'};{'A'}];
                    case 2
                        Sequence(:,SequenceOrder(2)) = [{'B'};{'B'};{'B'};{'A'};{'B'};{'B'};{'B'};{'B'};{'A'};{'B'};{'B'};{'B'};{'B'};{'A'};{'B'};{'B'};{'B'};{'B'};{'A'};{'B'};{'B'};{'B'};{'B'};{'A'};{'B'}];

                end

            case distractorseqtwo
                switch BoxAnswer(SequenceBuilding,blocks)
                    case 1
                        Sequence(:,SequenceOrder(3)) = [{'B'};{'A'};{'A'};{'A'};{'A'};{'B'};{'A'};{'A'};{'A'};{'A'};{'B'};{'A'};{'A'};{'A'};{'A'};{'B'};{'A'};{'A'};{'A'};{'A'};{'B'};{'A'};{'A'};{'A'};{'A'}];
                    case 2
                        Sequence(:,SequenceOrder(3)) = [{'A'};{'B'};{'B'};{'B'};{'B'};{'A'};{'B'};{'B'};{'B'};{'B'};{'A'};{'B'};{'B'};{'B'};{'B'};{'A'};{'B'};{'B'};{'B'};{'B'};{'A'};{'B'};{'B'};{'B'};{'B'}];

                end
            case distractorseqthree
                switch BoxAnswer(SequenceBuilding,blocks)
                    case 1
                        Sequence(:,SequenceOrder(4)) = [{'A'};{'A'};{'A'};{'A'};{'B'};{'A'};{'A'};{'B'};{'A'};{'A'};{'A'};{'A'};{'A'};{'A'};{'B'};{'A'};{'A'};{'B'};{'A'};{'A'};{'A'};{'A'};{'A'};{'A'};{'B'}];
                    case 2
                        Sequence(:,SequenceOrder(4)) = [{'B'};{'B'};{'B'};{'B'};{'A'};{'B'};{'B'};{'A'};{'B'};{'B'};{'B'};{'B'};{'B'};{'B'};{'A'};{'B'};{'B'};{'A'};{'B'};{'B'};{'B'};{'B'};{'B'};{'B'};{'A'}];

                end

        end
        TranslateCorrectColourBoxAAnswerIdx(SequenceBuilding,blocks) = BoxAnswer(SequenceBuilding,blocks)==1; %1 = Colour A is the answer
        TranslateCorrectColourBoxBAnswerIdx(SequenceBuilding,blocks) = BoxAnswer(SequenceBuilding,blocks)==2; %2 = Colour B is the answer
        Env.Translate = TranslateCorrectColourBoxBAnswerIdx;
        TranslateCorrectBoxAnswer(TranslateCorrectColourBoxAAnswerIdx(:,blocks),blocks) = "Colour A"; %%maybehere. 
        TranslateCorrectBoxAnswer(TranslateCorrectColourBoxBAnswerIdx(:,blocks),blocks) ="Colour B";
        Env.TranslateCorrectBoxAnswer= TranslateCorrectBoxAnswer;
    end
    switch  ConditionSequence(blocks)
        case 1
            ColourBoxA = Env.Colours.Yellow;
            ColourBoxAStr = "Yellow";
            ColourBoxB = Env.Colours.Blue;
            ColourBoxBStr = "Blue";
        case 2
            ColourBoxA = Env.Colours.Blue;
            ColourBoxAStr = "Blue";
            ColourBoxB = Env.Colours.Red;
            ColourBoxBStr = "Red";
        case 3
            ColourBoxA = Env.Colours.Green;
            ColourBoxAStr = "Green";
            ColourBoxB = Env.Colours.Blue;
            ColourBoxBStr = "Blue";
        case 4
            ColourBoxA = Env.Colours.Red;
            ColourBoxAStr = "Red";
            ColourBoxB = Env.Colours.Green;
            ColourBoxBStr = "Green";
    end

    DATA.ExperimentTwo(blocks).TargetSequenceStr =Sequence(:,SequenceOrder(2));
    AnswerQuote1 = ColourBoxAStr;
    AnswerQuote2 = ColourBoxBStr;
    TranslateCorrectColour(TranslateCorrectColourBoxAAnswerIdx(:,blocks),blocks) = AnswerQuote1; %UP TO HERE SEE WHY ITS REGISTERING AS NAN. 
    TranslateCorrectColour(TranslateCorrectColourBoxBAnswerIdx(:,blocks),blocks) =AnswerQuote2;

    Change2Colour =strcmp(Sequence,{'A'});
    Sequence(Change2Colour)={ColourBoxA};
    Change2Colour2=strcmp(Sequence,{'B'});
    Sequence(Change2Colour2)={ColourBoxB};

    DATA.ExperimentTwo(blocks).TargetSequence = Sequence(:,SequenceOrder(2));

    [ResponseBoxCoords3,Env.ExperimentTwo.ResponseOne,Env.ExperimentTwo.ResponseTwo]= BuildMyResponseBoxes(Env.MainWindow,Env.OffScreenWindow,2,[AnswerQuote1;AnswerQuote2],ResponseBoxandTextColour,3,[Env.ExperimentTwo.MinMaxXY(1,1);Env.ExperimentTwo.MinMaxXY(3,1)],[Env.ExperimentTwo.MinMaxXY(4,1)+230;Env.ExperimentTwo.MinMaxXY(4,1)+230],200,100,12,16,[ColourBoxA;ColourBoxB]');
    FrameIndex =1;
    Env.ResponseBoxCoords =ResponseBoxCoords3;
    for Trials =1:nTrials
           
        DATA.ExperimentTwo(blocks).Block(Trials).CorrectResponseColour = TranslateCorrectBoxAnswer(Trials,blocks);
        DATA.ExperimentTwo(blocks).Block(Trials).CorrectResponseBox =TranslateCorrectColour(Trials,blocks); 
        DATA.ExperimentTwo(blocks).Block(Trials).TrialSequence =Sequence(:,Trials);
        DATA.ExperimentTwo(blocks).Block(Trials).NumBoxtoDecision = 0;
        Response=1;
        LodgeAResponse =0;
        colour = zeros([width(BoxColour),width(Env.ExperimentTwo.Coordinates)]);
        for colourfill =1:width(BoxColour)
            colour(colourfill,:)= BoxColour(colourfill)';
        end
        FlipTime=Screen('Flip',Env.MainWindow,[]);
        WaitSecs(intertrialinterval);
                    start =GetSecs;

        for Attempts =1:nMaxAttempts
            BreakMeOut=0;
            ResponseHighlighter1 =Env.Colours.White;

            ResponseHighlighter2 = Env.Colours.White;
            KbQueueCreate(Env.MouseInfo{1,1}.index,[],2);
            KbQueueStart(Env.MouseInfo{1,1}.index);
            CurrentSample =[];
            %start =GetSecs;
            while LodgeAResponse <2
                [keyIsDown,timekeyisdown,KeyisReleased,~,~]= KbQueueCheck(Env.MouseInfo{1,1}.index);
                [x,y,buttons] = GetMouse(Env.MainWindow);

                switch Response
                    case 1
                        DrawFormattedText(Env.MainWindow,sprintf('%s',QuestionQuote),'center',600);

                    case 2
                        DrawFormattedText(Env.MainWindow,sprintf('%s',ConfidenceQuote),'center',600);

                end

                switch true
                    case (ismembertol(x,ResponseBoxCoords3(1,1):ResponseBoxCoords3(1,3))&& ismembertol(y,ResponseBoxCoords3(1,2):ResponseBoxCoords3(1,4)))
                        ResponseHighlighter1 = BoxColour;

                    case (ismembertol(x,ResponseBoxCoords3(2,1):ResponseBoxCoords3(2,3))&& ismembertol(y,ResponseBoxCoords3(2,2):ResponseBoxCoords3(2,4)))
                        ResponseHighlighter2 = BoxColour;


                end
                Env.HighlightIdx = (Response==1 & x>= Env.ExperimentTwo.Coordinates(1,:) & x<= Env.ExperimentTwo.Coordinates(3,:) & y>= Env.ExperimentTwo.Coordinates(2,:) & y<= Env.ExperimentTwo.Coordinates(4,:));
                checkcolour = (ismember(colour(:,1:end),BoxColour) & Env.HighlightIdx==1);
                logictest =any(checkcolour==1);
                switch true
                    case       (any(logictest==1))
                        colour(:,logictest)=[BoxHighlight'];
                end


                CoordinatesIdx = (keyIsDown==1 & x>= Env.ExperimentTwo.Coordinates(1,:) & x<= Env.ExperimentTwo.Coordinates(3,:) & y>= Env.ExperimentTwo.Coordinates(2,:) & y<= Env.ExperimentTwo.Coordinates(4,:));

                switch true
                    case any(CoordinatesIdx==1) && Response==1

                        if DATA.ExperimentTwo(blocks).Block(Trials).NumBoxtoDecision <25
                            colour(:,CoordinatesIdx)=cell2mat(Sequence(Attempts,Trials))';
                            BreakMeOut = 1;
                            LodgeAResponse =0;
                            DATA.ExperimentTwo(blocks).Block(Trials).NumBoxtoDecision = DATA.ExperimentTwo(blocks).Block(Trials).NumBoxtoDecision+1;
                        else
                            BreakMeOut = 0;
                            LodgeAResponse =0;
                            DATA.ExperimentTwo(blocks).Block(Trials).NumBoxtoDecision = nMaxAttempts;%DATA.ExperimentTwo(blocks).Block(Trials).NumBoxtoDecision+1;
                        end
                    case (DATA.ExperimentTwo(blocks).Block(Trials).NumBoxtoDecision>0 && any(keyIsDown==1) && ismembertol(x,ResponseBoxCoords3(1,1):ResponseBoxCoords3(1,3))&& ismembertol(y,ResponseBoxCoords3(1,2):ResponseBoxCoords3(1,4))&& Response ==1 &&LodgeAResponse==0);
                        DATA.ExperimentTwo(blocks).EyeData(FrameIndex).Trigger = 114; % Response Given 14 - 1 represents experiment number and 4 represents Response of A in each block
                        DATA.ExperimentTwo(blocks).Block(Trials).BoxResponseAnswer="ColourA";
                        DATA.ExperimentTwo(blocks).Block(Trials).BoxResponseColour=AnswerQuote1;
                        DATA.ExperimentTwo(blocks).Block(Trials).ResponseRT=GetSecs-start;
                        ResponseSystemTime=GetSecs;
                        LodgeAResponse =1;
                        Response =2;
                    case (DATA.ExperimentTwo(blocks).Block(Trials).NumBoxtoDecision>0 && any(keyIsDown==1) && ismembertol(x,ResponseBoxCoords3(2,1):ResponseBoxCoords3(2,3))&& ismembertol(y,ResponseBoxCoords3(2,2):ResponseBoxCoords3(2,4)) && Response ==1 && LodgeAResponse==0);
                        DATA.ExperimentTwo(blocks).EyeData(FrameIndex).Trigger = 115; % Response Given 15 - 1 represents experiment number and 5 represents Response of B for each trial in each block
                        DATA.ExperimentTwo(blocks).Block(Trials).BoxResponseAnswer = "ColourB";
                        DATA.ExperimentTwo(blocks).Block(Trials).BoxResponseColour=AnswerQuote2;
                        DATA.ExperimentTwo(blocks).Block(Trials).ResponseRT=GetSecs-start;
                        ResponseSystemTime=GetSecs;
                        LodgeAResponse =1;
                        Response =2;
                    case (Response ==2 && any(keyIsDown==1) && ismembertol(x,LineDetails(1)-10:LineDetails(3))&& ismembertol(y,LineDetails(2)-20:LineDetails(4)+20)&& LodgeAResponse==1)
                        DATA.ExperimentTwo(blocks).Block(Trials).Confidence = NumberToDisplay;
                        DATA.ExperimentTwo(blocks).Block(Trials).ConfidenceRT = GetSecs-ResponseSystemTime;

                        DATA.ExperimentTwo(blocks).EyeData(FrameIndex).Trigger = 116; % Response Given 16 - 1 represents experiment number and 6 represents confidence Response for each trial in each block

                        LodgeAResponse =2;
                    otherwise

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
                        Screen('DrawTextures',Env.MainWindow,[Env.ExperimentTwo.ResponseOne(Response);Env.ExperimentTwo.ResponseTwo(Response)],[],[ResponseBoxCoords3]',[],[],[],[ResponseHighlighter1;ResponseHighlighter2]');


                end

                Screen('FillRect',Env.MainWindow,colour,Env.ExperimentTwo.Coordinates);
                Screen('DrawingFinished',Env.MainWindow);

                changeidx = (ismember(colour(:,1:end),BoxHighlight));
                logicchangeidxtest=any(changeidx==1);

                switch true
                    case (any(logicchangeidxtest==1))
                        colour(:,logicchangeidxtest)=[BoxColour'];
                end

                ResponseHighlighter1 =Env.Colours.White;

                ResponseHighlighter2 = Env.Colours.White;

                switch DATA.useET
                    case 0
                        DATA.ExperimentTwo(blocks).EyeData(FrameIndex).SystemTime = GetSecs;
                        DATA.ExperimentTwo(blocks).EyeData(FrameIndex).OnsetTime =  DATA.ExperimentTwo(blocks).EyeData(FrameIndex).SystemTime  -start;

                    case 1
                        switch true
                            case isempty(CurrentSample)==1

                                DATA.ExperimentTwo(blocks).EyeData(FrameIndex).TobiiLeftEyePos = FirstPassET(1,end).LeftEye.GazePoint.OnDisplayArea;
                                DATA.ExperimentTwo(blocks).EyeData(FrameIndex).TobiiRightEyePos = FirstPassET(1,end).RightEye.GazePoint.OnDisplayArea;
                                DATA.ExperimentTwo(blocks).EyeData(FrameIndex).TobiiLeftEyePupil = FirstPassET(1,end).LeftEye.Pupil.Diameter;
                                DATA.ExperimentTwo(blocks).EyeData(FrameIndex).TobiiRightEyePupil = FirstPassET(1,end).LeftEye.Pupil.Diameter;
                                DATA.ExperimentTwo(blocks).EyeData(FrameIndex).TobiiTime = FirstPassET(1,end).SystemTimeStamp;


                            case isempty(CurrentSample)==0

                                DATA.ExperimentTwo(blocks).EyeData(FrameIndex).TobiiLeftEyePos= CurrentSample(1,end).LeftEye.GazePoint.OnDisplayArea;
                                DATA.ExperimentTwo(blocks).EyeData(FrameIndex).TobiiRightEyePos  = CurrentSample(1,end).RightEye.GazePoint.OnDisplayArea;
                                DATA.ExperimentTwo(blocks).EyeData(FrameIndex).TobiiLeftEyePupil = CurrentSample(1,end).LeftEye.Pupil.Diameter;
                                DATA.ExperimentTwo(blocks).EyeData(FrameIndex).TobiiRightEyePupil = CurrentSample(1,end).LeftEye.Pupil.Diameter;
                                DATA.ExperimentTwo(blocks).EyeData(FrameIndex).TobiiTime = CurrentSample(1,end).SystemTimeStamp;
                        end
                        CurrentSample = my_eyetracker.get_gaze_data();

                end

                if BreakMeOut ==1
                    break
                end
                ScreenFlipTime = FlipTime+(DATA.WaitFrameInput-0.5)*DATA.FlipInterval;
                FlipTime=  Screen('Flip',Env.MainWindow,ScreenFlipTime);
                %BIOSEMI HERE
                DATA.ExperimentTwo(blocks).EyeData(FrameIndex).FrameIndex =FrameIndex;
                DATA.ExperimentTwo(blocks).EyeData(FrameIndex).FlipTimeStamp=FlipTime;
                FrameIndex=FrameIndex+1;

                if BreakMeOut ==1
                    break
                end


            end
        end
    end
end
end
