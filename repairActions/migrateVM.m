
function flag = migrateVM( pars, mode)
%MIGRATEVM this function execute the migration of a VM in a specified server
% USAGE : flag = migrateVM( pars, mode)
% INPUT: 
%   pars - a vector containing two values: the id of the virtual machine to be migrated and the id of the server where to migrate
%   mode - the modality of execution, it can be 'check' if we want to test
%   the applicability of the action, or 'exec' if we want to execute the
%   action
% OUTPUT:
%   flag - it is a boolean value. If mode = 'check' it returns 1 if the
%   action can be applied or 0 otherwise. If mode = 'exec' it is equal to 1


if (strcmp(mode, 'exec'))
    exec(pars(1), pars(2));
    flag = 1;
end

if (strcmp(mode, 'check'))
    flag = check(pars(1), pars(2));
end

            
end

function exec(vmId, serverId)

global VMAllocation;


for x = 1:length(VMAllocation)
    if (VMAllocation{x}.server == serverId)
        if(find(VMAllocation{x}.vmList == vmId))
        else
            VMAllocation{x}.vmList = [VMAllocation{x}.vmList, vmId];
        end
    else
        ind = find(VMAllocation{x}.vmList == vmId);
        if (ind) 
            VMAllocation{x}.vmList(ind) = [];
        end
    end
end


end


%migration is possibe only if the cpu available on server "serverId" is
%more than the one needed by virtual machine vmId and if the vm is not
%already in the specified server
function flag = check(vmId, serverId)

global SList;
global VList;
global VMAllocation;

server = SList(find([SList.id] == serverId));

if isempty(server)
    flag = 0;
else    
    vm = VList(find([VList.id] == vmId));
    
    vmList = cell2mat(cellfun(@(x) [x.vmList * (x.server == server.id)], VMAllocation, 'UniformOutput',0));
    vmList = vmList(vmList~=0);
    
    %check if the vm is already on the specified server
    if(isempty(find(vmList == vmId)))
        vmListCont = 0;
        for i = 1:length(vmList)
            vmListCont = vmListCont + VList(find([VList.id] == vmList(i))).cpu;
        end
        
        
        if((server.cpu - vmListCont) >= vm.cpu )
            flag = 1;
        else
            flag = 0;
        end
    else
        flag = 0;
    end
    
end

end
