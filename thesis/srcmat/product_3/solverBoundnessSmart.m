%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��������� ����� ������� ������������ 
% � �������� ��������� epsilon, ��� ����� 
% ��� ���������� �� ���������� ���������� 
% ���� �� �����.
% type - ��� ���������� �������� 
% (1 ��� ���������������, 2 ��� ������������� 
% ��������������),
% tau - ������������,
% number - ���������� ��������,
% epsilon - ��������,
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [phi r] = solverBoundnessSmart(...
	type, tau, number, epsilon)
	radius = 2*epsilon;
	r = zeros(1, 1000);
	phi = zeros(1, 1000);
	% ��������� ������ ����� �� ���� '0a'.
	phi(1) = 0;
	[r(1)] = searchPointInRowGeom(...
		type, number, tau, 0, radius);
	% ��� ������ ����� �������, 
	% �������� � ��������� �������� �������
	% ���������, �� �������� ���������� 
	% radius �� ����������.
	n=1;
	while n<1000
		[r(n+1), phi(n+1)] = ...
			searchNeighbourhoodPoint(r(n), ...
			phi(n), radius);
		n = n+1;
		if phi(n-1) - phi(n) > 1
			break
		end
	end
	phi = phi(1:n);
	r = r(1:n);
	% ��������� ����� �� �������� �� � ����������.
	function [x y] = translate (r, phi, r1, phi1)
		x = r*cos (phi) + r1*cos (phi + phi1);
		y = r*sin(phi) + r1*sin(phi + phi1);
	end
	% ��������� ����� �� ���������� �� � ��������.
	function [r, phi] = toPolar(x, y)
		r = sqrt(x^2 + y^2);
		if x>0
			if y>=0
				phi = atan(y/x);
			else 
				phi = atan(y/x) + 2*pi;
			end
		elseif x < 0
			phi = atan(y/x) + pi;
		else %if x == 0
			if y > 0
				phi = pi/2;
			elseif y<0
				phi = 3*pi/2;
			else
				phi = 0;
			end
		end
	end
	% ���� ��������� ����� �� �������� 
	% ���������� radius �� ����������.
	function [rEnd phiEnd] = ...
			searchNeighbourhoodPoint(r,phi,radius)
		phi0 = 0;
		phi1 = pi;
		for jj=1:10
			phiHalf = (phi1+phi0)/2;
			[xHalf yHalf] = ...
				translate(r,phi,radius,phiHalf);
			stabHalf = straightStabAnalizer(...
				type,xHalf,yHalf,number,tau);
			if stabHalf == 1
				phi1 = phiHalf;
			else
				phi0 = phiHalf;
			end
		end
		[rEnd phiEnd] = toPolar(xHalf, yHalf);
	end
end
