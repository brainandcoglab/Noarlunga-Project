%Written by Tess Barich 2022
function Exp1ComprehensionCheck(Directory,window,window2,PracticeColourA,PracticeColourStrA,PracticeColourB,PracticeColourStrB,MainColourNumber,SecondaryColour,experimentStr,Question1,Question2,ResponseOpts1,ResponseOpts2,PracticeInstructs,ResponseBoxColour)
global Env DATA Jar Bead ResponseBoxCoords BeadSize QuestionQuote1 QuestionQuote2 ConfidenceQuote LowAnchor HighAnchor LineLength LineDivide
intertrialinterval =0.5;
blocks =1;
incorrecttext = "Your answer is INCORRECT, please press ENTER to try again.";
PracticeEndText =["The practice trial is complete. There will now follow four sets of four trials each. " + ...
    "Remember for each game, one of the jars will be randomly selected, but you will not be told which one. " + ...
    "You can request beads, and the computer will draw random beads from the selected jar. " + ...
    "Your task is to request enough beads in order to decide which jar was selected. " + ...
    "You can continue requesting beads until you feel confident about making a decision. " + ...
    "Press ENTER when you are ready to start."];
[Env.PracticeJarTexture1, Env.PracticeJarTexture2] =CreateJar(Directory,window, window2,PracticeColourA,PracticeColourB ,MainColourNumber,SecondaryColour,experimentStr);

Xposi(1:height(ResponseOpts2),1)=Env.ScreenInfo.Centre(1);
Yposi=zeros([height(ResponseOpts2),1]);
for NumofQs =1:2
    [~,TextYPos] =DrawFormattedText(Env.OffScreenWindow,sprintf('%s',Question1),'center',Env.ScreenInfo.Centre(2)-100);
    addY=110;
    for NumofResponses =1: height(ResponseOpts2)
        Yposi(NumofResponses)= TextYPos+addY;
        addY=addY+110;
    end
    [ResponseBoxCoords1,Env.ExperimentOnePractice.ResponseOne(1),Env.ExperimentOnePractice.ResponseOne(2)]= BuildMyResponseBoxes(Env.MainWindow,Env.OffScreenWindow,2,[ResponseOpts1],ResponseBoxColour,3,[Xposi],[Yposi],400,100,12,16);
    [ResponseBoxCoords2,Env.ExperimentOnePractice.ResponseTwo]= BuildMyResponseBoxes(Env.MainWindow,Env.OffScreenWindow,5,[ResponseOpts2],ResponseBoxColour,3,[Xposi],[Yposi],400,100,30,16);

end
CounterPracPres = randperm(2)';
PracticeSequence(:,CounterPracPres(1)) = [{'A'};{'A'};{'A'};{'B'};{'A'};{'A'};{'A'};{'A'};{'A'};{'B'}];
PracticeSequence(:,CounterPracPres(2)) =  [{'B'};{'B'};{'B'};{'A'};{'B'};{'B'};{'B'};{'B'};{'B'};{'A'}];

JarAColour = PracticeColourA;
JarAStr = PracticeColourStrA;
JarBColour = PracticeColourB;
JarBStr = PracticeColourStrB;
DATA.ExperimentOnePracticeSeqs.Str=PracticeSequence;

Change2Colour =strcmp(PracticeSequence,{'A'});
PracticeSequence(Change2Colour)={JarAColour};
Change2Colour2=strcmp(PracticeSequence,{'B'});
PracticeSequence(Change2Colour2)={JarBColour};
DATA.ExperimentOnePracticeSeqs.Colour=PracticeSequence;

TranslateCorrectJarAAnswerIdx(:) = CounterPracPres(:)==1 ;%1 = Jar A is the answer
TranslateCorrectJarBAnswerIdx(:) = CounterPracPres(:)==2; %2 = Jar B is the answer
TranslateCorrectJarAnswer(TranslateCorrectJarAAnswerIdx(:),1) = "Jar A";
TranslateCorrectJarAnswer(TranslateCorrectJarBAnswerIdx(:),1) ="Jar B";
Jar =contains([{Env.Stimuli.Name}],'Jar');
[~,Jar]= max([Jar(:)]);
Bead = contains([{Env.Stimuli.Name}],'Bead');
[~,Bead]=max([Bead(:)]);

