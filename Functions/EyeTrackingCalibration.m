function EyeTrackingCalibration(tol,buff)
%% Modified by Tess Barich 2021. Loosely Based on Tobii Pro Research Package
%%Eye Tracking Set Up
global  Env DATA 
global MyEyeTracker sp TimeStamps OverallGazeData calibrationStart TobiiOperations failed_licenses
%Declare the globals used in this function.
%% Eyetracking Initiation
ETFunctions =[Env.Loc_Functions filesep 'ETFunctions']; %Declare where the functions folder for ET is.
addpath(genpath(ETFunctions));% Add the ET functions to the current path

TobiiOperations = EyeTrackingOperations(); %Initialise ET operations function
FindMyEyetracker = []; %Find all eye trackers currently connected to the device
while isempty(FindMyEyetracker)
FindMyEyetracker = TobiiOperations.find_all_eyetrackers(); %Find all eye trackers currently connected to the device
end 
MyEyeTracker=FindMyEyetracker(1); %Use the first ET on the list
MyEyetrackerAddress = MyEyeTracker.Address; %Save the ET's address to calib global
FilePath = [[ETFunctions filesep 'Licenses' filesep] getmatchedfile([ETFunctions filesep 'Licenses' filesep],MyEyeTracker.SerialNumber)]; %Apply the most recently updated file as the license
fileID = fopen(FilePath, 'r'); %create file ID for the License file
InputLicense = LicenseKey(fread(fileID));
fclose(fileID);
Env.ET_licenseFile =FilePath; % Declare ET License file path to global environment variable.
Env.ETAddress =MyEyetrackerAddress; %Decalre ET Address to global environment varible.
failed_licenses = MyEyeTracker.apply_licenses(InputLicense);% Returns an array with the licenses that were not successfully applied. Should return empty if all the licenses were correctly applied.

%% Calibration of eyetracking

visualangleforgaze = tol; %pass through the inputted variables from Noarlunga.m
visualangleforgazebuffer =buff; %pass through the inputted variables from Noarlunga.m
%% Track status

dotSizePix = 20;% Dot size in pixels
OverallGazeData=MyEyeTracker.get_gaze_data();% Start collecting data
% The subsequent calls return the current values in the stream buffer.
%Screen ('OpenWindow', Env.MainWindow,Env.Colours.LightGrey);%Open a window using psychimaging and colour it light grey
Screen('TextSize', Env.MainWindow, 20); %Set text size to 20pt.

while ~KbCheck %Show the following display until any key is pressed. 
    DrawFormattedText(Env.MainWindow, 'When correctly positioned press any key to start the calibration.', 'center', Env.ScreenInfo.height * 0.1, Env.Colours.White); % Draw the text to the screen
    distance = []; % Assign empty variable for distance from eyetracker
   gaze_data = MyEyeTracker.get_gaze_data(); %This is the subsequent call to the eye tracker, will give data between the last call and now. 
  % OverallGazeData(end+1)=gaze_data;
    if ~isempty(gaze_data) % If gaze data isnt empty 
        last_gaze = gaze_data(end); %declare last gaze variable
        validityColor = Env.Colours.Red; %Set validity colour for empty gaze data to red. 
        % Check if user has both eyes inside a reasonable tracking area.
       
        if last_gaze.LeftEye.GazeOrigin.Validity.Valid && last_gaze.RightEye.GazeOrigin.Validity.Valid %if both eyes are valid
            left_validity = all(last_gaze.LeftEye.GazeOrigin.InTrackBoxCoordinateSystem(1:2) < 0.85) ...
                && all(last_gaze.LeftEye.GazeOrigin.InTrackBoxCoordinateSystem(1:2) > 0.15);
            right_validity = all(last_gaze.RightEye.GazeOrigin.InTrackBoxCoordinateSystem(1:2) < 0.85) ...
                && all(last_gaze.RightEye.GazeOrigin.InTrackBoxCoordinateSystem(1:2) > 0.15);
           
            if left_validity && right_validity
                validityColor = Env.Colours.Green;% Set validity colour to green if both eyes are within reasonable tracking area
            end
        end
       
        origin = [Env.ScreenInfo.width/4 Env.ScreenInfo.height/4]; % Declare origin variable for validity tests
        ScreenPixsize = [Env.ScreenInfo.width/2 Env.ScreenInfo.height/2];
        penWidthPixels = 3;
        baseRect = [0 0 ScreenPixsize(1) ScreenPixsize(2)];
        frame = CenterRectOnPointd(baseRect, Env.ScreenInfo.width/2, Env.ScreenInfo.Centre(2));
        Screen('FrameRect', Env.MainWindow, validityColor, frame, penWidthPixels);
       
        % Left Eye
        if last_gaze.LeftEye.GazeOrigin.Validity.Valid
            distance = [distance; round(last_gaze.LeftEye.GazeOrigin.InUserCoordinateSystem(3)/10,1)];
            left_eye_pos_x = double(1-last_gaze.LeftEye.GazeOrigin.InTrackBoxCoordinateSystem(1))*ScreenPixsize(1) + origin(1);
            left_eye_pos_y = double(last_gaze.LeftEye.GazeOrigin.InTrackBoxCoordinateSystem(2))*ScreenPixsize(2) + origin(2);
            Screen('DrawDots', Env.MainWindow, [left_eye_pos_x left_eye_pos_y], dotSizePix, validityColor, [], 2); % Show on screen the position of the user's eyes to garantee that the user is positioned correctly in the tracking area.
        end
      
        % Right Eye
        if last_gaze.RightEye.GazeOrigin.Validity.Valid
            distance = [distance;round(last_gaze.RightEye.GazeOrigin.InUserCoordinateSystem(3)/10,1)];
            right_eye_pos_x = double(1-last_gaze.RightEye.GazeOrigin.InTrackBoxCoordinateSystem(1))*ScreenPixsize(1) + origin(1);
            right_eye_pos_y = double(last_gaze.RightEye.GazeOrigin.InTrackBoxCoordinateSystem(2))*ScreenPixsize(2) + origin(2);
            Screen('DrawDots', Env.MainWindow, [right_eye_pos_x right_eye_pos_y], dotSizePix, validityColor, [], 2);% Show on screen the position of the user's eyes to garantee that the user is positioned correctly in the tracking area.
        end
        pause(0.05);
    end
    
    DrawFormattedText(Env.MainWindow, sprintf('Current distance to the eye tracker: %.2f cm.',mean(distance)), 'center', Env.ScreenInfo.height * 0.85, Env.Colours.White); % Draw to the screen
    Screen('Flip', Env.MainWindow);% Flip to the screen. This command basically draws all of our previous
