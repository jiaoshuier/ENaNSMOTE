
function [sample,avg_NaN]=SMOTE2(pos_data,num_new,NaN,AttVector,attribute)
% generate synthetic examples btw seed and its nature neighbors

num_pos = size(pos_data,1);
if(num_pos == 0)
    error('check T.')
elseif(num_pos == 1)%duplicate
    sample = repmat(pos_data,1,num_new);
end

    num_att = size(pos_data,2);
    n = floor(num_new/num_pos);
    remainder = num_new-num_pos*n;
    id = randperm(num_pos);   
    No = ones(1,num_pos)*n;
    No(id(1:remainder)) = No(id(1:remainder))+1;
    
%     generation
    sample = [];
num_NaN = [];
    a = std(pos_data,0,1); % the standard deviation of each attribute
    for i = find(No~=0)        
    %--------------- Natural neighbor
        k = length(NaN{i});
num_NaN = [num_NaN k];
        if k==0
            continue;
        end
        min_id = NaN{i};
   %----------------kNN----     
%         d = [];
%         for j = find(AttVector==0)
%             d = [d (repmat(pos_data(i,j),num_pos,1)-pos_data(:,j))/(4*a(j))];
%         end
%         
%         for j = find(AttVector==1)
%             id1 = Locate(attribute(j).values,pos_data(i,j));
%             id2 = Locate(attribute(j).values,pos_data(:,j));
%             d = [d attribute(j).VDM(id2,id1)];
%         end
%         d = sum(d.^2,2);   
%         d = sqrt(d);
%         d(i) = Inf;
%         if(k < log2(num_pos))
%             min_id = [];
%             for j = 1:k
%                 [~,id] = min(d);
%                 d(id) = Inf;
%                 min_id=[min_id id];% sort>=O(n*logn),so we take min: O(n).total time:O(k*n)
%             end
%         else
%             [tmp,id] = sort(d);
%             min_id = id(1:k);
%         end
        
        rn = floor(rand(1,No(i))*k)+1;
        if max(rn)>k
            flag = 1;
        end
        id = min_id(rn); % the id of pos_data to generate new sample
        weight = rand(No(i),num_att);
        D = repmat(pos_data(i,:),No(i),1);
        % for linear attribute
        aid = find(AttVector==0);
        if ~isempty(aid)
            D(:,aid) = D(:,aid)+weight(:,aid).*(pos_data(id,aid)-D(:,aid));
        end
        % for nominal attribute the new instances take the most frequent
        % value in the union of the seed and corresponding k-NN
        aid = find(AttVector==1);
        if ~isempty(aid)
            for i_aid = 1:length(aid)
                count = zeros(1,length(attribute(aid(i_aid)).values));
                for i_v = 1:length(attribute(aid(i_aid)).values)
                    count(i_v) = length(find([pos_data(id,aid(i_aid));...
                        D(1,aid(i_aid))]==attribute(aid(i_aid)).values(i_v)));
                end
                [tmp,most_id] = max(count);
                most_nominal(i_aid) = attribute(aid(i_aid)).values(most_id);
            end
            D(:,aid)=repmat(most_nominal,No(i),1);
        end
        sample = [sample;D];
    end
   avg_NaN = mean(num_NaN(num_NaN~=0));


% function loc = Locate(V,value)
% %locate a value in value set V
% % Usage:
% %  loc=Locate(V,value)
% %
% %  loc: location of value in the vector V.
% %         If value is not in V return -1. 
% %  V: value set
% %  value: the value to locate,it can be a vector
% 
% % check if values in V are unique
% if(length(unique(V))~=length(V))
%     error('values in the set is not unique')
% end
%     
% v = unique(value);
% Nv = length(v);
% 
% for i = 1:Nv
%     id = find(value==v(i));
%     l = find(V==v(i));
%     if(isempty(l))
%         loc(id)=-1;
%     else
%         loc(id)=l;
%     end
% end