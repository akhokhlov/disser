%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Чертит границу устойчивости.
% type - тип соединения нейронов (1 для несимметричного, 2 для симметричного 
% взаимодействия),
% tau - запаздывание,
% number - количество нейронов,
% epsilon - точность,
% dir - директория для сохранения графиков, 
% ext - расширение файлов для сохранения,
% minX, maxX - границы для графиков.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [minX, maxX, figure1] = plotterBoundness(...
    type, tau, number, epsilon, dir, ext, bounds, suffix)

large = false;
    fontsize=18;
    ticksize=16;
    fileExt = '';
if large
    fontsize=24;
    ticksize=22;
    fileExt = '_large';
end

    % Создание окна для графика
    figure1 = figure('InvertHardcopy','off','Color',[1 1 1], ...
        'position', [680 0 600 570]);
    hold on;
    grid on;

    % Загрузка или создание данных для границы устойчивости бесконечного
    % числа нейронов.
    datafile = [num2str(type) '_' num2str(tau) '.mat'];
    try 
        load(datafile);
    catch me
        display(me);
        % предполагается, что файла данных нет.
    end
    % Если данные не загрузились, то создадим их.
    if exist('infiniteR', 'var') == 0 || exist('infinitePhi', 'var') == 0 
        infiniteNumber = 100;
        [infinitePhi, infiniteR] = solverBoundnessSmart(type, tau, infiniteNumber, .02);
        save(datafile, 'infinitePhi', 'infiniteR');
    end
    h = polar(infinitePhi, infiniteR, '-');
    set(h, 'LineWidth', 2, 'color', 'k') ;
    
    % Вычисление области устойчивости для ограниченного числа нейронов.
    [phi, r] = solverBoundnessSmart(type, tau, number, epsilon);
    finiteBound = polar(phi, r, 'ob');
    set(finiteBound, 'LineWidth', 2);
    
    title(['$\tau = ' num2str(tau) ', n = ' num2str(number) '$' ],...
        'FontSize',fontsize, 'interpreter', 'latex');
    
    % Создание надписей
    xlabel({'a'}, 'FontSize',fontsize);
    ylabel({'b'}, 'FontSize',fontsize);
    text('String','stab',...
     'Position',[-.5 .2],...
     'FontSize',fontsize);
    text('String','unstab',...
     'Position',[-1.9 -1.8],...
     'FontSize',fontsize);
    text('String','unstab',...
     'Position',[1.2 1.8],...
     'FontSize',fontsize);

%     text('Interpreter','latex',...
%      'String',{['$n = ' num2str(number) '$']},...
%      'Position',[r(1) 1],...
%      'FontSize',fontsize);
%     text('Interpreter','latex',...
%      'String',{'$n = \infty$'},...
%      'Position',[-0.1 -0.7],...
%      'FontSize',fontsize);

 % axes
%set(gca, 'FontSize',ticksize);
%set(gca, 'XTick',[ -2 -1 0 1 2 ], 'YTick',[-2 -1 0 1 2], 'FontSize',ticksize);
 set(gca, 'XTick',[-4 -2 0 2 4], 'YTick',[-4 -2 0 2 4], 'FontSize',ticksize);
 
    % Масштабирование
%     ax=axis;
%     x1=min(ax(1), ax(3));
%     x2=max(ax(2), ax(4));
%     if exist('minX', 'var')
%         x1=minX;
%     end
%     if exist('maxX', 'var')
%         x2=maxX;
%     end
%     minX = x1;
%     maxX = x2;
%     axis([x1-.5 x2+.5 x1-.5 x2+.5]);
axis(bounds);

    % Создание дополнительных границ
    ax=axis;
    plot(ax(1:2), [ax(4) ax(4)], 'k', 'LineWidth', 1);
    plot([ax(2) ax(2)], ax(3:4), 'k', 'LineWidth', 1);
    %axis([x1-.5 x2+.5 x1-.5 x2+.51]);

    % Сохранение построенной фигуры
    if type == 1
        typeName = 'asym';
    else
        typeName = 'sym';
    end
    
    strTau = num2str(tau);
%     if length(strTau) < 3
%         strTau = [strTau '_0'];
%     end
%     
    %mkdir(dir);
    figureName = [typeName '_tau' strTau '_n' num2str(number) suffix];
    
    % Уберём точку, чтоб не было проблем в файловой системе.
    figureName = strrep(figureName, '.', '');
    
    set(figure1, 'PaperPositionMode', 'auto');
    
    if strcmp(ext, 'png')
        saveas(figure1, [dir filesep figureName '.png'], 'png');
    else
        saveas(figure1, [dir filesep figureName '.eps'], 'psc2');
    end
    
    close;

end

