clc;
clear;
close all;

%% =====================================
% INTEGRATED ADAS VALIDATION
% ======================================

% Test data
testName = [
    "Normal Driving"
    "Close Vehicle"
    "Very Close Vehicle"
    "High Speed"
    "Safe Distance"
    ];

vehicleSpeed = [40; 40; 40; 90; 50];

distanceAhead = [30; 15; 7; 30; 25];

expectedAction = [
    "NORMAL DRIVING"
    "SLOW DOWN / MAINTAIN DISTANCE"
    "BRAKE IMMEDIATELY"
    "REDUCE SPEED"
    "NORMAL DRIVING"
    ];

numberOfTests = length(testName);

testResult = strings(numberOfTests,1);

%% =====================================
% RUN VALIDATION TESTS
% ======================================

for i = 1:numberOfTests

    %% ADAS Decision

    if distanceAhead(i) < 10

        actualAction = "BRAKE IMMEDIATELY";

    elseif distanceAhead(i) < 20

        actualAction = "SLOW DOWN / MAINTAIN DISTANCE";

    elseif vehicleSpeed(i) > 80

        actualAction = "REDUCE SPEED";

    else

        actualAction = "NORMAL DRIVING";

    end

    %% Compare Expected and Actual

    if actualAction == expectedAction(i)

        testResult(i) = "PASS";

    else

        testResult(i) = "FAIL";

    end

end

%% =====================================
% DISPLAY RESULTS
% ======================================

disp("======================================================");
disp("           INTEGRATED ADAS VALIDATION");
disp("======================================================");

for i = 1:numberOfTests

    fprintf("\nTest %d : %s\n",i,testName(i));
    fprintf("Speed       : %.1f km/h\n",vehicleSpeed(i));
    fprintf("Distance    : %.1f m\n",distanceAhead(i));
    fprintf("Expected    : %s\n",expectedAction(i));
    fprintf("Result      : %s\n",testResult(i));

end

%% =====================================
% FINAL VALIDATION RESULT
% ======================================

passedTests = sum(testResult == "PASS");
failedTests = sum(testResult == "FAIL");

disp("======================================================");

fprintf("Total Tests  : %d\n",numberOfTests);
fprintf("Passed       : %d\n",passedTests);
fprintf("Failed       : %d\n",failedTests);

if failedTests == 0
    overallResult = "VALIDATION PASSED";
else
    overallResult = "VALIDATION FAILED";
end

fprintf("Overall Result : %s\n",overallResult);

disp("======================================================");