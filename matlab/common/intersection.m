% Returns intersection set of 'set1' and 'set2'.
% 'set1' and 'set2' need to be even.
function result = intersection(set1, set2)

% Simple checking for empty set.
if isempty(set1) || isempty(set2)
	result = [];
	return;
end

% Check for the even lenth.
if mod(length(set1), 2) == 1 || mod(length(set2), 2) == 1
	error('Input arrays ''set1'' and ''set2'' must has the even length!');
end

% Check order.

% Perform simple checking of two intervals.
if length(set1)==2 && length(set2)==2
	result = [max(set1(1), set2(1)), min(set1(end), set2(end))];
	if result(1) > result(2)
		result = [];
	end
	return;
end


% Decomposition.
if length (set1) > 2 || length (set2) > 2
    result = [] ;
    for n = 1:2:length (set1)
        for k = 1:2:length (set2)
            set = intersection(set1(n:n+1) , set2(k:k+1)) ;
            result = coalition(set, result) ;
        end
    end
end
