function [Actions, t_op] = ActionTraining( )
%ACTIONTRAINING this function is used to simulate several loads to train
%the Adaptive Action Selection algorithm
% USAGE : Actions = ActionTraining( )
% OUTPUT:
%   Actions - a complex structure containing information about the impact
%   and the quality of each action for each of its possible parameters
%   t_op - the current counter of runs of the learning algorithm

DCConfiguration;
adaptationActions;
global ActionsList
ActionsList = [Act1, Act2, Act3, Act6, Act7, Act22];
Indicators;
global IndicatorsList;
IndicatorsList = {I11, I12, I1, I2, I5, I7, I6, I8, I14, I15, I3, I4};

inputs.load = [5,5];
inputs.Actions = [];
inputs.t_op = [];
inputs.verbose = 0;
[Actions, t_op] = ActionSelection(inputs);

for l = 1:20
    inputs.load = [5,5];
    inputs.Actions = Actions;
    inputs.t_op = t_op;
    [Actions, t_op] = ActionSelection(inputs);    
end

for l = 1:20
    inputs.load = [l,5];
    inputs.Actions = Actions;
    inputs.t_op = t_op;
    [Actions, t_op] = ActionSelection(inputs);
end


% for l = 1:20
%     inputs.load = [5,l];
%     inputs.Actions = Actions;
%     inputs.t_op = t_op;
%     [Actions, t_op] = ActionSelection(inputs);
% end
% 
% for l = 1:20
%     inputs.load = [l,l];
%     inputs.Actions = Actions;
%     inputs.t_op = t_op;
%     [Actions, t_op] = ActionSelection(inputs);
% end
% 
% for l = 1:20
%     inputs.load = [20-l,l];
%     inputs.Actions = Actions;
%     inputs.t_op = t_op;
%     [Actions, t_op] = ActionSelection(inputs);
% end
% 
% for l = 1:20
%     inputs.load = [l,20-l];
%     inputs.Actions = Actions;
%     inputs.t_op = t_op;
%     [Actions, t_op] = ActionSelection(inputs);
% end

quality = qualityMatrixFinal(Actions);


drawQuality(quality);

end

