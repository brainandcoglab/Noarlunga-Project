%Written by Tess Barich 2022
function Exp2ComprehensionCheck(window,window2,PracticeColourA,PracticeColourStrA,BoxColour,PracticeColourB,PracticeColourStrB,Question1,Question2,Question3,ResponseOpts1,ResponseOpts2,PracticeInstructs,ResponseBoxColour)
global Env DATA ResponseBoxCoords4 QuestionQuote ConfidenceQuote LowAnchor HighAnchor LineLength LineDivide ResponseBoxCoords1
intertrialinterval =0.5;
blocks =1;
nMaxAttempts=26;
BoxesToOpen=13;
BoxHighlight =Env.Colours.DarkGrey;
incorrecttext = "Your answer is INCORRECT, please press ENTER to try again.";
PracticeEndText =["The practice trial is complete. There will now follow four sets of four trials each. " + ...
    "Remember for each game, one of the two colours will be randomly selected, but you will not be told which one. " + ...
    "Your task is to request enough boxes in order to decide which colour was selected. " + ...
    "You can continue requesting boxes until the maximum number of boxes on the screen is reached or until you feel confident about making a decision. " + ...
    "Press ENTER when you are ready to start."];



Xposi(1:height(ResponseOpts2),1)=Env.ScreenInfo.Centre(1);
Yposi=zeros([height(ResponseOpts2),1]);
Yposi2=zeros([height(ResponseOpts2),1]);
for NumofQs =1:2
    [~,TextYPos] =DrawFormattedText(Env.OffScreenWindow,sprintf('%s',Question1),'center',Env.ExperimentTwoPractice.MinMaxXY(4,1)+40);
        [~,TextYPos2] =DrawFormattedText(Env.OffScreenWindow,sprintf('%s',Question1),'center',Env.ExperimentTwo.MinMaxXY(4,1)+40);

    addY=70;
    for NumofResponses =1: height(ResponseOpts2)
        Yposi(NumofResponses)= TextYPos+addY;
                Yposi2(NumofResponses)= TextYPos2+addY;

        
        addY=addY+110;
    end
        %[ResponseBoxCoords1,Env.ExperimentTwoPractice.ResponseOne(1),Env.ExperimentTwoPractice.ResponseOne(2)]= BuildMyResponseBoxes(Env.MainWindow,Env.OffScreenWindow,2,[ResponseOpts1],ResponseBoxColour,3,[Xposi],[Yposi],400,100,12,16);
end
    [ResponseBoxCoords1,Env.ExperimentTwoPractice.ResponseOne(1),Env.ExperimentTwoPractice.ResponseOne(2)]= BuildMyResponseBoxes(Env.MainWindow,Env.OffScreenWindow,2,[ResponseOpts1],ResponseBoxColour,3,[Xposi],[Yposi2],400,100,12,16);
    [ResponseBoxCoords2,Env.ExperimentTwoPractice.ResponseTwo]= BuildMyResponseBoxes(Env.MainWindow,Env.OffScreenWindow,5,[ResponseOpts2],ResponseBoxColour,3,[Xposi],[Yposi],400,100,30,16);

%end
CounterPracPres = randperm(2)';
PracticeSequence(:,CounterPracPres(1)) = [{'A'};{'A'};{'A'};{'B'};{'A'};{'A'};{'A'};{'A'};{'A'};{'B'};{'A'};{'A'};{'A'};{'B'};{'A'};{'A'};{'A'};{'A'};{'A'};{'B'};{'A'};{'A'};{'A'};{'B'};{'A'}];
PracticeSequence(:,CounterPracPres(2)) = [{'B'};{'B'};{'B'};{'A'};{'B'};{'B'};{'B'};{'B'};{'B'};{'A'};{'B'};{'B'};{'B'};{'A'};{'B'};{'B'};{'B'};{'B'};{'B'};{'A'};{'B'};{'B'};{'B'};{'A'};{'B'}];

ColourBoxA = PracticeColourA;
ColourBoxAStr = PracticeColourStrA;
ColourBoxB = PracticeColourB;
ColourBoxBStr = PracticeColourStrB;
DATA.ExperimentTwoPracticeSeqs.Str=PracticeSequence;
AnswerQuote1 = ColourBoxAStr;
AnswerQuote2 = ColourBoxBStr;
Change2Colour =strcmp(PracticeSequence,{'A'});
PracticeSequence(Change2Colour)={ColourBoxA};
Change2Colour2=strcmp(PracticeSequence,{'B'});
PracticeSequence(Change2Colour2)={ColourBoxB};
DATA.ExperimentTwoPracticeSeqs.Colour=PracticeSequence;

