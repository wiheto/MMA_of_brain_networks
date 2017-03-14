function hits = getpubmedcounts(SearchTerm)

% Create base URL for PubMed db site
searchURL = ['http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&rettype=count&term="' SearchTerm '"'];


medlineText = urlread(searchURL);
beginCounttag=regexp(medlineText,'<Count>');
endCounttag=regexp(medlineText,'</Count>');
hits=medlineText(beginCounttag+7:endCounttag-1);
hits=str2num(hits);


searchURL = ['http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&rettype=count&term=' SearchTerm ''];


medlineText = urlread(searchURL);
beginCounttag=regexp(medlineText,'<Count>');
endCounttag=regexp(medlineText,'</Count>');
hits2=medlineText(beginCounttag+7:endCounttag-1);

if hits==str2num(hits2)
   hits=0;  
end

pause(5)




