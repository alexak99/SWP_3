rule paired_end:
    input:
        t1 = "results/fastq_trimmed/{sample}_1_trimmed.fastq",
        t2 = "results/fastq_trimmed/{sample}_2_trimmed.fastq",
        rf=["resources/index/rf.1.bt2", "resources/index/rf.2.bt2", "resources/index/rf.3.bt2", "resources/index/rf.4.bt2", "resources/index/rf.rev.1.bt2", "resources/index/rf.rev.2.bt2"]
    output:
        sam = "results/sam/{sample}.sam"
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
        "bowtie2 -N {params.n_max_mismatches} -L {params.len_seed_substr} --threads {threads} -x {params.index} -1 {input.t1} -2 {input.t2} -S {output} 2> {log}"