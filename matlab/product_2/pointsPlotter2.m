function [result] = pointsPlotter2(a, b, tau, geometry)
	addPath('../common');
	% Построение конуса устойчивости.
	cone();


    % Построение точек и вычисления.
    % Выбираем несколько (10) точек кривой и определяем находятся ли они внутри
    % конуса. Для этого находим собственные числа.
    result = [0 Inf];
    n = 100;
    t = 0:2*pi/(n-1):2*pi;
    j=1:n;
    if geometry == 1
        lambda = 1 + a*exp(1i*2*pi*j/n);
        mu = b*exp(-1i*2*pi*j/n);
    % Calculating point for displaying.
    U = [tau*b*cos(-t + a*tau*sin(t))
         tau*b*sin(-t + a*tau*sin(t))
         tau*(1 + a*cos(t))];
    elseif geometry == 2
        lambda = ones(1,n);
        mu = a*exp(1i*2*pi*j/n) + b*exp(-1i*2*pi*j/n);
    % Calculating point for displaying.
    U = [tau*abs(b+a)*cos(t)
         tau*abs(b-a)*sin(t)
         tau*ones(1, n)];
    end
    for j=1:n
        intervals = getIntervals(lambda(j), mu(j));
        result = intersection(result, intervals);
        % инвертируем рузультат, чтоб внешние точки отобразить красными.
        text(U(1,j), U(2,j), U(3,j), '*', 'color', [~isInside(intervals, tau) 0 0], 'fontsize', 20);
    end
end




