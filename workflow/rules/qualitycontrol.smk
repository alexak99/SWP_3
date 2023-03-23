rule fastqc_raw:
    params:
        "resources/fastq/tiny/ERR02460*"
    output:
        "results/fastqc_raw/{sample}_{suffix}_fastqc.html"
    log:
        "results/logs/fastqc_raw/{sample}_{suffix}.log"
    threads: 4
    conda:
        "../envs/fastqc_trim.yaml"
    shell:
        "fastqc {params} -t {threads} -o ./results/fastqc_raw 2> log"

rule trim:
    input:
        r1 = lambda wildcards: samples.at[wildcards.sample,'fq1'] if 
        wildcards.sample in samples.index else '',
        r2 = lambda wildcards: samples.at[wildcards.sample,'fq2'] if 
        wildcards.sample in samples.index else ''
    output:
        r1_trimmed = "resources/fastq/trimmed/{sample}_1.trimmed.fastq",
        r1_unpaired = "resources/fastq/trimmed/{sample}_1.unpaired.fastq",
        r2_trimmed = "resources/fastq/trimmed/{sample}_2.trimmed.fastq",
        r2_unpaired = "resources/fastq/trimmed/{sample}_2.unpaired.fastq"
    log:
        "results/logs/trimming/{sample}_1.log",
        "results/logs/trimming/{sample}_2.log"
    threads: 4
    conda:
        "../envs/fastqc_trim.yaml"
    shell:
        "trimmomatic PE -threads 4 {input.r1} {input.r2} {output} ILLUMINACLIP:resources/adapter/adapter.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36"

"""rule fastqc_trimmed:
    input:
        r1_trimmed = "resources/fastq/trimmed/{sample}_1.trimmed.fastq",
        r2_trimmed = "resources/fastq/trimmed/{sample}_2.trimmed.fastq",
        r1_unpaired = "resources/fastq/trimmed/{sample}_1.unpaired.fastq",
        r2_unpaired = "resources/fastq/trimmed/{sample}_2.unpaired.fastq"
    output:
        o1 = "results/fastqc_trimmed/{sample}_1_fastqc.html",
        o2 = "results/fastqc_trimmed/{sample}_2_fastqc.html"
    threads: 4
    conda:
        "../envs/fastqc_trim.yaml"
    shell:
        "fastqc {input.r1_trimmed} {input.r2_trimmed} -t {threads} -o ./results/fastqc_trimmed""""
    