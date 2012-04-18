function application
	MAX_DIM = 5;
	fontsize0 = 12;
	fontsize1 = 15;
    
    % Строковые ресурсы.
	label_error = 'Ошибка';
	err_incorrect_cell = 'Вы ввели некорректное значение в ячейке ';
	label_graph = 'График';
	appTitle = 'Анализ устойчивости';
	header = 'Анализ устойчивости уравнения ';
	header_eq = 'x''(t) + Ax(t) + Bx(t-tau) = 0';
	inputPanelTitle = 'Входные данные';
	inputPanelDesc = 'Базовая матрица';
    resultPanelTitle = 'Результаты вычислений';
	label_dim = 'Размерность = ';
	label_method = 'Выберите способ задания матриц A и B';
	label_method1 = 'Задать матрицы A и B с помощью базовой матрицы D';
	label_method2 = 'Задать матрицы A и B с помощью собственных чисел';
	label_eig = 'Собственные числа матрицы ';
    label_A = 'A = ';
	label_B = 'B = ';
	label_D = 'D = ';
	label_rand = 'Заполнить';
	tip_rand = 'Заполняет матрицу случайными значениями';
	label_clear = 'Очистить';
	tip_clear = 'Очищает матрицу';
	label_calc = 'Рассчитать...';
    label_calc_tip = 'Определяет интервалы устойчивости системы, заданной матрицами A и B';
    label_close = 'Закрыть все графики';
    tooltip_close = 'Закрывает все ранее открытые графики';
	label_result_good = 'Уравнение устойчиво при tau, лежащем в следующем объединении интервалов:';
	label_result_bad = 'Уравнение неустойчиво при любом tau!';
    label_vector = 'Введите коэффициенты в разложении матриц A и B по степеням матрицы D';

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
    
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input panel.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
inputPanel = uipanel('Parent',f,'Title',inputPanelTitle,...
		 'Position',[0 .3 1 .6]);
sliderPanel = uipanel('Parent',inputPanel, ...
    'bordertype', 'none', 'Position',[0 .9 1 .1]);
uicontrol(sliderPanel, 'style', 'text', 'fontsize', fontsize1, 'string', label_dim, ...
		'horizontalalignment', 'right',...
		'units', 'normalized', 'position', [0, 0, .2, 1]);
dimText = uicontrol(sliderPanel, 'style', 'text', ...
		'units', 'normalized', ...
		'fontsize', fontsize1, ...
		'position', [0.2, 0, .1, 1]);
scale = uipanel('parent', sliderPanel, 'bordertype', 'none', 'Position',[0.3, 0, .7, 1]);
	for n=1:5
		uicontrol(scale, 'style', 'text', ...
			'string', n, ...
            'horizontalalignment', 'left', ...
			'units', 'normalized', ...
			'position', [n/5-.1, 0, .1, .5]);
	end
