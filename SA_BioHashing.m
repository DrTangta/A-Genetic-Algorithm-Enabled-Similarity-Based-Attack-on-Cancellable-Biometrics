clear all;
close all;
load('data\lfw\LFW_10Samples_insightface.mat')
load('data\lfw\LFW_label_10Samples_insightface.mat')

addpath('matlab_tools');
addpath_recurse("btp")


hamming_dimension=500;
opts.dX=size(LFW_10Samples_insightface,2);
opts.model =biohashingKey(hamming_dimension,size(LFW_10Samples_insightface,2));
labels=ceil(0.1:0.1:158);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% sys_1 encrypt 

[transformed_data_sys1] = biohashing(LFW_10Samples_insightface,opts.model);
scores = 1- pdist2(transformed_data_sys1,transformed_data_sys1,'Hamming');
hamming_gen_score = scores(labels'==labels);
hamming_gen_score = hamming_gen_score(find(hamming_gen_score~=1));
hamming_imp_score = scores(labels'~=labels);
[EER_HASH_orig, mTSR, mFAR, mFRR, mGAR,threshold] =computeperformance(hamming_gen_score, hamming_imp_score, 0.001);  % isnightface 3.43 % 4.40 %
[FAR_orig,FRR_orig] = FARatThreshold(hamming_gen_score,hamming_imp_score,threshold);
reconstruct_x=zeros(158,512);
%% reconstruct the first one sample
i=1;
disp(['reconstructing ',num2str(i)])
to_retrieve_hash=transformed_data_sys1((i-1)*10+1,:); % first of the template are used to reconstruct
%rng default % For reproducibility
f_fitness = @(x)fitness_biohashing(x,to_retrieve_hash,opts); % fitness function
f_constr = []; % constrain function
reconstruct_x(i,:) = reconstruct_plot(f_fitness,f_constr,opts);

% a new sys, sys_2
opts.model =biohashingKey(hamming_dimension,size(LFW_10Samples_insightface,2));
[transformed_data_sys2] = biohashing(LFW_10Samples_insightface,opts.model);

[attacker_transformed_data] = biohashing(reconstruct_x(1,:),opts.model);

approxmate_scores = 1- pdist2(attacker_transformed_data,transformed_data_sys2(1:10,:),'Hamming');
[FAR_attack,FRR_attack] = FARatThreshold(hamming_gen_score,approxmate_scores,threshold);

disp(['Gen score mean: ',num2str(mean(hamming_gen_score))])
disp(['Score@ET: ',num2str(threshold)])
disp(['Mated-Imposter-score: ',num2str(approxmate_scores)])
disp(['FAR@ET: ',num2str(FAR_attack)])

