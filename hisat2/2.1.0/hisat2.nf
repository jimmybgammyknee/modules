
// Map using hisat2 producing a sorted bam
process HISAT2 {
    tag { sample_id + " - Hisat2 align" }

    memory '20 GB'

    publishDir "${outdir}/Hisat2", mode: 'copy'
    stageInMode 'copy' // Link read files + hisat2 index. Save on I/O
    label 'process_highCpuLowMem'

    input:
    tuple val(sample_id), file(reads)
    path hisat2_idx_dir
    val outdir

    output:
    tuple val(sample_id),
          file("${sample_id}.hisat2.sorted.bam"),
          file("${sample_id}.hisat2.sorted.bam.bai"), emit: bams_ch

    script:
    """
    INDEX=`find -L ${hisat2_idx_dir} -name "*.1.ht2" | sed 's/.1.ht2//'`

    # hisat2 alignment
    hisat2 \\
        --time --dta \\
        --rna-strandness RF \\
        --threads ${task.cpus} \\
        -k 1 \\
        --no-mixed \\
        --met-file ${sample_id}_hisat_metrics.txt \\
        --rg-id "\"@RG\\tID:${sample_id}\\tSM:${sample_id}\\tPL:ILLUMINA\\tLB:${sample_id}\\tPU:LIB1\"" \\
        -x \${INDEX} \\
        -1 ${reads[0]} -2 ${reads[1]} | \\
            samtools view -bhS - > ${sample_id}.hisat2.bam
    
    # sort and index with samtools
    samtools sort -@ ${task.cpus} -m 2G -o ${sample_id}.hisat2.sorted.bam ${sample_id}.hisat2.bam
    samtools index -@ ${task.cpus} ${sample_id}.hisat2.sorted.bam
    """
}
