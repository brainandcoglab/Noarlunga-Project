%% Created by Tess Barich (2022) Flinders Uni. 
% DRM Experiment with Eyetracking and EEG. 
function ExperimentThree(ConditionSequence)
global DATA Env Calib

EncodingInstructions = 'You are about to be shown a list of words. Please remember them as well as you can';
EncodingCounterBalancing = num2cell(randperm(width(Env.ExperimentThree.EncodingWords)));
RecognitionCounterBalancing = num2cell(randperm(width(Env.ExperimentThree.RecognitionWords)));

% Set the location that the files are stored in
fileDirectory = Env.Loc_Stimuli;
searchString = '.xlsx'; 
[Env.ExperimentThree.Raw.EncodingLists,Env.ExperimentThree.EncodingWords,Env.ExperimentThree.Raw.RecognitionLists,Env.ExperimentThree.RecognitionWords,Env.ExperimentThree.Raw.LureLists,Env.ExperimentThree.LureLists]=ImportandSortMyLists(fileDirectory,searchString);
end