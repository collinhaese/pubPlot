% Example of pubPlot()
clear
close all

% generate some data
x = 0:pi/100:2*pi;
y = sin(x);

x2 = 2*pi*rand([20,1]);
y2 = sin(x2);

x3 = 10*rand([30,1]);
y3 = (1-1e-2.*rand([30,1])).*x3;
x3Fit = y3\x3;
y3Fit = x3Fit*x3;

x4 = 10*rand([30,1]);
y4 = (-1+1e-2.*rand([30,1])).*x4;
x4Fit = y4\x4;
y4Fit = x4Fit*x4;

%% One plot figure
figure()
hold on
plot(x,y)
scatter(x2,y2)

% include filename to export as eps
fig = pubPlot(filename='Test_Fig.eps');

%% Figure with subplots
subFig = figure();

subplot(2,3,1)
hold on
plot(x,y)
scatter(x2,y2)

subplot(2,3,2)
hold on
scatter(x3,y3)
plot(x3,y3Fit)

subplot(2,3,3)
hold on
scatter(x4,y4)
plot(x4,y4Fit)

subplot(2,3,4)
plot(x,y)

subFig = pubPlot();