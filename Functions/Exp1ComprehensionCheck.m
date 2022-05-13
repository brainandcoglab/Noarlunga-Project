%Written by Tess Barich 2022
function Exp1ComprehensionCheck(Directory,window,window2,PracticeColourA,PracticeColourStrA,PracticeColourB,PracticeColourStrB,MainColourNumber,SecondaryColour,experimentStr,Question1,Question2,ResponseOpts1,ResponseOpts2,PracticeInstructs,ResponseBoxColour)
global Env Jar Bead ResponseBoxCoords BeadSize QuestionQuote1 QuestionQuote2 ConfidenceQuote LowAnchor HighAnchor LineLength LineDivide ResponseBoxCoords1
global DATA MyEyeTracker sp TimeStamps OverallGazeData TobiiOperations
Screen('TextColor',Env.MainWindow,Env.Colours.Black);
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
end
[ResponseBoxCoords1,Env.ExperimentOnePractice.ResponseOne(1),Env.ExperimentOnePractice.ResponseOne(2)]= BuildMyResponseBoxes(Env.MainWindow,Env.OffScreenWindow,2,[ResponseOpts1],ResponseBoxColour,3,[Xposi],[Yposi],400,100,12,16);
[ResponseBoxCoords2,Env.ExperimentOnePractice.ResponseTwo]= BuildMyResponseBoxes(Env.MainWindow,Env.OffScreenWindow,5,[ResponseOpts2],ResponseBoxColour,3,[Xposi],[Yposi],400,100,30,16);


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

