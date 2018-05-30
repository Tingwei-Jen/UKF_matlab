function [Sigma_Points, Weights] = calculateSigPntsandWeights(State, P, apha, process_noisy)

%% State Aug, P matrix Aug
nx = size(State,1);
nx_aug = nx+size(process_noisy,1);

State_aug = [State;0;0;];
P_aug = zeros(nx_aug, nx_aug);
P_aug(1:nx,1:nx) = P;
P_aug(5,5) = process_noisy(1,1)*process_noisy(1,1);
P_aug(6,6) = process_noisy(2,1)*process_noisy(2,1);

%% lambda
lambda = apha*apha*nx_aug-nx_aug;

%% Sigma points
Sigma_Points = zeros(nx_aug, 2*nx_aug+1);
Sigma_Points(:,1) = State_aug;

for i = 1:nx_aug
    a = (lambda+nx_aug)*P_aug(:,i);
    Sigma_Points(:,i+1) = State_aug + sqrt(a);
    Sigma_Points(:,i+1+nx_aug) = State_aug -sqrt(a);

end

%% Weights
Weights = zeros(2*nx_aug+1,1);
for i = 1:2*nx_aug+1
    if i==1
       Weights(i,1) = lambda / (lambda+nx_aug);
    else
       Weights(i,1) = 0.5 / (lambda+nx_aug);
    end    
end


end 