dimSlider =	uicontrol(sliderPanel, 'style', 'slider', ...
		'min', 0, 'max', 4, 'value', 4, 'sliderstep', [.25,.25], ...
		'units', 'normalized', 'position', [0.3, .5, .7, .5], ...
		'callback', @dimSlider_callback);
		set(dimText, 'string', get(dimSlider, 'value')+1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% input method
group = uibuttongroup('parent', inputPanel, 'Position',[0 .65 1 .25]);
uicontrol(group, 'style', 'text', 'fontsize', fontsize1, 'string', label_method, ...
		'units', 'normalized', 'position', [0, 0.7, 1, .3]);
set(group,'SelectionChangeFcn',@sel_callback);
uicontrol('parent',group, 'Style','Radio',...
    'fontsize', fontsize0, 'String',label_method1,...
    'units', 'normalized', 'pos',[0, .3, 1,.3]);
uicontrol('parent',group, 'Style','Radio',...
    'fontsize', fontsize0, 'String',label_method2,...
    'units', 'normalized', 'pos',[0, 0, 1,.3]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% matrix input
matrixPanel = uipanel('Parent',inputPanel, 'bordertype', 'none',...
                    'Position',[0 .25 1 .4]);
dim = str2double(get(dimText, 'string'));
	uicontrol(matrixPanel, 'style', 'text', 'fontsize', fontsize1, ...
        'string', inputPanelDesc, 'horizontalalignment', 'right',...
		'units', 'normalized', 'position', [0, 0.6, .2, .4]);
	uicontrol(matrixPanel, 'style', 'text', 'fontsize', fontsize1, ...
        'string', label_D, 'horizontalalignment', 'right',...
		'units', 'normalized', 'position', [0.2, 0.6, .1, .4]);
    uicontrol(matrixPanel, 'style', 'pushbutton', ...
    'string', label_clear, 'tooltipString', tip_clear,...
		'units', 'normalized', 'position', [0.2, 0.4, .1, .2], ...
		'visible', 'off', 'callback', @clear_callback); 
    uicontrol(matrixPanel, 'style', 'pushbutton', ...
    'string', label_rand, 'tooltipString', tip_rand,...
		'units', 'normalized', 'position', [0.2, 0.2, .1, .2], ...
		'visible', 'off', 'callback', @random_callback); 
    dim = MAX_DIM;
	matrixD = createTable(dim, dim);
		set(matrixD.root, 'Parent', matrixPanel);
		set(matrixD.root, 'Position',[.3 0 .7 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Vector Panel
vectorPanel = uipanel('Parent',inputPanel, 'bordertype', 'none',...
                    'Position',[0 0 1 .25]);
uicontrol(vectorPanel, 'style', 'text', 'fontsize', fontsize1, ...
    'string', label_vector, 'units', 'normalized', 'position', [0, 0.7, 1, .3]);
uicontrol(vectorPanel, 'style', 'text', 'fontsize', fontsize1, ...
    'string', label_A, 'horizontalalignment', 'right',...
    'units', 'normalized', 'position', [0.1 .3 .1 .3]);
vectorA = createVector(dim);
    set(vectorA.root, 'Parent', vectorPanel);
    set(vectorA.root, 'Position',[0.2 .3 .8 .3]);
uicontrol(vectorPanel, 'style', 'text', 'fontsize', fontsize1, ...
    'string', label_B, 'horizontalalignment', 'right',...
    'units', 'normalized', 'position', [0.1 0 .1 .3]);
vectorB = createVector(dim);
    set(vectorB.root, 'Parent', vectorPanel);
    set(vectorB.root, 'Position',[0.2 0 .8 .3]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Eig Panel
eigPanel = uipanel('Parent',inputPanel, 'bordertype', 'none',...
                    'Position',[1 0 1 .65]);
eigInput1 = createEigInput('A', 'lambda') ;
set (eigInput1.root, 'parent', eigPanel) ;
set (eigInput1.root, 'position', [0, 0, .5, 1]) ;

eigInput2 = createEigInput('B', 'mu') ;
set (eigInput2.root, 'parent', eigPanel) ;
set (eigInput2.root, 'position', [0.5, 0, .5, 1]) ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	

% Result panel.
    resultPanel = uipanel('Parent',f,'Title',resultPanelTitle,...
		 'Position',[0 0 1 .3]);
	resultChildPanel = uipanel('Parent',resultPanel,'bordertype', 'none',...
		 'Position',[0 0.2 .7 .8]);

    resultLabels = zeros (1, MAX_DIM) ;
    for n=1:MAX_DIM
        resultLabels(n) = uicontrol(resultChildPanel, 'style', 'text', ...
            'fontsize', fontsize1, 'horizontalalignment', 'left',...
            'units', 'normalized', 'position', [0, 1-.2*n, 1, .2]);
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	

resultMainPanel = uipanel('Parent',resultPanel,'bordertype', 'none',...
		 'Position',[0.7 0.2 .3 .8]);

    result_label = uicontrol(resultMainPanel, 'style', 'text', ...
		'fontsize', fontsize1, ...
		'units', 'normalized', 'position', [0, .5, 1, .5]);
	intervals_label = uicontrol(resultMainPanel, 'style', 'text', ...
		'units', 'normalized', ...
		'fontsize', fontsize1, ...
		'position', [0, 0, 1, .5]);
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
                                                                           
	%------------------------ Handlers --------------------------------------%
    function sel_callback(~,~)
        pos = get (matrixPanel, 'position');
        if  pos(1) == 0 
            % hide panels
            set (matrixPanel, 'position', [1 .25 1 .4]) ;
            set (vectorPanel, 'position', [1 0 1 .25]) ;

            % show panel
            set (eigPanel, 'position', [0 0 1 .65]) ;
        else
            % remove panel
            set (eigPanel, 'position', [1 0 1 .65]) ;

            % show panels
            set (matrixPanel, 'position', [0 .25 1 .4]) ;
            set (vectorPanel, 'position', [0 0 1 .25]) ;
        end
    end

    app_x = 100;
	app_y = 200;
	graph_count = 0;
	function calc_callback(~, ~)
		% getting eig values.
        dim = getDim () ;
        eigA = zeros (1, dim) ;
        eigB = zeros (1, dim) ;
        % Choosing the input method
        pos = get (matrixPanel, 'position');
        if  pos(1) == 0 
            D = getValues(matrixD.children, dim);
            eigD = eig(D) ;
            rowA = getVectorValues(vectorA.children, dim) ;
            rowB = getVectorValues(vectorB.children, dim) ;
            for j=1:length(eigD)
                e = [1 eigD(j) eigD(j)^2 eigD(j)^3 eigD(j)^4 eigD(j)^4]';
                eigA (j) = rowA*e(1:dim+1) ;
                eigB (j) = rowB*e(1:dim+1) ;
            end
        else
            eigA = getEigValues(eigInput1);
            eigB = getEigValues(eigInput2);
        end
        if isempty(eigA) || isempty(eigB)
            return;
        end
		app_x = app_x + 80;
		app_y = app_y - 80;
		graph_count = graph_count + 1;
		figure('Position', [app_x app_y, 600, 500],...
		'Name', [label_graph ' ' num2str(graph_count)],...  % Title figure
		'NumberTitle', 'off');      
        [intervals, intervalsCell]= pointsPlotter(eigA, eigB);
        set (close_btn, 'enable', 'on') ;
		
		dim = str2double(get(dimText, 'string'));
        for n=1:dim
            set(resultLabels(n), 'string', buildResult(intervalsCell{n}));
        end
        for n=dim+1:MAX_DIM
    		set(resultLabels(n), 'string', '');
        end
		% Set main result label.
		if isempty(intervals)
			set(result_label, 'string', label_result_bad);
		else
			set(result_label, 'string', label_result_good);
		end
		
		resultString = buildResult(intervals);
		set(intervals_label, 'string', resultString);
    end

% Closes all graph windows.
	function close_callback(~, ~)
		for n=1:graph_count
			try
				close([label_graph ' ' num2str(n)]);
            catch me
                display(me);
			end
		end
		app_x = 100;
		app_y = 200;
		graph_count = 0;
        set (close_btn, 'enable', 'off') ;
	end
	
	% DimSlider was changed.
	function dimSlider_callback(~, ~)
		val = int32(get(dimSlider, 'value'))+1;
		if str2double(get(dimText, 'string')) == val
			return;
		end
		set(dimText, 'string', val);
		setDim(matrixD.children, val);
        setVectorDim(vectorA.children, vectorA.children1, val) ;
        setVectorDim(vectorB.children, vectorB.children1, val) ;
        setEigInputDim(eigInput1, val);
        setEigInputDim(eigInput2, val);
	end
	
	% Regenerate matrix.
	function random_callback(~, ~)
        setValues(matrixD.children, rand (getDim())*2-1);
        generateRowValues(vectorA.children, MAX_DIM+1) ;
        generateRowValues(vectorB.children, MAX_DIM+1) ;
        generateRowValues(eigInput1.children, MAX_DIM) ;
        generateRowValues(eigInput1.children1, MAX_DIM) ;
        generateRowValues(eigInput2.children, MAX_DIM) ;
        generateRowValues(eigInput2.children1, MAX_DIM) ;
	end

	% Clear matrix.
	function clear_callback(~, ~)
		%if obj == clearAButton
        clearMatrix(matrixD.children);
        clearRowValues(vectorA.children, MAX_DIM+1) ;
        clearRowValues(vectorB.children, MAX_DIM+1) ;
        clearRowValues(eigInput1.children, MAX_DIM) ;
        clearRowValues(eigInput1.children1, MAX_DIM) ;
        clearRowValues(eigInput2.children, MAX_DIM) ;
        clearRowValues(eigInput2.children1, MAX_DIM) ;
    end
	
%------------------------ Functions --------------------------------------%		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function d = getDim ()
        d = str2double(get(dimText, 'string'));
    end

    function value = getRandomValAsString () 
        value = num2str(rand (1)*2-1,4);
    end

	% Build result string.
	function [resultString] = buildResult(intervals)
		resultString = '';
		for k = 1:2:length(intervals)
			from = num2str(intervals(k));
			to = num2str(intervals(k+1));
			resultString = [resultString ' (' from ', ' to ') U'];
		end
		resultString = resultString(1:end-1);
		if isempty(resultString)
			resultString = 'Empty set';
		end
    end

	function generateRowValues(children, dim)
        for n=1:dim
            set(children(n), 'string', getRandomValAsString());
        end
	end

	function clearRowValues(children, dim)
        for n=1:dim
            set(children(n), 'string', '');
        end
    end

%------------------------ Eig input --------------------------------------%		
    function eigInput = createEigInput (matrixName, eigName)
		root = uipanel();
        uicontrol(root, 'style', 'text', 'fontsize', fontsize1,...
            'string', [label_eig matrixName],...
            'units', 'normalized', 'position', [0, .7, 1,.2]);
		panel = uipanel('parent', root, 'bordertype', 'none',...
            'position', [0, 0, 1, .7]);
        childrenLabels = zeros (1, MAX_DIM) ;
        children = zeros (1, MAX_DIM) ;
        childrenLabels1 = zeros (1, MAX_DIM) ;
        children1 = zeros (1, MAX_DIM) ;
        childrenLabels2 = zeros (1, MAX_DIM) ;
        for n=1:MAX_DIM
            strnum = num2str (n) ;
            childrenLabels(n) = uicontrol(panel, 'style', 'text', 'fontsize', fontsize1,...
                'horizontalAlignment', 'right', 'string', [eigName strnum ' = '],...
                'units', 'normalized', 'position', [0, 1-.2*n, .3, .2]);
            children(n) = uicontrol(panel, 'style', 'edit', ...
                'string', num2str (rand (1)*2-1, 4), 'backgroundcolor', 'w',...
                'units', 'normalized', 'position', [.3, 1-.2*n, .25, .2]);
            childrenLabels1(n) = uicontrol(panel, 'style', 'text', 'fontsize', fontsize1,...
                'horizontalAlignment', 'center', 'string', ' + ',...
                'units', 'normalized', 'position', [0.55, 1-.2*n, .1, .2]);
            children1(n) = uicontrol(panel, 'style', 'edit', ...
                'string', num2str (rand (1)*2-1, 4), 'backgroundcolor', 'w',...
                'units', 'normalized', 'position', [.65, 1-.2*n, .25, .2]);
            childrenLabels2(n) = uicontrol(panel, 'style', 'text', 'fontsize', fontsize1,...

                'horizontalAlignment', 'left', 'string', '*i',...
                'units', 'normalized', 'position', [0.9, 1-.2*n, .1, .2]);
        end
        eigInput.root = root;
        eigInput.children = children;
        eigInput.children1 = children1;
        eigInput.childrenLabels = childrenLabels;
        eigInput.childrenLabels1 = childrenLabels1;
        eigInput.childrenLabels2 = childrenLabels2;
    end

	function setEigInputDim(eigInput, dim)
        for n = 1:dim
            set(eigInput.children(n), 'visible', 'on');
            set(eigInput.children1(n), 'visible', 'on');
            set(eigInput.childrenLabels(n), 'visible', 'on');
            set(eigInput.childrenLabels1(n), 'visible', 'on');
            set(eigInput.childrenLabels2(n), 'visible', 'on');
        end
        for n = dim+1:MAX_DIM
            set(eigInput.children(n), 'visible', 'off');
            set(eigInput.children1(n), 'visible', 'off');
            set(eigInput.childrenLabels(n), 'visible', 'off');
            set(eigInput.childrenLabels1(n), 'visible', 'off');
            set(eigInput.childrenLabels2(n), 'visible', 'off');
        end
	end

	function vector = getEigValues(eigInput)
        vector = zeros(1, getDim());
        for j=1:getDim()
            valRe = get(eigInput.children(j), 'string');
            valIm = get(eigInput.children1(j), 'string');
            parseValueRe = str2double(valRe);
            parseValueIm = str2double(valIm);
            if length(parseValueRe) ~= 1 || length(parseValueIm) ~= 1
                str = [err_incorrect_cell '(' num2str(j) ').'];
                errordlg(str, label_error, 'on');
                vector = [];
                return;
            end
            vector(j)=parseValueRe + parseValueIm*1i;
        end
	end

%------------------------ Vector input -----------------------------------%		
    function vector = createVector(dim)
        dim = dim+1;
		root = uipanel('bordertype', 'none');
        children = zeros(1, dim); % row
        children1 = zeros(1, dim); % row
        strings = {'E + ', 'D + ', 'D^2+', 'D^3+', 'D^4+', 'D^5'};
        for j=1:dim
            children(j) = uicontrol(root, 'style', 'edit', ...
                'string', num2str (rand (1)*2-1, 4), 'backgroundcolor', 'w',...
                'units', 'normalized', 'position', [(j-1)/dim, 0, 1/dim/2, 1]);
            children1(j) = uicontrol(root, 'style', 'text', 'string', strings (j),...
                'fontsize', fontsize1, 'units', 'normalized', ...
                'position', [(j-1)/dim+1/dim/2, 0, 1/dim/2, 1]);
        end
		vector.root = root;
		vector.children = children;
		vector.children1 = children1;
    end

	function setVectorDim(children, children1, dim)
        for j= 1:MAX_DIM+1
            if j>dim+1
                set(children(j), 'visible', 'off');
                set(children1(j), 'visible', 'off');
            else
                set(children(j), 'visible', 'on');
                set(children1(j), 'visible', 'on');
            end
        end
	end

	function vector = getVectorValues(children, dim)
        vector = zeros(1, dim+1);
        for j=1:dim+1
            val = get(children(j), 'string');
            parseValue = str2double(val);
            if length(parseValue) ~= 1
                str = [err_incorrect_cell '(' num2str(j) ').'];
                errordlg(str, label_error, 'on');
                vector = [];
                return;
            end
            vector(j)=str2double(val);
        end
    end

%------------------------ Matrix input -----------------------------------%		
	function matrix = createTable(rows, cols)
		root = uipanel('bordertype', 'none');
        children = zeros(rows, cols);
		for i=1:rows
			for j=1:cols
				children(i,j) = uicontrol(root, 'style', 'edit', ...
					'string', num2str(rand (1)*2-1,4), 'backgroundcolor', 'w',...
					'units', 'normalized', 'position', [(i-1)/rows, 1-j/cols, 1/cols, 1/rows]);
			end
		end
		matrix.root = root;
		matrix.children = children';
	end
	
	function [matrix] = getValues(children, dim)
        matrix = zeros(dim, dim);
		for i=1:dim
			for j=1:dim
				val = get(children(i,j), 'string');
				parseValue = str2double(val);
				if length(parseValue) ~= 1
					str = [err_incorrect_cell '(' num2str(i) ', ' num2str(j) ').'];
					errordlg(str, label_error, 'on');
					matrix = [];
					return;
				end
				matrix(i,j)=str2double(val);
			end
		end
	end

	function setValues(children, matrix)
		for i=1:length(matrix)
			for j=1:length(matrix)
				if i <= length(children) && j <= length(children)
					set(children(i,j), 'string', num2str (matrix(i,j), 4));
				end
			end
		end
	end

	function clearMatrix(children)
		for i=1:length(children)
			for j=1:length(children)
				set(children(i,j), 'string', '');
			end
		end
	end

	function setDim(children, dim)
		for i = 1:MAX_DIM
			for j= 1:MAX_DIM
				if i>dim || j>dim
					set(children(i,j), 'visible', 'off');
				else
					set(children(i,j), 'visible', 'on');
				end
			end
		end
	end
end
