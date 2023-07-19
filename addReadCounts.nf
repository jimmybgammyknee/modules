process addReadCounts {

    tag { "VCF to TSV - ${filename}" }
    publishDir "${outdir}/${group}/${filename}/Variants/AnnoVar", mode: 'copy'
    label 'rEnv'


    // Join channels on matching keys
    //ch_annovarINDEL.join(ch_annovarSNP, by: [0,1,2]).set{ results_Annovar }

    input:
    tuple val(filename), val(group), val(sample), val(outdir),
    path ("${filename}_INDEL_multianno.txt"),
    path ("${filename}_SNP_multianno.txt")
   
    output:
    tuple val(filename), val(group), val(sample), val(outdir),
    path ("${filename}_*.tsv")

    script:
    """
    ${workflow.projectDir}/scripts/nf-addReads2VCF.R \
    -i \${PWD}

    ${workflow.projectDir}/scripts/nf-secondaryFiltering.R \
    -i \${PWD}
    """
}