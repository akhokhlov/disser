function ringBounds
    addpath('../../common');
    addpath('../../product_3');
    
    %type = 1; tau = 0.5; minX = -5; maxX = 5;
    %type = 1; tau = 0.1; bounds = [-4.5 3 -3.5 4];
    %type = 1; tau = 1; bounds = [-2 3 -2 3];
    %type = 2; tau = .1; bounds = [-2.7 2.7 -2.7 2.7];
    %type = 2; tau = .5; bounds = [-2.7 2.7 -2.7 2.7];
    type = 2; tau = 1; bounds = [-2.7 2.7 -2.7 2.7];
    epsilon = 0.1;   
    dir = 'out';
    mkdir(dir);
    ext = 'eps';
    
    for num = 3:8 
        plotterBoundness(type, tau, num, epsilon, dir, ext, bounds);
    end
%     
%     plotterBoundness(type, tau, 3, epsilon, dir, ext);
%     plotterBoundness(type, tau, 4, epsilon, dir, ext);
%     plotterBoundness(type, tau, 5, epsilon, dir, ext);
%     plotterBoundness(type, tau, 6, epsilon, dir, ext);
%     plotterBoundness(type, tau, 7, epsilon, dir, ext);
%     plotterBoundness(type, tau, 8, epsilon, dir, ext);
%    
    close all;
   
    
     
 end