process pack {

    tag { "Pack - ${filename}" }
    publishDir "${params.outdir}/${group}/${filename}/Augment", mode: 'copy'
    label 'process_vg'

    input:
        tuple val(filename), val(group), val(sample), val(outdir),
        path ("${filename}_*.aug.pg"),
        path ("${filename}_*.aug.gam")

    output:
        tuple val(filename), val(group), val(sample), val(outdir),
        path ("${filename}_*.pack"), emit: ch_pack

    shell:
    '''
    for i in seq(1, 22) ++ ['X', 'Y', 'MT'] {
        echo "Packing Chr ${i}. Please wait ...";
        vg pack \
            -x !{filename}_${i}.aug.pg \
            -g !{filename}_${i}.aug.gam \
            -o !{filename}_${i}.pack
    }
    '''
}