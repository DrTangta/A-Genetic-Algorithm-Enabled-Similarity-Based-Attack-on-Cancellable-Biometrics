addpath('Segmentation');
addpath('Normal_encoding');
addpath('Matching');



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
        datpath = fullfile( maindir, subdir( i ).name,'/L/', dat( j ).name);
        labels(cnt) =str2num(dat( j ).name(2:5)); %
        [template, mask]=createiristemplate(datpath);
        
        %   dlmwrite(['iristemplate/',dat( j ).name(2:8),'.txt'],template)
        
        templates(cnt,:) = reshape(template,[1, 20*512]);
        masks(cnt,:,:) = mask;
        cnt=cnt+1;
        
    end
end

save('templates.mat','templates')
save('masks.mat','masks')
save('labels.mat','labels')

