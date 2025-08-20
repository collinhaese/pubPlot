%% DEMO SCRIPT: pubPlot — Format figures for publication-quality output.
%
%   Running pubPlot is easy: 
%    - Plot everything like normal in MATLAB
%    - When you are finished plotting your data, call pubPlot
%    - pubPlot will automatically handle making it look nice!
%   See the below several examples to get a feel on how it works.
%   If you want more control on appearance, see the ADDITIONAL INFORMATION 
%   section at the bottom of this script.
%
%   Make sure pubPlot.m is on the path before running this script.
%   Author : Collin Haese
%   GitHub : 

close all; clear; clc; rng(7);

%% 1) Basic usage — single axes
% Here we just call pubPlot() after calling normal plot commands
% You will see it reformats the figure and reduces whitespace
x = linspace(0,2*pi,400);
y = sin(x).*exp(-0.2*x);

figure('Color','w'); plot(x,y,'-'); title('Damped Sine Before pubPlot'); xlabel('x'); ylabel('y');
figure('Color','w'); plot(x,y,'-'); title('Damped Sine After pubPlot'); xlabel('x'); ylabel('y');

% we plot like normal first, then call pubPlot()
pubPlot();  % call with defaults

%% 2) Width/height variants (journal + columns + custom height)
% These example figures show how pubPlot() can account for different figure
% widths and heights to change the appearance of the figure.
% We pass them as arguments Width and Height
widths  = {'single','1.5','double'};
heights = [180 235 320];

x = linspace(0,2*pi,400);
y = sin(x).*exp(-0.2*x);
for i = 1:numel(widths)
    for j = 1:numel(heights)
        figure('Color','w');
        plot(x,cos(x)+(j-2)*0.5,'LineWidth',1.5);
        title(sprintf('Width=%s, Height=%d pt', widths{i}, heights(j)));
        xlabel('Time (s)'); ylabel('Signal');
        pubPlot('Width',widths{i},'Height',heights(j));
        % can also call Name-Value arguments as:
        % pubPlot(Width=widths{i},Height=heights(j));
    end
end

%% 3) Subplots
% These examples show how reformatting subplots works
% Note: Do not use sgtitle
% Note: pubPlot respects layout of subplots (doesn't override positions)

% Classic subplots (2x2) — stress different label lengths & rotations
t = linspace(0, 1, 200);
f = [3 5 9 13];
figure('Color','w');

subplot(2,2,1);
plot(t, sin(2*pi*f(1)*t)); grid on;
xlabel('t (s)'); ylabel('Signal');
title('f = 3 Hz');

subplot(2,2,2);
plot(t, sin(2*pi*f(2)*t)); grid on;
xlabel('time (seconds)'); ylabel('Output (Volts)');
title('f = 5 Hz'); xtickangle(30);
ylim([-2,2])

subplot(2,2,3);
plot(t, sin(2*pi*f(3)*t)); grid on;
xlabel('t (s)'); ylabel('Measurement (arbitrary units)');
title('f = 9 Hz'); ytickangle(90);
ylim([-2,2])

subplot(2,2,4);
plot(t, sin(2*pi*f(4)*t)); grid on;
xlabel('Independent Variable t (s)'); ylabel('y');
title('f = 13 Hz');
ylim([-2,2])

pubPlot(Width="double",Height=300,Grid="on",AxisFontSize=10);

% Subplot with varying sizes
% Two plots on the top
figure('Color','w');
subplot(2,2,[1]);
x = linspace(-3.8,3.8);
y_cos = cos(x);
plot(x,y_cos);
title('Subplot 1: Cosine')
xlabel('x')
ylabel('cos(x)')

subplot(2,2,2);
y_poly = 1 - x.^2./2 + x.^4./24;
plot(x,y_poly,'g');
title('Subplot 2: Polynomial')
xlabel('x')
ylabel('Polynomial Fit of cos(x)')

% One spanning on the bottom
subplot(2,2,[3:4]);
plot(x,y_cos,'b',x,y_poly,'g');
title('Subplot 3 and 4: Both')
xlabel('x')
ylabel('y')

pubPlot(Width="double",Height=300,Grid="on",AxisFontSize=12);

%% 4) Some Limitations:
% legends are not automatically repositioned, so place them wisely
x = linspace(-3.8,3.8);
% Legend styling
figure('Color','w'); hold on
plot(x,sin(x),'DisplayName','sin'); 
plot(x,cos(x),'DisplayName','cos'); 
legend('Location','best'); title('Legend demo');
pubPlot();

% pubPlot() does not currently take into account colorbars, so it will
% likely be cut off
figure('Color','w');
imagesc(peaks(200)); axis image; colormap(parula); colorbar;
title('imagesc + colorbar'); xlabel('x'); ylabel('y');
% pubPlot will style fonts and trim axes whitespace. The colorbar axis itself
% is not repositioned; adjust colorbar Position manually if needed.
pubPlot(Width="single",Height=220);


