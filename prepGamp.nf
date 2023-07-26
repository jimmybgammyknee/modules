process prepGamp {

    tag { "prepGamp - ${filename}" }
    publishDir "${params.outdir}/${group}/${filename}/Mapped", mode: 'copy'
    label 'process_vg'

    input:
	    tuple val(filename), val(group), val(sample), path("${filename}_mapped.gamp"), val (outdir)

    output:
        tuple val(filename), val(group), val(sample), val(outdir),
	    path ("${filename}_mapped.sorted.gam.gai"),
	    path ("${filename}_mapped.sorted.gam"), emit: ch_gamp

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

    # Index sorted gam
    echo "Indexing sorted GAM. Please wait ...";
    vg index \
        -p \
        -l ${filename}_mapped.sorted.gam
    """
}