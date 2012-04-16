function application3

fontsize0 = 12;
fontsize1 = 15;
image1 = imread('circles_right.png');                                                                           
image2 = imread('circles.png');                                                                           

% Error strings
label_error = 'Ошибка';
err_incorrect_tau = 'Вы ввели некорректное значение tau.';
err_incorrect_epsilon = 'You entered incorrect epsilon.';
appTitle = 'Построение областей устойчивости круговых нейронных сетей';
header = 'Построение областей устойчивости';
header_eq = 'для круговых нейронных сетей';
inputPanelTitle = 'Входные данные';
label_method = 'Конфигурация нейронной сети';
label_method1 = 'Круговое соединение нейронов с малым запаздыванием взаимодействия с правыми соседями';
label_method2 = 'Круговое соединение нейронов с одинаковым запаздываниям взаимодействия с соседями';
label_model1 = 'Модель сети: x''j(t) + xj(t) + a*xj-1(t) + b*xj+1(t-tau) = 0, 1 <= j <= n';
label_model2 = 'Модель сети: x''j(t) + xj(t) + a*xj-1(t-tau) + b*xj+1(t-tau) = 0, 1 <= j <= n';
label_set_tau = 'Величина запаздывания tau = ';
label_number = 'Число нейронов от ';
label_number1 = 'до ';
label_path = 'Путь для сохранения: ';
label_ext = 'Расширение: ';
label_epsilon = 'Точность: ';
label_theSameScale = 'Одинаковый масштаб';
label_calc = 'Рассчитать...';
label_calc_tip = 'Определяет интервалы устойчивости системы, заданной матрицами A и B';

	% Create a figure that will have a uitable, axes and checkboxes
f = figure('Position', [50, 100, 920, 600],...
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
		 'Position',[0 .1 1 .8]);

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
model_text = uicontrol(inputPanel1, 'style', 'text', 'fontsize', fontsize0,...
'string', label_model1, 'units', 'normalized', 'position', [0, 0.7, 1, .1]);
    
leftPanel1 = uipanel('Parent',inputPanel1, 'bordertype', 'none',...
                    'Position',[0 0 .75 .7]);
                                                                           
% tau
uicontrol(leftPanel1, 'style', 'text', 'fontsize', fontsize0, ...
    'string', label_set_tau, 'horizontalAlignment', 'right', ...
    'units', 'normalized', 'position', [0, 0.75, .6, .15]);
input_tau = uicontrol(leftPanel1, 'style', 'edit', ...
    'string', '0.5', 'backgroundcolor', 'w',...
    'units', 'normalized', 'position', [0.6 .77 .15 .15]);


% min max number 
uicontrol(leftPanel1, 'style', 'text', 'fontsize', fontsize0, ...
    'string', label_number, 'horizontalAlignment', 'right', ...
    'units', 'normalized', 'position', [0, 0.5, .6, .15]);
input_minnumber = uicontrol(leftPanel1, 'style', 'edit', ...
    'string', '3', 'backgroundcolor', 'w',...
    'units', 'normalized', 'position', [0.6 .52 .15 .15]);
uicontrol(leftPanel1, 'style', 'text', 'fontsize', fontsize0, ....
    'string', label_number1, 'horizontalAlignment', 'center', ...
    'units', 'normalized', 'position', [0.75, 0.5, .1, .15]);

input_number = uicontrol(leftPanel1, 'style', 'edit', ...
    'string', '3', 'backgroundcolor', 'w',...
    'units', 'normalized', 'position', [0.85 .52 .15 .15]);

     
% path
uicontrol(leftPanel1, 'style', 'text', 'fontsize', fontsize0, ...
    'string', label_path, 'horizontalAlignment', 'right', ...
    'units', 'normalized', 'position', [0, 0.25, .3, .15]);
uicontrol(leftPanel1, 'style', 'text', 'fontsize', fontsize0, ...
    'string', [pwd '/'], 'horizontalAlignment', 'right', ...
    'units', 'normalized', 'position', [0.3, 0.25, .55, .15]);
input_dir = uicontrol(leftPanel1, 'style', 'edit', ...
    'string', 'graphs', 'backgroundcolor', 'w',...
    'units', 'normalized', 'position', [0.85 .28 .15 .15]);


% use the same scale for all plots
checkboxScale = uicontrol(leftPanel1, 'style', 'checkbox', ...
    'string', label_theSameScale, ...
    'units', 'normalized', 'position', [0 .1 .25 .15]);

% extension
uicontrol(leftPanel1, 'style', 'text', 'fontsize', fontsize0, ...
    'string', label_ext, 'horizontalAlignment', 'right', ...
    'units', 'normalized', 'position', [0.25, 0.08, .2, .15]);
