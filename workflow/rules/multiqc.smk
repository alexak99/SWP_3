rule multiqc:
    input:
        expand("results/fastqc_raw/{sample}_{idx}_fastqc.html", sample = list(samples.index), idx = ["1","2"]),
        expand("results/fastqc_trimmed/{sample}_{idx2}_fastqc.html", sample = list(samples.index), idx2 = ["1_trimmed","2_trimmed"]),
        expand("results/stats_idxstats/{sample}_aug.txt", sample = list(samples.index)),
        expand("results/stats_bamqc/{sample}/qualimapReport.html", sample = list(samples.index))
    output:
        "results/multiqc/multiqc_report.html"
    log: 
        "results/logs/multiqc/multiqc.log"
    shell:
        "multiqc ./results -o ./results/multiqc"