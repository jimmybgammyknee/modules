process convertToAnnoVarINDEL {

    tag { "Convert to AnnoVar INDEL - ${filename}" }
    publishDir "${outdir}/${group}/${filename}/Variants/AnnoVar", mode: 'copy'
    label 'process_high'

    input:
        tuple val(filename), val(group), val(sample), val(outdir),
        path ("${filename}.passed.converted.indels.vcf.gz"),
        path ("${filename}.passed.converted.indels.vcf.gz.tbi")
        val ANNODB

    output:
        tuple val(filename), val(group), val(sample), val(outdir),
        path ("${filename}_INDEL_multianno.txt"), emit: ch_annovarINDEL

    script:
    """
    ## NEW FILTERING METHOD
    perl /apps/bioinfo/bin/annovar/convert2annovar.pl \
    -includeinfo \
    --format vcf4 ${vcf} > ${filename}.avinput

    perl /apps/bioinfo/bin/annovar/table_annovar.pl \
    ${filename}.avinput \
    ${ANNODB} \
    --buildver hg19 \
    -out ${filename}_INDEL \
    --remove  \
    --otherinfo \
    --protocol refGene,knownGene,ensGene,wgEncodeGencodeBasicV19,genomicSuperDups,esp6500siv2_all,exac03,1000g2015aug_all,1000g2015aug_afr,1000g2015aug_amr,1000g2015aug_eas,1000g2015aug_eur,1000g2015aug_sas,cg69,snp138NonFlagged,avsnp138,snp138,ljb26_all,clinvar_20150629,nci60,cosmic70 \
    -operation g,g,g,g,r,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f \
    -nastring NaN > ${filename}_INDEL_multianno.txt
    """
}