extCombo = uicontrol(leftPanel1, 'style', 'popupmenu', 'string', {'eps', 'png'}, ...
		'tooltipString', label_calc_tip,...
		'units', 'normalized', 'position', [0.45 .1 .15 .15]); 

% epsilon
uicontrol(leftPanel1, 'style', 'text', 'fontsize', fontsize0, ...
    'string', label_epsilon, 'horizontalAlignment', 'right', ...
    'units', 'normalized', 'position', [0.65, 0.1, .2, .15]);
input_epsilon = uicontrol(leftPanel1, 'style', 'edit', ...
    'string', '0.05', 'backgroundcolor', 'w',...
    'units', 'normalized', 'position', [0.85 .12 .15 .15]);

rightPanel1 = uipanel('Parent',inputPanel1, 'bordertype', 'none',...
                    'Position',[.75 0 .25 .7]);

ax = axes('parent', rightPanel1, 'position', [0 0 1 1]);
image( image1, 'parent', ax);
                                            

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
% Bottom panel.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
bottomPanel = uipanel('Parent',rootPanel,'bordertype', 'none',...
		 'Position',[0 0 1 .1]);

uicontrol(bottomPanel, 'style', 'pushbutton', 'string', label_calc, ...
		'tooltipString', label_calc_tip,...
		'units', 'normalized', 'position', [0.75, 0, .25, 1], ...
		'callback', @calc_callback); 

    
%------------------------ Functions --------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function [tau, minNumber, maxNumber, epsilon, dir, ext] = getValues()
            tau = str2double(get(input_tau, 'string'));
            minNumber = str2double(get(input_minnumber, 'string'));
            maxNumber = str2double(get(input_number, 'string'));
            dir = get(input_dir, 'string');
            epsilon = str2double(get(input_epsilon, 'string'));
            
            val = get(extCombo, 'value');
            values = get(extCombo, 'string');
            ext = values(val);
    end
                                                                           
    function sel_callback(source, ~)
        if  get(source,'SelectedObject') == rb1
            % show method 1
            set (method_text, 'string', label_method1);
            set (model_text, 'string', label_model1);
            image( image1, 'parent', ax);
        else
            % show method 2
            set (method_text, 'string', label_method2);
            set (model_text, 'string', label_model2);
            image( image2, 'parent', ax);
        end
    end

	function calc_callback(~, ~)
        [tau, minNumber, maxNumber, epsilon, dir, ext] = getValues();
        if isnan(tau) 
            str = err_incorrect_tau;
            errordlg(str, label_error, 'on');
            return;
        end
        if isnan(minNumber) || maxNumber < 3
            str = ['You entered incorrect min number of neirons. ' ...
                'It should be greater then 2.'];
            errordlg(str, label_error, 'on');
            return;
        end
        if isnan(maxNumber) || maxNumber < 3 || maxNumber < minNumber 
            str = ['You entered incorrect max number of neirons. ' ...
            'It should be greater then 2 and not less then min number.'];
            errordlg(str, label_error, 'on');
            return;
        end
        if isnan(epsilon)
            str = err_incorrect_epsilon;
            errordlg(str, label_error, 'on');
            return;
        end
        
        if abs(epsilon) < 0.05
            warn_eps = questdlg(['Calculating boundness with little epsion ', ...
                'may spend a lot of time on slow machines. ' ...
                'You should try greater value before. ',...
                'Are you sure you want to procesed?'], ...
                'Perfomance warning', 'Yes', 'No', 'No');
            switch warn_eps,
                case 'No', return;
            end % switch
        end
        
        if abs(minNumber - maxNumber) > 7
            warn_eps = questdlg(['Calculating boundness for many numbers ', ...
            'of neironous may spend a lot of time on slow machines. ' ...
            'You should try greater value before. Are you sure you want to procesed?'], ...
            'Perfomance warning', 'Yes', 'No', 'No');
            switch warn_eps,
                case 'No', return;
            end % switch
        end
        
        
        if  get(group,'SelectedObject') == rb1 
            type = 1;
        elseif get(group,'SelectedObject') == rb2
            type = 2;
        end
        
        mkdir(dir);
        [minX, maxX] = plotterBoundness(type, tau, minNumber, epsilon, dir, ext);

        if get(checkboxScale, 'value')
            for number=minNumber+1:maxNumber
                plotterBoundness(type, tau, number, epsilon, dir, ext, minX, maxX);
            end
        else
            for number=minNumber+1:maxNumber
                plotterBoundness(type, tau, number, epsilon, dir, ext);
            end
        end

    end
end