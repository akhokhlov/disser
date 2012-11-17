%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ������ ����� ������������.
% �������������: cone(lambda, mu), 
%		��� lambda, mu - ����������� ��������
% ������ A, B.
% ������:
% cone ([0.06+1.8658i 0.06-1.8658i],...
% [0.025+0.1555i 0.025-0.1555i], 7, 0.5)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cone
	if exist('n', 'var') == false 
		n=100;
	end
	% ���������� ������.
	tau_cone = 1;
	W = pi/tau_cone-0.5; %pi/6;
	%������ ��� ���������� ��������� ������(����)
	w=-W:2*W/100:W;		 
	z=-w./tan(w*tau_cone);
	%������� 3-� ������ �������(������������)
	[W,Z]=meshgrid(w,z);		
	%������� ������� ������ �� ��� x
	X=W.*sin(tau_cone*W) - Z.*cos(tau_cone*W); 
	%������� ������� ������ �� ��� y
	Y=-W.*cos(tau_cone*W) - Z.*sin(tau_cone*W);
	for ii=n/2+1 : n+1
		for j=1 : n+1 
			Z(ii,j)=1;%tau_cone/(tau_cone);
			X(ii,j)=1-z(50);
			Y(ii,j)=0;
		end
		for j=1:1:ii-51
			X(ii-50,j)=X(ii-50,ii-50);
			X(ii-50,102-j)=X(ii-50,ii-50);
			Y(ii-50,j)=0;
			Y(ii-50,102-j)=0;
		end
	end
	% ��������� ������ �� 3-� �������� �����������.
	hold on;
	hold on;
	shading interp;					   
	colormap(gray);
	mesh(X, Y, Z)
	xlabel('$u_{1}$','Interpreter','latex',...
		'FontSize',30);
	ylabel('$u_{2}$','Interpreter','latex',...
		'FontSize',30);
	zlabel('$u_{3}$','Interpreter','latex',...
		'FontSize',30);
	view([-30 30]);
	alpha(.2);
end
