%% NN Classification of material type with Helmholtz Simulation Data
% This script runs the MATLAB Neural Net Pattern Classification tool using
% acoustic simulations of various seafloors. The parameters describing the
% seafloors include the sound speed, density and layer thickness.
%
% parameterNames :  list of strings describing the columns of the "parameter" variable
% parameters     :  matrix where the rows correspond to the observation number and the 
%                    columns are entries corresponding to the parameterName
% signal         :  each row is a new observation of observation data taken
%                   on a spatial domain sampled at 1024 points
%

addpath ../Datasets
%% Data set 1 (one layer, 100 interface realizations,  4 materials)


load('oneLayerSeabed_N=400');


[x,t, class_str] =selectData(signal, parameters, 'all', 'material');
net = patternnet(3); net = train(net,x,t); %view(net) 
y = net(x); classes = vec2ind(y);
figure; plotconfusion(t,y);title(sprintf('(1 Layer N=400) Confusion: Target=material',j))
figure;plotroc(t,y);title(sprintf('(1 Layer N=400) ROC: all obs target=material',j))
h=get(gca,'legend'); set(h, 'String', class_str)



%% Data set 2 (two layers, 100 interface realizations, 1 thickness, 4 materials)
% The material type in the top layer is varying and the fixed parameters are thickness=1m and
% bottom material Basalt with parameters [c = 5250 rho = 2700] 

load('twoLayerSeabed_N=8000');

[ind,~] = find((parameters(:,1)<=100).*(parameters(:,4)==.25)); % choose the data corresponding to the first 100 realizations
parameters=parameters(ind,:); signal=signal(ind,:);

[x,t, class_str] =selectData(signal, parameters, 'all', 'material');
net = patternnet(3); net = train(net,x,t); %view(net) 
y = net(x); classes = vec2ind(y);
figure; plotconfusion(t,y);title(sprintf('(2 Layer N=400) Confusion: Target=material',j))
figure;plotroc(t,y);title(sprintf('(2 Layer N=400) ROC: all obs target=material',j))
h=get(gca,'legend'); set(h, 'String', class_str)
clear;

%% Data set 3 (two layers, 500 interface realizations, 4 thickness, 4 materials )
% There is a two-layer seafloor. The thickness and material type in the top layer is
% varying and the bottom material Basalt has fixed parameters [c = 5250 rho = 2700] 

load twoLayerSeabed_N=8000.mat


[x,t, class_str] =selectData(signal, parameters, 'all', 'material');
net = patternnet(3); net = train(net,x,t); %view(net) 
y = net(x); classes = vec2ind(y);
figure; plotconfusion(t,y);title(sprintf('(2 Layer N=8000) Confusion: target=material',j))
text(0,6, class_str)

figure;plotroc(t,y);title(sprintf('(2 Layer N=8000) ROC: target=material',j))
h=get(gca,'legend'); set(h, 'String', class_str)
clear;


%% Perform NN pattern recognition with material classes, fixed thickness
load twoLayerSeabed_N=8000.mat

for j=1:4
[x,t, class_str] =selectData(signal, parameters, sprintf('thc%d',j), 'material');
net = patternnet(3);
net = train(net,x,t); %view(net)
y = net(x); classes = vec2ind(y);
figure;
plotconfusion(t,y);
title(sprintf('Confusion: mat%d target=thickness',j))
figure;
plotroc(t,y);
title(sprintf('ROC: mat%d target=thickness',j))
h=get(gca,'legend'); set(h, 'String', class_str)

end


%% Other approaches: clustering

% Extract the mean and standard deviation of each observation
obs=signal;
[l w] = size(obs);
obs2=zeros(l,2);
for j=1:l
    obs2(j,1)=mean(obs(j,:));
    obs2(j,2)=std(obs(j,:));   
end

% plot the different material classes
figure; hold all;
for j=1:4 
ind=j:4:l;
h=scatter(obs2(ind,1),obs2(ind,2)); 
end
xlabel('mean'); ylabel('stddev');
legend('Clay: (c = 1500, rho = 1500)','Silt: (c = 1575, rho = 1700)','Sand: (c = 1650, rho = 1900)','Gravel: (c = 1800, rho = 2000)');
title('True material classes')



%% K means clustering
rng(1);
idx=kmeans(obs2,4);
%
figure;
hold all;
for j= [1 3 2 4 ]
    ind=idx==j;
    scatter(obs2(ind,1),obs2(ind,2),'x');
end
title('k-means classes')
legend('Clay: (c = 1500, rho = 1500)','Silt: (c = 1575, rho = 1700)','Sand: (c = 1650, rho = 1900)','Gravel: (c = 1800, rho = 2000)');

xlabel('mean'); ylabel('stddev');

% k means clustering error

true_ind = repmat(1:4, 1, length(obs2)/4)';
figure;
hold all;
ind_k = [1 3 2 4 ];
err1=0*obs2;

for j=1:4
    ind = j:4:length(obs2);
    for k=1:length(ind)
   if idx(ind(k)) ~= ind_k(j)
        err1(ind(k),:) = obs2(ind(k),:);
   end
    end
    scatter(err1(ind,1), err1(ind,2));
end
  
    

title('error k-means classes')
xlabel('mean'); ylabel('stddev');
legend('Clay: (c = 1500, rho = 1500)','Silt: (c = 1575, rho = 1700)','Sand: (c = 1650, rho = 1900)','Gravel: (c = 1800, rho = 2000)');



