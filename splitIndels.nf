process splitINDEL {

    tag { "split VCF indels - ${filename}" }
    publishDir "${params.outdir}/${group}/${filename}/Variants/filtered/indel_vcfs", mode: 'copy'
    label 'gatkEnv'

    input:
        tuple val(filename), val(group), val(sample), val(outdir),
        path ("${filename}_variants_all_passed.vcf"),
        path ("${filename}_variants_all_passed.vcf.gz")
        val REF
        val INDEX
        val DICT

    output:
        tuple val(filename), val(group), val(sample), val(outdir),
        path ("${filename}.passed.converted.indels.vcf.gz"),
        path ("${filename}.passed.converted.indels.vcf.gz.tbi"), emit: ch_INDELS
        path ("${filename}.converted.indels.vcf.gz")
        path ("${filename}.converted.indels.vcf.gz.tbi")


    script:
    """
    ## NEW FILTERING APPROACH
    gatk SelectVariants \
    -R ${REF} \
    -V ${vcf} \
    -select-type INDEL \
    -O ${filename}.temp.indels.vcf.gz

    zcat ${filename}.temp.indels.vcf.gz | \
    sed 's/^/chr/;s/^chr#/#/;s/chrMT/chrM/' | \
    bgzip > ${filename}.converted.indels.vcf.gz

    gatk IndexFeatureFile -I ${filename}.converted.indels.vcf.gz

    ## Filter out variants that dont pass filter
    gatk SelectVariants \
    -R ${REF} \
    -V ${filename}.temp.indels.vcf.gz \
    --exclude-filtered \
    -O ${filename}.passed.indels.vcf.gz

    zcat ${filename}.passed.indels.vcf.gz | \
    sed 's/^/chr/;s/^chr#/#/;s/chrMT/chrM/' | \
    bgzip > ${filename}.passed.converted.indels.vcf.gz

    gatk IndexFeatureFile -I ${filename}.passed.converted.indels.vcf.gz
    """
}