CentreJarOne=my_centreTexture(Env.Stimuli(Jar).Size(1)/2,Env.Stimuli(Jar).Size(2)/2,Env.ScreenInfo.width*0.4,Env.ScreenInfo.Centre(2)/2);
CentreJarTwo = my_centreTexture(Env.Stimuli(Jar).Size(1)/2,Env.Stimuli(Jar).Size(2)/2,Env.ScreenInfo.width*0.6,Env.ScreenInfo.Centre(2)/2);
BeadTexture= repmat({Env.Stimuli(Bead).TexturePointer},height(PracticeSequence),1);
if DATA.useET==1
    FirstPassET = my_eyetracker.get_gaze_data();
end
MoveOn=0;
FrameIndex=1;
KbQueueCreate(Env.MouseInfo{1,1}.index,[],2);
KbQueueStart(Env.MouseInfo{1,1}.index);
start =GetSecs;
while MoveOn~=1
    [keyboardDown,~,whichkey]=KbCheck;
        DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).FrameIndex =FrameIndex;
    %trigger
    DrawFormattedText(Env.MainWindow,sprintf('%s',PracticeInstructs),'center',CentreJarOne(4)+150,[],120,[],[],2);
    Screen('DrawTextures',Env.MainWindow,[Env.PracticeJarTexture1;Env.PracticeJarTexture2],[],[CentreJarOne;CentreJarTwo]');
     DrawFormattedText(Env.MainWindow,sprintf('Jar A\n85%% %s 15%% %s',JarAStr,JarBStr),CentreJarOne(1)+20,CentreJarOne(4)+20);
    DrawFormattedText(Env.MainWindow,sprintf('Jar B\n85%% %s 15%% %s',JarBStr,JarAStr),CentreJarTwo(1)+20,CentreJarTwo(4)+20);
    Screen('DrawingFinished',Env.MainWindow);

    switch DATA.useET
        case 0
            DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).SystemTime = GetSecs;
            DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).OnsetTime =  DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).SystemTime  -start;

        case 1
            switch true
                case isempty(CurrentSample)==1

                    DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).TobiiLeftEyePos = FirstPassET(1,end).LeftEye.GazePoint.OnDisplayArea;
                    DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).TobiiRightEyePos = FirstPassET(1,end).RightEye.GazePoint.OnDisplayArea;
                    DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).TobiiLeftEyePupil = FirstPassET(1,end).LeftEye.Pupil.Diameter;
                    DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).TobiiRightEyePupil = FirstPassET(1,end).LeftEye.Pupil.Diameter;
                    DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).TobiiTime = FirstPassET(1,end).SystemTimeStamp;


                case isempty(CurrentSample)==0

                    DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).TobiiLeftEyePos= CurrentSample(1,end).LeftEye.GazePoint.OnDisplayArea;
                    DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).TobiiRightEyePos  = CurrentSample(1,end).RightEye.GazePoint.OnDisplayArea;
                    DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).TobiiLeftEyePupil = CurrentSample(1,end).LeftEye.Pupil.Diameter;
                    DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).TobiiRightEyePupil = CurrentSample(1,end).LeftEye.Pupil.Diameter;
                    DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).TobiiTime = CurrentSample(1,end).SystemTimeStamp;


            end
            CurrentSample = my_eyetracker.get_gaze_data();

    end

    if (keyboardDown ==1 && KbName(whichkey)=="Return")
        MoveOn=1;
        %trigger
    end
    [FlipTime,~,EndFlip]=Screen('Flip',Env.MainWindow,[]);
        DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).FlipTimeStamp=FlipTime;

    FrameIndex =FrameIndex+1;
