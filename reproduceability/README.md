
# Important note about the structure of these document

So this analysis was performed at the unfortunate point where I was learning python but was still far much more comfortable in matlab.

Unfortunately this jump in program language was not linear. There was not a linear transgression from "first matlab, than python". Instead it started out with "(1) Matlab, (2) Neurosynth is in python (3) back to Matlab (4) now I know python better and I can try and make this in python."

As this is what I have done. This code is getting stored in `./as_is` (I am commenting some parts of it at the moment and sectioning the matlab code to make it more readable).

As the `./as_is` is far from a useful way for anyone to redo the analysis, I will be adding a `./clean` which will be in python the entire way and perform the same analysis.  

Python files also include jupyter notebook versions for readability purposes.

# Structure of ./clean

Once ./as_is is finished I will get working on ./clean

# Structure of ./as_is:

The code takes you from querying pubmed for network terms, using neurosynth for the conditional metaanalysis, and infomap clustering.

Matlab requirements are found in `matlabrequirements.m`

`scrape_pubmed.m` Query pubmed for terms including: `term + "network"` where terms are taken from the neurosynth terms.

Get articles associated with each term (`queryNeurosynthConditionally.py` / `queryNeurosynthConditionally.ipynb` ) (this file is badly named as the conditional part is actually done in the next step)

Perform neurosynths comparision for different terms conditionally ( `performMMA.py` / `performMMA.ipynb` )

`from_neurosynthresults_to_infomapclustering.m` continues where the python code leaves off. This code takes you from the results from the metaanalysis step to creating hierarchical infomap clustering.

Interactive figure: prepare_network_view.py / prepare_network_view.ipynb

### Additional files

__Coming soon (.txt of network selection)__
