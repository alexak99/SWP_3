rule paired_end:
    input:
        r1_trimmed = "resources/fastq/trimmed/{sample}_1.trimmed.fastq",
        r1_unpaired = "resources/fastq/trimmed/{sample}_1.unpaired.fastq",
        r2_trimmed = "resources/fastq/trimmed/{sample}_2.trimmed.fastq",
        r2_unpaired = "resources/fastq/trimmed/{sample}_2.unpaired.fastq",
        rf=["resources/index/rf.1.bt2", "resources/index/rf.2.bt2", "resources/index/rf.3.bt2", "resources/index/rf.4.bt2", "resources/index/rf.rev.1.bt2", "resources/index/rf.rev.2.bt2"]
    output:
        "results/sam/{sample}.sam"
    params:
        index = config["index"],
        n_max_mismatches = config["n_max_mismatches"],
        len_seed_substr = config["len_seed_substr"]
    log:
        "results/logs/paired_end/{sample}.log"
    threads: 4
    conda:
        "../envs/bowtie.yaml"
    shell:
        "bowtie2 -N {params.n_max_mismatches} -L {params.len_seed_substr} --threads {threads} -x {params.index} -1 {input.r1_trimmed} -2 {input.r2_trimmed} -S {output} 2> {log}"