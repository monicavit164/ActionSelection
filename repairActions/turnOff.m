function flag = turnOff( serverId, mode )
%TURNOFF this function turn off a server
% USAGE : flag = turnOff( serverId, mode )
% INPUT: 
%   serverId - the id of the server to turn off 
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
global VMAllocation;

SList([SList.id] == serverId) = [];

ind = 0;
for x = 1:length(VMAllocation)
    if (VMAllocation{x}.server == serverId)
        ind = x;        
    end
end

if (ind==0)
    
elseif(ind == 1 && length(VMAllocation) == 1)
    VMAllocation = {};
elseif(ind == 1)
    VMAllocation = VMAllocation(2:end);
elseif(ind == length(VMAllocation))
    VMAllocation = VMAllocation(1:end-1);
else
    VMAllocation = [VMAllocation(1:ind-1), VMAllocation(ind+1:end)];
end


end


%turn off is possible only if the server is on and no vm are running on it
function flag = check(serverId)

global SList;
global VMAllocation;

flag = 0;

%check if the server is on
if ~isempty(SList([SList.id] == serverId))
    %find the list of vm running on the server
    vmList = find(cell2mat(cellfun(@(x) [x.vmList * (x.server == serverId)], VMAllocation, 'UniformOutput',0)));
    %vmList = vmList(vmList~=0);
    
    %check is no vms are running on the server
    if isempty(vmList)
        flag = 1;
    else
        flag = 0;
    end
end

end

