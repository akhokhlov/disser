function infinite_line_fix_n

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
    x = [-bound:.1:-bound/20, -bound/20:.01: 0];
    x = [x -fliplr(x)];
    plot(x, Fodd(n)./x, '.', 'color', 'k', 'LineWidth', 1);
    plot(x, -Feven(tau, n)./x, '.', 'color', 'k', 'LineWidth', 1);
end

hold on
bound = 5;
n = Inf;
axis([-bound bound -bound bound]);

plot_gip(.1, n); 
plot_gip(.2, n); 
plot_gip(.5, n);
%plot_gip(1, n); 
% infinity N
plot_gip_inf(666, n);


% Create xlabel
xlabel({'a'}, 'FontSize',14);

% Create ylabel
ylabel({'b'}, 'FontSize',14);

%title({['n=' num2str(n)]}, 'FontSize',14);

% Create textbox
% Create textbox
annotation(figure1,'textbox',...
    [0.15 0.8 0.1 0.1],...
    'String',{'\tau=0.1'},...
    'FontSize',14,...
    'FitBoxToText','off',...
    'LineStyle','none',...
    'EdgeColor',[1 1 1]);
annotation(figure1,'textbox',...
    [0.25 0.66 0.1 0.1],...
    'String',{'\tau=0.2'},...
    'FontSize',14,...
    'FitBoxToText','off',...
    'LineStyle','none',...
    'EdgeColor',[1 1 1]);
annotation(figure1,'textbox',...
    [0.33 0.53 0.1 0.1],...
    'String',{'\tau=0.5'},...
    'FontSize',14,...
    'FitBoxToText','off',...
    'LineStyle','none',...
    'EdgeColor',[1 1 1]);
annotation(figure1,'textbox',...
    [0.41 0.53 0.06 0.06],...
    'String',{'\tau=\infty'},...
    'FontSize',14,...
    'FitBoxToText','off',...
    'LineStyle','none',...
    'EdgeColor',[1 1 1]);


  % Дополнительные границы
    plot([-bound  bound], [ bound  bound], 'k', 'LineWidth', 1);
    plot([ bound  bound], [-bound  bound], 'k', 'LineWidth', 1);
    
% axes
set(gca, 'XTick',[ -4 -2 0 2 4], 'YTick',[ -4 -2 0 2 4]);


end



   