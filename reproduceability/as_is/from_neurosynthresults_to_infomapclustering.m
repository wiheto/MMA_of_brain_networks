
% On path requires niftitools - https://se.mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image?requestedDomain=www.mathworks.com
% (Compiled) heirarchical directed infomap - mapequation.org 
% Cbrewer - https://se.mathworks.com/matlabcentral/fileexchange/34087-cbrewer---colorbrewer-schemes-for-matlab
% SPM - http://www.fil.ion.ucl.ac.uk/spm/
% Brain connectivity toolbox - https://sites.google.com/site/bctnet/
% Also requires a matlab version with the table function (2013+)

% Requires imaging processing toolbox

% Also assumes parrallel toolbox is accessible. If not, swtich parfor to
% for and delete all parpool lines 

% Also requires the neurosynth data from MMA to be on your path. 


%% Define main and working directoryies 

mdir = '/main/working/directory';
sdir = '/where/results/are/saved';
datdir = '/where/neurosynth/data/is/found/';
cd(mdir)

% Load in feature list. 

term_list_file = 'networklist.txt'; 
list=importdata(term_list_file);

% Get input directory

d = dir(datdir);


%% Create a nifti file where 1 if it is active in any of the network terms

clear netmap X
for n=1:length(list)
    tmp=load_nii([mdir datdir num2str(n-1) '_depon_' num2str(n-1) '_pFgA_z_FDR_0.01.nii.gz']);
       X(:,:,:,n)=tmp.img;
end

vox=tmp; 
vox.img=sum(X,4);
vox.img(vox.img>0)=1;
vox.img(vox.img<0)=0;
save_nii(vox,[sdir '/voxspace_148.nii'])


%% check that all the neurosynth data files correspond with loaded termlist 
%% And get the corresponding element in d that matches to list

for n=1:length(d)
    tmp=strcmp(list,d(n).name)
    if sum(tmp)>1
        error('too many files')
    elseif sum(tmp)==1
        Match(tmp==1)=n; 
    end
end

%% Calculate the conditional overlap and permutation test at once. 

tmp=load_nii([sdir '/voxspace_148.nii']);
voxspace=tmp.img;
clear tmp

parpool(20)
clear Overlap_ij tmpimg1 tmpimg2 voxcon1 voxcon2

% Note start point at 0 and j+1 in below code are due to python indexes

% Note while preparing to make available: the random seed was not defined. 

for i=0:length(list)-1
    i
    Overlaptmp={};
    parfor j=0:length(list)-1
        
        % Load meta analysis info
        tmpimg1=load_nii([mdir datdir num2str(i) '_depon_' num2str(j) '_pFgA_z_FDR_0.01.nii.gz']);
        tmpimg2=load_nii([mdir datdir num2str(j) '_depon_' num2str(i) '_pFgA_z_FDR_0.01.nii.gz']);
        
        % Reshape to vectors and convert to binary (only positive activations considered)
        voxcon1 = reshape(tmpimg1.img,91*109*91,1); 
        voxcon1(voxcon1<0 | isnan(voxcon1)==1)=0; voxcon1(voxcon1>0)=1;
        voxcon2 = reshape(tmpimg2.img,91*109*91,1); 
        voxcon2(voxcon2<0 | isnan(voxcon2)==1)=0; voxcon2(voxcon2>0)=1;

        % Calculate overlap of i given j
        tmp=voxcon1+voxcon2; 
        Otmp=length(find(tmp==2));
        num_j=sum(voxcon2); 
        Overlaptmp{j+1}=Otmp./num_j;
        % Do 1000 times with randomizing the cluster positions through
        % voxspace
        if j~=i       
            Overlaptmp_perm{j+1}=zeros(1000,1); 
            for p=1:1000
                cfg=[];
                cfg.vecsize=sum(sum(sum(voxspace))); 
                cfg.size=[91 109 91]; 
                cfg.img=voxcon1; 
                randvec_i=fun_random_clustervector(cfg); 
                cfg.img=voxcon2; 
                randvec_j=fun_random_clustervector(cfg); 

                tmp=randvec_i+randvec_j; 
                Otmp=sum(tmp==2);
                Overlaptmp_perm{j+1}(p)=Otmp./num_j;
            end
        end
       
    end
    for jj=0:length(list)-1
        Overlap_ij(i+1,jj+1)=(Overlaptmp{jj+1});
        if i~= jj
            permtest{i+1}(:,jj+1)=Overlaptmp_perm{jj+1};
        end
    end
end

% Save informaation 
save([sdir 'permtest_070416'],'permtest')
save([sdir 'Overlap_ij_070416'],'Overlap_ij')
figure; 
imagesc(Overlap_ij)
caxis([0 0.25])
colorbar


%% Threshold the previous results at 0.05


load([mdir 'permtest_070416']);
load([mdir 'Overlap_ij_070416'])

% Fix permtest all cells of equal length and it doesn't error out below
permtest{end}(:,end+1)=0;

% Get threshold for each edge. Not controlling for multiple comparisions
% here. Aim here is mainly to make the Overlap_ij sparser, and adding too many spurious edges is determinental for later inferences. 
% See article for more details. 
clear th thOverlap_ij_rejects
for n=1:size(Overlap_ij,1)
    tmp=sort(permtest{n},1);
    th(n,:)=tmp(950,:);
end

thOverlap_ij=Overlap_ij; 
for i=1:size(Overlap_ij,1)
    for j=1:size(Overlap_ij,2)
        if thOverlap_ij(i,j)<th(i,j)
            thOverlap_ij(i,j)=0;
            thOverlap_ij_rejects(i,j)=Overlap_ij(i,j); 
        end
    end
    thOverlap_ij(i,i)=NaN;
end

%turn any NaNs to 0s
thOverlap_ij(isnan(thOverlap_ij)==1)=0; 


%% Run infomap 

C=infomap_dir(thOverlap_ij);
% Code length 6.33157 in 22 modules.
save([mdir 'C_070416'],'C') 
Cheir=infoheirmap_dir(thOverlap_ij);
save([mdir 'Cheir_070416'],'Cheir') 

% Output from function: 
% Best codelength = 3.20501 bits.
% Compression: 62.9301 percent.
% Number of modules: 55
% Number of large modules (> 1 percent of total number of nodes): 44
% Average depth: 3.42568
% Average size: 5.09459
% Gain over two-level code: 7.40877 percent.
% Elapsed time is 278.065910 seconds.
