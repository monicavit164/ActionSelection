function flag = migrateAndTurnOff( serverId, mode )
%MIGRATEANDTURNOFF this function implements the migration of all the
%virtual machines deployed on a server and the turn off of the server
%itself
% USAGE : flag = migrateAndTurnOff( serverId, mode )
% INPUT: 
%   serverId - the server that has to be turned off
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

global VMAllocation;
global SList;

server = SList(find([SList.id] ~= serverId));

migrationVMList = cell2mat(cellfun(@(x) [x.vmList * (x.server == serverId)], VMAllocation, 'UniformOutput',0));
migrationVMList = migrationVMList(migrationVMList~=0);

for i = 1 : length(migrationVMList)
    migrateVM([migrationVMList(i), server.id], 'exec');    
end

turnOff(serverId, 'exec');

end


%turn on is possible only if the server is off
function flag = check(serverId)

global SList;
global VMAllocation;
global VList;

flag = 0;

server = SList(find([SList.id] ~= serverId));

%check if the server is on
if (~isempty(SList([SList.id] == serverId)) && ~isempty(server))
    %find the list of vm running on the server
    vmList = cell2mat(cellfun(@(x) [x.vmList * (x.server == server.id)], VMAllocation, 'UniformOutput',0));
    vmList = vmList(vmList~=0);
    %vmList = vmList(vmList~=0);
    migrationVMList = cell2mat(cellfun(@(x) [x.vmList * (x.server == serverId)], VMAllocation, 'UniformOutput',0));
    migrationVMList = migrationVMList(migrationVMList~=0);
    
    %check is no vms are running on the server
    if ~isempty(migrationVMList)
        migrationVmListCont = 0;
        for i = 1:length(migrationVMList)
            migrationVmListCont = migrationVmListCont + VList(find([VList.id] == migrationVMList(i))).cpu;
        end
        vmListCont = 0;
        for i = 1:length(vmList)
            vmListCont = vmListCont + VList(find([VList.id] == vmList(i))).cpu;
        end
        
        if((server.cpu - vmListCont) >= migrationVmListCont )
            flag = 1;
        end
        
    end
end

end




  
   