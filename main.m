
%% Description One dimension test
% sensor: px
% state: px,py,vx,vy
% state_augment: px,py,vx,vy,0,0
% pv: process noisy
% pn: measurement noisy
% nx = 4
% nx_aug = 6
% nz = 2

%% Parameter

% measurement noisy
std_laspx = 0.02;
std_laspy = 0.02;

% process noisy
std_ax = 0.2;
std_ay = 0.2;

mplot = 0;

%% Init state and init P matrix

State = [px(1);
         py(1);
         0;
         0;];

P = [std_laspx*std_laspx 0 0 0;
     0 std_laspy*std_laspy 0 0;
     0 0 0.1 0;
     0 0 0 0.1;];

time_pre = 0; 

px_ukf = zeros(size(px));
py_ukf = zeros(size(py));

px_ukf(1) = px(1);
py_ukf(1) = py(1);

vx_ukf = zeros(size(px));
vy_ukf = zeros(size(py));

vx_ukf(1) = 0.0;
vy_ukf(1) = 0.0;

for i = 2:size(px)
    

%% Sigma Points and Weights
apha = 2;
process_noisy = [std_ax;std_ay];
[Sigma_Points, Weights] = calculateSigPntsandWeights(State, P, apha, process_noisy);

if mplot ==1
    w = waitforbuttonpress;    
    if w == 1
       plot(State(1,1), State(2,1),'b*');
       hold on;
    end
    w = waitforbuttonpress;
    if w == 1
       for j = 1:size(Sigma_Points,2)
           plot(Sigma_Points(1,j),Sigma_Points(2,j),'bo')
           hold on;
       end
    end
end
%% Prediction
dt = time(i)-time_pre;
time_pre = time(i);
F = [1 0 dt 0 0.5*dt*dt 0;
     0 1 0 dt 0 0.5*dt*dt;
     0 0 1 0 dt 0;
     0 0 0 1 0 dt;];   % nx*nx_aug
H= [1 0 0 0;
    0 1 0 0;];          % nz*nx
[Sigma_pred, State_pred, P_pred, Z_sigma, Z_pred] = PredictionUpdate(Sigma_Points, Weights, F, H);

if mplot ==1
    w = waitforbuttonpress;    
    if w == 1
       for j = 1:size(Sigma_pred,2)
           plot(Sigma_pred(1,j),Sigma_pred(2,j),'ro')
           hold on;
       end
    end
    w = waitforbuttonpress;    
    if w == 1   
       plot(State_pred(1,1), State_pred(2,1),'c*');
       hold on;
    end
end
%% Correction
Observation = [px(i);
               py(i);];
R = [std_laspx*std_laspx 0;
     0 std_laspy*std_laspy;];
[State, P] = MeasurementUpdate(Observation, R, Weights, Sigma_pred, State_pred, P_pred, Z_sigma, Z_pred);

px_ukf(i) = State(1);
py_ukf(i) = State(2);
vx_ukf(i) = State(3);
vy_ukf(i) = State(4);

if mplot ==1
    w = waitforbuttonpress;    
    if w == 1
       plot(Observation(1,1), Observation(2,1),'m*');
    end
end

end


subplot(1,2,1)
plot(px, py,'o');
hold on;
plot(gtpx, gtpy);
hold on;
plot(px_ukf, py_ukf,'k');
grid on;
legend('laser-data','ground-truth','ukf');


subplot(1,2,2)
plot(gtvx, gtvy,'o');
hold on;
plot(vx_ukf, vy_ukf,'*');
grid on;
legend('ground-truth','ukf');




