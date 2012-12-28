function ringBounds
    addpath('../../common');
    addpath('../../product_3');
    
    epsilon = 0.1;   
    dir = 'out';
    mkdir(dir);
    ext = 'eps';
    suffix = '';...'_autoref';

% Границы для областей в диссертации.
    bounds = [-5 3 -4 4];

    %bounds = [-4 4 -4 4];
    %bounds = [-3 2.3 -2.3 3];
    
%    type = 1; tau = 0.5; plotBounds;
    type = 1; tau = 0.1; plotBounds;
    type = 1; tau = 1; plotBounds;
    type = 2; tau = .1; plotBounds;
    type = 2; tau = .5; plotBounds;
    type = 2; tau = 1; plotBounds;
    
    function plotBounds
        for num = 3:8 
            plotterBoundness(type, tau, num, epsilon, ...
                dir, ext, bounds, suffix);
        end
        close all;
    end
 end