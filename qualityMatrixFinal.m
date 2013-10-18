function qualityMatrix = qualityMatrixFinal( Actions )
%QUALITYMATRIXFINAL this function extacts the information about the quality
%from the complex Actions structure
% USAGE : qualityMatrix = qualityMatrixFinal( Actions )
% INPUT: 
%   Actions - a complex structure containing information about the impact
%   and the quality of each action for each of its possible parameters
% OUTPUT:
%   qualityMatrix - an mxn matrix in which each row corresponds to the
%   impact value of a given action with given parameters over all the
%   indicators. The order is the same of the definition of the actions

global IndicatorsList; 

qualityCells = cellfun(@(x)  x.quality, Actions, 'UniformOutput',0);

qualityMatrix = [];

for i = 1:length(qualityCells)
    qualityMatrixTemp =  reshape(cell2mat(cellfun(@(x)  [x{2}], qualityCells{i}, 'UniformOutput',0)), length(IndicatorsList), length(qualityCells{i}))';
    qualityMatrix = [qualityMatrix; qualityMatrixTemp];
end

qualityMatrix = qualityMatrix .* (abs(qualityMatrix)>0.1);

end

