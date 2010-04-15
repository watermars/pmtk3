%% Two hypothetical two-sided power curves. B dominates A.

figure('Color',[1,1,1]);
domain = -pi:0.01:pi;
f1 = @(x)-cos(x)+0.03;
f2 = @(x) -cos(2*x./3);
linewidth = {'LineWidth',2.5};

plot(domain,f1(domain),'-b',linewidth{:}); %curve B
hold on;
plot(domain,f2(domain),'-r',linewidth{:}); %curve A

%Small line indicating position of alpha
plot([-0.3;0.3],[-1.025;-1.025],'-k');

axis([-pi,pi,-2,2]);
axis off;


%y-axis
annotation(gcf,'arrow',rel2absX([0,0]),rel2absY([-2,2]),'HeadWidth',12,...
    'HeadStyle','plain',...
    'LineWidth',3);
%x-axis
annotation(gcf,'arrow',rel2absX([-pi,pi]),rel2absY([-1.5,-1.5]),...
    'HeadLength',12,...
    'HeadWidth',12,...
    'HeadStyle','plain',...
    'LineWidth',3);

% 1 - beta
annotation(gcf,'textbox',[0.4411 0.97 0.153 0.05689],...
    'String',{'1 - \beta'},...
    'HorizontalAlignment','center',...
    'FontSize',24,...
    'FitBoxToText','off',...
    'LineStyle','none');

% alpha
annotation(gcf,'textbox',[0.46 0.275 0.1001 0.06587],...
    'String',{'\alpha'},...
    'FontSize',24,...
    'FitBoxToText','off',...
    'LineStyle','none');

% 1
annotation(gcf,'textbox',[0.46 0.6 0.1001 0.06587],...
    'String',{'1'},...
    'FontSize',24,...
    'FitBoxToText','off',...
    'LineStyle','none');


% A
annotation(gcf,'textbox',[0.8219 0.53 0.07987 0.05186],'String',{'A'},...
    'HorizontalAlignment','center',...
    'FontSize',20,...
    'FitBoxToText','off',...
    'LineStyle','none');

% B
annotation(gcf,'textbox',[0.8206 0.745 0.07987 0.07784],'String',{'B'},...
    'HorizontalAlignment','center',...
    'FontSize',20,...
    'FitBoxToText','off',...
    'LineStyle','none');

% theta
annotation(gcf,'textbox',[0.9092 0.1796 0.06743 0.1078],...
    'String',{'\theta'},...
    'FontSize',24,...
    'FitBoxToText','off',...
    'LineStyle','none');

% theta_0
annotation(gcf,'textbox',[0.44 0.11 0.06743 0.1078],...
    'String',{'\theta_0'},...
    'FontSize',20,...
    'FitBoxToText','off',...
    'LineStyle','none');

