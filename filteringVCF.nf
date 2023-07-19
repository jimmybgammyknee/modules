process filterVCF {

    tag { "FilterVCFs - ${filename}" }
    publishDir "${outdir}/${group}/${filename}/Variants/filtered", mode: 'copy'
    label 'process_bcftools'

    input:
    tuple val(filename), val(group), val(sample), val(path)
    path "${filename}_variants_all.vcf"
    val outdir

    output:
    tuple val(filename), val(group), val(sample), val(path)
    path ("${filename}_variants_all_passed.vcf"),
    path ("${filename}_variants_all_passed.vcf.gz", emit: ch_filterVCF)

    shell:
    '''
    bcftools view \
        -f PASS \
        !{filename}_variants_all.vcf > !{filename}_variants_all_passed.vcf
    bgzip -c !{filename}_variants_all_passed.vcf > !{filename}_variants_all_passed.vcf.gz
    '''
}

