#basic_snakemake.snakefile

#include instructions here to run your snakemake pipeline
"""
#before running snakemake, do in tmux terminal:
ml snakemake/5.19.2-foss-2019b-Python-3.7.4
ml R/3.6.2-foss-2019b-fh1
ml Python/3.7.4-foss-2019b-fh1
#ml other_module

#command to run snakemake (remove -np at end when done validating):
snakemake -s basic_snakemake.snakefile --latency-wait 60 --restart-times 2 --keep-going --cluster-config config/cluster_slurm.yaml --cluster "sbatch -p {cluster.partition} --mem={cluster.mem} -t {cluster.time} -c {cluster.ncpus} -n {cluster.ntasks} -o {cluster.output}" -j 20 -np
"""

#keep these lines to source the information in your samples.yaml and config.yaml files
configfile: "config/samples.yaml"
configfile: "config/config.yaml"

#after writing your rules, put all their outputs in rule all following this format
rule all:
    input:
        expand("results/sorted_bams/{samples}_sorted.bam", samples = config["samples"]),
        expand("results/r_output/{samples}.txt", samples = config["samples"])

#insert your own rules here following this format
rule rule1:
    input:
        original_filepaths = lambda wildcards: config["samples"][wildcards.samples]
    output:
        sorted_bams = "results/sorted_bams/{samples}_sorted.bam"
    params:
        samtools_path = config["samtools_path"]
    shell:
        "{params.samtools_path} sort -o {output.sorted_bams} {input.original_filepaths}"

rule rule2:
    input:
        sorted_bams = "results/sorted_bams/{samples}_sorted.bam"
    output:
        script_results = "results/r_output/{samples}.txt"
    params:
        my_script = config["my_script"]
    shell:
        "Rscript {params.my_script} -input {input.sorted_bams} -output {output.script_results}"








