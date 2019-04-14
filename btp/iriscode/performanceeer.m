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
            hd = gethammingdistance(reshape(templates(matedid(jj,1),:),[20 512]),squeeze(masks(matedid(jj,1),:,:)),reshape(templates(matedid(jj,2),:),[20 512]),squeeze(masks(matedid(jj,2),:,:)), scales);
            gen=[gen hd];
        end
    end
end


nonmated=nchoosek(protocol_ids,2);

nonmated=nonmated(randperm(size(nonmated,1),2000),:);
for jj=1:length(nonmated)
    
    hd = gethammingdistance(reshape(templates(nonmated(jj,1),:),[20 512]), squeeze(masks(nonmated(jj,1),:,:)), ...
        reshape(templates(nonmated(jj,2),:),[20 512]),squeeze(masks(nonmated(jj,2),:,:)), scales);
    imposter=[imposter hd];
end

[EER_HASH_orig, mTSR, mFAR, mFRR, mGAR,threshold] =computeperformance(1-gen, 1-imposter, 0.001);  % isnightface 3.43 % 4.40 %

