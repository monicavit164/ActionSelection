function flag = turnOnAndMigrate( pars, mode )
%TURNONANDMIGRATE thif function implements the turning on of a server and
%the migration of a vm on it
% USAGE : flag = turnOnAndMigrate( pars, mode )
% INPUT: 
%   pars - a vector containing two values: the id of the virtual machine to
%   be migrated and the id of the server to turn on
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

turnOn(serverId, 'exec');
migrateVM([vmId, serverId], 'exec');

end


%turn on is possible only if the server is off
function flag = check(vmId, serverId)

global VList;
global completeSList;

flag = 0;

if (turnOn(serverId, 'check'))  
    server = completeSList(find([completeSList.id] == serverId));
    
    vm = VList(find([VList.id] == vmId));
    
    if (server.cpu  >= vm.cpu )
        flag = 1;
    end

end
end




  
   