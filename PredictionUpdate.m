function [Sigma_pred, State_pred, P_pred, Z_sigma, Z_pred] = PredictionUpdate(Sigma_Points, Weights, F, H)

% Sigma_pred 
Sigma_pred = F*Sigma_Points;

% State_pred
State_pred = Sigma_pred*Weights;

% P_pred
nx = size(State_pred,1);
P_pred = zeros(nx, nx);
for i = 1:size(Weights)
    x_diff = Sigma_pred(:,i) - State_pred;
    P_pred = P_pred + Weights(i,1)*x_diff*transpose(x_diff);
end

% Z_sigma
Z_sigma = H*Sigma_pred;

% Z_pred
Z_pred = Z_sigma*Weights;


end