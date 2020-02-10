import numpy as np
import matplotlib.pyplot as pyplot

from sklearn.datasets import make_blobs
from sklearn.cluster import DBSCAN, OPTICS
from sklearn.preprocessing import StandardScaler


POINTS_IN_CLUSTER = 200
SEED = 42

centers = np.random.RandomState(SEED).normal(0,1.5,size=(2,2))

def plot_auxilary(title):
    pyplot.axhline(y=0.0,c="k",linestyle="--",linewidth=2,alpha=0.75)
    pyplot.axvline(x=0.0,c="k",linestyle="--",linewidth=2,alpha=0.75)
    pyplot.legend(loc="best",fontsize="xx-large",markerscale=4.0)
    pyplot.title(title,fontsize=22,fontweight="bold")

def get_biggest_cluster(y):
    maxid = 0
    for id in np.unique(y):
        if id != -1:
            if np.sum((y==id).astype(np.float)) > np.sum((y==maxid).astype(np.float)):
                maxid = id
    return maxid

X, y = make_blobs(n_samples=2*POINTS_IN_CLUSTER,centers=centers,
                    cluster_std=[0.8, 4.5],random_state=SEED)


X = StandardScaler().fit_transform(X)
pyplot.figure(constrained_layout=True)
pyplot.scatter(X[y==0,0], X[y==0,1],6,"r",label="B2B")
pyplot.scatter(X[y==1,0], X[y==1,1],6,"b",label="B2T")
plot_auxilary("Expected Difference distribution")


dbscan = DBSCAN(eps=0.18)
dbscan.fit(X)

y_hat_dbscan = dbscan.labels_.astype(np.int)
y_dbscan_id = get_biggest_cluster(y_hat_dbscan)
idx = y_hat_dbscan == y_dbscan_id

pyplot.figure(constrained_layout=True)
pyplot.scatter(X[np.logical_and(idx, y==0),0], X[np.logical_and(idx, y==0),1],6,"r",label="Core B2B Cluster")
pyplot.scatter(X[np.logical_and(idx, y==1),0], X[np.logical_and(idx, y==1),1],6,"b",label="B2T Deviants")
pyplot.scatter(X[~idx,0], X[~idx,1],6,"k",label="Outlers")
plot_auxilary("Using DBSCAN to inference B2B cluster")

optic = OPTICS(min_samples=5,xi=0.035,min_cluster_size=0.2)
optic.fit(X)

y_hat_optic = optic.labels_.astype(np.int)
y_optic_id = get_biggest_cluster(y_hat_dbscan)
idx = y_hat_optic == y_optic_id

pyplot.figure(constrained_layout=True)
pyplot.scatter(X[np.logical_and(idx, y==0),0], X[np.logical_and(idx, y==0),1],6,"r",label="Core B2B Cluster")
pyplot.scatter(X[np.logical_and(idx, y==1),0], X[np.logical_and(idx, y==1),1],6,"b",label="B2T Deviants")
pyplot.scatter(X[~idx,0], X[~idx,1],6,"k",label="Outlers")
plot_auxilary("Using OPTIC to inference B2B cluster")

pyplot.show()
