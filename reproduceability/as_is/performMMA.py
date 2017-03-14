
# <markdown cell>

# This script calls neurosynth and does a meta analysis of each conditional set of indexes already derived

# <markdown cell>

# First import neurosynth, numpy, pandas and re

# <code cell>

import neurosynth
from neurosynth.base.dataset import Dataset
from neurosynth.analysis import meta, decode
import numpy as np
import re
import pandas as pd

# <markdown cell>

# Set the working directoryies.

# Also set the path for the jounralIDs for each seachterm that is going to be performed

# Finally load neurosynth dataset

# <code cell>


#Specify where data lives
mdir = '/home/william/work/FNAtlas/'
#Load data
data=pd.read_json(mdir + 'journalIds.json')
data.sort_index(inplace=True)
#Load neurosynth data
dataset = Dataset.load('dataset.pkl')

# <markdown cell>

# Loop through the n x n times and find unique indexes perform meta analysis comparision through neuroscynth

# <code cell>

#Preallocate
numArticles=np.zeros([len(data),len(data)])
for i in range(0,len(data)):
    print('Computing for term ' + str(i))
    for j in range(0,len(data)):
        if i == j:
            conditionalIDMatrix =  data.journalIDs.ix[i]
        elif re.search(data.mainTerm[j],data.mainTerm[i]):
            conditionalIDMatrix = data.journalIDs.ix[i]
        else:
            conditionalIDMatrix = list(set(data.journalIDs.ix[i]).difference(data.journalIDs.ix[j]))
        numArticles[i,j] = len(conditionalIDMatrix)
        ma = meta.MetaAnalysis(dataset, conditionalIDMatrix)
        ma.save_results('DependentComparision_060416',str(i) + '_depon_' + str(j) + '_','','pFgA_z_FDR_0.01')

#np.save(mdir + 'numArticlesOutput',numArticles)
