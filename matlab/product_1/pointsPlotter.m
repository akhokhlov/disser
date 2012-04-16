function [result, intervalsCell] = pointsPlotter(lambda, mu, maxdistanse, resolution)
	addPath('../common');
	% Построение конуса устойчивости.
	cone();
	
    % Построение точек.
    all = [0 Inf]; 
    intervalsCell = cell(size (lambda) ) ;
    for j=1:length(lambda)
        la = lambda(j);
        m = mu(j);

        % Calculation stability intervals.
        intervals = getintervals(lambda(j), mu(j));
        intervalsCell{j} = intervals;

        all = intersection(all, intervals);

    if exist('maxdistanse', 'var') == false 
        maxdistanse = 7;
    end
    if exist('resolution', 'var') == false 
        resolution =0.5;
    end

        dist_real = distance(m, la, 0, 1) ;
        max_tau = maxdistanse/dist_real;
        dist_real = distance(m, la, max_tau, max_tau-max_tau/10) ;
        quantity = dist_real/resolution*10;
        tau = 0.001 : max_tau/quantity : max_tau;

        for jj=1:length(tau)
            x = tau*abs(m).*cos(arg(m) + tau*imag(la));
            y = tau*abs(m).*sin(arg(m) + tau*imag(la));
            z = tau*real (la);

            if isInside(intervals, tau(jj))
                color = 'b';
            else 
                color = 'r';
            end
            text(x(jj), y(jj), z(jj), '*', 'color', color, 'fontsize', 20);
        end
        text(x(jj), y(jj), z(jj), num2str(j), 'color', color, 'fontsize', 20);
    end

    result = all;
end

    
    function [x,y,z] = point(m, la, tau)
        x = tau*abs(m).*cos(arg(m) + tau*imag(la));
        y = tau*abs(m).*sin(arg(m) + tau*imag(la));
        z = tau*real (la);
    end
    
    function [distance] = distance(m, la, tau0, tau1)
        [x0, y0, z0] = point(m, la, tau0) ;
        [x1, y1, z1] = point(m, la, tau1) ;
        distance = sqrt ((x1-x0)^2 + (y1-y0)^2 + (z1-z0)^2) ;
    end
