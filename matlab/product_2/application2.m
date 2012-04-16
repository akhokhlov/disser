function application2
	fontsize0 = 12;
	fontsize1 = 15;
    figure_width = 600;
    figure_height = 500;
    screen_size = get(0,'ScreenSize');
    screen_width = screen_size(1,3);
    screen_height = screen_size(1,4);
    figure_x = 0; 
    figure_y = 0; 
    graph_count = 0;
    resetFigureVars();
    image1 = imread('circles_right.png');                                                                           
    image2 = imread('circles.png');                                                                           
    label_graph = 'График';
	appTitle = 'Устойчивость нейронных сетей';
	header = 'Анализ устойчивости нейронных сетей';
	header_eq = 'с большим количеством нейронов';
	inputPanelTitle = 'Входные данные';
    resultPanelTitle = 'Результаты вычислений';
	label_method = 'Конфигурация нейронной сети';
	label_method1 = 'Круговое соединение нейронов с малым запаздыванием взаимодействия с правыми соседями';
	label_method2 = 'Круговое соединение нейронов с одинаковым запаздываниям взаимодействия с соседями';
	label_model1 = 'Модель сети: x''j(t) + xj(t) + a*xj-1(t) + b*xj+1(t-tau) = 0, 1 <= j <= n';
    label_model2 = 'Модель сети: x''j(t) + xj(t) + a*xj-1(t-tau) + b*xj+1(t-tau) = 0, 1 <= j <= n';
    label_intens = 'Интенсивность взаимодействия нейрона с';
    label_right = 'правым соседним нейроном a =';
    label_left = 'левым соседним нейроном b =';
    label_set_tau = 'Величина запаздывания tau = ';
	label_rand = 'Заполнить';
	tip_rand = 'Заполняет входные данные случайными значениями';
	label_clear = 'Очистить';
	tip_clear = 'Очищает входные данные ';
	label_calc = 'Рассчитать...';
    label_calc_tip = 'Определяет интервалы устойчивости системы, заданной матрицами A и B';
    label_close = 'Закрыть все графики';
    tooltip_close = 'Закрывает все ранее открытые графики';
	label_result_good = 'Уравнение устойчиво при tau, находящемся в интервале:';
	label_result_bad = 'Уравнение неустойчиво.';

	% Create a figure that will have a uitable, axes and checkboxes
    f = figure('Position', [50, 100, 900, 700],...
		'Name', appTitle,...  % Title figure
		'NumberTitle', 'off',... % Do not show figure number
		'MenuBar', 'none');      % Hide standard menu bar menus

	uicontrol('style', 'text', ...
		'string', header, ...
		'fontsize', fontsize1, ...
		'units', 'normalized', ...
		'position', [0, .95, 1, .05]);
	uicontrol('style', 'text', ...
		'string', header_eq, ...
		'fontsize', fontsize1, ...
		'units', 'normalized', ...
		'position', [0, .9, 1, .05]);
    
