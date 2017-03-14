% InfoMap method from (Roswall and Bergstrom, 2008)
%
%Input
%   - adj: adjacency matrix
%
% Output
%   - com: communities (listed for each node)
%
% Author: Erwan Le Martelot
% Date: 16/06/11

% Edited for heirarchy algorithm: WHT (2016)

function [com] = infoheirmap_dir(adj)

    % Set the path and command line name
    dir_path = '/data/william/toolbox/infohiermap_dir/';
    command = 'infohiermap';

    command = [dir_path,command];
    command = [command,' ',num2str(randi(2016)),' adj.net',' 1000'];

    % Get edges list and output to file
    adj2pajek(adj,'adj','.');
 
    % Call community detection algorithm
    tic;
    system(command);
    toc;
    
    a=fileread('adj.tree');
    
    b=regexp(a,'bits');
    a(1:b+5)=[];
    
    %Get nodes
    b=regexp(a,'"');
    clear com; nid=0; 
    for n=1:2:length(b)
        nid=nid+1;
        com(nid,1)=str2num(a(b(n)+2:b(n+1)-1));
    end
    
    b=regexp(a,':');
    nl=regexp(a,'\n');
    endass=regexp(a,' ');
    for n=1:length(nl) 
         if n~=1
            ind=b(b>nl(n-1) & b<nl(n));
            lastind=endass(endass>nl(n-1) & endass<nl(n));

         else 
             ind=b(b<nl(n));
             lastind=endass(endass<nl(n));

         end
            clear ind2
            for m=1:length(ind)+1
                if m==1 && n~=1
                    ind2(m,:)=[nl(n-1)+1 ind(1)-1];
                elseif m==1 && n==1
                    ind2(m,:)=[1 ind(1)-1];
                elseif m==length(ind)+1
                    ind2(m,:)=[ind(m-1)+1 lastind(1)-1];
                else
                    ind2(m,:)=[ind(m-1)+1 ind(m)-1]; 
                end
            end     
%         else
%             ind=b(b<nl(n))
%             ind2=[1 ind-1 ind(end)+1];
%         end   
        for m=1:size(ind2,1)
            com(n,m+2)=str2num(a(ind2(m,1):ind2(m,2)));
        end
    end
    
    
    for n=1:length(nl)
         if n~=1
            lastind=endass(endass>nl(n-1) & endass<nl(n));
            com(n,2)=str2num(a(lastind(1)+1:lastind(2)-1));
         else 
            lastind=endass(endass<nl(n))
            com(n,2)=str2num(a(lastind(1)+1:lastind(2)-1));
         end
    end
  
    
    
end
