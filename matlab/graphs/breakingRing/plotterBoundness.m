function [minX, maxX, figure1] = plotterBoundness(type, tau, number, epsilon, c, minX, maxX)
fontsize=24;
ticksize=22;

save('var', 'c');

    % Создание окна для графика
    figure1 = figure('InvertHardcopy','off','Color',[1 1 1], ...
        'position', [680 0 600 570]);
    hold on;
    grid on;

   
    % Вычисление области устойчивости для ограниченного числа нейронов.
    [phi, r] = solverBoundnessSmart(type, tau, number, epsilon);
    h = polar(phi, r, 'ok');
    set(h, 'LineWidth',2);
    
    c_str = num2str(c);
    if c < .001
        c_str = '0';
    end
    title(['$c = ' c_str '$'],...
        'FontSize',fontsize, 'interpreter', 'latex');
    
    % Создание надписей
    xlabel({'a'}, 'FontSize',fontsize);
    ylabel({'b'}, 'FontSize',fontsize);
    text('String','stab',...
     'Position',[-.8 0.1],...
     'FontSize',fontsize);
    text('String','unstab',...
     'Position',[-5 -3],...
     'FontSize',fontsize);
    text('String','unstab',...
     'Position',[2.5 3],...
     'FontSize',fontsize);
 
% axes
set(gca, 'FontSize',ticksize);
 
    
    % Масштабирование
    ax=axis;
    x1= -5.5;
    x2= 5.5;
    if exist('minX', 'var')
        x1=minX;
    end
    if exist('maxX', 'var')
        x2=maxX;
    end
    minX = -7;
    maxX = 7;
    axis([x1-.5 x2+.5 x1-.5 x2+.5]);

    % Создание дополнительных границ
    ax=axis;
    plot(ax(1:2), [ax(4) ax(4)], 'k', 'LineWidth', 1);
    plot([ax(2) ax(2)], ax(3:4), 'k', 'LineWidth', 1);
    axis([x1-.5 x2+.5 x1-.5 x2+.51]);

     
    strTau = num2str(tau);
    
    % axes
    set(gca, 'XTick',[ -4 -2 0 2 4], 'YTick',[ -4 -2 0 2 4], 'FontSize',ticksize);

    %mkdir(dir);
    figureName = ['tau' strTau '_n' num2str(number) '_c' num2str(c)];
    
    % Заменим точку на '_', чтоб не было проблем в файловой системе.
    figureName = strrep(figureName, '.', '');
    
    set(figure1, 'PaperPositionMode', 'auto');
    
    saveas(figure1, [figureName '.eps'], 'psc2');

end