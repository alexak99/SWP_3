rule convert_to_bam:
    input:
        sam_file="results/sam/{sample}.sam"
    output:
        bam_file="results/bam/{sample}.bam"
    threads: 4
    conda:
        "../envs/samtools.yaml"
    log:
        "results/logs/sam_to_bam/{sample}.log"
    shell:
        "samtools view -@ {threads} -S -b {input.sam_file} > {output.bam_file} 2> {log}"

rule sort_bam:
    input:
        bam_file="results/bam/{sample}.bam"
    output:
        sorted_bam_file="results/bam_sorted/{sample}.sorted.bam"
    threads: 4
    conda:
        "../envs/samtools.yaml"
    log:
        "results/logs/sort_bam/{sample}.log"
    shell:
        "samtools sort {input.bam_file} -@ {threads} -o {output.sorted_bam_file} 2> {log}"

rule index_bam:
    input:
        sorted_bam_file="results/bam_sorted/{sample}.sorted.bam"
    output:
        index_file="results/bam_sorted/{sample}.sorted.bam.bai"
    threads: 4
    conda:
        "../envs/samtools.yaml"
    log:
        "results/logs/index_bam/{sample}.log"
    shell:
        "samtools index {input.sorted_bam_file} {output.index_file} -@ {threads} 2> {log}"

rule idxstats:
    input:
        sorted_bam_file="results/bam_sorted/{sample}.sorted.bam",
        index_file="results/bam_sorted/{sample}.sorted.bam.bai"
    output:
        idxstats="results/stats_idxstats/{sample}_aug.txt"
    threads: 4
    conda:
        "../envs/samtools.yaml"
    log:
        "results/logs/stats_idxstats/{sample}.log"
    shell:
        "samtools idxstats {input.sorted_bam_file} > {output.idxstats} -@ {threads} --print-chr-name 2> {log}"

rule qualimap:
    input:
        sorted_bam_file="results/bam_sorted/{sample}.sorted.bam"
    output:
        bamqc="results/stats_bamqc/{sample}/qualimapReport.html"
    params:
        bamqc_dir="results/stats_bamqc/{sample}"
    threads: 4
    conda:
        "../envs/samtools.yaml"
    log:
        "results/logs/stats_qualimap/{sample}.log"
    shell:
        "qualimap bamqc -bam {input.sorted_bam_file} -gd hg19 -nt {threads} -outdir {params.bamqc_dir} 2> {log}"