rootPanel = uipanel('Parent',f, 'bordertype', 'none', 'Position',[0 0 1 1]);
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input panel.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
inputPanel = uipanel('Parent',rootPanel,'Title',inputPanelTitle,...
		 'Position',[0 .3 1 .6]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% input method
group = uibuttongroup('parent', inputPanel, 'Position',[0 .75 1 .25]);
uicontrol(group, 'style', 'text', 'fontsize', fontsize1, 'string', label_method, ...
		'units', 'normalized', 'position', [0, 0.7, 1, .3]);
set(group,'SelectionChangeFcn',@sel_callback);
rb1 = uicontrol('parent',group, 'Style','Radio',...
    'fontsize', fontsize0, 'String',label_method1,...
    'units', 'normalized', 'pos',[0, .3, 1,.3]);
rb2 = uicontrol('parent',group, 'Style','Radio',...
    'fontsize', fontsize0, 'String',label_method2,...
    'units', 'normalized', 'pos',[0, 0, 1,.3]);

        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% first method
inputPanel1 = uipanel('Parent',inputPanel, 'bordertype', 'none',...
                    'Position',[0 0 1 .65]);
method_text = uicontrol(inputPanel1, 'style', 'text', 'fontsize', fontsize1, ...
    'string', label_method1, 'units', 'normalized', 'position', [0, 0.85, 1, .2]);
model_text = uicontrol(inputPanel1, 'style', 'text', 'fontsize', fontsize0, ...
    'string', label_model1, 'units', 'normalized', 'position', [0, 0.7, 1, .1]);
    
leftPanel1 = uipanel('Parent',inputPanel1, 'bordertype', 'none',...
                    'Position',[0 0 .6 .7]);

uicontrol(leftPanel1, 'style', 'text', 'fontsize', fontsize0, 'string', label_intens, ...
		'units', 'normalized', 'position', [0, 0.7, 1, .2]);

uicontrol(leftPanel1, 'style', 'text', 'fontsize', fontsize0, 'string', label_right, ...
		'units', 'normalized', 'position', [0, 0.5, .6, .15]);
input_a = uicontrol(leftPanel1, 'style', 'edit', ...
    'string', num2str(rand(1)*2-1, 4), 'backgroundcolor', 'w',...
    'units', 'normalized', 'position', [0.6 .5 .4 .15]);

uicontrol(leftPanel1, 'style', 'text', 'fontsize', fontsize0, 'string', label_left, ...
		'units', 'normalized', 'position', [0, 0.3, .6, .15]);
input_b = uicontrol(leftPanel1, 'style', 'edit', ...
    'string', num2str(rand(1)*2-1, 4), 'backgroundcolor', 'w',...
    'units', 'normalized', 'position', [0.6 .3 .4 .15]);

uicontrol(leftPanel1, 'style', 'text', 'fontsize', fontsize0, 'string', label_set_tau, ...
		'units', 'normalized', 'position', [0, 0, .6, .15]);
input_tau = uicontrol(leftPanel1, 'style', 'edit', ...
    'string', num2str(rand(1), 4), 'backgroundcolor', 'w',...
    'units', 'normalized', 'position', [0.6 .05 .4 .15]);

rightPanel1 = uipanel('Parent',inputPanel1, 'bordertype', 'none',...
                    'Position',[.75 0 .25 .7]);
ax = axes('parent', rightPanel1, 'position', [0 0 1 1]);
image( image1, 'parent', ax);
                                            
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
% Result panel.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
resultPanel = uipanel('Parent',rootPanel,'Title',resultPanelTitle,...
		 'Position',[0 0 1 .3]);
result_text = uicontrol(resultPanel, 'style', 'text', ...
		'fontsize', fontsize1, ...
		'units', 'normalized', 'position', [0, .5, .7, .5]);
interval_text = uicontrol(resultPanel, 'style', 'text', ...
		'fontsize', fontsize1, ...
		'units', 'normalized', 'position', [0.7, .5, .3, .5]);
		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
% Bottom panel.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
	bottomPanel = uipanel('Parent',resultPanel,'bordertype', 'none',...
		 'Position',[0 0 1 .2]);
close_btn = uicontrol(bottomPanel, 'style', 'pushbutton', ...
        'string', label_close, 'tooltipString', tooltip_close, ...
		'units', 'normalized', 'position', [0.8, 0, .2, 1], ...
		'enable', 'off', 'callback', @close_callback); 
uicontrol(bottomPanel, 'style', 'pushbutton', 'string', label_calc, ...
		'tooltipString', label_calc_tip,...
		'units', 'normalized', 'position', [0.6, 0, .2, 1], ...
		'callback', @calc_callback); 
uicontrol(bottomPanel, 'style', 'pushbutton', ...
    'string', label_rand, 'tooltipString', tip_rand,...
		'units', 'normalized', 'position', [0.4, 0, .2, 1], ...
		'callback', @random_callback); 
uicontrol(bottomPanel, 'style', 'pushbutton', ...
    'string', label_clear, 'tooltipString', tip_clear,...
		'units', 'normalized', 'position', [0.2, 0, .2, 1], ...
		'callback', @clear_callback); 

    
%------------------------ Functions --------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function [a, b, tau] = getValues()
            a = str2double(get(input_a, 'string'));
            b = str2double(get(input_b, 'string'));
            tau = str2double(get(input_tau, 'string'));

    end
                                                                           
                                                                           
    function sel_callback(source,~)
        if  get(source,'SelectedObject') == rb1
            % show method 1
            set(method_text, 'string', label_method1);
            set(model_text, 'string', label_model1);
            image( image1, 'parent', ax);
        else
            % show method 2
            set(method_text, 'string', label_method2);
            set(model_text, 'string', label_model2);
            image( image2, 'parent', ax);
        end
    end


	function calc_callback(~, ~)
        [a, b, tau] = getValues();
		figure_y = figure_y - 30;
		graph_count = graph_count + 1;
		figure('Position', [figure_x figure_y, figure_width, figure_height],...
		'Name', [label_graph ' ' num2str(graph_count)],...  % Title figure
		'NumberTitle', 'off'... % Do not show figure number
		);  
        
        % determine the algorithm to calculate the result.
        if  get(group,'SelectedObject') == rb1 
            result = pointsPlotter2(a, b, tau, 1);
        elseif get(group,'SelectedObject') == rb2
            result = pointsPlotter2(a, b, tau, 2);
        end
        
        % check for result and set label.
        if isempty(result)
            set(result_text, 'string', label_result_bad);
            set(interval_text, 'string', '');
        else
            set(result_text, 'string', label_result_good);
            set(interval_text, 'string', ...
                ['(' num2str(result(1)) ', ' num2str(result(2)) ').' ]);
        end
        set(close_btn, 'enable', 'on') ;
    end
    
    function resetFigureVars()
        figure_x = screen_width - figure_width;
        figure_y = screen_height - figure_height - 25;
        graph_count = 0;
    end

% Closes all graphic windows.
	function close_callback(~, ~)
        for n=1:graph_count
            try
                close([label_graph ' ' num2str(n)]);
            catch e
                display(e);
            end
        end
        resetFigureVars();
        set(close_btn, 'enable', 'off') ;
	end
	
	% Regenerate input values.
	function random_callback(~, ~)
        set(input_a, 'string', num2str(rand(1)*2-1,4));
        set(input_b, 'string', num2str(rand(1)*2-1,4));
        set(input_tau, 'string', num2str(rand(1)*5,4));
	end

	% Clear input values.
	function clear_callback(~, ~)
        set(input_a, 'string', '');
        set(input_b, 'string', '');
        set(input_tau, 'string', '');
    end
	
	
end
