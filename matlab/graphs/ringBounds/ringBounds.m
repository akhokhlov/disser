function ringBounds
    addpath('../../common');
    addpath('../../product_3');
    
    epsilon = 0.1;   
    dir = 'out';
    mkdir(dir);
    ext = 'eps';
    
    type = 1; tau = 0.5; plotBounds;
    type = 1; tau = 0.1; plotBounds;
    type = 1; tau = 1; plotBounds;
%     type = 2; tau = .1; plotBounds;
%     type = 2; tau = .5; plotBounds;
%     type = 2; tau = 1; plotBounds;

    %bounds = [-4 4 -4 4];
    
    function plotBounds
        bounds = [-5 3 -4 4];
        for num = 3:8 
            plotterBoundness(type, tau, num, epsilon, ...
                dir, ext, bounds);
        end
        close all;
    end
 end