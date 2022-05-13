
% Names: Tess Barich & Oren Griffiths (Dec 2021)
% License: MIT.

% Goal: overarching main script that captures demographics, organizes
% access to the individual experimental tasks, and saves data in format
% that we can readily analyze.
% structures to pass general information between sub-experiments.


% initialize workspace
% clear all;
% close all;
% sca
% AssertOpenGL;
%Clear the workspace and the screen
sca;
close all;

clear global Env DATA
clearvars;
AssertOpenGL;
while KbCheck; end

global DATA Env Pointer  colour  ResponseBoxCoords2
global MyEyeTracker sp TimeStamps OverallGazeData calibrationStart TobiiOperations failed_licenses

% automatically switch pwd to location of current file, even if user
% declared otherwise (accidentally). (Lots of calls to pwd below.)
[pathstr,name,ext]  = fileparts(mfilename('fullpath'));
cd(pathstr);


ResponseBoxCoords2=[];
TimeStamps=[];
%% Capture demographic data
inputError = 1;
while inputError == 1
    inputError = 0;
    participantNumber = input('Participant number ---> ');
    datafilename = ['ExpData\myDataP',num2str(participantNumber),'.mat'] ;
    if exist(datafilename,"file")==2
        disp(['Data for participant',num2str(participantNumber),'already exists, please chose another participant number.'])
        inputError =1;
    end
end
participantGender ='a'; % placeholder value
while participantGender == 'a'% This is a free response demographic question, participant can enter any gender they wish to disclose or pass.
    participantGender = input('Participant gender ---> ', 's');
end
participantAge = input('Participant age ---> ');

participantHandedness = 'a'; % place holder value
while participantHandedness ~= 'l' && participantHandedness ~= 'r' && participantHandedness ~= 'L' && participantHandedness ~= 'R'
    participantHandedness = input('Left or right handed(L/R) ---> ', 's');
end

%Write demographic info to global data variable
DATA.participantNum = participantNumber;
DATA.participantGen = participantGender;
DATA.participantAge = participantAge;
DATA.participantHan = participantHandedness;
DATA.startTime = datestr(now, 'mmmm dd, yyyy HH:MM:SS.FFF');


%% Enter data about which conditions, which tasks, etc.
Exp1Con =[1:4];
Exp2Con =[1:4];
Exp3Con =[1:4];
% just as a for example:
% are we running Experiment 1? If so, what's the condition?
GoOn=0;
RunExp=0;
while RunExp==0
    runTask1 = input('Run Experiment 1? Y/N -->'   , 's');
    switch true
        case (contains(runTask1, 'Y','IgnoreCase', true) && ~contains(runTask1, 'N','IgnoreCase', true)) %Changed 'strcmp' to 'contains' to make more versatile. looks for a y anywhere in input
            while GoOn==0
                conditionTask1 = input('Which condition for Experiment 1? [1,2,3] ---> ');
                if ismember(conditionTask1,Exp1Con) %Check that input is actually a condition value
                    TasksToRun(1) = 1; % if condition exists, Experiment one is listed to run.
                    GoOn=1;
                    RunExp =1;
                else
                    warning('Condition does not exist, Please try again')%tell user the value they entered is not a known condition.
                    TaskToRun(1)=0; % List as not running experiment if condition value does not exist
                end % Should I make this a loop so they have another opportunity to enter a condition value?
            end

        case (~contains(runTask1, 'Y','IgnoreCase', true) && contains(runTask1, 'N','IgnoreCase', true)) %Changed 'strcmp' to 'contains' to make more versatile. looks for a y anywhere in input
            conditionTask1 = []; % maybe should make task fail with empty condition? <- I've done something above, is this what you meant? TB
            TasksToRun(1) = 0;
            RunExp =1;

    end
end

% same but for Experiment 2
GoOn=0;
RunExp=0;
while RunExp==0
    runTask2 = input('Run Experiment 2? Y/N -->'   , 's');
    switch true
        case contains(runTask2, 'Y','IgnoreCase', true) && ~contains(runTask2, 'N','IgnoreCase', true) %Changed 'strcmp' to 'contains' to make more versatile. looks for a y anywhere in input
            while GoOn ==0
                conditionTask2 = input('Which condition for Experiment 2? [1,2,3] ---> ');
                if ismember(conditionTask2,Exp2Con) %Check that input is actually a condition value
                    TasksToRun(2) = 1;% if condition exists, Experiment one is listed to run.
                    GoOn=1;
                    RunExp =1;
                else
                    warning('Condition does not exist, Please try again') %tell user the value they entered is not a known condition.
                    TaskToRun(2)=0; %list as not running experiment if condition value does not exist.

                end
            end
        case (~contains(runTask2, 'Y','IgnoreCase', true) && contains(runTask2, 'N','IgnoreCase', true)) %Changed 'strcmp' to 'contains' to make more versatile. looks for a y anywhere in input
            conditionTask2 = []; % maybe should make task fail with empty condition? <- I've done something above, is this what you meant? TB
            TasksToRun(2) = 0;
            RunExp =1;

    end
