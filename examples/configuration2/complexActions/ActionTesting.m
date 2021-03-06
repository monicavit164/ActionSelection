function [finalScore, averageScore, loadCounter, initialD] = ActionTesting( Actions, t_op )
%ACTIONTRAINING this function is used to test under an increasing load the Adaptive Action Selection algorithm
% USAGE : [finalScore, averageScore, loadCounter, initialD] = ActionTesting( Actions, t_op )
% INPUT:
%   Actions - a complex structure containing information about the impact
%   and the quality of each action for each of its possible parameters
%   t_op - the current counter of runs of the learning algorithm
% OUTPUT:
%   finalScore - a vector containing the average final score at each load
%   averageScore - a vector containing the average score of a step at each load
%   loadCounter - a matrix containing the number of times each action has
%   been used at each load
%   initialD - a vector containing the average initial distance from the
%   optimal configuration for each load

DCConfiguration;
adaptationActions;
global ActionsList
ActionsList = [Act1, Act2, Act3, Act6, Act7, Act23, Act22];
Indicators;
global IndicatorsList;
IndicatorsList = {I11, I12, I13, I1, I2, I5, I7, I9, I6, I8, I10, I14, I15, I16, I3, I4};

finalScore = zeros(1,20);
averageScore = zeros(1,20);
loadCounter = cell(1,20);
initialD = zeros(1,20);

for l = 1:20
    inputs.load = [l,l,l];
    inputs.Actions = Actions;
    inputs.t_op = t_op;
    inputs.verbose = 0;
    tempScore = [];
    tempScore2 = [];
    tempInitialD = 0;
    for i = 1:50
        DCConfiguration;
        [Actions, t_opN, score, actionCounter, d] = Testing(inputs);
        tempScore = [tempScore (score / (t_opN - t_op)) ];
        tempScore2 = [tempScore2 score ];
        tempInitialD = tempInitialD + d;
        t_op = t_opN;
        if (isempty(loadCounter{l}))
            loadCounter{l} = actionCounter;
        else
            loadCounter{l} = loadCounter{l} + actionCounter;
        end
    end
    averageScore(l) = mean(tempScore(~isnan(tempScore)));
    finalScore(l) = mean(tempScore2(~isnan(tempScore2)));
    loadCounter{l} = loadCounter{l}/i;
    initialD(l) = tempInitialD /i;
end

figure();
plot(initialD, 'xk')
hold
plot(initialD - finalScore, 'r');

end

