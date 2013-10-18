%Data center components definition

%Servers: id, number of cpus, peak power consumption
S1.id = 1;
S1.cpu = 4;
S1.cpuT.trH = 90;
S1.cpuT.tyH = 80;
S1.cpuT.trL = 50;
S1.cpuT.tyL = 60;
S1.peak = 350;
S1.E.trH = 340;
S1.E.tyH = 320;

S2.id = 2;
S2.cpu = 4;
S2.cpuT.trH = 90;
S2.cpuT.tyH = 80;
S2.cpuT.trL = 50;
S2.cpuT.tyL = 60;
S2.peak = 280;
S2.E.trH = 270;
S2.E.tyH = 250;

global SList;
SList = [S1];
global completeSList;
%completeSList = [S1, S2];
completeSList = [S1];

%Activities parameters definition
A1.id = 1;
A1.N = 1000;
A1.R.trH = 26;
A1.R.tyH = 24;
A1.PE.tyL = 2;
A1.PE.trL = 1;
A1.lambda = 0.2;
A1.prob = 1;
A1.completionTime = 20;

A2.id = 2;
A2.N = 10000;
A2.R.trH = 27;
A2.R.tyH = 26;
A2.PE.tyL = 10;
A2.PE.trL = 5;
A2.lambda = 0.3;
A2.prob = 1;
A2.completionTime = 20;

global AList;
AList = [A1, A2];

%Virtual Machines: id, number of cpus, number of transactions executed
%during a run of the activity, thresholds
V1.id = 1;
V1.cpu = 2;
V1.cpuT.trH = 95;
V1.cpuT.tyH = 85;
V1.cpuT.trL = 25;
V1.cpuT.tyL = 35;
V1.activity = A1;
V1.E.trH = 100;
V1.E.tyH = 80;


V2.id = 2;
V2.cpu = 2;
V2.cpuT.trH = 95;
V2.cpuT.tyH = 85;
V2.cpuT.trL = 25;
V2.cpuT.tyL = 35;
V2.activity = A2;
V2.E.trH = 100;
V2.E.tyH = 80;

global VList;
VList = [V1, V2];

% rows are servers, columns are virtual machines, 1 if virtual machine j on
% server i
% rows are servers, columns are virtual machines, 1 if virtual machine j on
% server i
global VMAllocation;
%VMAllocation = [1 0 1; 0 1 0];
vs1.server = S1.id;
vs1.vmList = [V1.id, V2.id];
VMAllocation = {vs1};
