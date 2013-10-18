
%adaptation actions definition
% id
% description
% completion time

Act1.id = 1;
Act1.description = 'VM migration';
Act1.time = 3;
Act1.exec = 'migrateVM';
Act1.params = 'vs';
Act1.label = 'A1';


Act2.id = 2;
Act2.description = 'VM Reconfiguration - add';
Act2.time = 1;
Act2.exec = 'reconfVMAdd';
Act2.params = 'v';
Act2.label = 'A2';

Act3.id = 3;
Act3.description = 'VM Reconfiguration - remove';
Act3.time = 1;
Act3.exec = 'reconfVMRem';
Act3.params = 'v';
Act3.label = 'A3';


Act6.id = 4;
Act6.description = 'Turn on Server';
Act6.time = 2;
Act6.exec = 'turnOn';
Act6.params = 's';
Act6.label = 'A6';


Act7.id = 5;
Act7.description = 'Turn off Server';
Act7.time = 2;
Act7.exec = 'turnOff';
Act7.params = 's';
Act7.label = 'A7';


Act22.id = 6;
Act22.description = 'Turn On and Migrate';
Act22.time = 3;
Act22.exec = 'turnOnAndMigrate';
Act22.params = 'vs';
Act22.label = 'AC2';


Act23.id = 7;
Act23.description = 'Migrate and Turn Off';
Act23.time = 3;
Act23.exec = 'migrateAndTurnOff';
Act23.params = 's';
Act23.label = 'AC1';

actions = [Act1, Act2, Act3, Act6, Act7];



