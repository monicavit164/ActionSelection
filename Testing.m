function [Actions, t_op, score, actionCounter, d] = Testing( inputs )
%TESTING this function is used to test the Adaptive Action
%Selection algorithm by running several time the algorithm with the same
%load
% USAGE : [Actions, t_op, score, actionCounter, d] = ActionSelection( inputs )
% INPUT: 
%   inputs.load - the load for each virtual machine in the configuration, default
%   load = 5
%   inputs.Actions - the quality information for each actions obtained by previous
%   runs, default Actions = empty
%   inputs.t_op - number of previous runs of the learning algorithm, default = 1
%   inputs.verbose - take values 1 or 0, if 1 than prints information during the
%   execution
% OUTPUT:
%   Actions - a complex structure containing information about the impact
%   and the quality of each action for each of its possible parameters
%   t_op - the current counter of runs of the learning algorithm
%   score - the absolute improvement in the distance function from the
%   initial configuration
%   actionCounter - a vector containing the number of times each action is
%   applied
%   d - the initial distance from the optimal configuration

global ActionsList;
global VList;
global IndicatorsList;

actionCounter = zeros(1, length(ActionsList));

%windows size ofr credit computation
W = 5;

if (~isempty(inputs.verbose))
    %the total number of actions executed
    verbose = inputs.verbose;
else
    verbose = 0;
end

if (isempty(inputs.load))
    load = zeros(1, length(VList)) + 5;
else
    load = inputs.load;
end


%first step
[indicatorsSample, assessedSamples] = assessment( load );

if (isempty(inputs.Actions))
    %each action is associated to some information: the action description,
    %impact and quality for each of the available parameters.
    Actions = cell(1,length(ActionsList));
    for i = 1:length(ActionsList)
        Actions{i}.action = ActionsList(i);
        parList = findParList(ActionsList(i));
        for j = 1:length(parList)
            %in impact, the first value is the parameter list, then the impact
            %matrix (considering the window W), then the number of times of
            %application and finally the timestamp of the last application
            Actions{i}.impact{j} = {parList(j,:), zeros(W, length(assessedSamples)), 0, 0};
            Actions{i}.quality{j} = {parList(j,:), zeros(1, length(assessedSamples))};
        end
    end
else
    Actions = inputs.Actions;
end

if (isempty(inputs.t_op))
    %the total number of actions executed
    t_op = 1;
else
    t_op = inputs.t_op;
end

%the weight of violation importance for each indicator
w_n = zeros(length(assessedSamples),1);

%it keeps count of the time of the last application of the
%actions
last_op_index = 4;

count_op_index = 3;

%compute alarm interval size
alarmS = cell2mat( cellfun(@(x) min(x.trH-x.tyH, x.tyL-x.trL), IndicatorsList, 'UniformOutput',0));

support = 5;

count = 0;
countTot = 10;

score = 0;

%avoid ripetitive migrations, it contains the id of VMs recently migrated
%and the timestamp of the migration
migrationList = zeros(1,2);

%if i don't improve for some steps i stop except something change
nop_steps = 0;

violations = find(assessedSamples ~= (support+1)/2);
d = sum(abs(assessedSamples(violations)-(support+1)/2));

