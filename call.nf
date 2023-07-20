process call {

    tag { "Call - ${filename}" }
    publishDir "${outdir}/${group}/${filename}/Variants", mode: 'copy'
    label 'process_vg'

    input:
        tuple val(filename), val(group), val(sample), val(outdir),
        path ("${filename}_*.aug.pg"),
        path ("${filename}_*.snarls")
        path ("${filename}_*.pack")

    output:
        tuple val(filename), val(group), val(sample), val(outdir),
        path ("${filename}_*_variants.vcf"), emit: ch_call

    script:
    """
    for i in seq(1, 22) ++ ['X', 'Y', 'MT'] {
        echo "Calling Chr ${i} variants. Please wait ...";
        vg call \
            !{filename}_${i}.aug.pg \
            -r !{filename}_${i}.snarls \
            -k !{filename}_${i}.pack \
            -s !{filename} > !{filename}_${i}_variants.vcf
    }
    """
}