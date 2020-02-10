import numpy as np
import matplotlib.pyplot as pyplot

from sklearn.manifold import TSNE
from scipy.io import loadmat

FILENAME = "population.mat"
SEED = 42
COMPARISONS = ['B2B', 'B2T', 'T2T']

mat = loadmat(FILENAME)

X = []
idxs = []
y = []
for array_name in COMPARISONS:
    array = mat[array_name]
    for i in range(array.shape[0]):
        for j in range(array.shape[1]):
            if array[i,j].size != 0:
                y.append(array_name)
                X.append(array[i,j])
                idxs.append((i,j))

X = np.concatenate(X,axis=0)
y = np.array(y)

# X = StandardScaler().fit_transform(X)
tSNE = TSNE(n_components=2, init='pca',random_state=SEED)

X_dim_reduced = tSNE.fit_transform(X)
pyplot.figure(constrained_layout=True)
for array_name,c in zip(COMPARISONS,["r","b","g"]):
    pyplot.scatter(X[y==array_name,0], X[y==array_name,1],4,c,label=array_name)
pyplot.legend(loc="best",fontsize="xx-large",markerscale=6)
pyplot.title("Comparisons t-SNEed",fontsize=28,fontweight="bold")

pyplot.show()