end

% Same but for Experiment 3
GoOn=0;
RunExp=0;
while RunExp==0
    runTask3 = input('Run Experiment 3? Y/N -->'   , 's');
    switch true
        case contains(runTask3, 'Y','IgnoreCase', true) && ~contains(runTask3, 'N','IgnoreCase', true) %Changed 'strcmp' to 'contains' to make more versatile. looks for a y anywhere in input
            while GoOn==0
                conditionTask3 = input('Which condition for Experiment 3? [1,2,3] ---> ');

                if ismember(conditionTask3,Exp3Con) %Check that input is actually a condition value
                    TasksToRun(3) = 1;% if condition exists, Experiment one is listed to run.
                    GoOn=1;
                    RunExp =1;
                else
                    warning('Condition does not exist, Please try again') %tell user the value they entered is not a known condition.
                    TaskToRun(3)=0; %list as not running experiment if condition value does not exist.
                end
            end
        case (~contains(runTask3, 'Y','IgnoreCase', true) && contains(runTask3, 'N','IgnoreCase', true)) %Changed 'strcmp' to 'contains' to make more versatile. looks for a y anywhere in input
            conditionTask3 = []; % maybe should make task fail with empty condition? <- I've done something above, is this what you meant? TB
            TasksToRun(3) = 0;
            RunExp =1;

    end
end


% declare what condition was selected in output files.
Env.Expt1_Condition = conditionTask1;
Env.Expt2_Condition = conditionTask2;
Env.Expt3_Condition = conditionTask3;
% save that value in output data file too.
DATA.Expt1_Condition = Env.Expt1_Condition;
DATA.Expt2_Condition = Env.Expt2_Condition;
DATA.Expt3_Condition = Env.Expt3_Condition;



%% setup workspace and configuration variables.
% Locations of supporting files.
Env.Loc_Functions = [pwd filesep 'Functions'];
Env.Loc_Data = [pwd filesep 'Data'];
Env.Loc_Stimuli = [pwd filesep 'Stimuli'];
addpath(Env.Loc_Functions);
addpath(Env.Loc_Stimuli);
colour =[];

Env.Stimuli.Name ='Prefill';

% ET license file (will need to change if we use a different device). Maybe
% I can build this into the ET setup code to be more automated? <- Done. It
% takes the most recent file in the License folder and uses that. So as
% long as you keep the license you want to use the most up to date, it
% works.
% Env.ET_licenseFile = [pwd filesep 'Functions' filesep 'license_key_00405485_-_The_University_of_NSW_IS404-100107012554'];
% Env.ETAddress = 'tobii-ttp://IS404-100107012554';

% experimental control variables
DATA.useET = 1; % 0 = no ET, 1 = ET.
DATA.ETTol= 2; %2 degrees visual angle tolerance for calibrations
DATA.ETBuf =1; % 1 degrees addition buffer for ET tolerance
DATA.useEEG = 0; % 0 = no EEG, 1 = EEG.
DATA.debugging = 0;

if DATA.useET==1
    DATA.usedefaultETSettings=input('Would you like to keep the default settings (2 degrees tolerance, 1 degree bufferzone)? Y/N--->'     , 's');
    if contains(DATA.usedefaultETSettings,'Y','IgnoreCase', true)
        DATA.ETTol= DATA.ETTol;
        DATA.ETBuf = DATA.ETBuf;
    else
        DATA.ETTol = input('What visual angle tolerance would you like? [1,2,3 etc]--->'   );
        DATA.ETBuf = input('What visual angle additional buffer would you like? [1,2,3 etc] --->'   );
    end
end

% soime stuff for psychtoolbox can be done here too. Definitely going to
% add a bit more here to ensure the ET calibration works properly.

%% Colour shortcuts so we can call the screens with the short cuts in the Psychtoolbox Setup
% colour shortcuts
Colours.Black = [1 1 1];
Colours.White = [255 255 255];
Colours.Yellow = [255 255 0];
Colours.Purple =[128 0 255];
Colours.Magenta = [255 0 128];
Colours.Cyan = [0 255 255];
Colours.Red = [255 0 0 ];
Colours.RedTransparent = [255 0 0 64];
Colours.Green = [32 239 73];
Colours.GreenTransparent = [0 255 0 64]; % with alpha value for blending.
Colours.Blue = [33 157 255];
Colours.BlueTransparent = [0 0 255 64];
Colours.Grey = [127 127 127];
Colours.DarkGrey = [64 64 64];
Colours.LightGrey = [192 192 192];
Colours.Alpha =[0,0,0,0];

