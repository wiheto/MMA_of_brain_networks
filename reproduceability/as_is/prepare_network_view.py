
# <markdowncell>

# In this file we need, (1) the output from the infomap clustering. (2) the thresholded adjacency matrix. (3) node ordering

# For node ordering, cytoscape was used graphically due to its implementation edge-weighted spring embedded layout (http://cytoscape.org/)

# <codecell>


import networkx as nx
import pandas as pd
import plotly.plotly as py
import plotly.graph_objs as go
import plotly.offline as pyof
import numpy as np


# <markdowncell>

# Function defines Returns a pos x and y corrdinates for nodenames from a cyjs file.

# <codecell>

def get_pos_from_cyjs(cytodat):
    cytodat_nodes=list(cytodat.elements['nodes'])
    nodePositions=[]
    nodeNames=[]
    for node in range(0,len(cytodat_nodes)):
        nodePositions.append(np.array([cytodat_nodes[node]['position']['x'], cytodat_nodes[node]['position']['y']]))
        nodeNames.append(cytodat_nodes[node]['data']['name'])
    return nodePositions,nodeNames

# <markdowncell>

# Load data

# <codecell>

# Node positions were first place in the GUI of Cytoscape
# Import data
dat=pd.read_csv('./thnetwork.csv')
clustdat=pd.read_csv('./thnetwork_infomap.csv')
cytodat = pd.read_json('./cyto_layout_3may2016.cyjs')


# <markdowncell>

# Convert pandas to networkx

# <codecell>

G=nx.from_pandas_dataframe(dat,'From','To','Overlap',nx.DiGraph())
edgeNames = list(G.edges())
nodePositions,nodeNames = get_pos_from_cyjs(cytodat)

# <markdowncell>

# The interactive part of the figure was made in plot.ly. An account will be needed there to get parts of this code to work.

# <markdowncell>

# Plot the edges. First defines an edge_trace object, then loops through all edges

# <codecell>


edge_trace = go.Scatter(
    x=[],
    y=[],
    line=go.Line(width=0.5,color='#999'),
    hoverinfo='none',
    mode='lines',
    opacity=0.4)

for edge in range(0,len(edgeNames)):
    x0,y0=nodePositions[nodeNames.index(edgeNames[edge][0])]
    x1,y1=nodePositions[nodeNames.index(edgeNames[edge][1])]
    #abs(x0-x1)<abs(y0-y1) : then curve y axis, otherwise x axis.
    #if y0>y1:, make x,y y,x otherwise, y,x x,
    edge_trace['x'] += [x0, x1, None]
    edge_trace['y'] += [y0, y1, None]


edge_trace_direction=[]
for edge in range(0,len(edgeNames)):
    edge_trace_direction_tmp = go.Scatter(

        x=[],
        y=[],
        line=go.Line(
        #Create multiple widths. wo
            width=list(G[edgeNames[edge][0]][edgeNames[edge][1]].values())[0]*30,
            color='#666'),
        hoverinfo='none',
        mode='lines',
        opacity=0.5)
    x0,y0=nodePositions[nodeNames.index(edgeNames[edge][1])]
    x1,y1=nodePositions[nodeNames.index(edgeNames[edge][0])]
    #edge_trace_direction_tmp.line.width.append()
    #abs(x0-x1)<abs(y0-y1) : then curve y axis, otherwise x axis.
    #if y0>y1:, make x,y y,x otherwise, y,x x,
    vec=np.array([x0-x1,y0-y1])
    vec=vec/sum(abs(vec)) #make unit vector
    edge_trace_direction_tmp['x'].append(x0-50*vec[0])
    edge_trace_direction_tmp['x'].append(x0-100*vec[0])
    edge_trace_direction_tmp['y'].append(y0-50*vec[1])
    edge_trace_direction_tmp['y'].append(y0-100*vec[1])
    edge_trace_direction_tmp['x'].append(None)
    edge_trace_direction_tmp['y'].append(None)
    edge_trace_direction.append(edge_trace_direction_tmp)

# <markdowncell>

# Plot the nodes.

# <codecell>

#SSpecify colors to use
node_color=['rgb(120,120,120)','rgb(244,102,102)','rgb(106,168,79)','rgb(30,132,226)','rgb(240,152,37)','rgb(175,37,240)','rgb(120,120,120)','rgb(23,190,207)']
node_trace=[]
for node in range(0,len(nodeNames)):
    nind = list(clustdat['Name']).index(nodeNames[node])
    cind = clustdat['InfoMapClusterNames'][nind]
    cindl1 = clustdat['InfoMapL1'][nind]
    if clustdat['Network Type'][nind]=='PCN':
        nodeWidth=0.5
    else:
        nodeWidth=2
    node_trace_tmp = go.Scatter(
        x=[],
        y=[],
        text=[],
        mode='markers',
        hoverinfo='text',
        marker=go.Marker(
            showscale=False,
            # colorscale options
            # 'Greys' | 'Greens' | 'Bluered' | 'Hot' | 'Picnic' | 'Portland' |
            # Jet' | 'RdBu' | 'Blackbody' | 'Earth' | 'Electric' | 'YIOrRd' | 'YIGnBu'
            opacity = .9,
            color=node_color[cindl1],
            size=clustdat['overlapWeight'][nind]*15,
            colorbar=dict(
                thickness=15,
                title='Cluster (Level 1)',
                xanchor='left',
                titleside='right'
            ),
            line=dict(width=nodeWidth)))

    x,y=nodePositions[node]
    node_trace_tmp['x'].append(x)
    node_trace_tmp['y'].append(y)
    node_trace_tmp.text.append(nodeNames[node] + ' - ' + str(cind))
    node_trace.append(node_trace_tmp)

# <markdowncell>

# Collect all data from above and send to plot.ly

# <codecell>

dataCollect = []
dataCollect.append(edge_trace)
dataCollect.extend(edge_trace_direction)
dataCollect.extend(node_trace)

fig = go.Figure(data=go.Data(dataCollect),
             layout=go.Layout(
                title='Figure 1b',
                titlefont=dict(size=16),
                showlegend=False,
                width=650,
                height=650,
                hovermode='closest',
                margin=dict(b=20,l=5,r=5,t=40),
                annotations=[ dict(
                    text="",
                    showarrow=False,
                    xref="paper", yref="paper",
                    x=0.005, y=-0.002 ) ],
                xaxis=go.XAxis(showgrid=False, zeroline=False, showticklabels=False),
                yaxis=go.YAxis(showgrid=False, zeroline=False, showticklabels=False)))

py.iplot(fig, filename='networkx')

pyof.plot(fig)
