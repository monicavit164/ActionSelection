function [] = drawQuality( qualityMatrix )
%DRAWQUALITY This function draws a matrix containing the quality of each
%actions over the indicators
% USAGE : drawQuality( qualityMatrix )
% INPUT:
%   qualityMatrix - the matrix containing the quality values for each
%   action over each indicator

global ActionsList;
global IndicatorsList;

indicatorsLabels = cellfun(@(x) x.label, IndicatorsList, 'UniformOutput',0);

actionsLabels = {};
for i = 1:length(ActionsList)
    p = findParList(ActionsList(i));
    for j = 1:size(p,1)
        actionsLabels{length(actionsLabels) + 1} = [ActionsList(i).label, '(' num2str(p(j,:)) ')'];
    end
end


imagesc(abs(qualityMatrix));
colorbar;
%q = qualityMatrix';
textStrings = num2str(qualityMatrix(:),'%0.2f');

textStrings = strtrim(cellstr(textStrings));
[x,y] = meshgrid(1:size(qualityMatrix,2), 1:size(qualityMatrix,1));

hStrings = text(x(:),y(:),textStrings(:),'HorizontalAlignment','center');


colormap(flipud(gray));
midValue = 0.5;
textColors = repmat(abs(qualityMatrix(:)) > midValue,1,3);
set(hStrings,{'Color'},num2cell(textColors,2));



set(gca,'XTick',1:size(qualityMatrix,2),'XTickLabel',indicatorsLabels,'YTick',1:size(qualityMatrix,1),'YTickLabel',actionsLabels, 'TickLength',[0 0]);

end

