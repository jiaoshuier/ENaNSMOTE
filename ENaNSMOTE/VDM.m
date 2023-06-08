function    attribute = VDM(train_instances,AttVector)

% Usage:
%  attribute=VDM(data,label,ClassType,AttVector)
%
%   data :instance matrix 
%   label: class labels for data
%   ClassType: class type
%   AttVector: attribute vector,1 presents for the corresponding attribute
%                    is nominal and 0 for numeric.
%   attribute: attribute structure vector. Each element has 3 fields
%                  FIELD kind - 'nominal' or 'numeric'
%                  FIELD values - values on the nominal attribute or [] for numeric attribute 
%                  FIELD VDM: pairwise VDM distance of values on nominal attribute or
%                                    [] otherwise
data = train_instances(:,1:end-1);
label = train_instances(:,end);
class = unique(label);
nc = length(class);
num_att = length(AttVector);

for i = 1:num_att
    if AttVector(i)==0
        attribute(i).values = [];
        attribute(i).VDM = [];
    else
        attribute(i).values = unique(data(:,i));
        n = length(attribute(i).values);
        num_unique = zeros(1,n);
        for k = 1:n
            num_unique(k) = length(find(abs(data(:,i)-attribute(i).values(k))<1e-6));
        end
        
        attribute(i).VDM = zeros(n);
        for ui = 1:n
            for vi = ui+1:n
                if vi~=ui
                    u = attribute(i).values(ui);
                    v = attribute(i).values(vi);
                    Nu = num_unique(ui);
                    Nv = num_unique(vi);
                    d = 0;
                    for j = 1:nc
                        Nuc = length(intersect(find(data(:,i)==u),find(label==class(j))));
                        Nvc = length(intersect(find(data(:,i)==v),find(label==class(j))));
                        d = d+(Nuc/Nu-Nvc/Nv)^2;
                    end
                    d = sqrt(d);
                    attribute(i).VDM(ui,vi) = d;
                    attribute(i).VDM(vi,ui) = d;                   
                end
            end
        end
    end
end