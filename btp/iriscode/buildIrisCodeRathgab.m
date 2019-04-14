clear all;


maindir = 'Codes_lg';
subdir  = dir( maindir );
cnt=1;
for i = 1 : length( subdir )
    if( isequal( subdir( i ).name, '.' )||...
            isequal( subdir( i ).name, '..')||...
            subdir( i ).isdir)               % ?????????
        continue;
    end
    subdirpath = fullfile( maindir, subdir( i ).name);
    
    cnt
    
  
    if( subdir( i ).name(9)=='L')
        
        labels(cnt) = str2num(subdir( i ).name(5:8));
        labels_LR(cnt) = subdir( i ).name(9)=='L';
        
        iriscode1= imread(subdirpath);
        iriscode=de2bi(iriscode1);
        dlmwrite(['iristemplate_lg/',subdir( i ).name(5:11),'.txt'],reshape(iriscode,[20,512]));

%         templates(cnt,:) = reshape(iriscode,[1, 8*1280]);
        cnt=cnt+1;
    end
    
end
% 
% save('Codes_lg_templates.mat','templates')
% save('Codes_lg_labels.mat','labels')
% save('Codes_lg_labels_LR.mat','labels_LR')
% % 


clear all;


maindir = 'Codes_qsw';
subdir  = dir( maindir );
cnt=1;
for i = 1 : length( subdir )
    if( isequal( subdir( i ).name, '.' )||...
            isequal( subdir( i ).name, '..')||...
            subdir( i ).isdir)               % ?????????
        continue;
    end
    subdirpath = fullfile( maindir, subdir( i ).name);
    
    cnt
    
  
    if( subdir( i ).name(10)=='L')
        
        labels(cnt) = str2num(subdir( i ).name(6:9));
        labels_LR(cnt) = subdir( i ).name(10)=='L';
        
        iriscode1= imread(subdirpath);
        iriscode=de2bi(iriscode1);
        dlmwrite(['iristemplate_qsw/',subdir( i ).name(6:12),'.txt'],reshape(iriscode,[20,512]));

%         templates(cnt,:) = reshape(iriscode,[1, 8*1280]);
        cnt=cnt+1;
    end
    
end
% 
% save('Codes_qsw_templates.mat','templates')
% save('Codes_qsw_labels.mat','labels')
% save('Codes_qsw_labels_LR.mat','labels_LR')
