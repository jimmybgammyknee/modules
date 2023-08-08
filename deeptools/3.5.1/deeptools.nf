
process bam2bw {

    tag { "bigwigs - ${sample_id}"  }
    publishDir "${outdir}/bigwigs", mode: 'copy'
    // stageInMode 'copy' // Link read files + star index. Save on I/O
    label 'process_medium'

    input :
        tuple val(sample_id), file(bam), file(bai)
    output :
        tuple val(sample_id), file("${sample_id}.fwd.bw"), emit : bws_ch
    
    shell :
    """
    #!/bin/bash -l

    source /localscratch/jbreen/miniforge3/bin/activate deeptools

    bamCoverage \
        -b ${bam} \
        -o ${sample_id}.bw \
        -bs 1 \
        -p ${task.cpus} \
        --filterRNAstrand forward \
        --exactScaling \
        --normalizeUsing CPM
    """
}