while(count<countTot)
    
    violations = find(assessedSamples ~= (support+1)/2);
    d1 = sum(abs(assessedSamples(violations)-(support+1)/2));
    
    if(~isempty(violations))
        if (verbose)
            disp(['Violated indicators are: ', num2str(violations)]);
        end
        
        %update w
        w_n(:) = 0;
        w1_n = w_n;
        %w_n(:) = -0.1; %penalty for modification of satisfied indicators
        w_n( [find(assessedSamples == 1), find(assessedSamples == 5)]) = 1;
        w_n( [find(assessedSamples == 2), find(assessedSamples == 4)]) = 0.5;
        
        w1_n(w_n == 0) = 1;
        
        %-----select the subsection of action and parameters that can be
        %applied
        availableActions = findAvailableActions(ActionsList);
        
        %check for migrations in black list
        
        migrationList(find(count - migrationList(:,2) > 10 ),:) = [];
        
        
        if (availableActions{1}{1} == 1)
            for i = 1:size(migrationList,1)
                index = find(availableActions{1}{2}(:,1) == migrationList(i,1));
                if (~isempty(index) )
                    availableActions{1}{2}(index,:) = [];
                    if (isempty(availableActions{1}{2}))
                        availableActions(1) = [];
                    end
                end
            end
        end
        
        
        
        c = 0;
        
        quality_c = cell(1);
        for i = 1:length(availableActions)
            for j = 1:size(availableActions{i}{2},1)
                q_index = find(cell2mat(cellfun(@(x) isequal(x{1}, availableActions{i}{2}(j,:)) , Actions{availableActions{i}{1}}.quality, 'UniformOutput',0)));
                impact_index = find(cell2mat(cellfun(@(x) isequal(x{1}, availableActions{i}{2}(j,:)) , Actions{availableActions{i}{1}}.impact, 'UniformOutput',0)));
                l_op = Actions{availableActions{i}{1}}.impact{impact_index}{count_op_index};
                q = Actions{availableActions{i}{1}}.quality{q_index}{2};
                q(:,assessedSamples>=4) = -q(:,assessedSamples>=4);
                quality_c{c+1} = {availableActions{i}{1}, availableActions{i}{2}(j,:), q, l_op};
                c = c+1;
            end
        end
        
        %check for actions never applied...
        new_actions = find(cell2mat(cellfun(@(x)  x{4} == 0, quality_c, 'UniformOutput',0)));
        
        if(~isempty(new_actions))
            quality_c = {quality_c{new_actions}};
            %probability is equal for all the actions
            p = ones(1,length(quality_c))/length(quality_c);
        else
            
            p1 = cell2mat(cellfun(@(x) max(0, sum(x{3}.*w_n')) , quality_c, 'UniformOutput',0));
            
            penalty = cell2mat(cellfun(@(x) max(0, sum(abs(x{3}).*w1_n'/length(w1_n))) , quality_c, 'UniformOutput',0))/2;
            for i=1:length(p1)
                a = Actions{find(cell2mat(cellfun(@(x) isequal(x.action.id, quality_c{i}{1}) , Actions, 'UniformOutput',0)))}.action.id;
                %t = actions([actions.id] == a).time;
                %p1(i) = max(0,(p1(i)-penalty(i))/t);
                p1(i) = max(0,(p1(i)-penalty(i)));
            end
            
            %compute p_min as dependent on affordability of the best action and
            %on the number of available actions
            p_min = (1-max(p1)) / (length(quality_c) * 10);
            
            
            %update general probability
            p = zeros(1,length(p1));
            if(sum(p1)~=0)
                p = p_min + (1 - length(quality_c) * p_min) * p1 / sum(p1);
            else
                %if there are no informations the probability is equal for all
                %actions
                %p(:) = 1/length(actions);
                p(:) = 1/length(quality_c);
            end
            
        end
        
        if (verbose)
            index = 0;
            for i = 1:length(availableActions)
                for j = 1:size(availableActions{i}{2},1)
                    disp([ 'Action ' num2str(availableActions{i}{1}) '  par: ' num2str(availableActions{i}{2}(j,:)) ' prob: ' num2str(p1(index+j)) ])
                end
                index = index+j;
            end
        end
        
        %select an action only if ptobability is not too low
        if (max(p1)<0.1)
            
            if (verbose)
                disp('No actions available for this context');
            end
            
            nop_steps = nop_steps + 1;
            if (nop_steps > 5)
                count = countTot;
            end
            [indicatorsSample2, assessedSamples2] = assessment( load );
        else
            nop_steps = 0;
            %wheele selection mechanism
            p(p<0.1) = 0;
            accumulation = cumsum(p);
            r = rand() * accumulation(end);
            indSelectedAction = find(accumulation>=r,1);
            
            selectedAction = find(cell2mat(cellfun(@(x) isequal(x.action.id, quality_c{indSelectedAction}{1}) , Actions, 'UniformOutput',0)));
            
            actionCounter(Actions{selectedAction}.action.id) = actionCounter(Actions{selectedAction}.action.id) + 1;
            
            %***************************************************************************************************
            
            if (verbose)
                disp(['Proposed action is Action ', num2str(quality_c{indSelectedAction}{1}), ': ' , Actions{selectedAction}.action.description, ',  with parameters [' , num2str(quality_c{indSelectedAction}{2}) , ']']);
            end
            
            ev = eval([Actions{selectedAction}.action.exec '(' mat2str(quality_c{indSelectedAction}{2}) ', ''exec'' )']);
            
            [indicatorsSample2, assessedSamples2] = assessment( load );
            
            %%%%results evaluation and quality update
            
            %impact: computed on all the indicators
            %the current impact value
            impact = zeros(size(indicatorsSample));
            
            indTrend = indicatorsSample2 - indicatorsSample;
            impact(indTrend>=alarmS/3) = 0.5;
            impact(indTrend>=alarmS) = 1;
            impact(indTrend<=-alarmS/3) = -0.5;
            impact(indTrend<=-alarmS) = -1;
            
            %impacts(selectedAction, :, mod(count(selectedAction), W)+1) = impact;
            
            %impact
            
            impactIndex = find(cell2mat(cellfun(@(x) isequal(x{1}, quality_c{indSelectedAction}{2}) , Actions{selectedAction}.impact, 'UniformOutput',0)));
            Actions{selectedAction}.impact{impactIndex}{2}(mod(Actions{selectedAction}.impact{impactIndex}{3}, W)+1,:) = impact;
            
            %credit computation as an average of the impact observed
            credit = zeros(size(impact));
            
            for i = 1:length(assessedSamples)
                if(sum(Actions{selectedAction}.impact{impactIndex}{2}(:, i)~=0))
                    credit(i) = sum(Actions{selectedAction}.impact{impactIndex}{2}(:, i)) / (sum(Actions{selectedAction}.impact{impactIndex}{2}(:, i)~=0));
                else
                    credit(i) = 0;
                end
            end
            
            %count(selectedAction) = count(selectedAction) + 1;
            Actions{selectedAction}.impact{impactIndex}{count_op_index} = Actions{selectedAction}.impact{impactIndex}{count_op_index} + 1;
            
            alpha = 1 - Actions{selectedAction}.impact{impactIndex}{last_op_index}/t_op;
            
            Actions{selectedAction}.quality{impactIndex}{2} = (1-alpha) * Actions{selectedAction}.quality{impactIndex}{2} + alpha * credit;
            
            %update the vector that counts the time expired since the last
            %application of each action
            Actions{selectedAction}.impact{impactIndex}{last_op_index} = t_op;
            t_op = t_op +1;
            
            
            
            violations2 = find(assessedSamples2 ~= (support+1)/2);
            d2 = sum(abs(assessedSamples2(violations2)-(support+1)/2));
            
            score = score + (d1 - d2)
            
            if ((quality_c{indSelectedAction}{1} == 1 || quality_c{indSelectedAction}{1} == 6 || quality_c{indSelectedAction}{1} == 7 ) && (d1-d2) >= 0)
                migrationList(size(migrationList,1) + 1, :) = [quality_c{indSelectedAction}{2}(1) count];
            end;
        end
        
    else
        [indicatorsSample2, assessedSamples2] = assessment( load );
    end
    
    count = count + 1;
    assessedSamples = assessedSamples2;
    indicatorsSample = indicatorsSample2;
end


end
