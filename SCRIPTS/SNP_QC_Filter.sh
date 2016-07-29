#!/bin/bash
# Linhua Sun
# Time: Tue May 17 10:22:27 CST 2016
# Usage: sh this_script.sh object_files
# Purpose: Filter the SNPs
# websites: http://gatkforums.broadinstitute.org/gatk/discussion/4702/undefined-variable-mappingqualityranksum

# set several traps

set -e
set -u
set -o pipefail

# assign the reference genome

REF="/sdd1/users/linhua/REFERENCE_GENOME/IRGSP-1.0_genome.fasta"
# GATK software location

GATK="/sdd1/users/linhua/software/GATK/GenomeAnalysisTK.jar"

WORKSPACE=$(pwd)

TEMP="${WORKSPACE}/TEMP"

if [ ! -d $TEMP ]
                then mkdir -p $TEMP
fi

# filter SNPs

## Inputdate: 5K_GATK_gt_raw_Genotype_1.vcf.gz_SNPs.vcf.gz == ${1}

java -Djava.io.tmpdir=${TEMP} -jar $GATK \
	-R $REF \
	-T VariantFiltration \
	--logging_level ERROR \
	--filterExpression "MQ < 40.0 || MQRankSum < -12.5 || QD < 2.0 || ReadPosRankSum < -8.0 || FS > 60.0 " \
	--filterName LowQualFilter \
	--variant ${1} \
	--missingValuesInExpressionsShouldEvaluateAsFailing \
	-o ${1}_concordance_flt_snp.vcf \
	> ${1}_VariantFiltration.log 2>&1

echo "VariantFiltration Marking is OK!"

grep -v "Filter" \
	${1}_concordance_flt_snp.vcf > \
	${1}_concordance_flt_snp_final.vcf

grep -v "LowQual" \
	${1}_concordance_flt_snp_final.vcf > \
	${1}_concordance_flt_snp_final_all.vcf

echo "Grep filter is OK!"

bgzip -@ 20 ${1}_concordance_flt_snp_final_all.vcf

tabix -p vcf ${1}_concordance_flt_snp_final_all.vcf.gz

echo "bgzip and tabix is OK!"

