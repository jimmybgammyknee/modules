process snarls {

    tag { "Snarls - ${filename}" }
    publishDir "${params.outdir}/${group}/${filename}/Snarls", mode: 'copy'
    label 'process_vg'

    input:
        tuple val(filename), val(group), val(sample), val(outdir),
        path ("${filename}_*.aug.pg")

    output:
        tuple val(filename), val(group), val(sample), val(outdir),
        path ("${filename}_*.snarls"), emit: ch_snarls

    script:
    """
    for i in seq(1, 22) ++ ['X', 'Y', 'MT'] {
        echo "Computing Chr ${i} snarls. Please wait ...";
        vg snarls \
           !{filename}_${i}.aug.pg > !{filename}_${i}.snarls
    }
    """
}

//ch_snarls.into { ch_snarls_pack; ch_snarls_call }