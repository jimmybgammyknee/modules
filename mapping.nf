process mapping {

    tag { "VG_mpmap - ${filename}" }
    publishDir "${outdir}/${group}/${filename}/Mapped", mode: 'copy'
    label 'process_vg'

    input:
	tuple val(filename), val(group), val(sample), val(path), file(reads)
	val XG
	val GCSA
	val DIST
	val SNARLS
	val PATHS
	val outdir

    output:
	tuple val(filename), val(group), val(sample), val(outdir), path("${filename}_mapped.gamp"), emit:ch_mapping

    script:
    """
	echo "Mapping Reads. Please wait ..."
	vg mpmap \
    	-x ${XG} \
    	-g ${GCSA} \
    	-d ${DIST} \
    	-s ${SNARLS} \
    	-f ${reads[0]} \
    	-f ${reads[1]} \
    	-n RNA \
    	-l short \
    	-S ${PATHS} > ${filename}_mapped.gamp
    """
}