%% 5) Log axes (semilogx / loglog) + title collision avoidance
% Non-linear axes are supported
% pubPlot() can also detect if data is overlapping the title and
% automatically move the title above the ticks
% You can also set the title to always be above the ticks. Currently the
% title is middle-aligned with top tick mark and tick label
figure('Color','w');
xx = logspace(-2,2,200);
yy = 1./sqrt(xx) + 0.02*randn(size(xx));

subplot(1,2,1);
semilogx(xx,yy,'o','MarkerSize',4); grid on;
title('SemilogX — may need title lift');
xlabel('x'); ylabel('y');

subplot(1,2,2);
loglog(xx,yy+0.05,'-','LineWidth',1.2); grid on;
title('LogLog'); xlabel('x'); ylabel('y');

% If data approaches the top, pubPlot will detect overlap and may lift the title
% you can force it too
pubPlot(Width="1.5",MoveTitleAboveAxis=true);

%% 6) Interpreters: 'tex' vs 'latex' vs 'none'
% Latex labels are respected
x = linspace(-3.8,3.8);
figure('Color','w');
plot(x, sin(x));
title('TeX default'); xlabel('x'); ylabel('y');
pubPlot(Interpreter="tex");

figure('Color','w');
plot(x, sin(x).^2);
title('$\sin^2(x)$','Interpreter','latex');
xlabel('$x$ (rad)','Interpreter','latex'); 
ylabel('$\sin^2(x)$','Interpreter','latex');
pubPlot(Interpreter="latex");

figure('Color','w');
plot(x, sin(x).^3);
title('Literal ^ and _','Interpreter','none');
xlabel('x_^ (rad)_','Interpreter','none'); ylabel('y^3_','Interpreter','none');
pubPlot(Interpreter="none");

%% 7) Exporting — EPS via pubPlot, PNG/PDF via exportgraphics
% Exporting figures is easy with pubPlot().
% Pass the Filename and extension(s) you want as arguments.
% IMPORTANT: pubPlot() modifies the .eps file to make importing into
% Illustrator easier

% EPS (pubPlot post-processes this for nice fonts/bounding box)
figure('Color','w');
x = linspace(0,2*pi,400);
y = sin(x).*exp(-0.2*x);
plot(x,y,'k','LineWidth',1.2); title('Export – EPS'); xlabel('x'); ylabel('y');
pubPlot('Filename','demo_pubPlot_eps');                            % writes and post-processes EPS

% PNG and PDF: export AFTER pubPlot (pubPlot's internal exporter is EPS-focused)
figure('Color','w');
plot(x,cos(x),'b','LineWidth',1.2); title('Export – PNG/PDF'); xlabel('x'); ylabel('cos(x)');
pubPlot('Filename','demo_pubPlot_eps','FileExtension',{'.png','.pdf'});  % no filename here

%% 8) Reusing the same “style” across many figures
% You can also force the same layout in plots if desired.
% Pass the desired spacing as a set of options from pubPlot().
% Notice how in the second plot, the same spacing is maintained around the
% labels and title. Note: you must use the figure with the  most space
% required, otherwise objects may overlap/clip
x = linspace(0,2*pi,400);
figure('Color','w'); plot(x, sin(2*x)); 
title('Maintain Position'); xlabel('x'); ylabel('sin(2x)');
[~,opts] = pubPlot(); % the first output is the figure handle of the plot

figure('Color','w'); plot(x, cos(2*x));
pubPlot(figOptions=opts);

%% ADDITIONAL INFORMATION

% All modifiable properties and their defaults can be seen in the arguments
% section of pubPlot
%
% Noteworthy/Most Important Properties:
% Journal: This sets the width of the figure
% Width: Single, 1.5, or double column width for the journal
% Height: Height of the figure
% LineWidth: Width of all strokes in the figure
% AxisOffset: If you wish to hold the same positioning across figures,
%             first plot your desired figure/spacing and request the 
%             figOptions output. Then pass this figOptions as an input into
%             all remaining figures.

% % A handy “base” options struct you can reuse across figures
% baseOpts = struct( ...
%     'Journal','Nature', ...            % Elsevier | Springer | Nature | Wiley
%     'Width','single', ...              % 'single' | '1.5' | 'double'
%     'Height',235, ...                  % points (1 pt = 1/72 in)
%     'FontName','Arial', ...
%     'FontSize',12, ...
%     'AxisFontSize',12, ...
%     'LineWidth',2, ...
%     'MarkerSize',8, ...
%     'AxisLineWidth',1.8, ...
%     'BoxColor','none', ...
%     'Grid','off', ...
% );

% CURRENTLY UNSUPPORTED GRAPHICS FUNCTIONS
% - Non-RGB colors
% - Arial is only supported font
% - Exponential Ticks
% - Color bars
% - 3D and non-Cartesian plots
%
% MATLAB compatibility: -tested on R2024b
disp('Demo complete. Check the exported files in your current folder.');
