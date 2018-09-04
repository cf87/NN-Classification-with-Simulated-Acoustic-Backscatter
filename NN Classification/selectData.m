function [x, t, class_str] =selectData(signal, parameters, obs_type, target_type)
otype=obs_type(1:3);
class_str={};
switch otype
    case 'all'
        obs = signal;
        [l ~] = size(obs);
        obs_ind=1:l;
    case 'mat'
        mat_list=unique(parameters(:,7:8), 'rows');
        obs_ind= find(max(bsxfun(@minus, parameters(:, 7:8), mat_list(str2double(obs_type(4)),:) ), [], 2)==0);
        obs = signal(obs_ind,:);
   case 'thc'
        thc_list=unique(parameters(:,4));
        obs_ind= find(parameters(:, 4) == thc_list(str2double(obs_type(4) ) ));
        obs = signal(obs_ind,:);
 
end

[l ~] = size(obs);

switch target_type
    case 'material'
        mat_list=unique(parameters(:,7:8), 'rows');
        target = zeros(l, length(mat_list));
        for j=1:length(mat_list)
            mat_ind= find(max(bsxfun(@minus, parameters(obs_ind, 7:8), mat_list(j,:) ), [], 2)==0);
            target(mat_ind,j) = 1;
        end
        class_str{1} = 'Class 1: clay';
        class_str{2} = 'Class 2: silt';
        class_str{3} = 'Class 3: sand';
        class_str{4} = 'Class 4: gravel';
    
        
    case 'thickness'
        t_list=unique(parameters(obs_ind,4));
        target = zeros(l, length(t_list));
        for j=1:length(t_list)
            target(:,j) = parameters(obs_ind, 4) == t_list(j);
             class_str{j} = sprintf('Class %d: thc=%f', j, t_list(j));
        end
        class_str{1} = 'Class 1: \tau=.25';
        class_str{2} = 'Class 2: \tau=.5';
        class_str{3} = 'Class 3: \tau=.75';
        class_str{4} = 'Class 4: \tau=1';
        
    case 'both'
        target=repmat(eye(16), [l/16,1]);
        
end

x=obs'; t=target';
end
