%Written by Tess Barich 2022
function ExperimentTwo(ConditionSequence)
global Env DATA  Calib
%% The Adjustables - Paired Fates
NumOfX =5;
NumOfY=5;
StimuliSizeX=50;
StimuliSizeY=50;
GapBetween =20;
BlankX=300;
BlankY =100;
nBlocks =4;
nTrials =4;
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
ResponseBoxandTextColour = Env.Colours.White;
LineLength =400; %pixels
WaitFrames =1;


%% Get the X and Y coordinates for the boxes
[Env.ExperimentTwo.Coordinates,Env.ExperimentTwo.MinMaxXY]=DetermineXYCoords(Env.MainWindow,Env.MainWindow,NumOfX,NumOfY,StimuliSizeX,StimuliSizeY,GapBetween,BlankX,BlankY);

%% Build the sequences
if DATA.useET ==1;
    RubbishET = my_eyetracker.get_gaze_data();
end
for blocks = 1: nBlocks

    BoxAnswer(:,blocks) = randi(2,[4,1]); % 1 = original sequence, 2 inverted sequence
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
        TranslateCorrectBoxAnswer(TranslateCorrectColourBoxAAnswerIdx(:,blocks),blocks) = "Colour A";
        TranslateCorrectBoxAnswer(TranslateCorrectColourBoxBAnswerIdx(:,blocks),blocks) ="Colour B";
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

    Change2Colour =strcmp(Sequence,{'A'});
    Sequence(Change2Colour)={ColourBoxA};
    Change2Colour2=strcmp(Sequence,{'B'});
    Sequence(Change2Colour2)={ColourBoxB};

    DATA.ExperimentTwo(blocks).TargetSequence = Sequence(:,SequenceOrder(2));

    [ResponseBoxCoords,Env.ExperimentTwo.ResponseOne,Env.ExperimentTwo.ResponseTwo]= BuildMyResponseBoxes(Env.MainWindow,Env.OffScreenWindow,2,[AnswerQuote1;AnswerQuote2],ResponseBoxandTextColour,3,[Env.ExperimentTwo.MinMaxXY(1,1);Env.ExperimentTwo.MinMaxXY(3,1)],Env.ExperimentTwo.MinMaxXY(4,1)+120,200,100,1,16,[ColourBoxA;ColourBoxB]');

    Response=1;





    Screen('DrawTextures',Env.MainWindow,[Env.ExperimentTwo.ResponseOne(Response);Env.ExperimentTwo.ResponseTwo(Response)],[],[ResponseBoxCoords]',[],[],[],[]);


    Screen('FillRect',Env.MainWindow,[],Env.ExperimentTwo.Coordinates);
    Screen('Flip',Env.MainWindow);
    KbWait([],2);
    sca;

end