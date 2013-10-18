function flag = reconfVMAdd( vmId, mode )
%RECONFVMADD this function increment the CPU amount assigned to the VM
% USAGE : flag = reconfVMAdd( vmId, mode )
% INPUT: 
%   vmId - the id of the virtual machine 
%   mode - the modality of execution, it can be 'check' if we want to test
%   the applicability of the action, or 'exec' if we want to execute the
%   action
% OUTPUT:
%   flag - it is a boolean value. If mode = 'check' it returns 1 if the
%   action can be applied or 0 otherwise. If mode = 'exec' it is equal to 1

if (strcmp(mode, 'exec'))
    exec(vmId);
    flag = 1;
end

if (strcmp(mode, 'check'))
    flag = check(vmId);
end

end



function exec(vmId)

global VList;

VList([VList.id] == vmId).cpu = VList([VList.id] == vmId).cpu + 1; 

end


%reconfiguration adding resources is possible only if there are more
%resources available on the server
function flag = check(vmId)

global SList;
global VList;
global VMAllocation;



%find which server is running the vm
serverId = cell2mat(cellfun(@(x) [x.server * (find(x.vmList == vmId) ~=0)], VMAllocation, 'UniformOutput',0));

if(~isempty(serverId))
    server = SList(find([SList.id] == serverId));
    
    %find the list of vm running on the server
    vmList = cell2mat(cellfun(@(x) [x.vmList * (x.server == server.id)], VMAllocation, 'UniformOutput',0));
    vmList = vmList(vmList~=0);
    
    %find the total resources used on the server
    vmListCont = 0;
    for i = 1:length(vmList)
        vmListCont = vmListCont + VList(find([VList.id] == vmList(i))).cpu;
    end
    
    
    if((server.cpu - vmListCont) >= 1 )
        flag = 1;
    else
        flag = 0;
    end
    
else
    flag = 0;
end
    
end

