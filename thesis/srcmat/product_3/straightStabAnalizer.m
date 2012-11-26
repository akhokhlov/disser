%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ѕровер€ет данную точку на устойчивость 
% непосредственно, использу€ годограф.
% type - тип соединени€ нейронов 
% (1 дл€ несимм., 2 дл€ симм. взаимодействи€),
% a, b - коэффициенты уравнени€, 
% number - количество нейронов,
% tau - запаздывание.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [stab] = straightStabAnalizer(...
	type, a, b, number, tau)
	j = 1:number;
	% ¬ычисление собственных чисел.
	if type == 1	% первый тип соединени€. 
		lambda = 1 + a*exp(1i*2*pi.*j/number);
		mu = b*exp(-1i*2*pi.*j/number);
	else % второй тип соединени€ нейронов. 
		lambda = ones(size(j));
		mu = a*exp(1i*2*pi.*j/number) + ...
			b*exp(-1i*2*pi.*j/number);
	end
	% Ќаходим w, котора€ €вл€етс€ параметром 
	% дл€ точки первого пересечени€
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
	% ƒл€ каждой из точек Mj срезаем конус 
	% на высоте еЄ третьей компоненты
	% (переводим задачу на плоскость), 
	% затем определ€ем, лежит ли эта точка
	% в овале устойчивости или нет. 
	for k=j
		PI = maxW(k) ;
		w=-PI:PI/100:PI;
		m = mu(k) ;
		la = lambda(k) ;
		x=tau*abs(m).*cos(arg(m)+tau*imag(la));
		y=tau*abs(m).*sin(arg(m)+tau*imag(la));
		z = tau*real(la);
		xcone =  w.*sin(w) - z.*cos(w);
		ycone = -w.*cos(w) - z.*sin(w) ;
		% Ќаходим рассто€ние от каждой точки 
		% овала устойчивости до Mj.
		distArr =(x-xcone).^2 +(y-ycone).^2 ;
		% Ќаходим точку овала, 
		%наиболее близкую к точке Mj.
		minInd1 = 1;
		minInd2 = 2;
		for jj= 2:length(distArr) 
			if distArr(jj) < distArr(minInd1)
				minInd2 = minInd1;
				minInd1 = jj ;
			end
		end
		distCone = (xcone(minInd1)-1)^2 + ...
			ycone(minInd1)^2;
		distPoint = (x-1)^2 + y^2;
		% ≈сли рассто€ние от начала координат 
		% до точки Mj больше, чем до ближайшей 
		% точки овала, то исследуема€ пара 
		% значени€ a, b €вл€етс€ неустойчивой 
		% и дальнейшее выполнение функции 
		% не имеет смысла.
		if distPoint > distCone
			stab = 0;
			return;
		end
	end
	% ≈сли протестированы все точки Mj и 
	% среди них не оказалось неустойчивых, 
	% то исследуема€ пара значени€ a, b 
	% €вл€етс€ устойчивой.
	stab = 1;
end