end
Response =1;
ResponseHighlighter1 = Env.Colours.Black;
ResponseHighlighter2 = Env.Colours.Black;
ResponseHighlighter=ones([width(Env.Colours.Black),height(ResponseOpts2)]);
%start =GetSecs;
blocks =1;
comprehensionpass=0;
LodgeAResponse =0;
displayincorrect =0;
%trigger
while comprehensionpass <3
    [keyIsDown]= KbQueueCheck(Env.MouseInfo{1,1}.index);
    [keyboardDown,~,whichkey]=KbCheck;
    [x,y] = GetMouse(Env.MainWindow);
    DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).FrameIndex =FrameIndex;

    switch DATA.useET
        case 0
            DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).SystemTime = GetSecs;
            DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).OnsetTime =  DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).SystemTime  -start;

        case 1
            switch true
                case isempty(CurrentSample)==1

                    DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).TobiiLeftEyePos = FirstPassET(1,end).LeftEye.GazePoint.OnDisplayArea;
                    DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).TobiiRightEyePos = FirstPassET(1,end).RightEye.GazePoint.OnDisplayArea;
                    DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).TobiiLeftEyePupil = FirstPassET(1,end).LeftEye.Pupil.Diameter;
                    DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).TobiiRightEyePupil = FirstPassET(1,end).LeftEye.Pupil.Diameter;
                    DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).TobiiTime = FirstPassET(1,end).SystemTimeStamp;


                case isempty(CurrentSample)==0

                    DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).TobiiLeftEyePos= CurrentSample(1,end).LeftEye.GazePoint.OnDisplayArea;
                    DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).TobiiRightEyePos  = CurrentSample(1,end).RightEye.GazePoint.OnDisplayArea;
                    DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).TobiiLeftEyePupil = CurrentSample(1,end).LeftEye.Pupil.Diameter;
                    DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).TobiiRightEyePupil = CurrentSample(1,end).LeftEye.Pupil.Diameter;
                    DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).TobiiTime = CurrentSample(1,end).SystemTimeStamp;


            end
            CurrentSample = my_eyetracker.get_gaze_data();

    end
    switch displayincorrect
        case 0
            switch Response
                case 1
                    DrawFormattedText(Env.MainWindow,sprintf('%s',Question1),'center',CentreJarOne(4)+100);

                    switch true
                        case (ismembertol(x,ResponseBoxCoords1(1,1):ResponseBoxCoords1(1,3))&& ismembertol(y,ResponseBoxCoords1(1,2):ResponseBoxCoords1(1,4)))
                            ResponseHighlighter1 = Env.Colours.Red;

                        case (ismembertol(x,ResponseBoxCoords1(2,1):ResponseBoxCoords1(2,3))&& ismembertol(y,ResponseBoxCoords1(2,2):ResponseBoxCoords1(2,4)))
                            ResponseHighlighter2 = Env.Colours.Red;

                    end
                    mask =[];
                    Screen('DrawTextures',Env.MainWindow,[Env.ExperimentOnePractice.ResponseOne],[],[ResponseBoxCoords1]',[],[],[],[ResponseHighlighter1;ResponseHighlighter2]');

                    ResponseHighlighter1 = Env.Colours.Black;
                    ResponseHighlighter2 = Env.Colours.Black;

                case 2
                    DrawFormattedText(Env.MainWindow,sprintf('%s',Question2),'center',CentreJarOne(4)+100);
                    highidx= ((x>=ResponseBoxCoords2(1,:)& x<=ResponseBoxCoords2(3,:))&((y>=ResponseBoxCoords2(2,:)&y<=ResponseBoxCoords2(4,:))));
                    switch true

                        case any(highidx==1)
                            ResponseHighlighter(:,highidx) = Env.Colours.Red';
                    end
                                        mask =[];

                    Screen('DrawTextures',Env.MainWindow,[Env.ExperimentOnePractice.ResponseTwo],[],[ResponseBoxCoords2],[],[],[],[ResponseHighlighter]);
                    ResponseHighlighter=ones([width(Env.Colours.Black),height(ResponseOpts2)]);

                case 3
                    DrawFormattedText(Env.MainWindow,'Check complete, Press ENTER to continue to practice trials','center','center',[],120,[],[],2);
                    mask =[0,0,0,0];

            end
        case 1
            DrawFormattedText(Env.MainWindow,sprintf('%s',incorrecttext),'center',CentreJarOne(4)+150);
    end

    switch true

        case (Response ==1 && any(keyIsDown==1) && ismembertol(x,ResponseBoxCoords1(1,1):ResponseBoxCoords1(1,3))&& ismembertol(y,ResponseBoxCoords1(1,2):ResponseBoxCoords1(1,4))&& comprehensionpass==0 );
            DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).Trigger = 113; % Response Given 113 - 1 represents experiment number and 3 represents Response to make decision for each trial in each block
            DATA.ExperimentOneComprehension(blocks).Block(1).ResponseAnswer="Incorrect";
            DATA.ExperimentOneComprehension(blocks).Block(1).ResponseRT=GetSecs-start;
            LodgeAResponse =LodgeAResponse+1;
            DATA.ExperimentOneComprehension(blocks).Block(1).NumIncorrectTries=LodgeAResponse;

            Response = 1; % Yes - which is incorrect, jars dont change
            displayincorrect =1;
            comprehensionpass =0;
        case (Response ==1 && any(keyIsDown==1) && ismembertol(x,ResponseBoxCoords1(2,1):ResponseBoxCoords1(2,3))&& ismembertol(y,ResponseBoxCoords1(2,2):ResponseBoxCoords1(2,4)) && comprehensionpass==0);
            DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).Trigger = 112; % Response Given 12 - 1 represents experiment number and 2 represents choice to see another bead for each trial in each block
            DATA.ExperimentOneComprehension(blocks).Block(1).ResponseAnswer="Correct";
            DATA.ExperimentOneComprehension(blocks).Block(1).ResponseRT=GetSecs-start;
            LodgeAResponse = LodgeAResponse;
            DATA.ExperimentOneComprehension(blocks).Block(1).NumIncorrectTries=LodgeAResponse;
            Response =2;
            displayincorrect =0;
            comprehensionpass=1;
        case (Response ==2 && any(keyIsDown==1) && (ismembertol(x,ResponseBoxCoords2(1,4):ResponseBoxCoords2(3,4))&& ~ismembertol(y,ResponseBoxCoords2(2,4):ResponseBoxCoords2(4,4)))&& comprehensionpass==1);
            DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).Trigger = 114; % Response Given 14 - 1 represents experiment number and 4 represents Response of A in each block
            DATA.ExperimentOneComprehension(blocks).Block(2).ResponseAnswer="Incorrect";
            DATA.ExperimentOneComprehension(blocks).Block(2).ResponseRT=GetSecs-start;
            LodgeAResponse =LodgeAResponse+1;
            DATA.ExperimentOneComprehension(blocks).Block(2).NumIncorrectTries=LodgeAResponse-DATA.ExperimentOneComprehension(blocks).Block(1).NumIncorrectTries;
            %             Response =2;
            displayincorrect =1;
            comprehensionpass=1;
        case (Response ==2 && any(keyIsDown==1) && ismembertol(x,ResponseBoxCoords2(1,4):ResponseBoxCoords2(3,4))&& ismembertol(y,ResponseBoxCoords2(2,4):ResponseBoxCoords2(4,4))&& comprehensionpass==1);
            DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).Trigger = 115; % Response Given 15 - 1 represents experiment number and 5 represents Response of B for each trial in each block
            DATA.ExperimentOneComprehension(blocks).Block(2).ResponseAnswer = "Correct";
            DATA.ExperimentOneComprehension(blocks).Block(2).ResponseRT=GetSecs-start;
            LodgeAResponse = LodgeAResponse;
            DATA.ExperimentOneComprehension(blocks).Block(2).NumIncorrectTries=LodgeAResponse-DATA.ExperimentOneComprehension(blocks).Block(1).NumIncorrectTries;
            Response =3;
            displayincorrect =0;
            comprehensionpass=2;
        case (displayincorrect==1 && keyboardDown==1 && KbName(whichkey)=="Return")
            displayincorrect=0;

        case (Response==3 && keyboardDown==1 && KbName(whichkey)=="Return")
            DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).Trigger = 115; % Response Given 15 - 1 represents experiment number and 5 represents Response of B for each trial in each block
            comprehensionpass=3;

    end



    Screen('DrawTextures',Env.MainWindow,[Env.PracticeJarTexture1;Env.PracticeJarTexture2],[],[CentreJarOne;CentreJarTwo]',[],[],[],mask);
    if Response<=2
  DrawFormattedText(Env.MainWindow,sprintf('Jar A\n85%% %s 15%% %s',JarAStr,JarBStr),CentreJarOne(1)+20,CentreJarOne(4)+20);
    DrawFormattedText(Env.MainWindow,sprintf('Jar B\n85%% %s 15%% %s',JarBStr,JarAStr),CentreJarTwo(1)+20,CentreJarTwo(4)+20);
    end
    Screen('DrawingFinished',Env.MainWindow);
    [FlipTime,~,EndFlip]=Screen('Flip',Env.MainWindow,[]);
    DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).FlipTimeStamp=FlipTime;
    FrameIndex=FrameIndex+1;