end
MyEyeTracker.stop_gaze_data();
%% Calibration

spaceKey = KbName('Space'); % Declare space key to use for later
RKey = KbName('R'); % Declare R key to use for Recalibration Command
enterKey = KbName('Return'); % Declare enter key to for Continue command
dotSizePix = 20; % Set dot size to 20 pixels
mmdotSizePix = dotSizePix/Env.ScreenInfo.pixelpermm; %Calculate dot size in mms
distancemm = distance*10; % Calculate distance in mm
bufferzone = tol+buff; % visual angle buffer wanted
dotColor = [[Env.Colours.Red];[Env.Colours.White]];%Set dot colours to Red and White
leftColor = Env.Colours.Red;% Set left eye to red - for display of eyes paths after looking task.
rightColor = Env.Colours.Blue;% Set right eye to blue - for display of eyes path after looking task. 

% get the angle for the buffer in actual experiment
[my_desiredAngle.PointPix,my_desiredAngle.PointMM] = desiredSize(visualangleforgaze,distancemm(1),Env.ScreenInfo.pixelpermm);
my_CurrentAngle = visAngle(my_desiredAngle.PointMM,distancemm(1));
[my_desiredBuffer.PointPix,my_desiredBuffer.PointMM] = desiredSize(visualangleforgazebuffer,distancemm(1),Env.ScreenInfo.pixelpermm);
my_BufferAngle = visAngle(my_desiredBuffer.PointMM,distancemm(1));

% Calibration points
lb = 0.1;  % left bound
xc = 0.5;  % horizontal center
rb = 0.9;  % right bound
ub = 0.1;  % upper bound
yc = 0.5;  % vertical center
bb = 0.9;  % bottom bound

points_to_calibrate = [[lb,ub];[rb,ub];[xc,yc];[lb,bb];[rb,bb]]; % Create 5x2 matrix with the calibration points. 
calibrationStart = ScreenBasedCalibration(MyEyeTracker);% Create calibration object
calibrating = true; % Declare variable for while loop below.

