process prepGamp {

    tag { "prepGamp - ${filename}" }
    publishDir "${params.outdir}/${group}/${filename}/Mapped", mode: 'copy'
    label 'process_vg'

    input:
	    tuple val(filename), val(group), val(sample), path("${filename}_mapped.gamp"), val (outdir)
        val (XG)

    output:
        tuple val(filename), val(group), val(sample), val(outdir), path ("${filename}_mapped.sorted.gam"), emit: ch_prepGamp

    script:
    """
    # convert gamp to gam
    # gam needed for vg augment
    echo "Converting GAMP to GAM. Please wait ...";
    vg view \
        -K \
        -G ${filename}_mapped.gamp > ${filename}_mapped.gam

    ## Sort gam
    echo "Sorting GAM. Please wait ...";
    vg gamsort \
        -p \
        ${filename}_mapped.gam > ${filename}_mapped.sorted.gam

    # alignment statistics
    echo "Calculating alignment statistics. Please wait ...";
    vg stats \
        -a ${filename}_mapped.sorted.gam \
        ${XG} > ${filename}_alignment_statistics.txt

    # Index sorted gam
    echo "Indexing sorted GAM. Please wait ...";
    vg index \
        -p \
        -l ${filename}_mapped.sorted.gam
    """
}