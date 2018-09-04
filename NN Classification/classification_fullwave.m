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
%% Data set 1 (full wave solution, two layers, 100 interface realizations,  4 materials)


fullwave=load('twoLayerSeabed_fullwave_N=8000');

%%
[ind,~] = find((fullwave.parameters(:,8)>0)); % choose the data corresponding to the first 100 realizations
parameters=fullwave.parameters(ind,:); signal=fullwave.signal(ind,:);



%% classify material
[x,t, class_str] =selectData(signal, parameters, 'all', 'material');
net = patternnet(10); net = train(net,x,t); %view(net) 
y = net(x); classes = vec2ind(y);
figure; plotconfusion(t,y);title(sprintf('(2 Layer N=8000, full wave) Confusion: Target=material',j))
figure;plotroc(t,y);title(sprintf('(2 Layer N=8000, full wave) ROC: all obs target=material',j))
h=get(gca,'legend'); set(h, 'String', class_str)

%% classify thickness
[x,t] =selectData(signal, parameters, 'all', 'thickness');
net = patternnet(10);
net = train(net,x,t); %view(net)
y = net(x); classes = vec2ind(y);
figure; plotconfusion(t,y);title(sprintf('(2 Layer N=8000, full wave) Confusion: target=thickness',j))
figure; plotroc(t,y);title(sprintf('(2 Layer N=8000, full wave) ROC: all obs target=thickness',j))



%% Perform NN pattern recognition with material classes, fixed thickness

for j=1:4
[x,t, class_str] =selectData(signal, parameters, sprintf('thc%d',j), 'material');
net = patternnet(6);
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
for j=1:l;
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



% plot the different thickness classes
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