while calibrating
    calibrationStart.enter_calibration_mode();% Enter calibration mode
    for i=1:length(points_to_calibrate)
        Screen('DrawDots', Env.MainWindow, points_to_calibrate(i,:).*Env.ScreenInfo.Resolution, dotSizePix, dotColor(1,:), [], 2);
        Screen('DrawDots', Env.MainWindow, points_to_calibrate(i,:).*Env.ScreenInfo.Resolution, dotSizePix*0.5, dotColor(2,:), [], 2);
        Screen('Flip', Env.MainWindow);
        pause(1); % Wait a moment to allow the user to focus on the point
        if calibrationStart.collect_data(points_to_calibrate(i,:)) ~= CalibrationStatus.Success % Try calibration again if calibration was not successful 
            calibrationStart.collect_data(points_to_calibrate(i,:)); % Reset the points to calibrate. 
        end
    end

    DrawFormattedText(Env.MainWindow, 'Calculating calibration result....', 'center', 'center', Env.Colours.White); % Draw the text to the screen
    Screen('Flip', Env.MainWindow); % Flip the screen. 
    calibration_result = calibrationStart.compute_and_apply(); % Blocking call that returns the calibration result
    calibrationStart.leave_calibration_mode()
   
    if calibration_result.Status ~= CalibrationStatus.Success
        break
    end

    points = calibration_result.CalibrationPoints;   % Calibration Result

    for i=1:length(points)
        Screen('DrawDots', Env.MainWindow, points(i).PositionOnDisplayArea.*Env.ScreenInfo.Resolution, dotSizePix*0.5, dotColor(2,:), [], 2);
        for j=1:length(points(i).RightEye)
            if points(i).LeftEye(j).Validity == CalibrationEyeValidity.ValidAndUsed
                Screen('DrawDots', Env.MainWindow, points(i).LeftEye(j).PositionOnDisplayArea.*Env.ScreenInfo.Resolution, dotSizePix*0.3, leftColor, [], 2);
                Screen('DrawLines', Env.MainWindow, ([points(i).LeftEye(j).PositionOnDisplayArea; points(i).PositionOnDisplayArea].*Env.ScreenInfo.Resolution)', 2, leftColor, [0 0], 2);
                VisualAngle(i).LeftEye(j).PointPos = visAngle(mmdotSizePix,distancemm(1));
                [my_desiredSize(i).LeftEye(j).PointPix,my_desiredSize(i).LeftEye(j).PointMM] = desiredSize((VisualAngle(i).LeftEye(j).PointPos+bufferzone),distancemm(1),Env.ScreenInfo.pixelpermm);
                tolL =    (my_desiredSize(i).LeftEye(j).PointPix)';
                lefteyedistpix(i) = sqrt(((calibration_result.CalibrationPoints(i).LeftEye(j).PositionOnDisplayArea(1)*Env.ScreenInfo.width(1)) -(points(1,i).PositionOnDisplayArea(1)*Env.ScreenInfo.width(1)))^2 + ((calibration_result.CalibrationPoints(i).LeftEye(j).PositionOnDisplayArea(2)*Env.ScreenInfo.height(1)) -(points(1,i).PositionOnDisplayArea(2)*Env.ScreenInfo.height(1)))^2);% circle tolerance
                if lefteyedistpix<= tolL
                    lefteyetolerant(i) = 1;
                else
                    lefteyetolerant(i) = 0;
                end
            end
            if points(i).RightEye(j).Validity == CalibrationEyeValidity.ValidAndUsed
                Screen('DrawDots', Env.MainWindow, points(i).RightEye(j).PositionOnDisplayArea.*Env.ScreenInfo.Resolution, dotSizePix*0.3, rightColor, [], 2);
                Screen('DrawLines', Env.MainWindow, ([points(i).RightEye(j).PositionOnDisplayArea; points(i).PositionOnDisplayArea].*Env.ScreenInfo.Resolution)', 2, rightColor, [0 0], 2);
                VisualAngle(i).RightEye(j).PointPos = visAngle(mmdotSizePix,distancemm(2));
                [my_desiredSize(i).RightEye(j).PointPix,my_desiredSize(i).RightEye(j).PointMM] = desiredSize((VisualAngle(i).RightEye(j).PointPos+bufferzone),distancemm(2),Env.ScreenInfo.pixelpermm);
                tolR =    (my_desiredSize(i).RightEye(j).PointPix);
                tolerance(:,i)= [tolL;tolR];
                righteyedistpix(i) = sqrt(((calibration_result.CalibrationPoints(i).RightEye(j).PositionOnDisplayArea(1)*Env.ScreenInfo.width(1)) -(points(1,i).PositionOnDisplayArea(1)*Env.ScreenInfo.width(1)))^2 + ((calibration_result.CalibrationPoints(i).RightEye(j).PositionOnDisplayArea(2)*Env.ScreenInfo.height(1)) -(points(1,i).PositionOnDisplayArea(2)*Env.ScreenInfo.height(1)))^2);% circle tolerance
                if righteyedistpix<= tolR
                    righteyetolerant(i) = 1;
                else
                    righteyetolerant(i) = 0;
                end
            end
        end
    end
switch true 
    case (length(lefteyetolerant)==5 && length(righteyetolerant)==5)
    if sum(lefteyetolerant + righteyetolerant) ~= 10 % THIS IS USED FOR CIRCLE TOLERANCE CALCS
        DrawFormattedText(Env.MainWindow, 'Calibration failed... please try again....Press any key', 'center', Env.ScreenInfo.height * 0.95, Env.Colours.White);
        Screen('Flip', Env.MainWindow);
        KbWait([],2);
        calibrating = true;
    else
        DrawFormattedText(Env.MainWindow, 'Press the ''R'' key to recalibrate or ''Enter'' to continue....', 'center', Env.ScreenInfo.height * 0.95, Env.Colours.White);
        Screen('Flip', Env.MainWindow);
        timer_one = GetSecs;

        while 1.
            [ keyIsDown, deltaseconds, keyCode ] = KbCheck;
            keyCode = find(keyCode, 1);
            if keyIsDown
                if keyCode == enterKey
                    calibrating = false;
                    break;
                elseif keyCode == RKey
                    break;
                end
                KbReleaseWait;
            end
        end
    end
    otherwise 
               DrawFormattedText(Env.MainWindow, 'Calibration failed... please try again....Press any key', 'center', Env.ScreenInfo.height * 0.95, Env.Colours.White);
        Screen('Flip', Env.MainWindow);
        KbWait([],2);
        calibrating = true;

end
end 
%Screen('Close', Env.MainWindow);
end
%% END CALIBRATION