import pandas as pd

def create_counts(eingabe, samp):
    table=pd.read_table(eingabe[0], header=None)
    data={'sequence':table[0]}
    df=pd.DataFrame(data)

    for i in range(samp):
        sampletab=pd.read_table(eingabe[i], header=None)
        df['sample'+str[i+1]]=sampletab[2]

df.drop(df.tail(1).index, inplace=True) 
df.to_csv("./results/count_table")