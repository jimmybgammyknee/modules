process augment {

    tag { "Augment - ${filename}" }
    publishDir "${outdir}/${group}/${filename}/Augment", mode: 'copy'
    label 'process_vg'

    input:
        tuple val(filename), val(group), val(sample), val(outdir),
        path ("${filename}_mapped.sorted.gam.gai"),
        path ("${filename}_mapped.sorted.gam")
        val CHUNK

    output:
        tuple val(filename), val(group), val(sample), val(outdir),
        path ("${filename}_*.aug.gam"),
        path ("${filename}_*.aug.pg"), emit: ch_augment

    script:
    """
    for i in seq(1, 22) ++ ['X', 'Y', 'MT'] {
    vg augment \
        -pv \
        "!{CHUNK}" \
        "!{filename}_mapped.sorted.gam" \
        -s \
        -m 2 \
        -q 5 \
        -Q 5 \
        -A "!{filename}_${i}.aug.gam" > "!{filename}_${i}.aug.pg"
    }
    """
}

ch_augment.into { ch_augment_snarls; ch_augment_call }