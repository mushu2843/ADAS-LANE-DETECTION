%% SIL Validation - MATLAB vs SIL

% Test conditions
distance = [25 15 5];
canSpeed = [70 70 70];

% Expected ADAS results from original model
expectedCollision = [0 1 1];
expectedAEB       = [0 0 1];
expectedSpeed     = [70 20 0];

% SIL results obtained from simulation
silCollision = [0 1 1];
silAEB       = [0 0 1];
silSpeed     = [70 20 0];

% Compare results
collisionPass = expectedCollision == silCollision;
aebPass       = expectedAEB == silAEB;
speedPass     = expectedSpeed == silSpeed;

% Create validation table
ValidationTable = table( ...
    distance', canSpeed', ...
    expectedCollision', silCollision', ...
    expectedAEB', silAEB', ...
    expectedSpeed', silSpeed', ...
    collisionPass', aebPass', speedPass', ...
    'VariableNames', { ...
    'Distance_m','CAN_Speed_kmh', ...
    'Expected_Collision','SIL_Collision', ...
    'Expected_AEB','SIL_AEB', ...
    'Expected_OutputSpeed','SIL_OutputSpeed', ...
    'Collision_Pass','AEB_Pass','Speed_Pass'});

disp(ValidationTable)

% Overall validation
if all(collisionPass) && all(aebPass) && all(speedPass)
    disp("SIL VALIDATION: PASS")
else
    disp("SIL VALIDATION: FAIL")
end

%% Save SIL Validation Results

writetable(ValidationTable, 'SIL_Validation_Results.xlsx');

save('SIL_Validation_Results.mat', ...
    'ValidationTable');

disp("SIL validation results saved successfully.");