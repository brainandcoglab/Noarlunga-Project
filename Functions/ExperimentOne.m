%Written by Tess Barich 2021.
function ExperimentOne(ConditionSequence) % Bead Jar Task
%   Declare Globals
global DATA Env Calib Jar Bead BeadSize QNumbers
%% The Adjustables - The Goblet for One
QuestionQuote1 = "Would you like to make a decision on which jar beads are being drawn from?";
QuestionQuote2 = "Which jar have you decided beads are being drawn from?";

AnswerYesQuote ="Yes\n(Make a decision)";
AnswerNoQuote = "No\n(See next bead)";
ConfidenceQuote = "On a scale of 50-100, How confident are you in this decision?";
LowAnchor ='Complete Guess';
HighAnchor ='I am sure\nI am right';
nTrials =4;
nBeadstoPresent =10;
TotalBeadsInJar = 1000; % can set to whatever you want.
MainColourNumberBeads = round((85/100)*TotalBeadsInJar);
SecondaryColourNumberBeads = round((15/100)*TotalBeadsInJar);
nBlocks =4;
ConditionSequence = randperm(4);
SequenceOrder = [1,2,3,4]; % Built this in incase you ever want to change  the sequence presentation order. randperm(4);
targetseq= SequenceOrder(2);
distractorseqone= SequenceOrder(1);
distractorseqtwo=SequenceOrder(3);
distractorseqthree =SequenceOrder(4);
Sequence =[{},{},{},{}];
intertrialinterval =0.5;
ResponseBoxandTextColour = Env.Colours.White;
LineLength =400; %pixels
WaitFrames =1;
                    Screen('TextSize', Env.MainWindow, 20); %  need to reset pen size after.




[TextXPos,TextYPos] =DrawFormattedText(Env.OffScreenWindow,sprintf('%s',QuestionQuote1),'center',Env.ScreenInfo.Centre(2)+150);
[ResponseBoxCoords,Env.ExperimentOne.ResponseOne(1),Env.ExperimentOne.ResponseTwo(1)]= BuildMyResponseBoxes(Env.MainWindow,Env.OffScreenWindow,2,[AnswerYesQuote;AnswerNoQuote],ResponseBoxandTextColour,3,[Env.ScreenInfo.Centre(1)-60;Env.ScreenInfo.Centre(1)+60],[TextYPos+60],100,100,1,16);


[TextXPos,TextYPos] =DrawFormattedText(Env.OffScreenWindow,sprintf('%s',QuestionQuote2),'center',Env.ScreenInfo.Centre(2)+150);
[ResponseBoxCoords,Env.ExperimentOne.ResponseOne(2),Env.ExperimentOne.ResponseTwo(2)]= BuildMyResponseBoxes(Env.MainWindow,Env.OffScreenWindow,2,["JarA";"JarB"],ResponseBoxandTextColour,3,[Env.ScreenInfo.Centre(1)-60;Env.ScreenInfo.Centre(1)+60],[TextYPos+60],100,100,2,16);

%% Build the sequences
if DATA.useET ==1;
    RubbishET = my_eyetracker.get_gaze_data();
