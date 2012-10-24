function finite_line_fix_n
fontsize=18;
ticksize=16;

%   ()
% Create figure
    figure1 = figure('InvertHardcopy','off','Color',[1 1 1], ...
        'position', [0 0 600 570]);
    set(figure1,'PaperUnits','centimeters');
    
    function minW = minW(tau)
        w = 0: 0.01: pi/2;
        func = w.*tan(w);
        
        ind = 1;
        while func(ind) < tau
            ind = ind + 1;
        end
        minW = func(ind);
    end

    function FF = Fodd(n)
        FF = 1/(4* cos(pi/(n+1)).^2); 
    end

    function FF = Feven(tau, n)
        w = minW(tau);
        FF = 1/(4*sin(w).^2 * cos(pi/(n+1)).^2); 
    end

 function plot_gip(tau, n)
        x = -bound:.01:bound;
        plot(x, Fodd(n)./x, 'color', 'k', 'LineWidth', 3);
        plot(x, -Feven(tau, n)./x, 'color', 'k', 'LineWidth', 3);
 end

function plot_gip_inf(tau, n)
    x = -bound:.1:bound;
    plot(x, Fodd(n)./x, '.', 'color', 'k', 'LineWidth', 1);
    plot(x, -Feven(tau, n)./x, '.', 'color', 'k', 'LineWidth', 1);
end

hold on
bound = 4;
n = 3;
axis([-bound bound -bound bound]);

plot_gip(.3, n); 
plot_gip(.5, n);
plot_gip(1, n); 
% infinity N
plot_gip_inf(666, n);


% Create xlabel
xlabel({'a'}, 'FontSize', fontsize);

% Create ylabel
ylabel({'b'}, 'FontSize', fontsize);

title({['n=' num2str(n)]}, 'FontSize', fontsize);

% Create textbox
% Create textbox
annotation(figure1,'textbox',...
    [0.18 0.72 0.1 0.1],...
    'String',{'\tau=0.3'},...
    'FontSize', fontsize,...
    'FitBoxToText','off',...
    'LineStyle','none',...
    'EdgeColor',[1 1 1]);
annotation(figure1,'textbox',...
    [0.26 0.63 0.1 0.1],...
    'String',{'\tau=0.5'},...
    'FontSize', fontsize,...
    'FitBoxToText','off',...
    'LineStyle','none',...
    'EdgeColor',[1 1 1]);
annotation(figure1,'textbox',...
    [0.34 0.55 0.1 0.1],...
    'String',{'\tau=1'},...
    'FontSize',fontsize,...
    'FitBoxToText','off',...
    'LineStyle','none',...
    'EdgeColor',[1 1 1]);
annotation(figure1,'textbox',...
    [0.41 0.516 0.06 0.06],...
    'String',{'\tau=\infty'},...
    'FontSize',fontsize,...
    'FitBoxToText','off',...
    'LineStyle','none',...
    'EdgeColor',[1 1 1]);


  % Дополнительные границы
    plot([-bound  bound], [ bound  bound], 'k', 'LineWidth', 1);
    plot([ bound  bound], [-bound  bound], 'k', 'LineWidth', 1);
    
% axes
set(gca, 'XTick',[ -4 -2 0 2 4], 'YTick',[ -4 -2 0 2 4], 'FontSize',ticksize);

% save figure
    figureName = 'finite_line_fix_n';
    set(figure1, 'PaperPositionMode', 'auto');
    saveas(figure1, [figureName '.eps'], 'psc2');
    close all;


end



   