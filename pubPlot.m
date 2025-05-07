function [fig] = pubPlot(NVArgs)
%pubPlot Formats current figure to publication quality.
%   Modifies and rescales the current figure to minimize whitespace and
%   improve the overall aesthetic for publication quality plots. 
%
%   Inputs
%   -------
%   None: will use the current figure by default.
%
%   Figure Property Inputs
%   -------
%   Figure: Handle of figure to format. Default = current figure
%   filename: String specifying filename.eps to export. Default = ''
%   Width: Column width of the figure. Default = single column width
%   Journal: Journal/Publisher name to specify figure size. Currently
%            supports: Elsevier, Springer, Nature, Wiley. 
%            Default = Elsevier
%   Height: Height of the figure. Default = 235 points
%   SpacingOffset: Amount of spacing between lables, ticks, and axes, 
%                  specified as a scalar numeric value in points. 
%                  Default = 1. Please see included pubPlotLayout.png for
%                  more information.
%   TiledLayout: Array of [m,n] integers. For figures with subplots, divides
%                the current figure into an m-by-n grid, filling the figure
%                row-wise with the axes currently in the object.
%
%   Font Property Inputs
%   -------
%   FontSize: Font size of the title, legends, and colorbars specified as a
%             scalar numeric value. Default = 12.
%   FontName: Font name, specified as a supported font name. Deafult =
%             Arial.
%   FontColor: Color of the title, legends, and colorbars specified as
%              an RGB triplet, a hexadecimal color code, a color name, or 
%              a short name. Default = [0 0 0] (Black)
%   AxisFontSize: Font size of the axis labels and tick lables specified as
%                 a scalar numeric value. Default = 12.
%   AxisFontColor: Color of the axis line, tick values, and labels  
%                  specified as an RGB triplet, a hexadecimal color code, a
%                  color name, or a short name. Default = [0 0 0] (Black)
%   Interpreter: All text objects interpreter, specified as one of these values:
%                'tex' — Interpret labels using a subset of the TeX markup.
%                'latex' — Interpret labels using a subset of LaTeX markup.
%                          When you specify the tick labels, use dollar 
%                          signs around each element in the cell array.
%                'none' — Display literal characters.
%
%   Plot Property Inputs
%   -------
%   LineWidth: Line width, specified as a positive value in points. If the 
%              line has markers, then the line width also affects the 
%              marker edges. Default = 2 points.
%   MarkerSize: Marker size, specified as a positive value in points.
%               Default = 8 points.
%   AxisLineWidth: Line width of axes outline, tick marks, and grid lines,
%                  specified as a positive numeric value in points.
%                  Default = 1.8 points
%   TickLength: Tick mark length, specified as a positive numeric value in
%               points. The funciton will attempt to match this length, as
%               MATLAB handles this normalized to the longest axis length.
%               Default = 3 points.
%   BoxColor: Background color, specified as an RGB triplet, a hexadecimal 
%             color code, a color name, or a short name. Default = 'none'
%
%   Grid Property Inputs
%   -------
%   Grid: Grid lines, specified as 'on' or 'off', or as numeric or logical 1 (true) or 0 (false).
%   GridLineWidth: Grid line width, specified as a positive number in 
%                  points. Default = 1.
%   GridColor: Color of grid lines, specified as an RGB triplet, a 
%              hexadecimal color code, a color name, or a short name.
%              Default = [0.15 0.15 0.15]
%
%
%   Optional Inputs
%   -------
%   ToolBar: Switch to hide the toolbar in the figure (which can mess with
%            the spacing/export of the figure). Default = 'none'
%   ExportMessage: Switch to display message on successful file export and
%                  modification. Default = 'on'
%   verbosity: verbosity/plot level 0-4. Default = 2.
%
%   Returns
%   -------
%   fig: Figure handle of the updated figure
%
%   Notes
%   -------
%   - This function is built ontop of MATLAB's existing plotting
%     functionality. For more information on figure properties, please see
%     the associated MATLAB documentation and help pages.
%   - This funcion only supports 2D plots.
%   - Color of plot objects is not modified.
%   - The content of text objects is not modified, but their location is.
%   - Axis limits and tick values are not modified.
%   - To reduce whitespace, the tick labels are manually moved and placed
%     as text objects. The centering of labels on tick marks is not
%     straightforward, so double-check alignment before final publication.
%
%
% Author: Collin Haese
% Date: May 06 2025
% Version: 1.0.1 Alpha
% 
% TODO:
% Tex interpreter breaks eps export?
% Only supports RGB triplet colors
% Validate font names
% check support for tiledlayout
% PNG/other export options
% manually set text sizes to account for
% lock positions to keep consistency across plots
arguments
    % figure properties
    NVArgs.Figure matlab.ui.Figure = gcf % handle of figure
    NVArgs.filename (1,:) char = ''
    NVArgs.Width (1,:) char {mustBeMember(NVArgs.Width, {'single', '1.5', 'double'})} = 'single'
    NVArgs.Journal (1,:) char {journalList} = 'Elsevier'
    NVArgs.Height (1,1) double {numericPositiveScalar} = 235
    NVArgs.SpacingOffset (1,1) double {numericPositiveScalar} = 1
    NVArgs.TiledLayout double {mustBeValidLayout} = [] % [m,n]
    
    % font properties
    NVArgs.FontSize (1,1) double {numericPositiveScalar} = 12
    NVArgs.FontName (1,:) char = 'Arial'
    NVArgs.FontColor (3,1) double = [0 0 0]
    NVArgs.AxisFontSize (1,1) double {numericPositiveScalar} = 12
    NVArgs.AxisColor (3,1) double = [0 0 0]
    NVArgs.Interpreter (1,:) char {mustBeMember(NVArgs.Interpreter, {'none', 'tex', 'latex'})} = 'tex'

    % plot properties
    NVArgs.LineWidth (1,1) double {numericPositiveScalar} = 2
    NVArgs.MarkerSize (1,1) double {numericPositiveScalar} = 8
    NVArgs.AxisLineWidth (1,1) double {numericPositiveScalar} = 1.8
    NVArgs.TickLength (2,1) double {mustBeNonnegative} = [3, 1.5]
    NVArgs.BoxColor = 'none'
    
    % grid properties
    NVArgs.Grid matlab.lang.OnOffSwitchState = 'off'
    NVArgs.GridLineWidth (1,1) double {numericPositiveScalar} = 1
    NVArgs.GridColor (3,1) double = [0.15 0.15 0.15]

    % legend properties - inherited from original plot and font properties

    % optional (but helpful) properties
    NVArgs.ToolBar (1,:) char {mustBeMember(NVArgs.ToolBar, {'none', 'auto', 'figure'})} = 'none'
    NVArgs.ExportMessage (1,:) char {mustBeMember(NVArgs.ExportMessage, {'on', 'off'})} = 'on'

    NVArgs.verbosity (1,1) {ismember(NVArgs.verbosity, [0,1,2,3,4])} = 2
    % specify the level of detail related to plotting
    % and text output. A higher value results in a higher level of
    % detail. The following options are possible:
    % Numeric Representation | Name         | Verbosity Description
    % ------------------------------------------------------------------------
    % 0	                     | None	        | No information
    % 1	                     | Terse        | Minimal information
    % 2	(Default)            | Concise      | Moderate amount of information
    % 3	                     | Detailed     | Some supplemental information
    % 4	                     | Verbose      | Lots of supplemental information
    
