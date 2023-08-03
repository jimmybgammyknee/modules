process snarls {

    tag { "Snarls - ${filename}" }
    publishDir "${params.outdir}/${group}/${filename}/Snarls", mode: 'copy'
    label 'process_vg'

    input:
        tuple val(filename), val(group), val(sample), val(outdir), path ("${filename}_*.aug.pg")

    output:
        tuple val(filename), val(group), val(sample), val(outdir), path ("${filename}_*.snarls"), emit: ch_snarls

    shell:
    '''
    for i in $(seq -w 01 22; echo X; echo Y; echo MT); do
        echo "Computing Chr ${i} snarls. Please wait ...";
        vg snarls \
           !{filename}_${i}.aug.pg > !{filename}_${i}.snarls
    done
    '''
}