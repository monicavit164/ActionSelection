

function parList = findParList(action)
%FINDPARLIST this function finds all the possible parameters combinations
%given the action definition
% USAGE : parList = findParList(action)
% INPUT: 
%   action - a specific actions used in the experiment
% OUTPUT:
%   parList - an mxn array where each row correspond to a parameter
%   combination for the action

global VList;
global completeSList;

par = action.params;
    if (length(par) == 1)
        if(strcmp(par, 'v'))
            parList = [VList.id]';            
        elseif(strcmp(par, 's'))
            parList = [completeSList.id]';
        end
    elseif(length(par) == 2)
        [p,q] = meshgrid([VList.id], [completeSList.id]);
        parList = [p(:) q(:)];
    end
end
