import pandas as pd
import numpy as np

number = 4
X = pd.read_csv("./SWP_3/results/stats_idxstats/ERR02460{0}_tiny.txt".format(number), sep="\t", header=None)
data = {'sequence': X[0], 'sample1': X[2]}
df = pd.DataFrame(data)

sample_number = 2
while number < 9:
    number += 1
    X = pd.read_csv("./SWP_3/results/stats_idxstats/ERR02460{0}_tiny.txt".format(number), sep="\t", header=None)
    df['sample{0}'.format(sample_number)] = X[2]
    sample_number += 1

df.drop(df.tail(1).index, inplace = True)
df.to_csv("./SWP_3/results/stats/counts.csv", sep="\t", header=True, index=False)
