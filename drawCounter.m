function [] = drawCounter( counter, labels1, labels2 )
%DRAWCOUNTER This function draws a matrix containing the number of times
%each action has been applied at each load rate.
% USAGE : drawCounter( qualityMatrix, labels1, labels2 )
% INPUT:
%   counter - the matrix containing the number of applications of each
%   action at each load rate
%   labels1 - a cell array containing the names of the actions
%   labels2 - a cell array containing the load labels

image(zeros(size(counter,1), size(counter,2)));
%colorbar;
%q = qualityMatrix';
textStrings = num2str(counter(:));

textStrings = strtrim(cellstr(textStrings));
[x,y] = meshgrid(1:size(counter,2), 1:size(counter,1));

hStrings = text(x(:),y(:),textStrings(:),'HorizontalAlignment','center');

    colormap(flipud(gray));
    midValue = 10000;
    textColors = repmat(abs(counter(:)) > midValue,1,3);
    set(hStrings,{'Color'},num2cell(textColors,2));



set(gca,'XTick',1:size(counter,2),'XTickLabel',labels2,'YTick',1:size(counter,1),'YTickLabel',labels1, 'TickLength',[0 0]);


end