Env.Colours = Colours; clear Colours;
disp('Setting up psychtoolbox main window.');
pause(2)

%% PsychtoolBox setup
PsychDefaultSetup(2);
% PsychImaging('PrepareConfiguration');
% PsychImaging('AddTask', 'General', 'UseFastOffscreenWindows');
Screen ('Preference', 'SkipSyncTests', 2);% change this to 0 when actually running experiments
Screen ('Preference', 'DefaultFontSize');% change this to 0 when actually running experiments
Pointer =1;

ScreenNumber = 2;%max(Screen('Screens')); % Selects the screen to display. Sole display = 0.
[Env.MainWindow, Env.windowRect] =Screen ('OpenWindow', ScreenNumber,Env.Colours.LightGrey,[],[],[],[],[],4);%Open a window using psychimaging and colour it light grey
[Env.OffScreenWindow]= Screen('OpenOffscreenWindow',Env.MainWindow,Env.Colours.Alpha);
Env.ScreenInfo= Screen('Resolution', Env.MainWindow); % Get some screen info including resolution, pixel size and hz.
Env.ScreenInfo.Resolution = [Env.ScreenInfo.width, Env.ScreenInfo.height]; % list the width and height in pixels to a resolution variable
Env.ScreenInfo.Centre = Env.ScreenInfo.Resolution/2;% Get the centre coordinate of the window
[Env.ScreenInfo.mmWidth, Env.ScreenInfo.mmHeight]= Screen('DisplaySize',Env.MainWindow); % Get more screen info on Display Size in mm to transform to cm and use to calculate visual angles
Env.ScreenInfo.cmWidth=Env.ScreenInfo.mmWidth/10; %conversion to cm size
Env.ScreenInfo.cmHeight=Env.ScreenInfo.mmHeight/10;% conversion to cm size
Env.ScreenInfo.diagonalpixelcount = sqrt(Env.ScreenInfo.width^2+Env.ScreenInfo.height^2); %diagonal pixel count in case needed for post measurements
Env.ScreenInfo.diagonalmmcount= sqrt(Env.ScreenInfo.mmWidth^2+Env.ScreenInfo.mmHeight^2);% diagonal mm size in case needed for post measurements
Env.ScreenInfo.diagonalcmcount= sqrt(Env.ScreenInfo.cmWidth^2+Env.ScreenInfo.cmHeight^2); % diagonal cm size in case needed for post measurements
Env.ScreenInfo.pixelpermm= Env.ScreenInfo.diagonalmmcount\Env.ScreenInfo.diagonalpixelcount; % pixel per mm calculation for ET calibration and visual angle calcs
Env.ScreenInfo.pixelpercm= Env.ScreenInfo.diagonalcmcount\Env.ScreenInfo.diagonalpixelcount;% pixel per mm calculation for ET calibration and visual angle calcs
Env.ScreenInfo.dotpitch=Env.ScreenInfo.diagonalcmcount/Env.ScreenInfo.diagonalpixelcount*10; %dot pitch calculations.
DATA.FlipInterval = Screen('GetFlipInterval', Env.MainWindow);% Query the frame duration
DATA.WaitFrameInput =1;
Maxpriority = Priority(2);%set priority to max.
Priority(Maxpriority);
[~,~, Env.MouseInfo]= GetMouseIndices; % Get mouse info for Experiment Confidence Slider response
Screen('BlendFunction', Env.MainWindow, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');% Set up alpha-blending for smooth (anti-aliased) lines
Screen('BlendFunction', Env.OffScreenWindow, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');% Set up alpha-blending for smooth (anti-aliased) lines

%Finished Psychtoolbox
%%
%Screen('Close', Env.MainWindow);


% Triggers for EEG (and/or ET).
% Just putting some token values in here for now. Limited of 20:256.

%   Comprehension - Exp 1 and 2
Triggers.Comprehension.InstructionsStart=66;

Triggers.Comprehension.InstructionsEnd=67;
Triggers.Comprehension.Start =68;
Triggers.Comprehension.CorrectResponse =69;
Triggers.Comprehension.IncorrectResponse =70;
Triggers.Comprehension.DisplayIncorrectEnd =71;
Triggers.Comprehension.End=72;

%Practice - Exp 1 and 2
Triggers.Practice.StartBlock = 81;
Triggers.Practice.EndBlock = 82;
Triggers.Practice.StartTrial = 83;
Triggers.Practice.ResponseYes = 84;
Triggers.Practice.ResponseSeeMore = 85;
Triggers.Practice.ResponseMaxNumReached= 86;
Triggers.Practice.ResponseA = 87;
Triggers.Practice.ResponseB = 88;
Triggers.Practice.ConfidenceResponse = 89;
Triggers.Practice.EndTrial = 90;
%Attention Check - Exp 1 and 2
Triggers.Attention.Start =74;
Triggers.Attention.StartSmile =75;
Triggers.Attention.StartQuestions=76;
Triggers.Attention.YesNoticedResponse =77;
Triggers.Attention.NoNoticedResponse =78;
Triggers.Attention.EndFreeResponse =79;
Triggers.Attention.End=80;

%% Experiments 1 and 2
Triggers.Exp.Start = 158;
Triggers.Exp.StartBlock = 159;
Triggers.Exp.EndBlock = 160;
Triggers.Exp.BlockStartText=161;
Triggers.Exp.BlockEndText=162;
Triggers.Exp.StartTrial = 163;
Triggers.Exp.ResponseYes  = 164;
Triggers.Exp.ResponseSeeMore = 165;
Triggers.Exp.ResponseMaxNumReached= 166;
Triggers.Exp.ResponseA = 167;
Triggers.Exp.ResponseB = 168;
Triggers.Exp.ConfidenceResponse = 169;
Triggers.Exp.EndTrial = 170;
Triggers.Exp.End =171;

%% Experiment 3
Triggers.Exp3.Start = 179;
Triggers.Exp3.End = 180;
Triggers.Exp3.StartEncoding=181;
Triggers.Exp3.StartBlock = 182;
Triggers.Exp3.JitterStart = 183;
Triggers.Exp3.JitterEnd = 184;
Triggers.Exp3.WordShownStart = 185;
Triggers.Exp3.WordShownEnd = 186;
Triggers.Exp3.BackBufferStart =187;
Triggers.Exp3.BackBufferEnd =188;
Triggers.Exp3.EndBlock = 189;
Triggers.Exp3.EndEncoding=190;
Triggers.Exp3.StartRecognition=191;
Triggers.Exp3.StartTrial = 192;
Triggers.Exp3.ResponseOldTrial  = 193;
Triggers.Exp3.ResponseNewTrial = 194;
Triggers.Exp3.ConfidenceResponse = 195;
Triggers.Exp3.EndTrial = 196;
Triggers.Exp3.EndRecognition=187;

Triggers.Exp3.Break=200;



Env.Triggers = Triggers;  clear Triggers;

Env.AttentionCheckTex=DrawASmile(Env.Colours.White,Env.MainWindow,Env.OffScreenWindow);


%% Run the tasks (and output partial info/data as you go).
Temp = struct;

% Eye Tracking Calibration
if DATA.useET ==1% 0 = no ET, 1 = ET.

    OverallGazeData= struct;

    EyeTrackingCalibration(DATA.ETTol,DATA.ETBuf);
    Temp=MyEyeTracker.get_gaze_data();
end

if DATA.useEEG==1
    % set up the serial port to start sending commands
    sp = BioSemiSerialPort(); % open serial port
    sp.testTriggers; % test pins 1-8
end


if TasksToRun(1) == 1
    ExperimentOne(Env.Expt1_Condition);
    %     % do calibrations as needed, show instructions as needed

    DataFromExpt = DATA.ExperimentOne;%ExperimentOne(Env);
    % also have the option for updating DATA global directly within
    % function, if needed
    DATA.E1_raw = DataFromExpt;
end

if TasksToRun(2) == 1

    % do calibrations as needed, show instructions as needed
    ExperimentTwo(Env.Expt2_Condition);

    DataFromExpt =DATA.ExperimentTwo;
    % also have the option for updating DATA global directly within
    % function, if needed
    DATA.E2_raw = DataFromExpt;
end

if TasksToRun(3) == 1
    ExperimentThree(Env.Expt3_Condition);
    % do calibrations as needed, show instructions as needed

    DataFromExpt = DATA.ExperimentThree;
    % also have the option for updating DATA global directly within
    % function, if needed
    DATA.E3_raw = DataFromExpt;
end

%% collate data for final output.

% might need to e.g. trim gaze data so can do that here.


%% wrap up and clean up.
sca;

if DATA.useEEG == 1
    fclose(sp.sp); % the serial port object is actually a property of sp aslo called sp
end

if DATA.useET == 1
    OverallGazeData=MyEyeTracker.get_gaze_data;
    MyEyeTracker.stop_gaze_data();
end

sca;

%end
% clear all;

