%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ќпредел€ет принадлежность tau множеству 
% интервалов 'evenSet'.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function result = isInside(evenSet, tau)
	% Supporting 'tau' as array.
	result = zeros(1, length(tau));
	if length(tau)>1
		for k=1:length(tau)
			result(k) = isInside(tau(k));
		end
		result = result';
		return;
	end
	% Check for even.
	if mod(length(evenSet), 2) == 1
		error(['Input array evenSet '...
			'must has the even length!']);
	end
	for j = 1:2:length(evenSet)
		if evenSet(j) < tau && tau < evenSet(j+1)
			result = 1;
			return;
		end
	end
	% tau is excluded from all intervals.
	result = 0;
end
