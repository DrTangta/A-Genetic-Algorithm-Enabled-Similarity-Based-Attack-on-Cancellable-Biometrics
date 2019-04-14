addpath('matlab_tools');

maindir = 'CASIA-IrisV4\CASIA-Iris-Interval';
subdir  = dir( maindir );
cnt=1;
for i = 1 : length( subdir )
    if( isequal( subdir( i ).name, '.' )||...
            isequal( subdir( i ).name, '..')||...
            ~subdir( i ).isdir)               % ?????????
        continue;
    end
    subdirpath = fullfile( maindir, subdir( i ).name,'/L/' , '*.jpg');
    dat = dir( subdirpath ) ;              % ?????????dat???
    
    for j = 1 : length( dat )
        if( isequal( dat( j ).name, '.' )||...
                isequal( dat( j ).name, '..')||...
                dat( j ).isdir)               % ?????????
            continue;
        end
        cnt
        
        
        namelabels(cnt,:)= dat( j ).name(2:8);
        
        cnt=cnt+1;
        
        % ????????????? %
    end
end
%
uniqulabels=unique(labels);
indexs=[];
for i=1:length(uniqulabels)
    [value, inde]=find(labels==uniqulabels(i));
    indexs=[indexs inde(1)];
end

M = containers.Map({1},{[]});
for i=1:length(labels)
    if isKey(M,labels(i))
        M(labels(i)) =[ M(labels(i)) i];
    else
        M(labels(i)) = [i];
    end
end
remove(M,1);

%% three group
scales=1;
allids=M.keys;
attack_ids=[];
attack_label_x=[];
protocol_ids=[];
imposter=[];gen=[];
for nameidx=1:length(allids)
    thisuseremplate=M(allids{nameidx});
    cnt=length(thisuseremplate);
    if cnt>4
        matedid=nchoosek(thisuseremplate,2);
        protocol_ids=[protocol_ids thisuseremplate(1)];
        for jj=1:length(matedid)
          A=  templates(matedid(jj,1),:);
           B= templates(matedid(jj,2),:);
           
            gen=[gen pdist2(A,B,'Hamming')];
        end
    end
end
mean(gen)