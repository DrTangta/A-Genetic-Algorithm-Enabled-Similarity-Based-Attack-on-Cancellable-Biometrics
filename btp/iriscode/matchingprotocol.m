load('labels.mat')


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
allids=M.keys;
attack_ids=[];
attack_label_x=[];
protocol_ids=[];
matedid=nchoosek(1:5,2);
fid = fopen('mated.txt','at');

for nameidx=1:length(allids)
    thisuseremplate=M(allids{nameidx});
    cnt=length(thisuseremplate);
    if cnt>4
        protocol_ids=[protocol_ids allids{nameidx}];
        for jj=1:length(matedid)
            fprintf(fid, '%d %d %d\n',[allids{nameidx} matedid(jj,1) matedid(jj,2)]);
        end
    end
end

fclose(fid);
fid = fopen('nonmated.txt','at');

nonmated=nchoosek(protocol_ids,2);

nonmated=nonmated(randperm(size(nonmated,1),2000),:);
for jj=1:length(nonmated)
    fprintf(fid, '%d %d\n',[ nonmated(jj,1) nonmated(jj,2)]);
end
fclose(fid);