TranslateCorrectColourAAnswerIdx(:) = CounterPracPres(:)==1 ;%1 =  A is the answer
TranslateCorrectColourBAnswerIdx(:) = CounterPracPres(:)==2; %2 =  B is the answer
TranslateCorrectColourBoxAnswer(TranslateCorrectColourAAnswerIdx(:),1) = "Colour A";
TranslateCorrectColourBoxAnswer(TranslateCorrectColourBAnswerIdx(:),1) ="Colour B";

colourexamplepickidx = randperm(25,BoxesToOpen);
AorBcolourdecide = randsrc(BoxesToOpen,1,[1,2;0.85,0.15]);
change2colourA(:)=AorBcolourdecide(:)==1;
change2colourB(:)=AorBcolourdecide(:)==2;
colour1 = zeros([width(BoxColour),width(Env.ExperimentTwoPractice.Coordinates)]);
for colourfill =1:width(colour1)
    colour1(:,colourfill)= BoxColour(:);
end
for i = 1:width(change2colourB)
    if change2colourA(i)==1
        colour1(:,colourexamplepickidx(i),(change2colourA(i)))=ColourBoxA(:);
    end
    if change2colourB(i)==1
        colour1(:,colourexamplepickidx(i),(change2colourB(i))) =ColourBoxB(:);
    end