end



for blocks =1:1
    for PracticeTrials = 1:width(PracticeSequence) % The things that need to happen on each trial
        clear DispStim LodgeAResponse BreakMeOut Response
        DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).Trigger = 110; % Trigger Given 10 - 1 represents experiment number and 0 represents start of each trial in each block.

        DATA.ExperimentOnePractice(blocks).Block(PracticeTrials).CorrectResponseStr = TranslateCorrectJarAnswer(PracticeTrials,blocks);
        DATA.ExperimentOnePractice(blocks).Block(PracticeTrials).CorrectResponse = CounterPracPres(PracticeTrials,blocks);
        DATA.ExperimentOnePractice(blocks).Block(PracticeTrials).TrialSequence =PracticeSequence(:,PracticeTrials);
        DATA.ExperimentOnePractice(blocks).Block(PracticeTrials).NumBeadstoDecision = 1;

        WaitSecs(intertrialinterval);
        [FlipTime,~,EndFlip]=Screen('Flip',Env.MainWindow,[]);
        for Attempts =1:height(PracticeSequence)
            LodgeAResponse =0;
            Response = 1;
            BreakMeOut =0;
            DispStim(Attempts,1) = BeadTexture(Attempts,1);

            DispStim(Attempts,2)= cell({my_centreTexture(BeadSize(1),BeadSize(2),(Env.ScreenInfo.width*Attempts/17+250),Env.ScreenInfo.Centre(2)+50)});

            DispStim(Attempts,3)= PracticeSequence(Attempts,PracticeTrials);
            textures = cell2mat(DispStim(:,1));
            textures = transpose(textures);
            coordinates = cell2mat(DispStim(:, 2));
            coordinates= transpose(coordinates);
            colourmask = cell2mat(DispStim(:, 3));
            colourmask= transpose(colourmask);
            ResponseHighlighter1 = Env.Colours.Black;
            ResponseHighlighter2 = Env.Colours.Black;
            %             KbQueueCreate(Env.MouseInfo{1,1}.index,[],2);
            %             KbQueueStart(Env.MouseInfo{1,1}.index);
            CurrentSample =[];
            start =GetSecs;
            while LodgeAResponse <3
                [keyIsDown]= KbQueueCheck(Env.MouseInfo{1,1}.index);
                [x,y] = GetMouse(Env.MainWindow);
                DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).FrameIndex =FrameIndex;
                DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).FlipTimeStamp=FlipTime;
                switch DATA.useET
                    case 0
                        DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).SystemTime = GetSecs;
                        DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).OnsetTime =  DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).SystemTime  -start;

                    case 1
                        switch true
                            case isempty(CurrentSample)==1

                                DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).TobiiLeftEyePos = FirstPassET(1,end).LeftEye.GazePoint.OnDisplayArea;
                                DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).TobiiRightEyePos = FirstPassET(1,end).RightEye.GazePoint.OnDisplayArea;
                                DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).TobiiLeftEyePupil = FirstPassET(1,end).LeftEye.Pupil.Diameter;
                                DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).TobiiRightEyePupil = FirstPassET(1,end).LeftEye.Pupil.Diameter;
                                DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).TobiiTime = FirstPassET(1,end).SystemTimeStamp;


                            case isempty(CurrentSample)==0

                                DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).TobiiLeftEyePos= CurrentSample(1,end).LeftEye.GazePoint.OnDisplayArea;
                                DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).TobiiRightEyePos  = CurrentSample(1,end).RightEye.GazePoint.OnDisplayArea;
                                DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).TobiiLeftEyePupil = CurrentSample(1,end).LeftEye.Pupil.Diameter;
                                DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).TobiiRightEyePupil = CurrentSample(1,end).LeftEye.Pupil.Diameter;
                                DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).TobiiTime = CurrentSample(1,end).SystemTimeStamp;


                        end
                        CurrentSample = my_eyetracker.get_gaze_data();

                end

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
                Screen('DrawTextures',Env.MainWindow,[Env.PracticeJarTexture1;Env.PracticeJarTexture2],[],[CentreJarOne;CentreJarTwo]');

           DrawFormattedText(Env.MainWindow,sprintf('Jar A\n85%% %s 15%% %s',JarAStr,JarBStr),CentreJarOne(1)+20,CentreJarOne(4)+20);
    DrawFormattedText(Env.MainWindow,sprintf('Jar B\n85%% %s 15%% %s',JarBStr,JarAStr),CentreJarTwo(1)+20,CentreJarTwo(4)+20);
                Screen('DrawTextures',Env.MainWindow,textures,[],coordinates,[],[],[],colourmask);

                switch true
                    case Response ==3
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
                        Screen('DrawTextures',Env.MainWindow,[Env.ExperimentOne.ResponseOne(Response);Env.ExperimentOne.ResponseTwo(Response)],[],[ResponseBoxCoords]',[],[],[],[ResponseHighlighter1;ResponseHighlighter2]');

                end

                Screen('DrawingFinished',Env.MainWindow);


                switch true

                    case (any(keyIsDown==1) && ismembertol(x,ResponseBoxCoords(1,1):ResponseBoxCoords(1,3))&& ismembertol(y,ResponseBoxCoords(1,2):ResponseBoxCoords(1,4))&& Response ==1 && LodgeAResponse==0 );
                        DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).Trigger = 113; % Response Given 113 - 1 represents experiment number and 3 represents Response to make decision for each trial in each block

                        LodgeAResponse =1;
                        Response = 2; % Yes

                    case (any(keyIsDown==1) && ismembertol(x,ResponseBoxCoords(1,1):ResponseBoxCoords(1,3))&& ismembertol(y,ResponseBoxCoords(1,2):ResponseBoxCoords(1,4))&& Response ==2 &&LodgeAResponse==1);
                        DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).Trigger = 114; % Response Given 14 - 1 represents experiment number and 4 represents Response of A in each block
                        DATA.ExperimentOnePractice(blocks).Block(PracticeTrials).JarResponseAnswer="JarA";
                        DATA.ExperimentOnePractice(blocks).Block(PracticeTrials).JarResponseRT=GetSecs-start;
                        JarResponseSystemTime=GetSecs;

                        LodgeAResponse =2;
                        Response =3;


                    case (any(keyIsDown==1) && ismembertol(x,ResponseBoxCoords(2,1):ResponseBoxCoords(2,3))&& ismembertol(y,ResponseBoxCoords(2,2):ResponseBoxCoords(2,4)) && Response==1 && LodgeAResponse==0);
                        DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).Trigger = 112; % Response Given 12 - 1 represents experiment number and 2 represents choice to see another bead for each trial in each block

                        if DATA.ExperimentOnePractice(blocks).Block(PracticeTrials).NumBeadstoDecision <10
                            BreakMeOut = 1;
                            LodgeAResponse =0;
                            DATA.ExperimentOnePractice(blocks).Block(PracticeTrials).NumBeadstoDecision = DATA.ExperimentOnePractice(blocks).Block(PracticeTrials).NumBeadstoDecision+1;
                        else
                            BreakMeOut = 0;
                            LodgeAResponse =1;
                            Response = 2;
                            DATA.ExperimentOnePractice(blocks).Block(PracticeTrials).NumBeadstoDecision = DATA.ExperimentOnePractice(blocks).Block(PracticeTrials).NumBeadstoDecision+1;

                        end

                    case (any(keyIsDown==1) && ismembertol(x,ResponseBoxCoords(2,1):ResponseBoxCoords(2,3))&& ismembertol(y,ResponseBoxCoords(2,2):ResponseBoxCoords(2,4)) && Response ==2 && LodgeAResponse==1);
                        DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).Trigger = 115; % Response Given 15 - 1 represents experiment number and 5 represents Response of B for each trial in each block

                        DATA.ExperimentOnePractice(blocks).Block(PracticeTrials).JarResponseAnswer = "JarB";
                        DATA.ExperimentOnePractice(blocks).Block(PracticeTrials).JarResponseRT=GetSecs-start;
                        JarResponseSystemTime=GetSecs;
                        Response =3;
                        LodgeAResponse =2;

                    case (Response ==3 && any(keyIsDown==1) && ismembertol(x,LineDetails(1)-10:LineDetails(3))&& ismembertol(y,LineDetails(2)-20:LineDetails(4)+20)&& LodgeAResponse==2)
                        DATA.ExperimentOnePractice(blocks).Block(PracticeTrials).Confidence = NumberToDisplay;
                        DATA.ExperimentOnePractice(blocks).Block(PracticeTrials).ConfidenceRT = GetSecs-JarResponseSystemTime;

                        DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).Trigger = 116; % Response Given 16 - 1 represents experiment number and 6 represents confidence Response for each trial in each block

                        LodgeAResponse =3;
                    otherwise

                end

                ResponseHighlighter1 = Env.Colours.Black;
                ResponseHighlighter2 = Env.Colours.Black;





                if BreakMeOut ==1
                    break
                end
                ScreenFlipTime = FlipTime+(DATA.WaitFrameInput-0.5)*DATA.FlipInterval;
                FlipTime=  Screen('Flip',Env.MainWindow,ScreenFlipTime);
                %BIOSEMI HERE

                FrameIndex=FrameIndex+1;

            end

            if LodgeAResponse ==3
                break
            end
        end

    end
