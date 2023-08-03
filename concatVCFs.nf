process concatVCFs {

    tag { "ConcatVCFs - ${filename}" }
    publishDir "${params.outdir}/${group}/${filename}/Variants", mode: 'copy'
    label 'process_bcftools'

    input:
        tuple val(filename), val(group), val(sample), val(outdir),
        path ("${filename}_*_variants.vcf"), val(contig)

    output:
        tuple val(filename), val(group), val(sample), val(outdir),
        path ("${filename}_variants_all.vcf"), emit: ch_concatVCFs

    shell:
    '''
    bcftools concat \
        -o !{filename}_variants_all.vcf \
        $(for i in $(seq -w 01 22; echo X; echo Y; echo MT); do echo !{filename}_$i_variants.vcf; done)
    '''
}
