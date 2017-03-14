# <markdown cell>

#Import neurosynth, numpy re and pandas. Load neurosynth data (in ./)

# <code cell>

import neurosynth
from neurosynth.base.dataset import Dataset
import numpy as np
import re
import pandas as pd
mdir = './'
neurosynth.set_logging_level('info')
#Load neurosynth data
dataset = Dataset.load('dataset.pkl')

# <markdown cell>

# load the list of network terms from txt file (originates from matlab)

# <code cell>

#Import the dervived list of files
termListFile = 'networklist_round2_revision.txt'
with open(termListFile) as f:
	termList = f.read().splitlines()

# <markdown cell>

# Get the article indexes associated with each article. For somereason I called this journalIDs in the code below, where they are more articleIDs in practice. I was calling them journalIDs due to a different project where they were journalIDs and this variable name felt natural.

# <code cell>

#Create dataframe with terms and articles in neurosynth database
data=pd.DataFrame(index=range(0,len(termList)),columns={'mainTerm','allTerms','journalIDs'})
for i in range(0,len(termList)):
	print(i)
	data.allTerms[i]=termList[i]
	#Seperate variants of same term, seperated in txt file by comma.
	strSplit = re.split(',',termList[i])
	data.mainTerm[i]=strSplit[0]
	ids=np.array([])
	#Loop round additional terms (seperated by ,)
	for j in range(0,len(strSplit)):
		ids = np.append(ids,dataset.get_ids_by_expression(strSplit[j]))
	#Only save inique ids (in case variants repeat themselves)
	data.journalIDs[i] = list(set(ids))

# <markdown cell>

# Save as json.

# <code cell>

data.to_json(mdir + 'journalIds.json')