end

verbosity = NVArgs.verbosity;

if verbosity < 2
    NVArgs.ExportMessage = 'off';
end

% get figure handle
fig = NVArgs.Figure;

% get all axes of figure
subPlotFlag = false; % flag if multiple plots
% if a subplot, will have multiple axes
axesList = findall(fig, 'Type', 'axes');
if numel(axesList) == 0
    error('No axes object detected. Figure is empty.')
elseif numel(axesList) > 1
    subPlotFlag = true;
    % flip axis so first subplot is first position
    axesList = flip(axesList);
end

% make sure plots are 2D only
for ax = axesList'
    if ~isempty(get(ax, 'ZLim')) && ~isequal(get(ax, 'ZLim'),[-1 1])
        error('3D axes detected — pubPlot supports 2D only.');
    end
end

% determine layout of figure, either from User input or estimate if there
% are multiple plots per figure (subplots)
if subPlotFlag
    if isempty(NVArgs.TiledLayout)
        % estimate the layout
        [m, n] = estimateSubplotLayout(length(axesList));
        NVArgs.TiledLayout = [m, n];
        
    else
        [m, n] = NVArgs.TiledLayout;
    end
    numFigRows = m;
    numFigCols = n;
else
    numFigRows = 1;
    numFigCols = 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%% SET FIGURE PROPERTIES %%%%%%%%%%%%%%%%%%%%%%%%%%

