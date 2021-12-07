
% Names: Tess Barich & Oren Griffiths (Dec 2021)
% License: MIT.

% Goal: overarching main script that captures demographics, organizes 
% access to the individual experimental tasks, and saves data in format
% that we can readily analyze.

% initialize workspace
clear all;
close all; 
AssertOpenGL;
while KbCheck; end 

% structures to pass general information between sub-experiments.
global DATA Env

% automatically switch pwd to location of current file, even if user
% declared otherwise (accidentally). (Lots of calls to pwd below.) 
[pathstr,name,ext]  = fileparts(mfilename('fullpath'));
cd(pathstr);



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

% just as a for example:
% are we running Experiment 1? If so, what's the condition?
runTask1 = input('Run Experiment 1? Y/N', 's');
if strcmp(runTask1, 'Y')
    conditionTask1 = input('Which condition for Experiment 1? [1,2,3] ---> ', 's');
    TasksToRun(1) = 1;
else
    conditionTask1 = []; % maybe should make task fail with empty condition?
    TasksToRun(1) = 0;
end

% same but for Experiment 2
runTask2 = input('Run Experiment 2? Y/N', 's');
if strcmp(runTask2, 'Y')
    conditionTask2 = input('Which condition for Experiment 2? [1,2,3] ---> ', 's');
    TasksToRun(2) = 1;
else
    conditionTask2 = [];
    TasksToRun(2) = 0;
end

% Same but for Experiment 3
runTask3 = input('Run Experiment 3? Y/N', 's');
if strcmp(runTask3, 'Y');
    conditionTask3 = input('Which condition for Experiment 3? [1,2,3] ---> ', 's');
    TasksToRun(3) = 1;
else
    conditionTask3 = [];
    TasksToRun(3) = 0;
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

% ET license file (will need to change if we use a different device).
Env.ET_licenseFile = [pwd filesep 'Functions' filesep 'license_key_00405485_-_The_University_of_NSW_IS404-100107012554'];
Env.ETAddress = 'tobii-ttp://IS404-100107012554';

% other hardware stuff. 
ScreenNumber = max(Screen('Screens')); % Selects the screen to display. Sole display = 0.

% experimental control variables
DATA.useET = 0; % 0 = no ET, 1 = ET.
DATA.useEEG = 0; % 0 = no EEG, 1 = EEG.
DATA.debugging = 0;

% soime stuff for psychtoolbox can be done here too. 
disp('Setting up psychtoolbox main window.');
% Set up a  default, plain grey screen and get the details of refresh rate
resolution = Screen('Resolution',ScreenNumber);
Env.Res = [resolution.width , resolution.height]; % written assuming HD/1080p.
Env.centre = Env.Res/2;
HideCursor; 
[Env.MainWindow, Env.WindowRect] = Screen('OpenWindow', ScreenNumber, Colours.Black, [], []);
% and any general settings that will be needed across the experiments.



% Triggers for EEG (and/or ET). 
% Just putting some token values in here for now. Limited of 20:256.

% Practice
Triggers.Practice.StartBlock = 81;
Triggers.Practice.EndBlock = 82;
%
Triggers.Practice.StartTrial = 91;
Triggers.Practice.FriendTrial = 92;
Triggers.Practice.FoeTrial = 93;
Triggers.Practice.NeitherTrial = 94;
Triggers.Practice.Response = 95;
Triggers.Practice.TimeOut = 96;
Triggers.Practice.EndTrial = 97;
% Pretraining
Triggers.PreTraining.StartBlock = 101;
Triggers.PreTraining.EndBlock = 102;
%
Triggers.PreTraining.StartTrial = 111;
Triggers.PreTraining.FriendTrial = 112;
Triggers.PreTraining.FoeTrial = 113;
Triggers.PreTraining.NeitherTrial = 114;
Triggers.PreTraining.Response = 115;
Triggers.PreTraining.TimeOut = 116;
Triggers.PreTraining.EndTrial = 117;
% Training
Triggers.Training.StartBlock = 131;
Triggers.Training.EndBlock = 132;
%
Triggers.Training.StartTrial = 141;
Triggers.Training.FriendTrial = 142;
Triggers.Training.FoeTrial = 143;
Triggers.Training.NeitherTrial = 144;
Triggers.Training.Response = 145;
Triggers.Training.TimeOut = 146;
Triggers.Training.EndTrial = 147;
% Test
Triggers.Test.StartBlock = 161;
Triggers.Test.EndBlock = 162;
%
Triggers.Test.StartTrial = 171;
Triggers.Test.FriendTrial = 172;
Triggers.Test.FoeTrial = 173;
Triggers.Test.NeitherTrial = 174;
Triggers.Test.Response = 175;
Triggers.Test.TimeOut = 176;
Triggers.Test.EndTrial = 177;

Env.Triggers = Triggers;  clear Triggers;

% colour shortcuts
Colours.Black = [1 1 1];
Colours.White = [255 255 255];
Colours.Yellow = [255 255 0];
Colours.Magenta = [255 0 255];
Colours.Cyan = [0 255 255];
Colours.Red = [255 0 0];
Colours.RedTransparent = [255 0 0 64];
Colours.Green = [0 255 0];
Colours.GreenTransparent = [0 255 0 64]; % with alpha value for blending.
Colours.Blue = [0 0 255];
Colours.BlueTransparent = [0 0 255 64];
Colours.Grey = [127 127 127];
Colours.DarkGrey = [64 64 64];
Colours.LightGrey = [192 192 192];

Env.Colours = Colours; clear Colours;

%% Run the tasks (and output partial info/data as you go).

if TasksToRun(1) == 1
    
    ExperimentOne()
    % do calibrations as needed, show instructions as needed
    
    DataFromExpt = Experiment1(Env);
    % also have the option for updating DATA global directly within
    % function, if needed
    DATA.E1_raw = DataFromExpt;
end

if TasksToRun(2) == 1
    
    % do calibrations as needed, show instructions as needed
    
    DataFromExpt = Experiment2(Env);
    % also have the option for updating DATA global directly within
    % function, if needed
    DATA.E2_raw = DataFromExpt;
end

if TasksToRun(3) == 1
    
    % do calibrations as needed, show instructions as needed
    
    DataFromExpt = Experiment3(Env);
    % also have the option for updating DATA global directly within
    % function, if needed
    DATA.E3_raw = DataFromExpt;
end

%% collate data for final output. 

% might need to e.g. trim gaze data so can do that here. 


%% wrap up and clean up.
sca;
clear all;

