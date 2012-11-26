%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ������ ������� ������������.
% type - ��� ���������� �������� (1 ��� 
% ���������������, 2 ��� ������������� 
% ��������������),
% tau - ������������,
% number - ���������� ��������,
% epsilon - ��������,
% dir - ���������� ��� ���������� ��������, 
% ext - ���������� ������ ��� ����������,
% minX, maxX - ������� ��� ��������.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [minX, maxX, figure1] = ...
	plotterBoundness(type, tau, number, ...
	epsilon, dir, ext, minX, maxX)
addPath('../common');
fontsize=24;
ticksize=22;
% �������� ���� ��� �������
figure1 = figure('InvertHardcopy','off',...
	'Color',[1 1 1], ...
	'position', [680 0 600 570]);
hold on;
grid on;
% �������� ��� �������� ������ ��� ������� 
% ������������ ������������ ����� ��������.
datafile = ...
	[num2str(type) '_' num2str(tau) '.mat'];
try 
	load(datafile);
catch me
	display(me);
	% ��������������, ��� ����� ������ ���.
end
% ���� ������ �� �����������, �� �������� ��.
if exist('infiniteR', 'var') == 0 || ...
		exist('infinitePhi', 'var') == 0 
	infiniteNumber = 100;
	[infinitePhi, infiniteR] = ...
		solverBoundnessSmart(type, tau, ...
		infiniteNumber, .02);
	save(datafile,'infinitePhi','infiniteR');
end
h = polar(infinitePhi, infiniteR, '-');
set(h, 'LineWidth', 3, 'color', 'k') ;
% ���������� ������� ������������ 
% ��� ������������� ����� ��������.
[phi, r] = solverBoundnessSmart(type, tau, ...
	number, epsilon);
polar(phi, r, 'o');
title(['$\tau = ' num2str(tau) ', n = ' ...
	num2str(number) '$' ],...
	'FontSize',fontsize,'interpreter','latex');
% �������� ��������
xlabel({'a'}, 'FontSize',fontsize);
ylabel({'b'}, 'FontSize',fontsize);
text('String','stab',...
 'Position',[-.5 .2],...
 'FontSize',fontsize);
text('String','unstab',...
 'Position',[-2 -1.2],...
 'FontSize',fontsize);
text('String','unstab',...
 'Position',[1.2 1.5],...
 'FontSize',fontsize);
text('Interpreter','latex',...
 'String',{['$n = ' num2str(number) '$']},...
 'Position',[r(1) .4],...
 'FontSize',fontsize);
text('Interpreter','latex',...
 'String',{'$n = \infty$'},...
 'Position',[0 -0.7],...
 'FontSize',fontsize);
 % axes
set(gca, 'FontSize',ticksize);
%set(gca, 'XTick',[ -3 -2 -1 0 1 2 3 ], ...
% 'YTick',[-1 0 1 2], 'FontSize',ticksize);
	% ���������������
	ax=axis;
	x1=min(ax(1), ax(3));
	x2=max(ax(2), ax(4));
	if exist('minX', 'var')
		x1=minX;
	end
	if exist('maxX', 'var')
		x2=maxX;
	end
	minX = x1;
	maxX = x2;
	axis([x1-.5 x2+.5 x1-.5 x2+.5]);
	% �������� �������������� ������
	ax=axis;
	plot(ax(1:2), [ax(4) ax(4)], 'k', ...
		'LineWidth', 1);
	plot([ax(2) ax(2)], ax(3:4), 'k', ...
		'LineWidth', 1);
	axis([x1-.5 x2+.5 x1-.5 x2+.51]);
	% ���������� ����������� ������
	if type == 1
		typeName = 'asym';
	else
		typeName = 'sym';
	end
	strTau = num2str(tau);
%	 if length(strTau) < 3
%		 strTau = [strTau '_0'];
%	 end
	%mkdir(dir);
	figureName = [typeName '_tau' strTau ...
		'_n' num2str(number)];
	% ����� �����, ���� �� ���� ������� 
	% � �������� �������.
	figureName = strrep(figureName, '.', '');
	set(figure1, 'PaperPositionMode', 'auto');
	if strcmp(ext, 'png')
		saveas(figure1, [dir filesep ...
			figureName '.png'], 'png');
	else
		saveas(figure1, [dir filesep ...
			figureName '.eps'], 'psc2');
	end
	close;
end