% change figure units to points (Illustrator default)
fig.Units = 'points';

% hide toolbar in figure
fig.ToolBar = NVArgs.ToolBar;

% set figure width to correct artwork sizing
% Note: this is not necessarily the maximum width allowed, but the width I
% have found works best in the associated Latex/Word template
if strcmpi(NVArgs.Journal,'Elsevier')
    if strcmpi(NVArgs.Width,'single')
        figureWidth = 252;
    elseif strcmpi(NVArgs.Width,'1.5')
        figureWidth = 394;
    elseif strmcpi(NVArgs.Width,'double')
        figureWidth = 536;
    end
elseif strcmpi(NVArgs.Journal,'Springer')
    if strcmpi(NVArgs.Width,'single')
        figureWidth = 238;
    elseif strcmpi(NVArgs.Width,'1.5')
        figureWidth = 365;
    elseif strmcpi(NVArgs.Width,'double')
        figureWidth = 493;
    end
elseif strcmpi(NVArgs.Journal,'Nature')
    if strcmpi(NVArgs.Width,'single')
        figureWidth = 255;
    elseif strcmpi(NVArgs.Width,'1.5')
        figureWidth = 382;
    elseif strmcpi(NVArgs.Width,'double')
        figureWidth = 510;
    end
elseif strcmpi(NVArgs.Journal,'Wiley')
    if strcmpi(NVArgs.Width,'single')
        figureWidth = 226;
    elseif strcmpi(NVArgs.Width,'1.5')
        figureWidth = 352;
    elseif strmcpi(NVArgs.Width,'double')
        figureWidth = 480;
    end
end

% height of figure, defaults to 235 points
figureHeight = NVArgs.Height;

% grab current screen size and place figure at the center
screenSize = get(0, 'ScreenSize');  % [x y width height] in pixels
screenWidth = screenSize(3);
screenHeight = screenSize(4);
centerX = 0.75*(screenWidth/2); % convert to points
centerY = 0.75*(screenHeight/2);

% rescale and shape figure to correct size
set(fig, 'Units', 'points');
set(fig, 'Position', [(centerX-figureWidth/2) (centerY-figureHeight/2) ...
    figureWidth figureHeight]);  % position on screen

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LOOP OVER AXES %%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% compute subPlot total width and heights
% when only one plot, use entire figure space
subFigureWidth = figureWidth/numFigCols;
subFigureHeight = figureHeight/numFigRows;

% for subPlots, compute x and y position offsets
xSubPlotOffset = repmat([0:subFigureWidth:subFigureWidth],1,numFigCols);
ySubPlotOffset = flip(reshape(repmat([0:subFigureHeight:subFigureHeight],2,1),1,[]));

for k = 1 : numel(axesList)

% translate current axis based on (potential) subplot position 

% get current axis handle
ax = axesList(k);

% change axis units to points (Illustrator default)
ax.Units = 'points';

% set axis properties
set(ax, 'FontName', NVArgs.FontName, 'FontSize', NVArgs.AxisFontSize, ...
    'LineWidth', NVArgs.AxisLineWidth, 'TickDir', 'out', 'Box', 'off');
% set axis color
set(ax, 'XColor', NVArgs.AxisColor, 'YColor', NVArgs.AxisColor,...
    'ZColor', NVArgs.AxisColor);

% set grid properties
% turn on or off
grid(ax, NVArgs.Grid);
if NVArgs.Grid
    ax.GridLineWidth = NVArgs.GridLineWidth;
    ax.GridColor = NVArgs.GridColor;
end

% change background color
ax.Color = NVArgs.BoxColor;

% scale labels and fonts to 1.0 of text size
ax.LabelFontSizeMultiplier = 1.0;
ax.TitleFontSizeMultiplier = 1.0;

% set all line stroke properties and marker sizes
lines = findall(ax, 'Type', 'Line');
for i = 1 : length(lines)
    lines(i).LineWidth = NVArgs.LineWidth;
    lines(i).MarkerSize = NVArgs.MarkerSize;
end

