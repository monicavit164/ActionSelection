function flag = reconfVMRem( vmId, mode )
%RECONFVMREM this function remove a cpu core from a VM
% USAGE : flag = reconfVMRem( vmId, mode )
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

VList([VList.id] == vmId).cpu = VList([VList.id] == vmId).cpu - 1; 

end


%reconfiguration removing resources is possible only if there are minimal
%resources garanteed to the vm
function flag = check(vmId)

global VList;

vm = VList(find([VList.id] == vmId));

if (vm.cpu >1)
    flag = 1;
else
    flag = 0;    
end

end