MoveOn=0;
FrameIndex=1;
KbQueueCreate(Env.MouseInfo{1,1}.index,[],2);
KbQueueStart(Env.MouseInfo{1,1}.index);
start =GetSecs;
TriggerToSend=Env.Triggers.Comprehension.InstructionsStart;
while MoveOn~=1
    [keyboardDown,~,whichkey]=KbCheck;

    %trigger
    DrawFormattedText(Env.MainWindow,sprintf('%s',PracticeInstructs),'center',CentreJarOne(4)+150,[],120,[],[],2);
    Screen('DrawTextures',Env.MainWindow,[Env.PracticeJarTexture1;Env.PracticeJarTexture2],[],[CentreJarOne;CentreJarTwo]');
    DrawFormattedText(Env.MainWindow,sprintf('Jar A\n85%% %s 15%% %s',JarAStr,JarBStr),CentreJarOne(1)+20,CentreJarOne(4)+20);
    DrawFormattedText(Env.MainWindow,sprintf('Jar B\n85%% %s 15%% %s',JarBStr,JarAStr),CentreJarTwo(1)+20,CentreJarTwo(4)+20);
    Screen('DrawingFinished',Env.MainWindow);

    if (keyboardDown ==1 && KbName(whichkey)=="Return")
        MoveOn=1;
        TriggerToSend=Env.Triggers.Comprehension.InstructionsEnd;
    end
   
   [FlipTime,~,EndFlip]=Screen('Flip',Env.MainWindow,[]);
    
   switch DATA.useEEG
       case 1
        switch true
            case FrameIndex==1
                sp.sendTrigger(TriggerToSend); % trigger
            case MoveOn==1
                sp.sendTrigger(TriggerToSend); % trigger

        end
    end

    switch DATA.useET
        case 1
            switch true
                case FrameIndex==1
                    TimeStamps(end+1,1) =TobiiOperations.get_system_time_stamp;
                    TimeStamps(end,2)= TriggerToSend;
                case MoveOn==1
                    TimeStamps(end+1,1) =TobiiOperations.get_system_time_stamp;
                    TimeStamps(end,2)= TriggerToSend;
            end
    end
            TriggerToSend=0;

    FrameIndex =FrameIndex+1;

end
Response =1;
ResponseHighlighter1 = Env.Colours.Black;
ResponseHighlighter2 = Env.Colours.Black;
ResponseHighlighter=ones([width(Env.Colours.Black),height(ResponseOpts2)]);
start =GetSecs;
blocks =1;
comprehensionpass=0;
LodgeAResponse =0;
displayincorrect =0;
DATA.ExperimentOneComprehension(1).ParticipantNum = DATA.participantNum;
DATA.ExperimentOneComprehension(1).ParticipantAge = DATA.participantAge;
DATA.ExperimentOneComprehension(1).ParticipantGen = DATA.participantGen;
DATA.ExperimentOneComprehension(1).ParticipantHan = DATA.participantHan;
DATA.ExperimentOneComprehension(2).ParticipantNum = DATA.participantNum;
DATA.ExperimentOneComprehension(2).ParticipantAge = DATA.participantAge;
DATA.ExperimentOneComprehension(2).ParticipantGen = DATA.participantGen;
DATA.ExperimentOneComprehension(2).ParticipantHan = DATA.participantHan;
FrameIndex=1;
EEGPass=0;
TriggerToSend=Env.Triggers.Comprehension.Start;
while comprehensionpass <3
    [keyIsDown]= KbQueueCheck(Env.MouseInfo{1,1}.index);
    [keyboardDown,~,whichkey]=KbCheck;
    [x,y] = GetMouse(Env.MainWindow);

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
            TriggerToSend=Env.Triggers.Comprehension.IncorrectResponse;
            EEGPass=1;

            DATA.ExperimentOneComprehension(1).ResponseAnswer="Incorrect";
            DATA.ExperimentOneComprehension(1).ResponseRT=GetSecs-start;
            LodgeAResponse =LodgeAResponse+1;
            DATA.ExperimentOneComprehension(1).NumIncorrectTries=LodgeAResponse;
            Response = 1; % Yes - which is incorrect, jars dont change
            displayincorrect =1;
            comprehensionpass =0;

        case (Response ==1 && any(keyIsDown==1) && ismembertol(x,ResponseBoxCoords1(2,1):ResponseBoxCoords1(2,3))&& ismembertol(y,ResponseBoxCoords1(2,2):ResponseBoxCoords1(2,4)) && comprehensionpass==0);
            TriggerToSend=Env.Triggers.Comprehension.CorrectResponse;
            EEGPass=1;


            DATA.ExperimentOneComprehension(1).ResponseAnswer="Correct";
            DATA.ExperimentOneComprehension(1).ResponseRT=GetSecs-start;
            LodgeAResponse = LodgeAResponse;
            DATA.ExperimentOneComprehension(1).NumIncorrectTries=LodgeAResponse;
            Response =2;
            displayincorrect =0;
            comprehensionpass=1;

        case (Response ==2 && any(keyIsDown==1) && (ismembertol(x,ResponseBoxCoords2(1,4):ResponseBoxCoords2(3,4))&& ~ismembertol(y,ResponseBoxCoords2(2,4):ResponseBoxCoords2(4,4)))&& comprehensionpass==1);
            TriggerToSend=Env.Triggers.Comprehension.IncorrectResponse;

            DATA.ExperimentOneComprehension(2).ResponseAnswer="Incorrect";
            DATA.ExperimentOneComprehension(2).ResponseRT=GetSecs-start;
            LodgeAResponse =LodgeAResponse+1;
            DATA.ExperimentOneComprehension(2).NumIncorrectTries=LodgeAResponse-DATA.ExperimentOneComprehension(1).NumIncorrectTries;
            %             Response =2;
            displayincorrect =1;
            comprehensionpass=1;

        case (Response ==2 && any(keyIsDown==1) && ismembertol(x,ResponseBoxCoords2(1,4):ResponseBoxCoords2(3,4))&& ismembertol(y,ResponseBoxCoords2(2,4):ResponseBoxCoords2(4,4))&& comprehensionpass==1);
            TriggerToSend=Env.Triggers.Comprehension.CorrectResponse;
            EEGPass=1;

            DATA.ExperimentOneComprehension(2).ResponseAnswer = "Correct";
            DATA.ExperimentOneComprehension(2).ResponseRT=GetSecs-start;
            LodgeAResponse = LodgeAResponse;
            DATA.ExperimentOneComprehension(2).NumIncorrectTries=LodgeAResponse-DATA.ExperimentOneComprehension(1).NumIncorrectTries;
            Response =3;
            displayincorrect =0;
            comprehensionpass=2;

        case (displayincorrect==1 && keyboardDown==1 && KbName(whichkey)=="Return")
            TriggerToSend=Env.Triggers.Comprehension.DisplayIncorrectEnd;
            displayincorrect=0;
            EEGPass=1;

        case (Response==3 && keyboardDown==1 && KbName(whichkey)=="Return")
            TriggerToSend=Env.Triggers.Comprehension.End;

            EEGPass=1;
            comprehensionpass=3;

    end
    Screen('DrawTextures',Env.MainWindow,[Env.PracticeJarTexture1;Env.PracticeJarTexture2],[],[CentreJarOne;CentreJarTwo]',[],[],[],mask);
    if Response<=2
        DrawFormattedText(Env.MainWindow,sprintf('Jar A\n85%% %s 15%% %s',JarAStr,JarBStr),CentreJarOne(1)+20,CentreJarOne(4)+20);
        DrawFormattedText(Env.MainWindow,sprintf('Jar B\n85%% %s 15%% %s',JarBStr,JarAStr),CentreJarTwo(1)+20,CentreJarTwo(4)+20);
    end
    Screen('DrawingFinished',Env.MainWindow);
    [FlipTime,~,EndFlip]=Screen('Flip',Env.MainWindow,[]);
    switch  DATA.useEEG
        case 1
            switch true
                case FrameIndex==1
                    sp.sendTrigger(TriggerToSend); % trigger
                case (EEGPass==1)
                    sp.sendTrigger(TriggerToSend); % trigger
%                 case (Response==2 &&EEGPass==1)
%                     sp.sendTrigger(TriggerToSend); % trigger
%                 case (Response==3 &&EEGPass==1)
%                     sp.sendTrigger(TriggerToSend); % trigger
            end
    end
    switch DATA.useET
        case 1
            switch true
                case FrameIndex==1
                    TimeStamps(end+1,1) =TobiiOperations.get_system_time_stamp;
                    TimeStamps(end,2)=TriggerToSend;
                case (EEGPass==1)
                    TimeStamps(end+1,1) =TobiiOperations.get_system_time_stamp;
                    TimeStamps(end,2)=TriggerToSend;
%                 case (Response==2 &&EEGPass==1)
%                     TimeStamps(end+1,1) =TobiiOperations.get_system_time_stamp;
%                     TimeStamps(end,2)=TriggerToSend;
%                 case (Response==3 &&EEGPass==1)
%                     TimeStamps(end+1,1) =TobiiOperations.get_system_time_stamp;
%                     TimeStamps(end,2)=TriggerToSend;
            end
    end
    FrameIndex=FrameIndex+1;
    TriggerToSend=0;
    EEGPass=0;
end



if exist('ExptData', 'dir') == 0
    mkdir('ExptData\EXP1');
end
if exist('ExptData\EXP1\combined','dir')==0
    mkdir('ExptData\EXP1\combined');
end

ExcelFile = ['ExptData\EXP1\combined\myComprehensionDataP', num2str(DATA.participantNum), '_B', num2str(blocks),'_Data', '.xlsx'];
if isfile(ExcelFile)==1
    ExcelFile = ['ExptData\EXP1\combined\myComprehensionDataP', num2str(DATA.participantNum),'_B',num2str(blocks),'_Data','DOUBLECHANGEPNUM', '.xlsx'];
end
writetable(struct2table(DATA.ExperimentOneComprehension), ExcelFile);



TriggerToSend=Env.Triggers.Practice.StartBlock;
[FlipTime,~,EndFlip]=Screen('Flip',Env.MainWindow,[]);
switch  DATA.useEEG
    case 1
        sp.sendTrigger(TriggerToSend); % trigger
end
switch DATA.useET
    case 1
        TimeStamps(end+1,1) =TobiiOperations.get_system_time_stamp;
        TimeStamps(end,2)= TriggerToSend;
end
TriggerToSend=0;
for blocks =1:1
    for PracticeTrials = 1:width(PracticeSequence) % The things that need to happen on each trial
        clear DispStim LodgeAResponse BreakMeOut Response
        FrameIndex=1;

        DATA.ExperimentOnePractice(blocks).Block(PracticeTrials).ParticipantNum = DATA.participantNum;
        DATA.ExperimentOnePractice(blocks).Block(PracticeTrials).ParticipantAge = DATA.participantAge;
        DATA.ExperimentOnePractice(blocks).Block(PracticeTrials).ParticipantGen = DATA.participantGen;
        DATA.ExperimentOnePractice(blocks).Block(PracticeTrials).ParticipantHan = DATA.participantHan;
        DATA.ExperimentOnePractice(blocks).Block(PracticeTrials).CorrectResponseStr = TranslateCorrectJarAnswer(PracticeTrials,blocks);
        DATA.ExperimentOnePractice(blocks).Block(PracticeTrials).CorrectResponse = CounterPracPres(PracticeTrials,blocks);
        DATA.ExperimentOnePractice(blocks).Sequences(PracticeTrials).TrialSequence =PracticeSequence(:,PracticeTrials);
        DATA.ExperimentOnePractice(blocks).Block(PracticeTrials).NumBeadstoDecision = 1;
        WaitSecs(intertrialinterval);
        TriggerToSend=Env.Triggers.Practice.StartTrial;
            start =GetSecs;                



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
            EEGPass=0;

            while LodgeAResponse <3
                [keyIsDown]= KbQueueCheck(Env.MouseInfo{1,1}.index);
                [x,y] = GetMouse(Env.MainWindow);

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
                        TriggerToSend=Env.Triggers.Practice.ResponseYes;
                        EEGPass=1;
                        LodgeAResponse =1;
                        Response = 2; % Yes

                    case (any(keyIsDown==1) && ismembertol(x,ResponseBoxCoords(1,1):ResponseBoxCoords(1,3))&& ismembertol(y,ResponseBoxCoords(1,2):ResponseBoxCoords(1,4))&& Response ==2 &&LodgeAResponse==1);
                        TriggerToSend=Env.Triggers.Practice.ResponseA;
                        EEGPass=1;
                        DATA.ExperimentOnePractice(blocks).Block(PracticeTrials).JarResponseAnswer="JarA";
                        DATA.ExperimentOnePractice(blocks).Block(PracticeTrials).JarResponseRT=GetSecs-start;
                        JarResponseSystemTime=GetSecs;
                        LodgeAResponse =2;
                        Response =3;
                    case (any(keyIsDown==1) && ismembertol(x,ResponseBoxCoords(2,1):ResponseBoxCoords(2,3))&& ismembertol(y,ResponseBoxCoords(2,2):ResponseBoxCoords(2,4)) && Response==1 && LodgeAResponse==0);
                        if DATA.ExperimentOnePractice(blocks).Block(PracticeTrials).NumBeadstoDecision <10
                            TriggerToSend=Env.Triggers.Practice.ResponseSeeMore;
                            BreakMeOut = 1;
                            LodgeAResponse =0;
                            DATA.ExperimentOnePractice(blocks).Block(PracticeTrials).NumBeadstoDecision = DATA.ExperimentOnePractice(blocks).Block(PracticeTrials).NumBeadstoDecision+1;
                        else
                            TriggerToSend=Env.Triggers.Practice.ResponseMaxNumReached;

                            BreakMeOut = 0;
                            LodgeAResponse =1;
                            Response = 2;
                            DATA.ExperimentOnePractice(blocks).Block(PracticeTrials).NumBeadstoDecision = DATA.ExperimentOnePractice(blocks).Block(PracticeTrials).NumBeadstoDecision+1;

                        end
                        EEGPass=1;

                    case (any(keyIsDown==1) && ismembertol(x,ResponseBoxCoords(2,1):ResponseBoxCoords(2,3))&& ismembertol(y,ResponseBoxCoords(2,2):ResponseBoxCoords(2,4)) && Response ==2 && LodgeAResponse==1);
                                               TriggerToSend=Env.Triggers.Practice.ResponseB;
 EEGPass=1;
                        DATA.ExperimentOnePractice(blocks).Block(PracticeTrials).JarResponseAnswer = "JarB";
                        DATA.ExperimentOnePractice(blocks).Block(PracticeTrials).JarResponseRT=GetSecs-start;
                        JarResponseSystemTime=GetSecs;
                        Response =3;
                        LodgeAResponse =2;

                    case (Response ==3 && any(keyIsDown==1) && ismembertol(x,LineDetails(1)-10:LineDetails(3))&& ismembertol(y,LineDetails(2)-20:LineDetails(4)+20)&& LodgeAResponse==2)
                                               TriggerToSend=Env.Triggers.Practice.ConfidenceResponse;
 EEGPass=1;
                        DATA.ExperimentOnePractice(blocks).Block(PracticeTrials).Confidence = NumberToDisplay;
                        DATA.ExperimentOnePractice(blocks).Block(PracticeTrials).ConfidenceRT = GetSecs-JarResponseSystemTime;
                        LodgeAResponse =3;
                    otherwise

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
                            case ( EEGPass==1)
                                sp.sendTrigger(TriggerToSend); % trigger
                        end
                end
                switch DATA.useET
                    case 1
                        switch true
                            case FrameIndex==1
                                TimeStamps(end+1,1) =TobiiOperations.get_system_time_stamp;
                                TimeStamps(end,2)=TriggerToSend;
                            case (EEGPass==1)
                                TimeStamps(end+1,1) =TobiiOperations.get_system_time_stamp;
                                TimeStamps(end,2)=TriggerToSend;
                      
                        end
                end
                FrameIndex=FrameIndex+1;
                TriggerToSend=0;
                EEGPass=0;
                if BreakMeOut ==1
                    break
                end
            end

            if LodgeAResponse ==3
                break
            end
        end

    end
    %Create file to output by appending to stimuli any required columns
    %e.g. Participant# and Block# possibly also what the targets and
    %distractors were.
    % Then save that combined table

    %% First, write a Matlab file filled with all relevant DATA.
    if exist('ExptData', 'dir') == 0
        mkdir('ExptData\EXP1');
    end
    if exist('ExptData\EXP1\combined','dir')==0
        mkdir('ExptData\EXP1\combined');
    end

    ExcelFile = ['ExptData\EXP1\combined\myPracticeDataP', num2str(DATA.participantNum), '_B', num2str(blocks),'_Data', '.xlsx'];
    if isfile(ExcelFile)==1
        ExcelFile = ['ExptData\EXP1\combined\myPracticeDataP', num2str(DATA.participantNum),'_B',num2str(blocks),'_Data','DOUBLECHANGEPNUM', '.xlsx'];
    end
    %xlswrite(ExcelFile,stimuli);
    writetable(struct2table(DATA.ExperimentOnePractice(blocks).Block), ExcelFile);
    %     if exist('OutputData', 'var')==1
    %         OutputData = [OutputData,DATA.ExperimentOnePractice(blocks).Block];
    %     else
    %         OutputData = DATA.ExperimentOnePractice(blocks).Block;
    %     end
end
TriggerToSend =Env.Triggers.Practice.EndBlock;
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
  TriggerToSend=0;
MoveOn=0;
while MoveOn~=1
    [keyboardDown,~,whichkey]=KbCheck;
    %trigger
    DrawFormattedText(Env.MainWindow,sprintf('%s',PracticeEndText),'center','center',[],120,[],[],2);
    Screen('DrawingFinished',Env.MainWindow);

    if (keyboardDown ==1 && KbName(whichkey)=="Return")
      
        MoveOn=1;
        TriggerToSend =Env.Triggers.Exp.Start;
    end
    [FlipTime,~,EndFlip]=Screen('Flip',Env.MainWindow,[]);
    switch DATA.useEEG
        case 1
            switch MoveOn
                case 1
        sp.sendTrigger(TriggerToSend); % trigger
            end
    end
      switch DATA.useET
            case 1
                  switch MoveOn
                case 1
                TimeStamps(end+1,1) =TobiiOperations.get_system_time_stamp;
                TimeStamps(end,2)= TriggerToSend;
                  end
      end

end
KbReleaseWait;

end