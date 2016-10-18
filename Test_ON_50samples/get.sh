#!/bin/bash
for i in chr*_joint_genotyping_japonica.vcf.gz_BIALLELIC_SNPs.vcf.gz
do
ID=$(basename ${i} .vcf.gz)
plink  \
--vcf ${i} \
--make-bed \
--const-fid \
--biallelic-only strict \
--allow-no-sex \
--set-missing-var-ids @:#[IRGSP1.0]\$1,\$2 \
--keep-allele-order \
--out ${ID}_plink
done
