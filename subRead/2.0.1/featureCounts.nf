process featureCountsAll {

    tag { "FeatureCounts" }
    publishDir "${outdir}/featureCounts", mode: 'copy'
    label 'process_low'

    input:
    file gtf
    file bams
    file bais
    val outdir
    val opt_args

    output:
    file "*"

    script:
    def usr_args = opt_args ?: ''

    """
    featureCounts \
        ${usr_args} \
        -T ${task.cpus} \
        -a ${gtf} \
        -o counts.txt \
        ${bams}
    """
}

process featureCountsStr {

    tag { "FeatureCounts  - ${sample_id}" }
    publishDir "${outdir}/featureCounts", mode: 'copy'
    label 'process_low'

    input:
    file gtf
    tuple val(sample_id), file(bam), file(bai)
    val outdir
    val opt_args

    output:
    file "*"

    script:
    def usddr_args = opt_args ?: ''

    """
    featureCounts \
        -s 1 \
        -T ${task.cpus} \
        -a ${gtf} \
        -o ${sample_id}.fwdStrCounts.txt \
        ${bam}

    featureCounts \
        -s 2 \
        -T ${task.cpus} \
        -a ${gtf} \
        -o ${sample_id}.revStrCounts.txt \
        ${bam}
    """
}