% set legend properties to font properties
leg = findobj(gcf, 'Type', 'Legend');
for i = 1 : length(leg)
    set(leg(i), 'FontSize', NVArgs.FontSize, 'Box', 'off',...
                'Interpreter', NVArgs.Interpreter);
end

% set title font properties
title(ax.Title.String, 'FontSize', NVArgs.FontSize, ...
    'FontWeight', 'bold', 'Interpreter', NVArgs.Interpreter,...
    'Color', NVArgs.FontColor);

% set axis font properties
xlabel(ax.XLabel.String, 'FontSize', NVArgs.AxisFontSize,...
    'Interpreter', NVArgs.Interpreter, 'Color', NVArgs.FontColor);
ylabel(ax.YLabel.String, 'FontSize', NVArgs.AxisFontSize,...
    'Interpreter', NVArgs.Interpreter, 'Color', NVArgs.FontColor);


%%%%%%%%%%%%%%%%%%%%%%%%%%%% REDUCE WHITESPACE %%%%%%%%%%%%%%%%%%%%%%%%%%%%
Spacing = NVArgs.SpacingOffset;

% record axis limits and labels to preserve their original values
XLim = ax.XLim;
YLim = ax.YLim;
XTick = ax.XTick;
YTick = ax.YTick;
XTickLabels = ax.XTickLabel;
YTickLabels = ax.YTickLabel;

% get desired tick length
tickLength = NVArgs.TickLength(1);

% for the longest string in the tick labels, find the extents of the
% associated text box (should be the largest extents)
lengthsX = cellfun(@strlength, ax.XTickLabel);
[~, idx] = max(lengthsX);                   % get index of longest string
longestStrX = ax.XTickLabel{idx};              % extract longest string
extXTick = getTextSize(longestStrX,NVArgs.FontName,NVArgs.AxisFontSize);

lengthsY = cellfun(@strlength, ax.YTickLabel);
[~, idx] = max(lengthsY);                   % get index of longest string
longestStrY = ax.YTickLabel{idx};              % extract longest string
extYTick = getTextSize(longestStrY,NVArgs.FontName,NVArgs.AxisFontSize);

% find extent of the text box for last tick labels (the ones which may fall
% outside of the figure, i.e. at the X and Y limits)
extXTickLast = getTextSize(ax.XTickLabel{end},NVArgs.FontName,NVArgs.AxisFontSize);
extYTickLast = getTextSize(ax.YTickLabel{end},NVArgs.FontName,NVArgs.AxisFontSize);

% find x and y label extents

% flag if xLabels and yLabels contain string
xLabelFlag = false;
yLabelFlag = false;

xLabl = ax.XLabel;
if ~isempty(xLabl.String)
    set(xLabl, 'Units', 'points');
    extXLabel = get(xLabl, 'Extent');
    extXLabel = extXLabel(3:4);
    xLabelFlag = true;
else
    extXLabel = [0,0];
end

yLabl = ax.YLabel;
if ~isempty(yLabl.String)
    set(yLabl, 'Units', 'points');
    extYLabel = get(yLabl, 'Extent');
    extYLabel = extYLabel(3:4);
    yLabelFlag = true;
else
    extYLabel = [0,0];
end

% distance from the left edge to the origin
plotLeftOffset = (3*Spacing + extYLabel(1) + extYTick(1) + tickLength);

% distance from the right edge to the end of the x-axis path
maxPlotWidth = subFigureWidth-plotLeftOffset-Spacing;
% approximate the approximate x location of the last XTick
finalXLocation = (maxPlotWidth)/(ax.XLim(2) - ax.XLim(1))*(ax.XTick(end)-ax.XLim(1))+plotLeftOffset;

% check if last XTickLabel will extend past the figure limits
if finalXLocation + extXTickLast(1)/2 > subFigureWidth
    % if so, adjust
    plotRightOffset = Spacing + ceil(extXTickLast(1)/2*4)/4;
