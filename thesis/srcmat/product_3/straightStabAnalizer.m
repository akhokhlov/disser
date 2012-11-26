%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��������� ������ ����� �� ������������ 
% ���������������, ��������� ��������.
% type - ��� ���������� �������� 
% (1 ��� ������., 2 ��� ����. ��������������),
% a, b - ������������ ���������, 
% number - ���������� ��������,
% tau - ������������.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [stab] = straightStabAnalizer(...
	type, a, b, number, tau)
	j = 1:number;
	% ���������� ����������� �����.
	if type == 1	% ������ ��� ����������. 
		lambda = 1 + a*exp(1i*2*pi.*j/number);
		mu = b*exp(-1i*2*pi.*j/number);
	else % ������ ��� ���������� ��������. 
		lambda = ones(size(j));
		mu = a*exp(1i*2*pi.*j/number) + ...
			b*exp(-1i*2*pi.*j/number);
	end
	% ������� w, ������� �������� ���������� 
	% ��� ����� ������� �����������
	% ��������� � ���� 0a.
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
	% ��� ������ �� ����� Mj ������� ����� 
	% �� ������ � ������� ����������
	% (��������� ������ �� ���������), 
	% ����� ����������, ����� �� ��� �����
	% � ����� ������������ ��� ���. 
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
		% ������� ���������� �� ������ ����� 
		% ����� ������������ �� Mj.
		distArr =(x-xcone).^2 +(y-ycone).^2 ;
		% ������� ����� �����, 
		%�������� ������� � ����� Mj.
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
		% ���� ���������� �� ������ ��������� 
		% �� ����� Mj ������, ��� �� ��������� 
		% ����� �����, �� ����������� ���� 
		% �������� a, b �������� ������������ 
		% � ���������� ���������� ������� 
		% �� ����� ������.
		if distPoint > distCone
			stab = 0;
			return;
		end
	end
	% ���� �������������� ��� ����� Mj � 
	% ����� ��� �� ��������� ������������, 
	% �� ����������� ���� �������� a, b 
	% �������� ����������.
	stab = 1;
end
