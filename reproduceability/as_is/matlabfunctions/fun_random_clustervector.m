function voxvec=fun_random_clustervector(cfg) 

        tmp=reshape(cfg.img,cfg.size(1),cfg.size(2),cfg.size(3)); 
        GetClusters=bwconncomp(tmp,26);
        clear tmp; 
        numVoxels = cellfun(@numel,GetClusters.PixelIdxList);  
        [~, ClOrder]=sort(numVoxels,'descend'); 
        voxvec = zeros(cfg.vecsize,1);
        %Place Clusters
        for n=1:length(ClOrder)
            assigned=0;
            attempt=0; 
            while assigned ==0 
                attempt=attempt+1; 
                if attempt==10000
                    error('Reset too much');  
                end
                clusterstart=randperm(cfg.vecsize-numVoxels(ClOrder(n)),1);
                voxvec_tmp=voxvec;
                voxvec_tmp(clusterstart:clusterstart+numVoxels(ClOrder(n)))=voxvec_tmp(clusterstart:clusterstart+numVoxels(ClOrder(n)))+1; 
                if max(voxvec_tmp)==1
                    voxvec=voxvec_tmp;
                    assigned=1; 
                end
            end
        end