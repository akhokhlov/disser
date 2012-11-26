%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ������� ����� ������� ������� ������������ 
% �� ����, ����������� ����� phi � �������� 
% ������� ��������� � ��������� epsilon.
% ���������� ���������� ����� �� �������� 
% ���� � ��������� epsilon.
% type - ��� ���������� �������� 
% (1 ��� ���������������, 2 ��� ������������� 
% ��������������).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [half] = searchPointInRowGeom(...
	type, number, tau, phi, epsilon)
r = [0 2];
stab = straightStabAnalizer(type, ...
	r(2)*cos(phi), r(2)*sin(phi), number, tau);
while stab
	r(2) = r(2) + 1;
	stab = straightStabAnalizer(type, ...
		r(2)*cos(phi), r(2)*sin(phi),...
		number, tau);
end
for iter = 1:20
	%disp(' ');
	%disp(['Step ' num2str(iter) ' ======>'])
	half = sum(r)/2;
	stab = straightStabAnalizer(type, ...
	half*cos(phi), half*sin(phi), number, tau);
	if stab
		r(1) = half;
	else
		r(2) = half;
	end
	if abs(r(1) - r(2)) < epsilon
		%disp (['Stopped on ' num2str(iter)]);
		%return;
	end
end
end
