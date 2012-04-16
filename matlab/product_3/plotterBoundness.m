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

function [minX, maxX] = plotter_boundness(type, tau, number, epsilon, dir, ext, minX, maxX)

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
    set(h, 'LineWidth', 3, 'color', 'k') ;
    
    % Вычисление области устойчивости для ограниченного числа нейронов.
    [phi, r] = solverBoundnessSmart(type, tau, number, epsilon);
    polar(phi, r, 'o');
    
    title(['$\tau = ' num2str(tau) ', n = ' num2str(number) '$' ],...
        'FontSize',20, 'interpreter', 'latex');
    
    % Создание надписей
    xlabel({'a'}, 'FontSize',16);
    ylabel({'b'}, 'FontSize',16);
    text('String','Stability',...
     'Position',[-.5 .2],...
     'FontSize',16);
    text('String','Instability',...
     'Position',[-2.5 -1.2],...
     'FontSize',16);
    text('String','Instability',...
     'Position',[1.2 2.5],...
     'FontSize',16);
    text('Interpreter','latex',...
     'String',{['$n = ' num2str(number) '$']},...
     'Position',[r(1) -.2],...
     'FontSize',16);
    text('Interpreter','latex',...
     'String',{'$n = \infty$'},...
     'Position',[infiniteR(1) 0.2],...
     'FontSize',16);

    % Масштабирование
    ax=axis;
    x1=min(ax(1), ax(3));
    x2=max(ax(2), ax(4));
    if exist('minX', 'var')
        x1=minX;
    end
    if exist('maxX', 'var')
        x2=maxX;
    end
    minX = x1;
    maxX = x2;
    axis([x1-.5 x2+.5 x1-.5 x2+.5]);

    % Создание дополнительных границ
    ax=axis;
    plot(ax(1:2), [ax(4) ax(4)], 'k', 'LineWidth', 1);
    plot([ax(2) ax(2)], ax(3:4), 'k', 'LineWidth', 1);
    axis([x1-.5 x2+.5 x1-.5 x2+.51]);

    % Сохранение построенной фигуры
    if type == 1
        typeName = 'asym';
    else
        typeName = 'sym';
    end
    
    strTau = num2str(tau);
    if length(strTau) < 3
        strTau = [strTau '_0'];
    end
    
    %mkdir(dir);
    figureName = [typeName '-' strTau '-' num2str(number)];
    
    % Заменим точку на '_', чтоб не было проблем в файловой системе.
    figureName = strrep(figureName, '.', '_');
    
    set(figure1, 'PaperPositionMode', 'auto');
    
    if strcmp(ext, 'png')
        saveas(figure1, [dir filesep figureName '.png'], 'png');
    else
        saveas(figure1, [dir filesep figureName '.eps'], 'psc2');
    end
    
    close;

end