end
MoveOn=0;
while MoveOn~=1
    [keyboardDown,~,whichkey]=KbCheck;
    %trigger
    DrawFormattedText(Env.MainWindow,sprintf('%s',PracticeEndText),'center','center',[],120,[],[],2);
    Screen('DrawingFinished',Env.MainWindow);
    DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).FrameIndex =FrameIndex;

    switch DATA.useET
        case 0
            DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).SystemTime = GetSecs;
            DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).OnsetTime =  DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).SystemTime  -start;

        case 1
            switch true
                case isempty(CurrentSample)==1

                    DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).TobiiLeftEyePos = FirstPassET(1,end).LeftEye.GazePoint.OnDisplayArea;
                    DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).TobiiRightEyePos = FirstPassET(1,end).RightEye.GazePoint.OnDisplayArea;
                    DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).TobiiLeftEyePupil = FirstPassET(1,end).LeftEye.Pupil.Diameter;
                    DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).TobiiRightEyePupil = FirstPassET(1,end).LeftEye.Pupil.Diameter;
                    DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).TobiiTime = FirstPassET(1,end).SystemTimeStamp;


                case isempty(CurrentSample)==0

                    DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).TobiiLeftEyePos= CurrentSample(1,end).LeftEye.GazePoint.OnDisplayArea;
                    DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).TobiiRightEyePos  = CurrentSample(1,end).RightEye.GazePoint.OnDisplayArea;
                    DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).TobiiLeftEyePupil = CurrentSample(1,end).LeftEye.Pupil.Diameter;
                    DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).TobiiRightEyePupil = CurrentSample(1,end).LeftEye.Pupil.Diameter;
                    DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).TobiiTime = CurrentSample(1,end).SystemTimeStamp;


            end
            CurrentSample = my_eyetracker.get_gaze_data();

    end

    if (keyboardDown ==1 && KbName(whichkey)=="Return")
        MoveOn=1;
        %trigger
    end
    [FlipTime,~,EndFlip]=Screen('Flip',Env.MainWindow,[]);
                    DATA.ExperimentOnePractice(blocks).EyeData(FrameIndex).FlipTimeStamp=FlipTime;

    FrameIndex =FrameIndex+1;
end
        KbReleaseWait;

end