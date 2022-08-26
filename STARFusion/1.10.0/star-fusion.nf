process starFusion {

    tag { "STAR_Fusion - ${filename}" } 
    publishDir "${outdir}/${group}/${filename}/STAR_fusion", mode: 'copy'
    label 'process_starfusion'

    input:
    tuple val(filename), val(group), val(sample), val(path), file(reads)
    val ctat_dir
    val outdir
     
    output:
    file "${filename}_star-fusion.tsv"
    file "${filename}_star-fusion.abridged.tsv"
    file "${filename}_star-fusion.abridged.coding_effect.tsv"
    file "${filename}_FusionInspector.html"

    script:
    """
	STAR-Fusion \
	--genome_lib_dir ${ctat_dir} \
	--left_fq ${reads[0]} \
	--right_fq ${reads[1]} \
	--CPU ${task.cpus} \
    --FusionInspector inspect \
	--examine_coding_effect \
	--output_dir \${PWD}

	mv star-fusion.fusion_predictions.tsv ${filename}_star-fusion.tsv
	mv star-fusion.fusion_predictions.abridged.tsv ${filename}_star-fusion.abridged.tsv
    mv star-fusion.fusion_predictions.abridged.coding_effect.tsv ${filename}_star-fusion.abridged.coding_effect.tsv
    mv FusionInspector-inspect/finspector.fusion_inspector_web.html ${filename}_FusionInspector.html
    """
}

