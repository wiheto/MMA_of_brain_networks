
# Important note about the structure of these document

So this analysis was performed at the unfortunate point where I was learning python but was still far much more comfortable in matlab.

Unfortunately this jump in program language was not linear. There was not a linear transgression from "first matlab, than python". Instead it started out with "(1) Matlab, (2) Neurosynth is in python (3) back to Matlab (4) now I know python better and I can try and make this in python."

As this is what I have done. This code is getting stored in `./as_is` (I am commenting some parts of it at the moment and sectioning the matlab code to make it more readable).

As the `./as_is` is far from a useful way for anyone to redo the analysis, I will be adding a `./clean` which will be in python the entire way and perform the same analysis.  

# Structure of ./clean

Once ./as_is is finished I will get working on ./clean

# Languages of ./as_is:

### In matlab

Query pubmed.

Perform network analysis

Plot surface brains of network masks

Perform network theory analysis

export to nii.

### In python

Interaction with neurosynth

Plot interactive figure

For reproducibility purposes all this code is getting posted here "./used_in_analysis/".

I will however be working on transforming the entire pipeline to python and will be found in "./clean/"

### CSV files

Pubmed selection.
