process splitSNP {

    tag { "split VCF SNPs - ${filename}" }
    publishDir "${params.outdir}/${group}/${filename}/Variants/filtered/snps_vcfs", mode: 'copy'
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
        path ("${filename}.passed.converted.snp.vcf.gz"),
        path ("${filename}.passed.converted.snp.vcf.gz.tbi"), emit: ch_SNPS
        path ("${filename}.converted.snp.vcf.gz")
        path ("${filename}.converted.snp.vcf.gz.tbi")


    script:
    """
    ## NEW FILTERING APPROACH
    gatk SelectVariants \
    -R ${REF} \
    -V ${vcf} \
    -select-type SNP \
    -O ${filename}.temp.snps.vcf.gz

    zcat ${filename}.temp.snps.vcf.gz | \
    sed 's/^/chr/;s/^chr#/#/;s/chrMT/chrM/' | \
    bgzip > ${filename}.converted.snp.vcf.gz

    gatk IndexFeatureFile -I ${filename}.converted.snp.vcf.gz

    ## Filter out variants that dont pass filter
    gatk SelectVariants \
    -R ${REF} \
    -V ${filename}.temp.snps.vcf.gz \
    --exclude-filtered \
    -O ${filename}.passed.snp.vcf.gz

    zcat ${filename}.passed.hg19.snp.vcf.gz | \
    sed 's/^/chr/;s/^chr#/#/;s/chrMT/chrM/' | \
    bgzip > ${filename}.passed.converted.snp.vcf.gz

    gatk IndexFeatureFile -I ${filename}.passed.converted.snp.vcf.gz
    """
}