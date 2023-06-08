function  [ExNN,r] = ExNN_Search(pos_data)

data = pos_data;
%% Search RNN  By  NaN_search
%% initialize paramters
n=size(data,1);
r=1;
ExNN=cell(n,1);
RN=zeros(n,1);
KNN_idx= cell(1,n);
RKNN_idx = cell(1,n);
nb = zeros(1,n);
cnt = [];
%%
Dist=pdist2(data,data);
index=cell(n,1);
for i=1:n
    [~,index{i}]=sort(Dist(i,:),'ascend');
end
%%

while r<n
    for i=1:n
        tempidx=index{i};
        try
            KNN_idx{i} = [KNN_idx{i} tempidx(r+1)];
        catch ME
            disp ME£»
        end
        try
            RKNN_idx{tempidx(r+1)} = [RKNN_idx{tempidx(r+1)} i];
        catch ME
            disp(ME)
        end
        nb(tempidx(r+1)) =nb(tempidx(r+1))+1;
    end
    
    pos=[];
    for i=1:n
        if nb(i)~=0
            pos=[pos;i];
        end
    end
    RN(pos)=1;
    
    cnt(r)=length(find(RN==0));
    if r>1 && cnt(r)==cnt(r-1)
        r=r-1;
        %         nb(pos) = nb(pos)-1;
        break;
    end
    r=r+1;
end
for i=1:n
    ExNN{i,1} = unique(union(KNN_idx{i},RKNN_idx{i}));
end

% end