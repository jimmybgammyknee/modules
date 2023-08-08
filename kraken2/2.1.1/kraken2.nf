process kraken2 {

    tag { "Kraken2 - ${sample_id}" } 
    publishDir "${outdir}/QC-results/kraken2", mode: 'copy'
    label 'process_kraken'

    input:
    tuple val(sample_id), file(reads)
    val outdir

    output:
    path "${sample_id}.kraken2", emit: stats

    script:
    """
    kraken2 \
        --db /localscratch/Programs/bcbio/genomes/Hsapiens/hg38/minikraken2_v2_8GB_201904_UPDATE \
        --quick \
        --threads ${task.cpus} \
        --gzip-compressed \
        --memory-mapping \
        --report ${sample_id}.kraken2 \
        ${reads}
    """
}
