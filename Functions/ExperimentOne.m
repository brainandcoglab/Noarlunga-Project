%Written by Tess Barich 2021.
function ExperimentOne(ConditionSequence) % Bead Jar Task
%   Declare Globals

global DATA Env Calib Jar Bead BeadSize
%% Declare condition values
QuestionQuote = "Would you like to make a decision on which jar beads are being drawn from?";
nTrials =4;
nBeadstoPresent =10;
TotalBeadsInJar = 300;
MainColourNumberBeads = (85/100)*TotalBeadsInJar;
SecondaryColourNumberBeads = (15/100)*TotalBeadsInJar;
nBlocks =4;
ConditionSequence = randperm(4);
SequenceOrder = [1,2,3,4]; % Built this in incase you ever want to change  the sequence presentation order. randperm(4);
targetseq= SequenceOrder(2);
distractorseqone= SequenceOrder(1);
distractorseqtwo=SequenceOrder(3);
distractorseqthree =SequenceOrder(4);
Sequence =[{},{},{},{}];
%% Build the sequences
for blocks = 1: nBlocks
    for SequenceBuilding = 1:nBlocks
        switch SequenceOrder(SequenceBuilding)
            case distractorseqone
                Sequence(:,SequenceOrder(1)) = [{'A'};{'A'};{'B'};{'A'};{'A'};{'A'};{'B'};{'A'};{'A'};{'A'}];
            case targetseq
                Sequence(:,SequenceOrder(2)) = [{'A'};{'A'};{'A'};{'B'};{'A'};{'A'};{'A'};{'A'};{'B'};{'A'}];

            case distractorseqtwo
                Sequence(:,SequenceOrder(3)) = [{'B'};{'A'};{'A'};{'A'};{'A'};{'B'};{'A'};{'A'};{'A'};{'A'}];

            case distractorseqthree
                Sequence(:,SequenceOrder(4)) = [{'A'};{'A'};{'A'};{'A'};{'B'};{'A'};{'A'};{'B'};{'A'};{'A'}];

        end
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

    CentreJarOne=my_centreTexture(Env.Stimuli(Jar).Size(1),Env.Stimuli(Jar).Size(2),Env.ScreenInfo.width*0.3,Env.ScreenInfo.Centre(2));
    CentreJarTwo = my_centreTexture(Env.Stimuli(Jar).Size(1),Env.Stimuli(Jar).Size(2),Env.ScreenInfo.width*0.6,Env.ScreenInfo.Centre(2));
    BeadTexture = repmat({Env.Stimuli(Bead).TexturePointer},height(Sequence),1);
    for Trials = 1:nTrials % The things that need to happen on each trial
        clear DispStim
        for Attempts =1:nBeadstoPresent
            DispStim(Attempts,1) = BeadTexture(Attempts,1);
            DispStim(Attempts,2)= cell({my_centreTexture(BeadSize(1),BeadSize(2),Env.ScreenInfo.width*Attempts/17,Env.ScreenInfo.height-200)});
            DispStim(Attempts,3)= Sequence(Attempts,Trials);
            textures = cell2mat(DispStim(:,1));
            textures = transpose(textures);
            coordinates = cell2mat(DispStim(:, 2));
            coordinates= transpose(coordinates);
            colourmask = cell2mat(DispStim(:, 3));
            colourmask= transpose(colourmask);
            Screen('DrawTextures',Env.MainWindow,[Env.JarOne;Env.JarTwo],[],[CentreJarOne;CentreJarTwo]');
            DrawFormattedText(Env.MainWindow,sprintf('%s',QuestionQuote),'center',Env.ScreenInfo.Centre(2)-300);
            DrawFormattedText(Env.MainWindow,sprintf('85 percent %s, 15 percent %s',JarAStr,JarBStr),CentreJarOne(1),CentreJarOne(4)+20);
            DrawFormattedText(Env.MainWindow,sprintf('85 percent %s, 15 percent %s',JarBStr,JarAStr),CentreJarTwo(1),CentreJarTwo(4)+20);
            Screen('DrawTextures',Env.MainWindow,textures,[],coordinates,[],[],[],colourmask);
            Screen('Flip',Env.MainWindow);
            KbWait([],2);


        end


    end

end
end