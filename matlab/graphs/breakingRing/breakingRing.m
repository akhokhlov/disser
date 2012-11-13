function breakingRing
    addpath('../../common');
    addpath('../../product_3');
    
    type = 2;
    tau = 0.1;
    number = 6;
    epsilon = 0.15;   
    
     plotterBoundness(type, tau, number, epsilon, 1);
     plotterBoundness(type, tau, number, epsilon, 0.5);
     plotterBoundness(type, tau, number, epsilon, 0.1);
     plotterBoundness(type, tau, number, epsilon, 0.01);
     plotterBoundness(type, tau, number, epsilon, 0.001);
     plotterBoundness(type, tau, number, epsilon, 0.0001);

     close all;
   
    
     
 end