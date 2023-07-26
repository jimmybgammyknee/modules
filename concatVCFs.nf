process concatVCFs {

    tag { "ConcatVCFs - ${filename}" }
    publishDir "${params.outdir}/${group}/${filename}/Variants", mode: 'copy'
    label 'process_bcftools'

    input:
        tuple val(filename), val(group), val(sample), val(outdir),
        path "${filename}_*_variants.vcf"

    output:
        tuple val(filename), val(group), val(sample), val(outdir),
        path ("${filename}_variants_all.vcf"), emit: ch_concatVCFs

    shell:
    '''
    bcftools concat \
        -o !{filename}_variants_all.vcf \
        $(for i in seq(1, 22) ++ ['X', 'Y', 'MT'] {echo !{filename}_$i_variants.vcf})
    '''
}