end


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
    DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).FrameIndex =FrameIndex;
    %trigger
    DrawFormattedText(Env.MainWindow,sprintf('%s',PracticeInstructs),'center',TextYPos,[],120,[],[],2);
    Screen('FillRect',window,colour1,Env.ExperimentTwoPractice.Coordinates);

    Screen('DrawingFinished',window);

    switch DATA.useET
        case 0
            DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).SystemTime = GetSecs;
            DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).OnsetTime =  DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).SystemTime  -start;

        case 1
            switch true
                case isempty(CurrentSample)==1

                    DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).TobiiLeftEyePos = FirstPassET(1,end).LeftEye.GazePoint.OnDisplayArea;
                    DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).TobiiRightEyePos = FirstPassET(1,end).RightEye.GazePoint.OnDisplayArea;
                    DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).TobiiLeftEyePupil = FirstPassET(1,end).LeftEye.Pupil.Diameter;
                    DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).TobiiRightEyePupil = FirstPassET(1,end).LeftEye.Pupil.Diameter;
                    DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).TobiiTime = FirstPassET(1,end).SystemTimeStamp;


                case isempty(CurrentSample)==0

                    DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).TobiiLeftEyePos= CurrentSample(1,end).LeftEye.GazePoint.OnDisplayArea;
                    DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).TobiiRightEyePos  = CurrentSample(1,end).RightEye.GazePoint.OnDisplayArea;
                    DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).TobiiLeftEyePupil = CurrentSample(1,end).LeftEye.Pupil.Diameter;
                    DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).TobiiRightEyePupil = CurrentSample(1,end).LeftEye.Pupil.Diameter;
                    DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).TobiiTime = CurrentSample(1,end).SystemTimeStamp;


            end
            CurrentSample = my_eyetracker.get_gaze_data();

    end

    if (keyboardDown ==1 && KbName(whichkey)=="Return")
        MoveOn=1;
        %trigger
    end
    [FlipTime,~,EndFlip]=Screen('Flip',Env.MainWindow,[]);
    DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).FlipTimeStamp=FlipTime;

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
while comprehensionpass <4
    [keyIsDown]= KbQueueCheck(Env.MouseInfo{1,1}.index);
    [keyboardDown,~,whichkey]=KbCheck;
    [x,y] = GetMouse(Env.MainWindow);
    DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).FrameIndex =FrameIndex;

    switch DATA.useET
        case 0
            DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).SystemTime = GetSecs;
            DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).OnsetTime =  DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).SystemTime  -start;

        case 1
            switch true
                case isempty(CurrentSample)==1

                    DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).TobiiLeftEyePos = FirstPassET(1,end).LeftEye.GazePoint.OnDisplayArea;
                    DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).TobiiRightEyePos = FirstPassET(1,end).RightEye.GazePoint.OnDisplayArea;
                    DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).TobiiLeftEyePupil = FirstPassET(1,end).LeftEye.Pupil.Diameter;
                    DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).TobiiRightEyePupil = FirstPassET(1,end).LeftEye.Pupil.Diameter;
                    DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).TobiiTime = FirstPassET(1,end).SystemTimeStamp;


                case isempty(CurrentSample)==0

                    DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).TobiiLeftEyePos= CurrentSample(1,end).LeftEye.GazePoint.OnDisplayArea;
                    DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).TobiiRightEyePos  = CurrentSample(1,end).RightEye.GazePoint.OnDisplayArea;
                    DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).TobiiLeftEyePupil = CurrentSample(1,end).LeftEye.Pupil.Diameter;
                    DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).TobiiRightEyePupil = CurrentSample(1,end).LeftEye.Pupil.Diameter;
                    DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).TobiiTime = CurrentSample(1,end).SystemTimeStamp;


            end
            CurrentSample = my_eyetracker.get_gaze_data();

    end
    switch displayincorrect
        case 0
            switch Response
                case 1
                    DrawFormattedText(Env.MainWindow,sprintf('%s',Question1),'center',TextYPos);

                    switch true
                        case (ismembertol(x,ResponseBoxCoords1(1,1):ResponseBoxCoords1(1,3))&& ismembertol(y,ResponseBoxCoords1(1,2):ResponseBoxCoords1(1,4)))
                            ResponseHighlighter1 = Env.Colours.Red;

                        case (ismembertol(x,ResponseBoxCoords1(2,1):ResponseBoxCoords1(2,3))&& ismembertol(y,ResponseBoxCoords1(2,2):ResponseBoxCoords1(2,4)))
                            ResponseHighlighter2 = Env.Colours.Red;

                    end
                    mask =[];
                    Screen('DrawTextures',Env.MainWindow,[Env.ExperimentTwoPractice.ResponseOne],[],[ResponseBoxCoords1]',[],[],[],[ResponseHighlighter1;ResponseHighlighter2]');

                    ResponseHighlighter1 = Env.Colours.Black;
                    ResponseHighlighter2 = Env.Colours.Black;
                case 2
                    DrawFormattedText(Env.MainWindow,sprintf('%s',Question2),'center',TextYPos);

                    switch true
                        case (ismembertol(x,ResponseBoxCoords1(1,1):ResponseBoxCoords1(1,3))&& ismembertol(y,ResponseBoxCoords1(1,2):ResponseBoxCoords1(1,4)))
                            ResponseHighlighter1 = Env.Colours.Red;

                        case (ismembertol(x,ResponseBoxCoords1(2,1):ResponseBoxCoords1(2,3))&& ismembertol(y,ResponseBoxCoords1(2,2):ResponseBoxCoords1(2,4)))
                            ResponseHighlighter2 = Env.Colours.Red;

                    end
                    mask =[];
                    Screen('DrawTextures',Env.MainWindow,[Env.ExperimentTwoPractice.ResponseOne],[],[ResponseBoxCoords1]',[],[],[],[ResponseHighlighter1;ResponseHighlighter2]');

                    ResponseHighlighter1 = Env.Colours.Black;
                    ResponseHighlighter2 = Env.Colours.Black;
                case 3
                    DrawFormattedText(Env.MainWindow,sprintf('%s',Question3),'center',TextYPos);
                    highidx= ((x>=ResponseBoxCoords2(1,:)& x<=ResponseBoxCoords2(3,:))&((y>=ResponseBoxCoords2(2,:)&y<=ResponseBoxCoords2(4,:))));
                    switch true
                        case any(highidx==1)
                            ResponseHighlighter(:,highidx) = Env.Colours.Red';
                    end
                    mask =[];

                    Screen('DrawTextures',Env.MainWindow,[Env.ExperimentTwoPractice.ResponseTwo],[],[ResponseBoxCoords2],[],[],[],[ResponseHighlighter]);
                    ResponseHighlighter=ones([width(Env.Colours.Black),height(ResponseOpts2)]);

                case 4
                    DrawFormattedText(Env.MainWindow,'Check complete, Press ENTER to continue to practice trials','center','center',[],120,[],[],2);
                    mask =[0,0,0,0];

            end
        case 1
            DrawFormattedText(Env.MainWindow,sprintf('%s',incorrecttext),'center',TextYPos);
    end

    switch true

        case (Response ==1 && any(keyIsDown==1) && ismembertol(x,ResponseBoxCoords1(1,1):ResponseBoxCoords1(1,3))&& ismembertol(y,ResponseBoxCoords1(1,2):ResponseBoxCoords1(1,4))&& comprehensionpass==0 );
            DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).Trigger = 113; % Response Given 113 - 1 represents experiment number and 3 represents Response to make decision for each trial in each block
            DATA.ExperimentTwoComprehension(blocks).Block(1).ResponseAnswer="Incorrect";
            DATA.ExperimentTwoComprehension(blocks).Block(1).ResponseRT=GetSecs-start;
            LodgeAResponse =LodgeAResponse+1;
            DATA.ExperimentTwoComprehension(blocks).Block(1).NumIncorrectTries=LodgeAResponse;

            Response = 1; % Yes - which is incorrect, boxes dont close once opened
            displayincorrect =1;
            comprehensionpass =0;
        case (Response ==1 && any(keyIsDown==1) && ismembertol(x,ResponseBoxCoords1(2,1):ResponseBoxCoords1(2,3))&& ismembertol(y,ResponseBoxCoords1(2,2):ResponseBoxCoords1(2,4)) && comprehensionpass==0);
            DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).Trigger = 112; % Response Given 12 - 1 represents experiment number and 2 represents choice to see another bead for each trial in each block
            DATA.ExperimentTwoComprehension(blocks).Block(1).ResponseAnswer="Correct";
            DATA.ExperimentTwoComprehension(blocks).Block(1).ResponseRT=GetSecs-start;
            LodgeAResponse = LodgeAResponse;
            DATA.ExperimentTwoComprehension(blocks).Block(1).NumIncorrectTries=LodgeAResponse;
            Response =2;
            displayincorrect =0;
            comprehensionpass=1;

        case (Response ==2 && any(keyIsDown==1) && ismembertol(x,ResponseBoxCoords1(1,1):ResponseBoxCoords1(1,3))&& ismembertol(y,ResponseBoxCoords1(1,2):ResponseBoxCoords1(1,4))&& comprehensionpass==1);
            DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).Trigger = 113; % Response Given 113 - 1 represents experiment number and 3 represents Response to make decision for each trial in each block
            DATA.ExperimentTwoComprehension(blocks).Block(2).ResponseAnswer="Correct";
            DATA.ExperimentTwoComprehension(blocks).Block(2).ResponseRT=GetSecs-start;
            LodgeAResponse =LodgeAResponse;
            DATA.ExperimentTwoComprehension(blocks).Block(2).NumIncorrectTries=LodgeAResponse-DATA.ExperimentTwoComprehension(blocks).Block(1).NumIncorrectTries;

            Response = 3; % Yes - they change colour once opened
            displayincorrect =0;
            comprehensionpass =2;

        case (Response ==2 && any(keyIsDown==1) && ismembertol(x,ResponseBoxCoords1(2,1):ResponseBoxCoords1(2,3))&& ismembertol(y,ResponseBoxCoords1(2,2):ResponseBoxCoords1(2,4)) && comprehensionpass==1);
            DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).Trigger = 112; % Response Given 12 - 1 represents experiment number and 2 represents choice to see another bead for each trial in each block
            DATA.ExperimentTwoComprehension(blocks).Block(2).ResponseAnswer="Incorrect";
            DATA.ExperimentTwoComprehension(blocks).Block(2).ResponseRT=GetSecs-start;
            LodgeAResponse = LodgeAResponse+1;
            DATA.ExperimentTwoComprehension(blocks).Block(2).NumIncorrectTries=LodgeAResponse;
            Response =2;
            displayincorrect =1;
            comprehensionpass=comprehensionpass;

        case (Response ==3 && any(keyIsDown==1) && (ismembertol(x,ResponseBoxCoords2(1,4):ResponseBoxCoords2(3,4))&& ~ismembertol(y,ResponseBoxCoords2(2,4):ResponseBoxCoords2(4,4)))&& comprehensionpass==2);
            DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).Trigger = 114; % Response Given 14 - 1 represents experiment number and 4 represents Response of A in each block
            DATA.ExperimentTwoComprehension(blocks).Block(3).ResponseAnswer="Incorrect";
            DATA.ExperimentTwoComprehension(blocks).Block(3).ResponseRT=GetSecs-start;
            LodgeAResponse =LodgeAResponse+1;
            DATA.ExperimentTwoComprehension(blocks).Block(3).NumIncorrectTries=LodgeAResponse-DATA.ExperimentTwoComprehension(blocks).Block(1).NumIncorrectTries;
            %             Response =2;
            displayincorrect =1;
            comprehensionpass=comprehensionpass;

        case (Response ==3 && any(keyIsDown==1) && ismembertol(x,ResponseBoxCoords2(1,4):ResponseBoxCoords2(3,4))&& ismembertol(y,ResponseBoxCoords2(2,4):ResponseBoxCoords2(4,4))&& comprehensionpass==2);
            DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).Trigger = 115; % Response Given 15 - 1 represents experiment number and 5 represents Response of B for each trial in each block
            DATA.ExperimentTwoComprehension(blocks).Block(3).ResponseAnswer = "Correct";
            DATA.ExperimentTwoComprehension(blocks).Block(3).ResponseRT=GetSecs-start;
            LodgeAResponse = LodgeAResponse;
            DATA.ExperimentTwoComprehension(blocks).Block(3).NumIncorrectTries=LodgeAResponse-DATA.ExperimentTwoComprehension(blocks).Block(2).NumIncorrectTries;
            Response =4;
            displayincorrect =0;
            comprehensionpass=3;

        case (displayincorrect==1 && keyboardDown==1 && KbName(whichkey)=="Return")
            displayincorrect=0;

        case (Response==4 && keyboardDown==1 && KbName(whichkey)=="Return")
            DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).Trigger = 115; % Response Given 15 - 1 represents experiment number and 5 represents Response of B for each trial in each block
            comprehensionpass=4;

    end

    Screen('FillRect',window,colour1,Env.ExperimentTwoPractice.Coordinates);
    Screen('DrawingFinished',Env.MainWindow);
    [FlipTime,~,EndFlip]=Screen('Flip',Env.MainWindow,[]);
    DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).FlipTimeStamp=FlipTime;
    FrameIndex=FrameIndex+1;


