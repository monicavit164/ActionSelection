function flag = turnOn( serverId, mode )
%TURNON thif function implements the turning on of a server
% USAGE : flag = turnOn( serverId, mode )
% INPUT: 
%   serverId - the id of the server to turn on 
%   mode - the modality of execution, it can be 'check' if we want to test
%   the applicability of the action, or 'exec' if we want to execute the
%   action
% OUTPUT:
%   flag - it is a boolean value. If mode = 'check' it returns 1 if the
%   action can be applied or 0 otherwise. If mode = 'exec' it is equal to 1

if (strcmp(mode, 'exec'))
    exec(serverId);
    flag = 1;
end

if (strcmp(mode, 'check'))
    flag = check(serverId);
end


end



function exec(serverId)
global SList;
global completeSList;
global VMAllocation;

%check if the server is already on
if (isempty(SList([SList.id] == serverId)) && ~isempty(completeSList([completeSList.id] == serverId)))
    SList = [SList, completeSList([completeSList.id] == serverId)];
    index = length(VMAllocation)+1;
    VMAllocation{index}.server = serverId;
    VMAllocation{index}.vmList = [];
end


end


%turn on is possible only if the server is off
function flag = check(serverId)

global SList;
global completeSList;

if isempty(SList([SList.id] == serverId)) && ~isempty(completeSList([completeSList.id] == serverId))
    flag = 1;
else
    flag = 0;
end

end

