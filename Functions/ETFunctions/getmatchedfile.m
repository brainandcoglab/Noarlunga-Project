%Altered By Tess Barich Flinders University 2021 - Sourced from MathWorks Support Team 2009
function Matchfile = getmatchedfile(directory,str)
%This function returns the file that contains the search string.
dirclean = dir(directory); %pull directory contents 
dirclean = dirclean(find(~cellfun(@isdir,{dirclean(:).name})));%Filter out all the folders.
A = contains([{dirclean(:).name}],str); %Search for the serial number.
[~,A] = max(A); %A contains the index to the logical true value "The highest value in the array" which will give us the
%matching license
if ~isempty(A);
    Matchfile = dirclean(A).name;
end

end