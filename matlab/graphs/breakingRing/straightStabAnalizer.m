%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Проверяет данную точку на устойчивость непосредственно, использую
% годограф.
% type - тип соединения нейронов (1 для несимметричного, 2 для симметричного 
% взаимодействия),
% a, b - коэффициенты уравнения, 
% number - количество нейронов,
% tau - запаздывание.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [stab] = straightStabAnalizer(type, a, b, number, tau)
    j = 1:number;
    % Вычисление собственных чисел.
        lambda = ones(size(j));
% Находим собственные числа матрицы B =
%         0 b 0 0 0 a*c
%         a 0 b 0 0 0
%         0 a 0 b 0 0
%         0 0 a 0 b 0
%         0 0 0 a 0 b
%       b*c 0 0 0 a 0
        
        %B = zeros(j)+diag(ones(b,size(j)),1)+diag(ones(a,size(j)),-1)+diag(a*c,j)+diag(b*c,-j);
        
        c=0;
        load('var');
        mu = eig([...
        0 b 0 0 0 a*c
        a 0 b 0 0 0
        0 a 0 b 0 0
        0 0 a 0 b 0
        0 0 0 a 0 b
      b*c 0 0 0 a 0
            ]);

    % Находим w, которая является параметром для точки первого пересечения
    % годографа с осью 0a.
    PI=2*pi;
    w=0:PI/100:PI;
    maxW = zeros(1, number) ;
    for k=j
        z = tau*real(lambda(k));
        if z < -1
            stab = false;
            return;
        end
        ycone = -z.*sin(w)- w.*cos(w) ;

        jj =1;
        while ycone(jj) <= 0
            jj = jj+1;
        end
        maxW(k) = w(jj) ;
    end
    
    % Для каждой из точек Mj срезаем конус на высоте её третьей компоненты
    % (переводим задачу на плоскость), затем определяем, лежит ли эта точка
    % в овале устойчивости или нет. 
    for k=j
        PI = maxW(k) ;
        w=-PI:PI/100:PI;

        m = mu(k) ;
        la = lambda(k) ;
        x = tau*abs(m).*cos(arg(m) + tau*imag(la));
        y = tau*abs(m).*sin(arg(m) + tau*imag(la));
        z = tau*real(la);

        xcone =  w.*sin(w) - z.*cos(w);
        ycone = -w.*cos(w) - z.*sin(w) ;
        % Находим расстояние от каждой точки овала устойчивости до Mj.
        distArr =(x-xcone).^2 +(y-ycone).^2 ;

        % Находим точку овала, наиболее близкую к точке Mj.
        minInd1 = 1;
        minInd2 = 2;
        for jj= 2:length(distArr) 
            if distArr(jj) < distArr(minInd1)
                minInd2 = minInd1;
                minInd1 = jj ;
            end
        end

        distCone = (xcone(minInd1)-1)^2 + ycone(minInd1)^2;
        distPoint = (x-1)^2 + y^2;

        % Если расстояние от начала координат до точки Mj больше, чем до 
        % ближайшей точки овала, то исследуемая пара значения a, b является 
        % неустойчивой и дальнейшее выполнение функции не имеет смысла.
        if distPoint > distCone
            stab = 0;
            return;
        end
    end

    % Если протестированы все точки Mj и среди них не оказалось
    % неустойчивых, то исследуемая пара значения a, b является устойчивой.
    stab = 1;
end
