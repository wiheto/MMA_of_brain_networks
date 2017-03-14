
%Little function to go from features_text to a cell
%Everything downloaded 1december 2015
tmplabs=importdata('features_text.txt')
tabs = regexp(tmplabs,'\t')

Terms{1}=tmplabs{1}(1:tabs{1}(1)-1)
if isempty(regexp(Terms{1},'network'))
    NetNamed(1)=0;
else 
    NetNamed(1)=1;
end
for n=2:length(tabs{1}) 
  Terms{n}=tmplabs{1}(tabs{1}(n-1)+1:tabs{1}(n)-1);
    if isempty(regexp(Terms{n},'network'))
        NetNamed(n)=0;
    else 
        NetNamed(n)=1;
    end
end
  

for n=1:length(Terms)
    n
    hitsPubMed(n) = getpubmedcounts([Terms{n} ' network']);
end
save(['./hits'],'hitsPubMed')
load(['./hits'])

[s o]=sort(hitsPubMed(1:end),'descend')
clear OrderedTerms

fid=find(s>0);
clear KeptTerms
for n=1:length(fid)
    OrderedTerms{n}=Terms{o(n)};
    if n<=length(fid)
        KeptTerms{n,1}=Terms{o(n)};
        KeptTerms{n,2}=s(n);
    end
end

% KeptTerms={OrderedTerms{fid}}
writetable(table(KeptTerms),'./terms2sort_all.csv')










