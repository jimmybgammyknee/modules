process bcl2fastq_paired_umi {

    tag { "Bcl2Fastq paired umi" }
    publishDir "${outdir}/${sampleProject}/fastq", mode: 'copy'
    // stageInMode 'copy'
    label 'process_medium'

    input:
    file sampleSheet
    val sampleProject
    val sampleProjectTF
    val outdir
    val path_bcl 

    output:
    path "*_R1.fastq.gz", emit: R1
    path "*_R2.fastq.gz", emit: R2
    path "*_UMI.fastq.gz", emit: UMI
    path "Stats", emit: bcl_stats
    path "Reports", emit: bcl_reports
    file "fastq.md5"

    script:
    """
    cleanSamplesheet.py ${sampleSheet}

    bcl2fastq \
        --runfolder-dir ${path_bcl} \
        -p ${task.cpus} \
        --output-dir \$PWD \
        --use-bases-mask Y*,I8Y8,Y* \
        --mask-short-adapter-reads=8 \
        --create-fastq-for-index-reads \
        --no-lane-splitting \
        --sample-sheet nf-SampleSheet.csv \
        --minimum-trimmed-read-length=8 \
        --ignore-missing-positions \
        --ignore-missing-controls \
        --ignore-missing-filter \
        --barcode-mismatches=1

    rm -f Undetermined*.fastq.gz

    if [[ ${sampleProjectTF} == 'true' ]]; then
        find . -type f -name '*.fastq.gz' -exec mv -t \$PWD {} +
    fi

    for f in *R1_001.fastq.gz; do
        BN=\${f%_S*}

        mv \${f} \${BN}_R1.fastq.gz
        mv \${BN}*_R2_001.fastq.gz \${BN}_UMI.fastq.gz
        mv \${BN}*_R3_001.fastq.gz \${BN}_R2.fastq.gz
    done

    md5sum *fastq.gz > fastq.md5
    """
}
