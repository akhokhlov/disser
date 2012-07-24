%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Возвращает массив чётной длины, представляющий собой упорядоченный набор 
% множеств (отрезков) и являющийся объединением наборов множеств set1 и set2.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function result = coalition(set1, set2)
    % проверка входных параметров.
    validate(set1);
    validate(set2);
    
    % проверка на пустое множество.
    if isempty(set1)
        result = set2;
        return;
    elseif isempty (set2) 
        result = set1;
        return;
    end

    % Now dimention of set1, set2 >= 2.
    complexSet = []; % Determine complex set. 
    set = [];
    if length (set1) == 2
        complexSet = set2;
        set = set1;
    elseif length (set2) == 2;
        complexSet = set1;
        set = set2;
    else
        result = set1;
        for n=1:2:length(set2)
            result = coalition1(result, set2(n:n+1));
        end
        return;
    end

    % Perform coalition complex and simple set.
    % First and last indexed of simple set in the complexSet.
    maxIndex = length(complexSet)+1;
    first=maxIndex;
    last=maxIndex;
    for n=1:length(complexSet)
        if first == maxIndex && set(1)<complexSet(n)
            first = n;
        end
        if last == maxIndex && set(2)<complexSet(n)
            last = n;
        end
    end

    % Insert simple set into complex set.
    if mod (first,2) == 1  % odd index
        if first == last
            result = [complexSet(1:first-1), set, complexSet(last:end)];
            return;
        elseif last>length (complexSet)
            result = [complexSet(1:first-1), set];
            return;
        end
        if mod (last, 2) == 1 % odd index
            result = [complexSet(1:first-1), set, complexSet(last:end)];
            return;
        else
            result = [complexSet(1:first-1), set(1), complexSet(last:end)];
            return;
        end
    else % first index even.
        if first == last
            result = complexSet;
            return;
        end
        if mod (last, 2) == 1 % odd index
            result = [complexSet(1:first-1), set(2), complexSet(last:end)];
            return;
        else
            result = [complexSet(1:first-1), complexSet(last:end)];
            return;
        end
    end
        % Проверяет, что массив имеет чётную длину и состоит из неубывающих
        % значений.
        function validate(set)
            if mod(length(set), 2) == 1 
                error(['Input array [' num2str(set) '] should has the even length!']);
            end
            for n=1:length(set)-1
                if set(n)>set(n+1)
                    error(['Input array [' num2str(set) ...
                        '] should consist of increasing values!']);
                end
            end
        end
end
