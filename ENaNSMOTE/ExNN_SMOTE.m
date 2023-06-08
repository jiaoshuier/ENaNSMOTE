
function [ins_new,avg_NaN] = ExNN_SMOTE(train_instances,categorical)
% function numNaN = ExNN_SMOTE(train_instances,categorical)
% generate synthetic examples btw seed and its nature neighbors

% set(0,'defaultfigurecolor','w');
%------prepare for distance function------
labels = train_instances(:,end);
IR = sum(labels==0)/sum(labels==1);
pos_data = train_instances(labels==1,1:end-1);
AttVector = zeros(1,size(pos_data,2));
AttVector(categorical) = 1;
attribute = VDM(train_instances,AttVector);
numNaN = zeros(100,1);
%% SMOTE parameters
[ExNN,~] = ExNN_Search(pos_data); 
for i = 1:length(ExNN)
    if ~isempty(ExNN{i})
        numNaN(numel(ExNN{i})) = numNaN(numel(ExNN{i}))+1;
    end
end

negnum = sum(train_instances(:,end)==0);
N = negnum-size(pos_data,1); % number of new samples to generate

[data_new,avg_NaN] = SMOTE2(pos_data,N,ExNN,AttVector,attribute);
ins_new = [data_new ones(size(data_new,1),1)];
% curtrain_instances = [train_instances;ins_new];