end
for blocks = 1: nBlocks

    JarAnswer(:,blocks) = randi(2,[4,1]); % 1 = original sequence, 2 inverted sequence
    for SequenceBuilding = 1:nBlocks
        switch SequenceOrder(SequenceBuilding)
            case distractorseqone
                switch JarAnswer(SequenceBuilding,blocks)
                    case 1
                        Sequence(:,SequenceOrder(1)) = [{'A'};{'A'};{'B'};{'A'};{'A'};{'A'};{'B'};{'A'};{'A'};{'A'}];
                    case 2
                        Sequence(:,SequenceOrder(1)) = [{'B'};{'B'};{'A'};{'B'};{'B'};{'B'};{'A'};{'B'};{'B'};{'B'}];
                end

            case targetseq
                switch JarAnswer(SequenceBuilding,blocks)
                    case 1
                        Sequence(:,SequenceOrder(2)) = [{'A'};{'A'};{'A'};{'B'};{'A'};{'A'};{'A'};{'A'};{'B'};{'A'}];
                    case 2
                        Sequence(:,SequenceOrder(2)) = [{'B'};{'B'};{'B'};{'A'};{'B'};{'B'};{'B'};{'B'};{'A'};{'B'}];

                end

            case distractorseqtwo
                switch JarAnswer(SequenceBuilding,blocks)
                    case 1
                        Sequence(:,SequenceOrder(3)) = [{'B'};{'A'};{'A'};{'A'};{'A'};{'B'};{'A'};{'A'};{'A'};{'A'}];
                    case 2
                        Sequence(:,SequenceOrder(3)) = [{'A'};{'B'};{'B'};{'B'};{'B'};{'A'};{'B'};{'B'};{'B'};{'B'}];

                end
            case distractorseqthree
                switch JarAnswer(SequenceBuilding,blocks)
                    case 1
                        Sequence(:,SequenceOrder(4)) = [{'A'};{'A'};{'A'};{'A'};{'B'};{'A'};{'A'};{'B'};{'A'};{'A'}];
                    case 2
                        Sequence(:,SequenceOrder(4)) = [{'B'};{'B'};{'B'};{'B'};{'A'};{'B'};{'B'};{'A'};{'B'};{'B'}];

                end

        end
        TranslateCorrectJarAAnswerIdx(SequenceBuilding,blocks) = JarAnswer(SequenceBuilding,blocks)==1; %1 = Jar A is the answer
        TranslateCorrectJarBAnswerIdx(SequenceBuilding,blocks) = JarAnswer(SequenceBuilding,blocks)==2; %2 = Jar B is the answer
        TranslateCorrectJarAnswer(TranslateCorrectJarAAnswerIdx(:,blocks),blocks) = "Jar A";
        TranslateCorrectJarAnswer(TranslateCorrectJarBAnswerIdx(:,blocks),blocks) ="Jar B";
    end
    switch  ConditionSequence(blocks)
        case 1
            JarAColour = Env.Colours.Yellow;
            JarAStr = "yellow";
            JarBColour = Env.Colours.Blue;
            JarBStr = "blue";
        case 2
            JarAColour = Env.Colours.Blue;
            JarAStr = "blue";
            JarBColour = Env.Colours.Red;
            JarBStr = "red";
        case 3
            JarAColour = Env.Colours.Green;
            JarAStr = "green";
            JarBColour = Env.Colours.Blue;
            JarBStr = "blue";
        case 4
            JarAColour = Env.Colours.Red;
            JarAStr = "red";
            JarBColour = Env.Colours.Green;
            JarBStr = "green";

    end

    DATA.ExperimentOne(blocks).TargetSequenceStr =Sequence(:,SequenceOrder(2));

    Change2Colour =strcmp(Sequence,{'A'});
    Sequence(Change2Colour)={JarAColour};
    Change2Colour2=strcmp(Sequence,{'B'});
    Sequence(Change2Colour2)={JarBColour};

    DATA.ExperimentOne(blocks).TargetSequence = Sequence(:,SequenceOrder(2));
    %% Load in and make our images on the fly
    [Env.JarTexture1, Env.JarTexture2] =CreateJar(Env.Loc_Stimuli,Env.MainWindow, Env.OffScreenWindow,JarAColour, JarBColour,MainColourNumberBeads,SecondaryColourNumberBeads,'EXP1');
    Jar =contains([{Env.Stimuli.Name}],'Jar');
    [~,Jar]= max([Jar(:)]);
    Bead = contains([{Env.Stimuli.Name}],'Bead');
    [~,Bead]=max([Bead(:)]);

    CentreJarOne=my_centreTexture(Env.Stimuli(Jar).Size(1)/2,Env.Stimuli(Jar).Size(2)/2,Env.ScreenInfo.width*0.4,Env.ScreenInfo.Centre(2)/2);
    CentreJarTwo = my_centreTexture(Env.Stimuli(Jar).Size(1)/2,Env.Stimuli(Jar).Size(2)/2,Env.ScreenInfo.width*0.6,Env.ScreenInfo.Centre(2)/2);
    BeadTexture = repmat({Env.Stimuli(Bead).TexturePointer},height(Sequence),1);
    FrameIndex =1;
    if DATA.useET==1
        FirstPassET = my_eyetracker.get_gaze_data();
    end
    for Trials = 1:nTrials % The things that need to happen on each trial
        clear DispStim LodgeAResponse BreakMeOut Response
        DATA.ExperimentOne(blocks).EyeData(FrameIndex).Trigger = 110; % Trigger Given 10 - 1 represents experiment number and 0 represents start of each trial in each block.

        DATA.ExperimentOne(blocks).Block(Trials).CorrectResponseStr = TranslateCorrectJarAnswer(Trials,blocks);
        DATA.ExperimentOne(blocks).Block(Trials).CorrectResponse = JarAnswer(Trials,blocks);
        DATA.ExperimentOne(blocks).Block(Trials).TrialSequence =Sequence(:,Trials);
        DATA.ExperimentOne(blocks).Block(Trials).NumBeadstoDecision = 1;
        FlipTime=Screen('Flip',Env.MainWindow,[]);
        WaitSecs(intertrialinterval);
        for Attempts =1:nBeadstoPresent
            LodgeAResponse =0;
            Response = 1;
            BreakMeOut =0;
            DispStim(Attempts,1) = BeadTexture(Attempts,1);
            DispStim(Attempts,2)= cell({my_centreTexture(BeadSize(1),BeadSize(2),(Env.ScreenInfo.width*Attempts/17+250),Env.ScreenInfo.Centre(2)+50)});
            DispStim(Attempts,3)= Sequence(Attempts,Trials);
            textures = cell2mat(DispStim(:,1));
            textures = transpose(textures);
            coordinates = cell2mat(DispStim(:, 2));
            coordinates= transpose(coordinates);
            colourmask = cell2mat(DispStim(:, 3));
            colourmask= transpose(colourmask);
            ResponseHighlighter1 = Env.Colours.Black;
            ResponseHighlighter2 = Env.Colours.Black;
            KbQueueCreate(Env.MouseInfo{1,1}.index,[],2);
            KbQueueStart(Env.MouseInfo{1,1}.index);
            CurrentSample =[];
            start =GetSecs;
            while LodgeAResponse <3

                [keyIsDown,timekeyisdown,KeyisReleased,~,~]= KbQueueCheck(Env.MouseInfo{1,1}.index);

                [x,y,buttons] = GetMouse(Env.MainWindow);

                switch Response
                    case 1
                        DrawFormattedText(Env.MainWindow,sprintf('%s',QuestionQuote1),'center',Env.ScreenInfo.Centre(2)+100);

                    case 2
                        DrawFormattedText(Env.MainWindow,sprintf('%s',QuestionQuote2),'center',Env.ScreenInfo.Centre(2)+100);
                    case 3
                        DrawFormattedText(Env.MainWindow,sprintf('%s',ConfidenceQuote),'center',Env.ScreenInfo.Centre(2)+100);
                end

                switch true
                    case (ismembertol(x,ResponseBoxCoords(1,1):ResponseBoxCoords(1,3))&& ismembertol(y,ResponseBoxCoords(1,2):ResponseBoxCoords(1,4)))
                        ResponseHighlighter1 = Env.Colours.Red;

                    case (ismembertol(x,ResponseBoxCoords(2,1):ResponseBoxCoords(2,3))&& ismembertol(y,ResponseBoxCoords(2,2):ResponseBoxCoords(2,4)))
                        ResponseHighlighter2 = Env.Colours.Red;

                end
                Screen('DrawTextures',Env.MainWindow,[Env.JarTexture1;Env.JarTexture2],[],[CentreJarOne;CentreJarTwo]');

                DrawFormattedText(Env.MainWindow,sprintf('85 percent %s\n15 percent %s',JarAStr,JarBStr),CentreJarOne(1)+20,CentreJarOne(4)+20);
                DrawFormattedText(Env.MainWindow,sprintf('85 percent %s\n15 percent %s',JarBStr,JarAStr),CentreJarTwo(1)+20,CentreJarTwo(4)+20);
                Screen('DrawTextures',Env.MainWindow,textures,[],coordinates,[],[],[],colourmask);

                switch true
                    case Response ==3
                       Screen('FillRect',Env.MainWindow,Env.Colours.White,[Env.ScreenInfo.Centre(1)-(LineLength/2),Env.ScreenInfo.Centre(2)+120,Env.ScreenInfo.Centre(1)+(LineLength/2),Env.ScreenInfo.Centre(2)+125]);
                            TotalLengthLine = LineLength;
                            LineDetails = [(Env.ScreenInfo.Centre(1)-(LineLength/2)),Env.ScreenInfo.Centre(2)+120,(Env.ScreenInfo.Centre(1)+(LineLength/2)),Env.ScreenInfo.Centre(2)+125];
                            DrawFormattedText(Env.MainWindow,sprintf('%s',LowAnchor),LineDetails(1)-200,Env.ScreenInfo.Centre(2)+125);
                            DrawFormattedText(Env.MainWindow,sprintf('%s',HighAnchor),LineDetails(3)+50,Env.ScreenInfo.Centre(2)+125);
                            if ismembertol(x,LineDetails(1):LineDetails(3))&& ismembertol(y,LineDetails(2)-20:LineDetails(4)+20)
                                Difference = (LineDetails(3) -x)/2;
                                NumberToDisplay = ceil((TotalLengthLine-Difference)/4);
                                DrawFormattedText(Env.MainWindow,sprintf('%i',NumberToDisplay),'center',Env.ScreenInfo.Centre(2)+150);

                            end
                    otherwise
                        Screen('DrawTextures',Env.MainWindow,[Env.ExperimentOne.ResponseOne(Response);Env.ExperimentOne.ResponseTwo(Response)],[],[ResponseBoxCoords]',[],[],[],[ResponseHighlighter1;ResponseHighlighter2]');

                end

                Screen('DrawingFinished',Env.MainWindow);


                switch true

                    case (any(keyIsDown==1) && ismembertol(x,ResponseBoxCoords(1,1):ResponseBoxCoords(1,3))&& ismembertol(y,ResponseBoxCoords(1,2):ResponseBoxCoords(1,4))&& Response ==1 && LodgeAResponse==0 );
                        DATA.ExperimentOne(blocks).EyeData(FrameIndex).Trigger = 113; % Response Given 113 - 1 represents experiment number and 3 represents Response to make decision for each trial in each block

                        LodgeAResponse =1;
                        Response = 2; % Yes

                    case (any(keyIsDown==1) && ismembertol(x,ResponseBoxCoords(1,1):ResponseBoxCoords(1,3))&& ismembertol(y,ResponseBoxCoords(1,2):ResponseBoxCoords(1,4))&& Response ==2 &&LodgeAResponse==1);
                        DATA.ExperimentOne(blocks).EyeData(FrameIndex).Trigger = 114; % Response Given 14 - 1 represents experiment number and 4 represents Response of A in each block
                        DATA.ExperimentOne(blocks).Block(Trials).JarResponseAnswer="JarA";
                        DATA.ExperimentOne(blocks).Block(Trials).JarResponseRT=GetSecs-start;
                        JarResponseSystemTime=GetSecs;

                        LodgeAResponse =2;
                        Response =3;


                    case (any(keyIsDown==1) && ismembertol(x,ResponseBoxCoords(2,1):ResponseBoxCoords(2,3))&& ismembertol(y,ResponseBoxCoords(2,2):ResponseBoxCoords(2,4)) && Response==1 && LodgeAResponse==0);
                        DATA.ExperimentOne(blocks).EyeData(FrameIndex).Trigger = 112; % Response Given 12 - 1 represents experiment number and 2 represents choice to see another bead for each trial in each block

                        if DATA.ExperimentOne(blocks).Block(Trials).NumBeadstoDecision <10
                            BreakMeOut = 1;
                            LodgeAResponse =0;
                            DATA.ExperimentOne(blocks).Block(Trials).NumBeadstoDecision = DATA.ExperimentOne(blocks).Block(Trials).NumBeadstoDecision+1;
                        else
                            BreakMeOut = 0;
                            LodgeAResponse =1;
                            Response = 2;
                            DATA.ExperimentOne(blocks).Block(Trials).NumBeadstoDecision = DATA.ExperimentOne(blocks).Block(Trials).NumBeadstoDecision+1;

                        end

                    case (any(keyIsDown==1) && ismembertol(x,ResponseBoxCoords(2,1):ResponseBoxCoords(2,3))&& ismembertol(y,ResponseBoxCoords(2,2):ResponseBoxCoords(2,4)) && Response ==2 && LodgeAResponse==1);
                        DATA.ExperimentOne(blocks).EyeData(FrameIndex).Trigger = 115; % Response Given 15 - 1 represents experiment number and 5 represents Response of B for each trial in each block

                        DATA.ExperimentOne(blocks).Block(Trials).JarResponseAnswer = "JarB";
                        DATA.ExperimentOne(blocks).Block(Trials).JarResponseRT=GetSecs-start;
                        JarResponseSystemTime=GetSecs;
                        Response =3;
                        LodgeAResponse =2;

                    case (Response ==3 && any(keyIsDown==1) && ismembertol(x,LineDetails(1):LineDetails(3))&& ismembertol(y,LineDetails(2)-10:LineDetails(4)+10)&& LodgeAResponse==2)
                        DATA.ExperimentOne(blocks).Block(Trials).Confidence = NumberToDisplay;
                        DATA.ExperimentOne(blocks).Block(Trials).ConfidenceRT = GetSecs-JarResponseSystemTime;

                        DATA.ExperimentOne(blocks).EyeData(FrameIndex).Trigger = 116; % Response Given 16 - 1 represents experiment number and 6 represents confidence Response for each trial in each block

                        LodgeAResponse =3;
                    otherwise

                end

                ResponseHighlighter1 = Env.Colours.Black;
                ResponseHighlighter2 = Env.Colours.Black;


                if BreakMeOut ==1
                    break
                end

                switch DATA.useET
                    case 0
                        DATA.ExperimentOne(blocks).EyeData(FrameIndex).SystemTime = GetSecs;
                        DATA.ExperimentOne(blocks).EyeData(FrameIndex).OnsetTime =  DATA.ExperimentOne(blocks).EyeData(FrameIndex).SystemTime  -start;

                    case 1
                        switch true
                            case isempty(CurrentSample)==1

                                DATA.ExperimentOne(blocks).EyeData(FrameIndex).TobiiLeftEyePos = FirstPassET(1,end).LeftEye.GazePoint.OnDisplayArea;
                                DATA.ExperimentOne(blocks).EyeData(FrameIndex).TobiiRightEyePos = FirstPassET(1,end).RightEye.GazePoint.OnDisplayArea;
                                DATA.ExperimentOne(blocks).EyeData(FrameIndex).TobiiLeftEyePupil = FirstPassET(1,end).LeftEye.Pupil.Diameter;
                                DATA.ExperimentOne(blocks).EyeData(FrameIndex).TobiiRightEyePupil = FirstPassET(1,end).LeftEye.Pupil.Diameter;
                                DATA.ExperimentOne(blocks).EyeData(FrameIndex).TobiiTime = FirstPassET(1,end).SystemTimeStamp;


                            case isempty(CurrentSample)==0

                                DATA.ExperimentOne(blocks).EyeData(FrameIndex).TobiiLeftEyePos= CurrentSample(1,end).LeftEye.GazePoint.OnDisplayArea;
                                DATA.ExperimentOne(blocks).EyeData(FrameIndex).TobiiRightEyePos  = CurrentSample(1,end).RightEye.GazePoint.OnDisplayArea;
                                DATA.ExperimentOne(blocks).EyeData(FrameIndex).TobiiLeftEyePupil = CurrentSample(1,end).LeftEye.Pupil.Diameter;
                                DATA.ExperimentOne(blocks).EyeData(FrameIndex).TobiiRightEyePupil = CurrentSample(1,end).LeftEye.Pupil.Diameter;
                                DATA.ExperimentOne(blocks).EyeData(FrameIndex).TobiiTime = CurrentSample(1,end).SystemTimeStamp;


                        end
                        CurrentSample = my_eyetracker.get_gaze_data();

                end

                ScreenFlipTime = FlipTime+(DATA.WaitFrameInput-0.5)*DATA.FlipInterval;
                FlipTime=  Screen('Flip',Env.MainWindow,ScreenFlipTime);
                %BIOSEMI HERE
                DATA.ExperimentOne(blocks).EyeData(FrameIndex).FrameIndex =FrameIndex;
                DATA.ExperimentOne(blocks).EyeData(FrameIndex).FlipTimeStamp=FlipTime;
                FrameIndex=FrameIndex+1;

            end

            if LodgeAResponse ==3
                break
            end
        end

    end

end
end