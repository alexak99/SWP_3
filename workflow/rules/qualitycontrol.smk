rule fastqc_raw:
    input:
        fastq = lambda wildcards: samples.at[wildcards.sample,f"fq{int(wildcards.idx)}"] if wildcards.sample in samples.index else ''
    output:
        fastqc_raw="results/fastqc_raw/{sample}_{idx}_fastqc.html"
    log:
        log="results/logs/fastqc_raw/{sample}_{idx}.log"
    threads: 4
    conda:
        "../envs/fastqc_trim.yaml"
    shell:
        "fastqc {input} -t {threads} -o ./results/fastqc_raw 2> log"

rule trim:
    input:
        r1 = lambda wildcards: samples.at[wildcards.sample,'fq1'] if 
        wildcards.sample in samples.index else '',
        r2 = lambda wildcards: samples.at[wildcards.sample,'fq2'] if 
        wildcards.sample in samples.index else ''
    output:
        t1 = "results/fastq_trimmed/{sample}_1_trimmed.fastq",
        u1 = "results/fastq_trimmed/{sample}_1_unpaired.fastq",
        t2 = "results/fastq_trimmed/{sample}_2_trimmed.fastq",
        u2 = "results/fastq_trimmed/{sample}_2_unpaired.fastq"
    params:
        LEADING = config["trimmomatic"]["LEADING"],
        TRAILING = config["trimmomatic"]["TRAILING"],
        MINLEN = config["trimmomatic"]["MINLEN"],
        adapters = config["trimmomatic"]["ILLUMINACLIP"]["adapters"],
        clip_opts = config["trimmomatic"]["ILLUMINACLIP"]["clip_opts"]
    log:
        log1="results/logs/trimming/{sample}_1_trimmed.log",
        log2="results/logs/trimming/{sample}_2_trimmed.log"
    threads: 4
    conda:
        "../envs/fastqc_trim.yaml"
    shell:
        "trimmomatic PE -threads 4 {input.r1} {input.r2} {output.t1} {output.u1} {output.t2} {output.u2} ILLUMINACLIP:{params.adapters}:{params.clip_opts} LEADING:{params.LEADING} TRAILING:{params.TRAILING} MINLEN:{params.MINLEN}"

rule fastqc_trimmed:
    input:
        fastq_t = "results/fastq_trimmed/{sample}_{idx2}.fastq"
    output:
        fastqc_trimmed = "results/fastqc_trimmed/{sample}_{idx2}_fastqc.html"
    log:
        log="results/logs/fastqc_trimmed/{sample}_{idx2}.log"
    threads: 4
    conda:
        "../envs/fastqc_trim.yaml"
    shell:
        "fastqc {input} -t {threads} -o ./results/fastqc_trimmed"
    