elseif NVArgs.AxisLineWidth > Spacing
    % check if axis path extends past the figure limits (if the label doesn't)
    plotRightOffset = Spacing + ceil(NVArgs.AxisLineWidth*4)/4;
else
    % do not need to adjust
    plotRightOffset = Spacing;
end

% distance from the bottom edge to the origin
plotBottomOffset = (3*Spacing + extXLabel(2) + extXTick(2) + tickLength);

% distance from the top edge to the end of the y-axis path
maxPlotHeight = subFigureHeight-plotBottomOffset-Spacing;
% approximate the approximate y location of the last YTick
finalYLocation = (maxPlotHeight)/(ax.YLim(2) - ax.YLim(1))*(ax.YTick(end)-ax.YLim(1))+plotBottomOffset;

% check if last XTickLabel will extend past the figure limits
if finalYLocation + extYTickLast(2)/2 > subFigureHeight
    % if so, adjust
    plotTopOffset = Spacing + ceil(extYTickLast(2)/2*4)/4;
elseif NVArgs.AxisLineWidth > Spacing
% check if axis path extends past the figure limits (if the label doesn't)
    plotTopOffset = Spacing + ceil(NVArgs.AxisLineWidth*4)/4;
else
    % do not need to adjust
    plotTopOffset = Spacing;
end

% round to the nearest 0.25
plotLeftOffset = roundQtr(plotLeftOffset);
plotRightOffset = roundQtr(plotRightOffset);
plotBottomOffset = roundQtr(plotBottomOffset);
plotTopOffset = roundQtr(plotTopOffset);

% width and height of the plot area
plotWidth = subFigureWidth - (plotLeftOffset + plotRightOffset);
plotHeight = subFigureHeight - (plotBottomOffset + plotTopOffset);

% adjust axis position
ax.Position = [plotLeftOffset + xSubPlotOffset(k),...
               plotBottomOffset + ySubPlotOffset(k),...
               plotWidth, plotHeight];

% reset limits
ax.XLim = XLim;
ax.YLim = YLim;
ax.XTick = XTick;
ax.YTick = YTick;

% manually place tick labels

% adjust for apparent width of plot area
% MATLAB does some weird stuff here
cycle = mod(round(roundQtr(Spacing)*4), 3);
switch cycle
    case 0
        offset = 0; % 0.0, 0.75, 1.5, ...
    case 1
        offset = 0.25; % 0.25, 1.0, 1.75, ...
    case 2
        offset = -0.25; % 0.5, 1.25, 2.0, ...
end
apparentWidth = plotWidth + offset;
apparentHeight = plotHeight; % seems to be correct
 % adjust for text descent, but shifts text too high
descentCompensation = 0.1*NVArgs.AxisFontSize;

% function to map x data point to position in points
XDataToPoint = @(x) (apparentWidth)/(ax.XLim(2) - ax.XLim(1))*(x-ax.XLim(1));

% function to map y data point to position in points
YDataToPoint = @(y) (apparentHeight)/(ax.YLim(2) - ax.YLim(1))*(y-ax.YLim(1));

% remove existing labels
ax.XTickLabel = {};
% store in new array
XTickText = {};

for i = 1 : size(XTickLabels,1)
    t = text(XDataToPoint(ax.XTick(i)) - (subFigureWidth - xSubPlotOffset(k)),...
        -(plotBottomOffset - 2*Spacing - extXLabel(2)) + ySubPlotOffset(k),...
        [XTickLabels{i,1}],...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'bottom', ...
        'FontSize', ax.FontSize,'FontName',ax.FontName,...
        'Color', NVArgs.FontColor,'Units','points');

    XTickText{i,1} = t;
end

% remove existing labels
ax.YTickLabel = {};
% store in new array
YTickText = {};

for i = 1 : size(YTickLabels,1)
    t = text(-(Spacing+tickLength) - (subFigureWidth - xSubPlotOffset(k)),...
        YDataToPoint(ax.YTick(i)) + ySubPlotOffset(k),...
        YTickLabels{i,1}, ...
        'HorizontalAlignment', 'right', ...
        'VerticalAlignment', 'middle', ...
        'FontSize', ax.FontSize,'FontName',ax.FontName,...
        'Color', NVArgs.FontColor,'Units','points');
    YTickText{i,1} = t;
end

% adjust tick length
% find longest axis length
maxAxLen = max([apparentWidth,apparentHeight]);
ax.TickLength = [tickLength/maxAxLen, tickLength/maxAxLen];

% manually place axis labels

% place X label
if xLabelFlag
    XLabelText = text(apparentWidth/2 - xSubPlotOffset(k),...
        -(plotBottomOffset - Spacing) + ySubPlotOffset(k),...
        xLabl.String, ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'bottom', ...
        'FontSize', ax.FontSize,'FontName',ax.FontName,...
        'Color', NVArgs.FontColor,'Units','points');
    xLabl.String = '';
end

% place Y label
if yLabelFlag
    YLabelText = text(-(plotLeftOffset - Spacing) - xSubPlotOffset(k),...
        apparentHeight/2 + ySubPlotOffset(k),...
        yLabl.String, ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'top', ...
        'FontSize', ax.FontSize,'FontName',ax.FontName,...
        'Color', NVArgs.FontColor,'Units','points',...
        'Rotation',90);
    yLabl.String = '';
end

% manually place title
if ~isempty(ax.Title.String)
    TitleText = text(apparentWidth/2 - xSubPlotOffset(k),...
        apparentHeight + ySubPlotOffset(k),...
        ax.Title.String, ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'middle', ...
        'FontSize', ax.FontSize,'FontName',ax.FontName,...
        'Color', NVArgs.FontColor,'Units','points');
    ax.Title.String = '';
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%% EXPORT FIGURE %%%%%%%%%%%%%%%%%%%%%%%%%%
% export figure as .eps file with filename.eps
if ~isempty(NVArgs.filename)
    filename = NVArgs.filename;

    exportgraphics(fig, filename, 'ContentType', 'vector')
    % print(fig, filename, '-depsc2', '-vector');
    
    % modify postscript file to enable easy opening in Illustrator

    % read all lines from original postscript file
    lines = readlines(filename);

    % store updated lines in new array
    linesNew = string();
    linesNewCounter = 1;

    % list of fonts to export
    fontList = string();
    if strcmp(NVArgs.FontName,'Arial')
        fontList = {'Arial';'Arial-Bold';'Arial-Italic';'Arial-BoldItalic'};
    end

    fontDictFlag = 0; % font dictionary flag
    fontReencodeFlag = 0; % font reencoding flag
    fontCommandFlag = 0; % place font command

    % loop through all lines and modify
    for i = 1 : size(lines,1)
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%% PARSE FLAGS %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        if strcmp(lines{i,1},'%FOPBeginFontDict')
            fontDictFlag = 1;
            % copy BeginFontDict line
            linesNew{linesNewCounter,1} = lines{i,1};
            linesNewCounter = linesNewCounter+1;
            % manually update font reencoding commands
            for j = 1 : size(fontList,1)
                linesNew{linesNewCounter,1} = ['%%IncludeResource: font ',fontList{j,1}];
                linesNewCounter = linesNewCounter+1;
            end
        end

        if strcmp(lines{i,1},'%FOPEndFontDict')
            fontDictFlag = 0;
        end

        if strcmp(lines{i,1},'%FOPBeginFontReencode')
            fontReencodeFlag = 1;
            % copy BeginFontReencode line
            linesNew{linesNewCounter,1} = lines{i,1};
            linesNewCounter = linesNewCounter+1;
            % manually update font reencoding commands
            for j = 1 : size(fontList,1)
                linesNew{linesNewCounter,1} = ['/',fontList{j,1},' findfont'];
                linesNewCounter = linesNewCounter+1;
                linesNew{linesNewCounter,1} = 'dup length dict begin';
                linesNewCounter = linesNewCounter+1;
                linesNew{linesNewCounter,1} = '  {1 index /FID ne {def} {pop pop} ifelse} forall';
                linesNewCounter = linesNewCounter+1;
                linesNew{linesNewCounter,1} = '  /Encoding WinAnsiEncoding def';
                linesNewCounter = linesNewCounter+1;
                linesNew{linesNewCounter,1} = '  currentdict';
                linesNewCounter = linesNewCounter+1;
                linesNew{linesNewCounter,1} = 'end';
                linesNewCounter = linesNewCounter+1;
                linesNew{linesNewCounter,1} = ['/',fontList{j,1},' exch definefont pop'];
                linesNewCounter = linesNewCounter+1;
            end
        end

        if strcmp(lines{i,1},'%FOPEndFontReencode')
            fontReencodeFlag = 0;
        end

        if contains(lines{i,1},'/Helvetica') && ~fontDictFlag && ~fontReencodeFlag
            if ~fontReencodeFlag
                % skip command during reencode
                fontCommandFlag = 1;
            end
        end

        %%%%%%%%%%%%%%%%%%%%%%%%% WRITE NEW LINES %%%%%%%%%%%%%%%%%%%%%%%%%
        if ~fontDictFlag && ~fontReencodeFlag && ~fontCommandFlag
            % copy line as is
            linesNew{linesNewCounter,1} = lines{i,1};
            linesNewCounter = linesNewCounter+1;

            % set artboard size
            if contains(lines{i,1},'%%BoundingBox')
                linesNew{linesNewCounter-1,1} = ['%%BoundingBox:     0     0   ',num2str(figureWidth),'   ',num2str(figureHeight)];
            end
        end

        if fontCommandFlag
            % change depending on font type
            if contains(lines{i,1},'Bold') && (contains(lines{i,1},'Italic') || contains(lines{i,1},'Oblique'))
                linesNew{linesNewCounter,1} = replace(lines{i,1},"Helvetica-BoldOblique","Arial-BoldItalic");
            elseif contains(lines{i,1},'Italic') || contains(lines{i,1},'Oblique')
                linesNew{linesNewCounter,1} = replace(lines{i,1},"Helvetica-BoldOblique","Arial-BoldItalic");
            elseif contains(lines{i,1},'Bold')
                linesNew{linesNewCounter,1} = replace(lines{i,1},"Helvetica-Bold","Arial-Bold");
            else
                linesNew{linesNewCounter,1} = replace(lines{i,1},"Helvetica","Arial");
            end
            linesNewCounter = linesNewCounter+1;
            fontCommandFlag = 0;
        end

    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%% WRITE FILE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    fid = fopen(filename,'w');

    for i = 1 : size(linesNew,1)
        fprintf(fid,'%s\n',linesNew{i,1});
    end
    fclose(fid);

    if strcmpi(NVArgs.ExportMessage,'on')
        fprintf('Successfully updated and exported %s.\n',filename)
    end

end

end

%%%%%%%%%%%%%%%%%%%%%%%%%% VALIDATION FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%

function numericPositiveScalar(x, argName)
    if ~isnumeric(x) && ~isscalar(x) && ~mustBeNonnegative(x)
        error('The value of %s must be a positive scalar.',argName);
    end
end

function mustBeValidLayout(A)
    if ~isempty(A)
        if ~isequal(size(A),[1,2])
            error('TiledLayout must be an [m,n] array of integers.');
        elseif isnumeric(A)
            error('TiledLayout must be an [m,n] array of integers.');
        end
    end
end

function mustBeNiceFont(f)
    if ~ischar(f) && ~isstring(f)
        error('Font must be a character vector or string.');
    end
end

function journalList(s)
    list = {'Elsevier',...
            'Springer',...
            'Nature',...
            'Wiley'};
    if ~ischar(s) && ~isstring(s)
        error('Specified journal must be a character vector or string.');
    end
    if ~ismember(s,list)
        error('Specified journal is not valid.');
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%% HELPER FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ext = getTextSize(str, fontName, fontSize)
    % Return the [width, height] in points of given string

    % Create an invisible figure
    tempFig = figure('Visible', 'off');
    ax = axes('Parent', tempFig, 'Units', 'points');
    
    % Create a text object
    t = text(0, 0, str, ...
        'FontName', fontName, ...
        'FontSize', fontSize, ...
        'Units', 'points', ...
        'Parent', ax);

    % Get the extent [x, y, width, height] in inches
    ext = get(t, 'Extent');
    ext = ext(3:4);

    close(tempFig);  % Clean up
end

function roundedValue = roundQtr(value)
    roundedValue = round(value*4)/4; 
end

function [m, n] = estimateSubplotLayout(p)
    % Given p = number of axes, determine the most likely (rows, cols) layout:
    % Favoring compact, nearly square grids
    % Avoiding unnecessary empty rows or columns
    % Keeping rows ≤ cols if possible (common MATLAB style)

    % Try all factor pairs and pick the most square-like
    layoutOptions = [];
    for r = 1 : p
        if mod(p, r) == 0
            c = p / r;
            layoutOptions(end+1, :) = [r, c];
        end
    end

    % Score based on how square the layout is
    scores = abs(layoutOptions(:,1) - layoutOptions(:,2));
    
    % Prefer more cols (wider plots) in case of tie
    [~, idx] = min(scores + 0.01 * layoutOptions(:,2));  
    
    m = layoutOptions(idx, 2);
    n = layoutOptions(idx, 1);
end
