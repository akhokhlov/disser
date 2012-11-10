function finite_line_circle
%   ()
addpath('../../product_3');
addpath('../../common');

large = false;
    fontsize=18;
    ticksize=16;
    fileExt = '';
if large
    fontsize=24;
    ticksize=22;
    fileExt = '_large';
end
    

% for k=3:6
%     createFigure(.5, k);
% end
% createFigure(.5, 5, [-0 1 -0 1]);
% createFigure(.5, 6, [-1.5 -.5 .5 1.5 ]);

createFigure(100, 101);


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
  
        
        fileFormat = 'eps';
        filename = [mfilename '_n' num2str(n) fileExt '.' fileFormat];
        axis([-bound bound -bound bound]);
        if (exist('zoom', 'var'))
            axis(zoom);
            % Дополнительные границы
            plot(zoom(1:2), [ max(zoom(3:4)) max(zoom(3:4))], 'k', 'LineWidth', 1);
            plot([max(zoom(1:2)) max(zoom(1:2))], zoom(3:end), 'k', 'LineWidth', 1);
            filename = [mfilename '_n' num2str(n) '_zoom' fileExt '.' fileFormat];
        end

      
        set(figure1, 'PaperPositionMode', 'auto');
        saveas(figure1, filename, fileFormat);

    end

    function minW = minOmega(tau)
        % функция f = w*tg(w) пересекается в одной точке с f = x
        % и лежит под ней около нуля.
        w = 0: 0.01: pi/2;
        func = w.*tan(w);
        ind = 1;
        while func(ind) < tau
            ind = ind + 1;
        end
        minW = w(ind);
    end

    function FF = Fodd(n)
        FF = 1/(4* cos(pi/(n+1)).^2); 
    end

    function FF = Feven(tau, n)
        w = minOmega(tau);
        FF = 1/(4*(sin(w)).^2 * cos(pi/(n+1)).^2); 
    end

 function plot_gip(tau, n, bound)
        x = -bound:.01:bound;
        plot(x, Fodd(n)./x, 'color', 'k', 'LineWidth', 2);
        plot(x, -Feven(tau, n)./x, 'color', 'k', 'LineWidth', 2);
 end

end



   