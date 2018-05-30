function [State, P] = MeasurementUpdate(Observation, R, Weights, Sigma_pred, State_pred, P_pred, Z_sigma, Z_pred)

% 
nx = size(State_pred,1);
nz = size(Z_pred,1);

% S
S = zeros(nz, nz);
for i = 1:size(Weights)
    z_diff = Z_sigma(:,i) - Z_pred;
    S = S + Weights(i,1)*z_diff*transpose(z_diff);
end
S = S+R;

% Tc
TC = zeros(nx, nz);
for i = 1:size(Weights)
    z_diff = Z_sigma(:,i) - Z_pred;
    x_diff = Sigma_pred(:,i) - State_pred;
    TC = TC + Weights(i,1)*x_diff*transpose(z_diff);
end

% K
K = TC*inv(S);

% residue
residue = Observation - Z_pred;
State = State_pred + K*residue;
P = P_pred - K*S*transpose(K);

end 