end



for blocks =1:1
    for PracticeTrials =1:width(PracticeSequence)
        TranslateCorrectColour(TranslateCorrectColourAAnswerIdx(:,PracticeTrials),PracticeTrials) = AnswerQuote1;
        TranslateCorrectColour(TranslateCorrectColourBAnswerIdx(:,PracticeTrials),PracticeTrials) =AnswerQuote2;
        DATA.ExperimentTwoPractice(blocks).Block(PracticeTrials).CorrectResponseColour = TranslateCorrectColourBoxAnswer(PracticeTrials,blocks);
        DATA.ExperimentTwoPractice(blocks).Block(PracticeTrials).CorrectResponseBox = TranslateCorrectColour(blocks,PracticeTrials);
        DATA.ExperimentTwoPractice(blocks).Sequence(PracticeTrials).TrialSequence =PracticeSequence(:,PracticeTrials);
        DATA.ExperimentTwoPractice(blocks).Block(PracticeTrials).NumBoxtoDecision = 0;
        Response=1;
        LodgeAResponse =0;
        colour = zeros([width(BoxColour),width(Env.ExperimentTwoPractice.Coordinates)]);
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
                    case (ismembertol(x,ResponseBoxCoords4(1,1):ResponseBoxCoords4(1,3))&& ismembertol(y,ResponseBoxCoords4(1,2):ResponseBoxCoords4(1,4)))
                        ResponseHighlighter1 = BoxColour;

                    case (ismembertol(x,ResponseBoxCoords4(2,1):ResponseBoxCoords4(2,3))&& ismembertol(y,ResponseBoxCoords4(2,2):ResponseBoxCoords4(2,4)))
                        ResponseHighlighter2 = BoxColour;


                end
                Env.HighlightIdx = (Response==1 & x>= Env.ExperimentTwoPractice.Coordinates(1,:) & x<= Env.ExperimentTwoPractice.Coordinates(3,:) & y>= Env.ExperimentTwoPractice.Coordinates(2,:) & y<= Env.ExperimentTwoPractice.Coordinates(4,:));
                checkcolour = (ismember(colour(:,1:end),BoxColour) & Env.HighlightIdx==1);
                logictest =any(checkcolour==1);
                switch true
                    case       (any(logictest==1))
                        colour(:,logictest)=[BoxHighlight'];
                end


                CoordinatesIdx = (keyIsDown==1 & x>= Env.ExperimentTwoPractice.Coordinates(1,:) & x<= Env.ExperimentTwoPractice.Coordinates(3,:) & y>= Env.ExperimentTwoPractice.Coordinates(2,:) & y<= Env.ExperimentTwoPractice.Coordinates(4,:));

                switch true
                    case any(CoordinatesIdx==1) && Response==1

                        if DATA.ExperimentTwoPractice(blocks).Block(PracticeTrials).NumBoxtoDecision <25
                            colour(:,CoordinatesIdx)=cell2mat(PracticeSequence(Attempts,PracticeTrials))';
                            BreakMeOut = 1;
                            LodgeAResponse =0;
                            DATA.ExperimentTwoPractice(blocks).Block(PracticeTrials).NumBoxtoDecision = DATA.ExperimentTwoPractice(blocks).Block(PracticeTrials).NumBoxtoDecision+1;
                        else
                            BreakMeOut = 0;
                            LodgeAResponse =0;
                            DATA.ExperimentTwoPractice(blocks).Block(PracticeTrials).NumBoxtoDecision = nMaxAttempts;%DATA.ExperimentTwoPractice(blocks).Block(Trials).NumBoxtoDecision+1;
                        end
                    case (DATA.ExperimentTwoPractice(blocks).Block(PracticeTrials).NumBoxtoDecision>0 && any(keyIsDown==1) && ismembertol(x,ResponseBoxCoords4(1,1):ResponseBoxCoords4(1,3))&& ismembertol(y,ResponseBoxCoords4(1,2):ResponseBoxCoords4(1,4))&& Response ==1 &&LodgeAResponse==0);
                        DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).Trigger = 114; % Response Given 14 - 1 represents experiment number and 4 represents Response of A in each block
                        DATA.ExperimentTwoPractice(blocks).Block(PracticeTrials).BoxResponseAnswer="ColourA";
                        DATA.ExperimentTwoPractice(blocks).Block(PracticeTrials).BoxResponseColour=AnswerQuote1;
                        DATA.ExperimentTwoPractice(blocks).Block(PracticeTrials).ResponseRT=GetSecs-start;
                        ResponseSystemTime=GetSecs;
                        LodgeAResponse =1;
                        Response =2;
                    case (DATA.ExperimentTwoPractice(blocks).Block(PracticeTrials).NumBoxtoDecision>0 && any(keyIsDown==1) && ismembertol(x,ResponseBoxCoords4(2,1):ResponseBoxCoords4(2,3))&& ismembertol(y,ResponseBoxCoords4(2,2):ResponseBoxCoords4(2,4)) && Response ==1 && LodgeAResponse==0);
                        DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).Trigger = 115; % Response Given 15 - 1 represents experiment number and 5 represents Response of B for each trial in each block
                        DATA.ExperimentTwoPractice(blocks).Block(PracticeTrials).BoxResponseAnswer = "ColourB";
                        DATA.ExperimentTwoPractice(blocks).Block(PracticeTrials).BoxResponseColour=AnswerQuote2;
                        DATA.ExperimentTwoPractice(blocks).Block(PracticeTrials).ResponseRT=GetSecs-start;
                        ResponseSystemTime=GetSecs;
                        LodgeAResponse =1;
                        Response =2;
                    case (Response ==2 && any(keyIsDown==1) && ismembertol(x,LineDetails(1)-10:LineDetails(3))&& ismembertol(y,LineDetails(2)-20:LineDetails(4)+20)&& LodgeAResponse==1)
                        DATA.ExperimentTwoPractice(blocks).Block(PracticeTrials).Confidence = NumberToDisplay;
                        DATA.ExperimentTwoPractice(blocks).Block(PracticeTrials).ConfidenceRT = GetSecs-ResponseSystemTime;

                        DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).Trigger = 116; % Response Given 16 - 1 represents experiment number and 6 represents confidence Response for each trial in each block

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
                        Screen('DrawTextures',Env.MainWindow,[Env.ExperimentTwoPractice.ResponseThree(Response);Env.ExperimentTwoPractice.ResponseFour(Response)],[],[ResponseBoxCoords4]',[],[],[],[ResponseHighlighter1;ResponseHighlighter2]');


                end

                Screen('FillRect',Env.MainWindow,colour,Env.ExperimentTwoPractice.Coordinates);
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
                        DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).SystemTime = GetSecs;
                        DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).OnsetTime =  DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).SystemTime  -start;

                    case 1
                        switch true
                            case isempty(CurrentSample)==1

                                DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).TobiiLeftEyePos = FirstPassET(1,end).LeftEye.GazePoint.OnDisplayArea;
                                DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).TobiiRightEyePos = FirstPassET(1,end).RightEye.GazePoint.OnDisplayArea;
                                DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).TobiiLeftEyePupil = FirstPassET(1,end).LeftEye.Pupil.Diameter;
                                DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).TobiiRightEyePupil = FirstPassET(1,end).LeftEye.Pupil.Diameter;
                                DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).TobiiTime = FirstPassET(1,end).SystemTimeStamp;


                            case isempty(CurrentSample)==0

                                DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).TobiiLeftEyePos= CurrentSample(1,end).LeftEye.GazePoint.OnDisplayArea;
                                DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).TobiiRightEyePos  = CurrentSample(1,end).RightEye.GazePoint.OnDisplayArea;
                                DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).TobiiLeftEyePupil = CurrentSample(1,end).LeftEye.Pupil.Diameter;
                                DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).TobiiRightEyePupil = CurrentSample(1,end).LeftEye.Pupil.Diameter;
                                DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).TobiiTime = CurrentSample(1,end).SystemTimeStamp;
                        end
                        CurrentSample = my_eyetracker.get_gaze_data();

                end

                if BreakMeOut ==1
                    break
                end
                ScreenFlipTime = FlipTime+(DATA.WaitFrameInput-0.5)*DATA.FlipInterval;
                FlipTime=  Screen('Flip',Env.MainWindow,ScreenFlipTime);
                %BIOSEMI HERE
                DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).FrameIndex =FrameIndex;
                DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).FlipTimeStamp=FlipTime;
                FrameIndex=FrameIndex+1;

                if BreakMeOut ==1
                    break
                end


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
    DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).FrameIndex =FrameIndex;

    switch DATA.useET
        case 0
            DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).SystemTime = GetSecs;
            DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).OnsetTime =  DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).SystemTime  -start;

        case 1
            switch true
                case isempty(CurrentSample)==1

                    DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).TobiiLeftEyePos = FirstPassET(1,end).LeftEye.GazePoint.OnDisplayArea;
                    DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).TobiiRightEyePos = FirstPassET(1,end).RightEye.GazePoint.OnDisplayArea;
                    DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).TobiiLeftEyePupil = FirstPassET(1,end).LeftEye.Pupil.Diameter;
                    DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).TobiiRightEyePupil = FirstPassET(1,end).LeftEye.Pupil.Diameter;
                    DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).TobiiTime = FirstPassET(1,end).SystemTimeStamp;


                case isempty(CurrentSample)==0

                    DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).TobiiLeftEyePos= CurrentSample(1,end).LeftEye.GazePoint.OnDisplayArea;
                    DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).TobiiRightEyePos  = CurrentSample(1,end).RightEye.GazePoint.OnDisplayArea;
                    DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).TobiiLeftEyePupil = CurrentSample(1,end).LeftEye.Pupil.Diameter;
                    DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).TobiiRightEyePupil = CurrentSample(1,end).LeftEye.Pupil.Diameter;
                    DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).TobiiTime = CurrentSample(1,end).SystemTimeStamp;


            end
            CurrentSample = my_eyetracker.get_gaze_data();

    end

    if (keyboardDown ==1 && KbName(whichkey)=="Return")
        MoveOn=1;
        %trigger
    end
    [FlipTime,~,EndFlip]=Screen('Flip',Env.MainWindow,[]);
    DATA.ExperimentTwoPractice(blocks).EyeData(FrameIndex).FlipTimeStamp=FlipTime;

    FrameIndex =FrameIndex+1;
end
KbReleaseWait;

end