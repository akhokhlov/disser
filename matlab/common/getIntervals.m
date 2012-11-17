%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Вычисляет интервалы устойчивости по tau.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function result = getIntervals(lambda, mu)

    % Simple cheking for stability.
    if real(lambda) > abs(mu)
        %disp('INFO: stability anyway!');
        result = [0 Inf];
        return;
    end

    % Perform necessary calculations.
    Q = sqrt((abs(mu))^2 - (real(lambda))^2);
    M = 15;
    m = -M:M;

    tau_plus = (arg(1i*Q - real(lambda)) + ...
        2*pi*m - arg(mu)) / (imag(lambda) + Q);
    tau_minus = (arg(-1i*Q - real(lambda)) + ...
        2*pi*m - arg(mu)) / (imag(lambda) - Q);


    % Check if atau in [0, pi/Q].
    baund = pi/Q;
    % concatenate arrays.
    all = [tau_plus, tau_minus]; 
    k=1;
    for j = 1 : length(all) 
        atau = all(j); 
        if atau > 0 && atau <= baund && ...
                real(lambda) >= -Q/tan(Q*atau)
            result_set(k) = atau;
            k = k+1;
        end
    end

    if exist('result_set', 'var') == 0
        %disp('INFO: empty set!');
        result = [];
        return;
    end

    % Check if [0, tau1] is included 
    % in the result set.
    
    % spiral goes up.
    if (real(lambda)>0 && mu>-pi/2 && mu<pi/2)	
        % add zero to result set.
        result_set = [0 result_set]; 
    elseif (real(lambda) > 0 && (real(lambda)) ...
            > abs(real(mu)))	% spiral goes up.
        % add zero to result set.
        result_set = [0 result_set]; 
    elseif (real(lambda) < 0 && ...
            abs(real(lambda)/real(mu)) < 1)
        % add zero to result set.		
        result_set = [0 result_set]; 
    end

    % Sort the result set.
    %disp('INFO: Sorted set: ');
    result_set = sort(result_set);

    % Remove the same values.
    if length(result_set) > 1
        cleanSet = result_set;
        %result_set(1) == result_set(2)
        if abs(result_set(1)-result_set(2))<0.000001     
            cleanSet = cleanSet(2:end);
        end
        for k = 2:length(result_set)-1
            if abs(result_set(k)-result_set(k+1)) ...
                < 0.000001 
                cleanSet = [cleanSet(1:k-1), ...
                    cleanSet(k+1:end)];
            end
        end
        result_set = cleanSet;
    end

    % Check for even.
    if mod(length(result_set), 2) == 1
        result_set = [0 result_set];
    end

    result = result_set;
end

