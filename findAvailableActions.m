

function actionList = findAvailableActions(actions)
%FINDAVAILABLEACTIONS this function creates a combination of action - parameters that are
%appliable in the given context, excluding all the actions that can't be
%applied
% USAGE : actionList = findAvailableActions(actions)
% INPUT: 
%   actions - the list of actions used in the experiment
% OUTPUT:
%   actionList - a complex structure containing the id of each action and the list of parameters to which it can be applied

actionList = cell(1);
c = 1;

for i = 1:length(actions)
    arg = findParList(actions(i));
    check = zeros(length(arg), 1);
    for j = 1:length(arg)
        check(j) = eval([actions(i).exec '(' mat2str(arg(j,:)) ', ''check'' )'] );
    end
    arg = arg(check==1,:);
    if (~isempty(arg))
        actionList{c} = {actions(i).id, arg};
        c = c+1;
    end

end

end


