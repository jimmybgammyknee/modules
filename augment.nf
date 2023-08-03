process augment {

    tag { "Augment - ${filename}" }
    publishDir "${params.outdir}/${group}/${filename}/Augment", mode: 'copy'
    label 'process_vg'

    input:
        tuple val(filename), val(group), val(sample), val(outdir), path ("${filename}_mapped.sorted.gam.gai"),
        path ("${filename}_mapped.sorted.gam")
        val CHUNK

    output:
        tuple val(filename), val(group), val(sample), val(outdir), path ("${filename}_*.aug.gam"),
        path ("${filename}_*.aug.pg")

    shell:
    '''
    for i in $(seq -w 01 22; echo X; echo Y; echo MT); do
    vg augment \
        -pv \
        "!{CHUNK}/SplicedGraph_GRCh37_chunk_${i}.pg" \
        "!{filename}_mapped.sorted.gam" \
        -s \
        -m 2 \
        -q 5 \
        -Q 5 \
        -A "!{filename}_${i}.aug.gam" > "!{filename}_${i}.aug.pg"
    done
    '''
}