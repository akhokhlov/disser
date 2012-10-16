function finite_line_circle
%   ()
addpath('../../product_3');
addpath('../../common');
fontsize=24;
ticksize=18;


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


hold on



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
bound = 2;
tau =.5;
n = 7;
axis([-bound bound -bound bound]);
%..axis([-0 1 -0 1]);

plot_gip(tau, n); 


[phi, r] = solverBoundnessSmart(2, tau, n, .05);
polar(phi, r, 'o');

% Create xlabel
xlabel({'a'}, 'FontSize',fontsize);

% Create ylabel
ylabel({'b'}, 'FontSize',fontsize);

title({['\tau=' num2str(tau) ', n=' num2str(n)]}, 'FontSize',fontsize);



  % Дополнительные границы
    plot([-bound  bound], [ bound  bound], 'k', 'LineWidth', 1);
    plot([ bound  bound], [-bound  bound], 'k', 'LineWidth', 1);
    
% axes
set(gca, 'XTick',[ -2 -1 0 1 2], 'YTick',[-2 -1 0 1 2], 'FontSize',ticksize);
grid on;


end



   