import pandas as pd
import os

def aggregate(files, output_path):
    dfs = []
    sample_names = []
    for filename in files:
        df = pd.read_csv(filename, header=None, sep='\t', names=['seqname', 'length', 'mapped_reads', 'unmapped_reads'])
        dfs.append(df)
        sample_names.append(os.path.basename(filename).split("_")[0])

    df_merged = dfs[0]
    for i in range(1, len(dfs)):
        df_merged = pd.merge(df_merged, dfs[i], on='seqname', how='left')

    df_merged.drop(['length_x', 'length_y', 'unmapped_reads_x', 'unmapped_reads_y'], axis=1, inplace=True)

    df_merged.columns = ['seqname'] + sample_names

    df_merged.to_csv(output_path, index=False)
