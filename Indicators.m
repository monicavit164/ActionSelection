
%definition of thresholds over the available indicators

I1.type = 'CPU';
I1.trH = 90;
I1.tyH = 80;
I1.trL = 50;
I1.tyL = 60;
I1.label = 'U(S1)';

I2.type = 'CPU';
I2.trH = 90;
I2.tyH = 80;
I2.trL = 50;
I2.tyL = 60;
I2.label = 'U(S2)';

I3.type = 'energy';
I3.trH = 340;
I3.tyH = 320;
I3.trL = -inf;
I3.tyL = -inf;
I3.label = 'E(S1)';

I4.type = 'energy';
I4.trH = 270;
I4.tyH = 250;
I4.trL = -inf;
I4.tyL = -inf;
I4.label = 'E(S2)';

I5.type = 'rt';
I5.trH = 26;
I5.tyH = 25;
I5.trL = -inf;
I5.tyL = -inf;
I5.label = 'R(V1)';

I6.type = 'PE';
I6.trL = 1;
I6.tyL = 2;
I6.trH = -inf;
I6.tyH = -inf;
I6.label = 'PE(V1)';

I7.type = 'rt';
I7.trH = 27;
I7.tyH = 26;
I7.trL = -inf;
I7.tyL = -inf;
I7.label = 'R(V2)';

I8.type = 'PE';
I8.trL = 5;
I8.tyL = 10;
I8.trH = -inf;
I8.tyH = -inf;
I8.label = 'PE(V2)';

I9.type = 'rt';
I9.trH = 28;
I9.tyH = 26;
I9.trL = -inf;
I9.tyL = -inf;
I9.label = 'R(V3)';

I10.type = 'PE';
I10.trL = 1;
I10.tyL = 2;
I10.trH = -inf;
I10.tyH = -inf;
I10.label = 'PE(V3)';

I11.type = 'CPU';
I11.trH = 95;
I11.tyH = 85;
I11.trL = 25;
I11.tyL = 35;
I11.label = 'U(V1)';

I12.type = 'CPU';
I12.trH = 95;
I12.tyH = 85;
I12.trL = 25;
I12.tyL = 35;
I12.label = 'U(V2)';

I13.type = 'CPU';
I13.trH = 95;
I13.tyH = 85;
I13.trL = 25;
I13.tyL = 35;
I13.label = 'U(V3)';

I14.type = 'energy';
I14.trH = 100;
I14.tyH = 80;
I14.trL = -inf;
I14.tyL = -inf;
I14.label = 'E(V1)';

I15.type = 'energy';
I15.trH = 100;
I15.tyH = 80;
I15.trL = -inf;
I15.tyL = -inf;
I15.label = 'E(V2)';

I16.type = 'energy';
I16.trH = 100;
I16.tyH = 80;
I16.trL = -inf;
I16.tyL = -inf;
I16.label = 'E(V3)';

%indicators = {I11, I12, I13, I1, I2, I5, I7, I9, I6, I8, I10, I14, I15, I16, I3, I4};
%indicators = {I11, I12, I1, I2, I5, I7, I6, I8, I14, I15, I3, I4};
%indicators = {I11, I12, I1, I5, I7, I6, I8, I14, I15, I3};
