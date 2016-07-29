#!/bin/bash
## Linhua Sun
## 2016.5.16
## Usage: sh this_script.sh the_name_of_the_objects
## Purpose: split snps and indels from the raw VCF fils.
## https://www.broadinstitute.org/gatk/guide/tooldocs/org_broadinstitute_gatk_tools_walkers_variantutils_SelectVariants.php
# assign reference genome of the species

## modified scripts to get(extract) the BIALLELIC SNPs
## Based on the GATK: https://software.broadinstitute.org/gatk/gatkdocs/org_broadinstitute_gatk_tools_walkers_variantutils_SelectVariants.php#--restrictAllelesTo 

REF="/sdd1/users/linhua/REFERENCE_GENOME/IRGSP-1.0_genome.fasta"
# GATK software location

GATK="/sdd1/users/linhua/software/GATK/GenomeAnalysisTK.jar"

WORKSPACE=$(pwd)

TEMP="${WORKSPACE}/TEMP"

if [ ! -d $TEMP ]
                then mkdir -p $TEMP
fi

## INPUT: 5K_GATK_gt_raw_Genotype_2.vcf.gz === $1

#SelectVariants

java -Djava.io.tmpdir=${TEMP} -jar $GATK \
        -R $REF \
        -T SelectVariants \
        -V ${1} \
        -selectType SNP \
	-restrictAllelesTo BIALLELIC \
        -o ${1}_BIALLELIC_SNPs.vcf.gz \
	-nt 10 \
	> ${1}_BIALLELIC_SNPs.log 2>&1

echo "BIALLELIC SNP extraction is OK!"

