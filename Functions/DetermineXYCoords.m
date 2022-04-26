% Written by Tess Barich 2022

function [Coordinates,MinMaxXY] = DetermineXYCoords(window,window2,NumOfX,NumOfY,StimuliSizeX,StimuliSizeY,GapBetween,BlankX,BlankY)
global Env 
numXcolumns = NumOfX;
numYrows =NumOfY;
cellwidth = StimuliSizeX+GapBetween; % this controls how big you want each grid box to be by setting the width
cellheight = StimuliSizeY+GapBetween; % this controls how big you want each grid box to be by setting the height
cellcentre = [cellwidth/2, cellheight/2]; % this finds the centre xy of each grid box
x_width = (numXcolumns*cellwidth)+ (BlankX*2); %how many x pixels we have to draw with.
y_width = (numYrows*cellheight)+(BlankY*2); %how many y pixels we have to draw with.
startXmaskframe = (Env.ScreenInfo.width - x_width)/2; % this is the pixel that we should start drawing our frame on.
startYmaskframe = (Env.ScreenInfo.height - x_width)/2;% same here
endXmaskframe = startXmaskframe + x_width; % this tells you the end pixel (boundary) for the frame, should come out at 1920 if you're using 1920
endYmaskframe = startYmaskframe + y_width; % same here
innerframeboundrect = [startXmaskframe + BlankX,startYmaskframe+BlankY, endXmaskframe - BlankX, endYmaskframe - BlankY];
innerXframerange = [innerframeboundrect(1),innerframeboundrect(3)]; % broken down into x and y coords
innerYframerange = [innerframeboundrect(2), innerframeboundrect(4)];
% outerframerange = [startXmaskframe, startYmaskframe,endXmaskframe,endYmaskframe]; % just tells you the outer frame range, doesn't tell you the limits to the inner frame though. Not overly useful.
Q1centreXquadCoOr = innerXframerange(1)+ (cellwidth/2); % Centre x pixel for quandrant one
Q1centreYquadCoOr = innerYframerange(1)+ (cellheight/2); % Centre y pixel for quandrant one
centrequadcounter = 1;%counters for the while loop
quadcounter = 1;%counters for the while loop
centreXquad = zeros(numXcolumns,1); %prefilled
centreYquad = zeros(numYrows,1);%prefilled
quadX = zeros(numXcolumns,1);%prefilled
quadY = zeros(numYrows,1);%prefilled
GoOn = 0; % control for the while, when it reaches whatever numXcolumns is, it'll stop.
addX = 0;
addY = 0;
while GoOn~= numXcolumns % this finds x centre points across the screen
    centreXquad(centrequadcounter)= Q1centreXquadCoOr +addX; % for first time through, it'll just take the value for Q1 centre
    centrequadcounter = centrequadcounter + 1;
    GoOn = GoOn + 1;
    addX = addX +cellwidth;
end
centrequadcounter = 1;
GoOn = 0;
while GoOn~= numYrows
    centreYquad(centrequadcounter)= Q1centreYquadCoOr +addY;
    centrequadcounter = centrequadcounter + 1;
    GoOn = GoOn + 1;
    addY = addY +cellheight;
end
GoOn = 0;
addX = 0;
while GoOn~= numXcolumns+1
    quadX(quadcounter) = innerXframerange(1) + addX;
    quadcounter = quadcounter +1;
    GoOn = GoOn +1;
    addX = addX + cellwidth;
end
GoOn = 0;
addY = 0;
quadcounter =1;
while GoOn~= numYrows+1
    quadY(quadcounter) = innerYframerange(1) + addY;
    quadcounter = quadcounter +1;
    GoOn = GoOn +1;
    addY = addY + cellheight;
end
% innerframewidth = (innerXframerange(2))- (innerXframerange(1));
% innerframeheight = (innerYframerange(2))- (innerYframerange(1));
centreXquad= transpose(centreXquad);
centreYquad = transpose(centreYquad);
%% This makes the unique positions on the screen but also
switch true
    case numXcolumns>=numYrows
        Xplacement = 0;
        while length(Xplacement)~=(numXcolumns*numYrows)
            Xplacement = repelem(centreXquad,numYrows);
            Yplacement = centreYquad;
            Yplacement= repmat(Yplacement,[1,numXcolumns]);
            [a,b] = unique([Xplacement;Yplacement]','rows','first');
            xyb = sortrows([a ,b],3)';
            Xplacement = xyb(1,:)';
            Yplacement = xyb(2,:)';

        end

    case numYrows>numXcolumns
        Yplacement =0;
        while length(Yplacement)~=(numXcolumns*numYrows)
            Yplacement = repelem(centreYquad,numXcolumns);
            Xplacement = centreXquad;
            Xplacement= repmat(Xplacement,[1,numYrows]);
            [a,b] = unique([Xplacement;Yplacement]','rows','first');
            xyb = sortrows([a ,b],3)';
            Xplacement = xyb(1,:)';
            Yplacement = xyb(2,:)';

        end
end

%% Find the exact locations to place the stimuli based on their centre positions. 
            Coordinates = cell({my_centreTexture(StimuliSizeX,StimuliSizeY,Xplacement,Yplacement)});
            Coordinates=cell2mat(Coordinates);
            Coordinates =Coordinates';
            x = [Coordinates(1,:),Coordinates(3,:)]';
            y = [Coordinates(2,:),Coordinates(4,:)]';

        Max=max([x,y])';
        Min =min([x,y])';
MinMaxXY=[Min;Max];


end
