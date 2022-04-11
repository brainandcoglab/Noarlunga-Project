%Written by Tess Barich 2022
function [EncodingList,AllEncodingWords,RecognitionList,AllRecognitionWords,LuresList,AllLureWords] =  ImportandSortMyLists(fileDirectory,searchString)
global Env

addpath(fileDirectory);
fileNames = dir(fileDirectory);
fileNames = {fileNames.name};
fileNames = fileNames(cellfun(...
    @(f)~isempty(strfind(f,searchString)),fileNames));
AllEncodingWords = [];
AllRecognitionWords =[];
AllLureWords =[];
for f = 1:numel(fileNames)
    AllEncodingWords = readtable(fileNames{f},'Range','A2:X13','ReadVariableNames',false);
    AllRecognitionWords =readtable(fileNames{f},'Range','A16:H39','ReadVariableNames',false);
    AllLureWords =readtable(fileNames{f},'Range','A43:J54','ReadVariableNames',false);

end
EncodingList =table2cell(AllEncodingWords);
RecognitionList =table2cell(AllRecognitionWords);
LuresList = table2cell(AllLureWords);
EncodingCounterBalancing = num2cell(randperm(width(EncodingList)));
RecognitionCounterBalancing = num2cell(randperm(width(RecognitionList)));

AllEncodingWords = [EncodingCounterBalancing;AllEncodingWords];
AllEncodingWords =rows2vars(AllEncodingWords);
AllEncodingWords = AllEncodingWords(:,2:end);
AllEncodingWords = sortrows(AllEncodingWords,{'Var1'},{'ascend'});
AllEncodingWords=table2cell(AllEncodingWords(:,2:end));
AllEncodingWords=AllEncodingWords';
AllEncodingWords=AllEncodingWords(:);
AllEncodingWords = reshape(AllEncodingWords,[96,3]);

NotMissingIdx = ~ismissing(LuresList);
SmoothMyList=LuresList(NotMissingIdx(1:8),:);
AddNewColumns = LuresList(9:12,:);
AddNewColumns=AddNewColumns(:);
AddNewColumns=AddNewColumns(~cellfun(@isempty,AddNewColumns(:,1)),:);
AddNewColumns=reshape(AddNewColumns,[8,2]);
AddNewColumns=Shuffle(AddNewColumns);
AllLureWords=[SmoothMyList,AddNewColumns];
AllLureWords =Shuffle(AllLureWords);
AllLureWords = AllLureWords';
AllLureWords =Shuffle(AllLureWords);
AllRecognitionWords=[RecognitionList;AllLureWords];
AllRecognitionWords=Shuffle(AllRecognitionWords);
% AllRecognitionWords = cell2table(AllRecognitionWords);
% AllRecognitionWords = [RecognitionCounterBalancing;AllRecognitionWords];
% AllRecognitionWords = rows2vars(AllRecognitionWords);
% AllRecognitionWords = AllRecognitionWords(:,2:end);
% AllRecognitionWords =sortrows(AllRecognitionWords,{'Var1'},{'ascend'});
% AllRecognitionWords = table2cell(AllRecognitionWords(:,2:end));
% AllRecognitionWords =AllRecognitionWords';
AllRecognitionWords = AllRecognitionWords(:);
AllRecognitionWords = reshape(AllRecognitionWords,[96,3]);




end