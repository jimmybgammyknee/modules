process multiqc {

    tag { "MultiQC" } 
    publishDir "${outdir}/QC-results", mode: 'copy'
    label 'process_low'

    input:
    file fastqc_in
    file kraken2_stats
    val outdir
    // val opt_args 

    output:
    path "multiqc_report.html", emit: multiqc_report
    path "multiqc_data", emit: multiqc_data

    script:
    // def stats = opt_args ?: ''

    """
    multiqc .
    """
}
