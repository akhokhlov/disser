function finite_line_circle
%   ()
addpath('../../product_3');
addpath('../../common');

large = true;
    fontsize=18;
    ticksize=16;
    fileExt = '';
if large
    fontsize=24;
    ticksize=22;
    fileExt = '_large';
end
    

createFigure(.5, 3);
createFigure(.5, 4);
createFigure(.5, 5);
createFigure(.5, 5, [-0 1 -0 1]);
createFigure(.5, 6);
createFigure(.5, 7);
close all;


    function createFigure(tau, n, zoom)
        % Create figure
        figure1 = figure('InvertHardcopy','off','Color',[1 1 1], ...
            'position', [0 0 600 570]);
        set(figure1,'PaperUnits','centimeters');
        grid on;
        hold on;
        
        
        bound = 2.5;
        %tau =.5;
        %n = 7;
        plot_gip(tau, n, bound); 


        [phi, r] = solverBoundnessSmart(2, tau, n, .05);
        polar(phi, r, 'ok');

        % Create xlabel
        xlabel({'a'}, 'FontSize',fontsize);

        % Create ylabel
        ylabel({'b'}, 'FontSize',fontsize);

        title({['\tau=' num2str(tau) ', n=' num2str(n)]}, 'FontSize',fontsize);

        % Дополнительные границы
        plot([-bound  bound], [ bound  bound], 'k', 'LineWidth', 1);
        plot([ bound  bound], [-bound  bound], 'k', 'LineWidth', 1);

        set(gca, 'XTick',[ -2 -1 0 1 2], 'YTick',[-2 -1 0 1 2], 'FontSize',ticksize);
  
        filename = [mfilename '_n' num2str(n) fileExt '.eps'];
        axis([-bound bound -bound bound]);
        if (exist('zoom', 'var'))
            axis(zoom);
            % Дополнительные границы
            plot(zoom(1:2), [ zoom(2) zoom(2)], 'k', 'LineWidth', 1);
            plot([ zoom(end) zoom(end)], zoom(3:end), 'k', 'LineWidth', 1);
            filename = [mfilename '_n' num2str(n) '_zoom' fileExt '.eps'];
        end

      
        set(figure1, 'PaperPositionMode', 'auto');
        saveas(figure1, filename, 'psc2');

    end

    
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

 function plot_gip(tau, n, bound)
        x = -bound:.01:bound;
        plot(x, Fodd(n)./x, 'color', 'k', 'LineWidth', 3);
        plot(x, -Feven(tau, n)./x, 'color', 'k', 'LineWidth', 3);
 end

end



   