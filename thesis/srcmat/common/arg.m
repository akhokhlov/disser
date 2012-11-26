%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% По действительной и мнимой частям 
% комплексного числа находит его аргумент 
% в пределах [-pi, pi]. Функция также 
% работает с вектором комплексных чисел, 
% получая при этом вектор аргументов.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [result] = arg(x)
% Preallocating variable result.
result = zeros(1, length(x));
if length(x)>1
	for k=1:length(x)
		result(k)=arg(x(k));
	end
	result = result';
	return;
end
a=real(x); b=imag(x);
if a>0 && b==0
	result=0;
elseif a>0 && b>0
	result=atan(b/a);
elseif a==0 && b>0
	result=pi/2;
elseif a<0 && b>0
	result=pi+atan(b/a);
elseif a<0 && b==0
	result=pi;
elseif a<0 && b<0
	result=-pi+atan(b/a);
elseif a==0 && b<0
	result=-pi/2;
elseif a>0 && b<0
	result=atan(b/a);
end
