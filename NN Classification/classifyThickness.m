%% NN Classification of thickness with Helmholtz Simulation Data
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

%%

load ../Datasets/twoLayerSeabed_N=8000.mat

%%

[x,t] =selectData(signal, parameters, 'all', 'thickness');
net = patternnet(3);
net = train(net,x,t); %view(net)
y = net(x); classes = vec2ind(y);
figure; plotconfusion(t,y);title(sprintf('(2 Layer N=8000) Confusion: target=thickness',j))
figure; plotroc(t,y);title(sprintf('(2 Layer N=8000) ROC: all obs target=thickness',j))



%% Perform NN pattern recognition with thickness classes, fixed material
for j=1:4
[x,t] =selectData(signal, parameters, sprintf('mat%d',j), 'thickness');
net = patternnet(3);
net = train(net,x,t); %view(net)
y = net(x); classes = vec2ind(y);
figure;
plotconfusion(t,y);
title(sprintf('(2 Layer N=2000) Confusion: mat%d target=thickness',j))
figure;
plotroc(t,y);
title(sprintf('(2 Layer N=2000) ROC: mat%d target=thickness',j))
end



%% Other approaches: clustering

% Extract the mean and standard deviation of each observation
obs=signal;
[l w] = size(obs);
obs2=zeros(l,2);
for j=1:length(obs);
    obs2(j,1)=mean(obs(j,:));
    obs2(j,2)=std(obs(j,:));   
end

%plot the different thickness classes
figure; hold all;
colormap winter;
thc_list=unique(parameters(:,4));
for j=1:4 
ind=find(parameters(:, 4) == thc_list(j));
h=scatter(obs2(ind,1),obs2(ind,2),'.'); 
end
xlabel('mean'); ylabel('stddev');
legend('thc = .25','thc = .5','thc = .75','thc = 1');
title('True thickness classes')


