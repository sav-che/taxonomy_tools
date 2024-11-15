### Script to download GenBank specimen metadata for many accessions using Entrez Direct.

# Installation and documentation for EDirect https://www.ncbi.nlm.nih.gov/books/NBK179288/

# esearch -query accepts a regular GenBank search string in quotation marks.
# To (almost) stop query expansion (= strict search), use [WORD] field after each query word. 
# More info on fields: https://www.ncbi.nlm.nih.gov/books/NBK49540/

# QUERY FAILURE message is normal and indicates that not all items were found.
# ERROR: Missing -query argument or Missing -db argument likely indicate that query is too long. 

# Specify input and output files
ENTREZ_QUERY=$(cat < "/mnt/c/Users/cereb/Desktop/test.txt")
ENTREZ_RESULT="/mnt/c/Users/cereb/Desktop/genbank_records.tsv"

# Search GenBank through EDirect
esearch -db nuccore -query "$ENTREZ_QUERY" | \
efetch -format gbc | \
xtract -head accession keyword organism type_material specimen_voucher isolate isolation_source tissue_type culture_collection geo_loc_name collection_date collected_by identified_by note marker other-seqids\
    -pattern INSDSeq -def "-" -sep "|" -element INSDSeq_primary-accession INSDKeyword \
    -group INSDFeature -if INSDFeature_key -equals source -pfx "\n" \
        -block INSDQualifier -if INSDQualifier_name -equals organism -element INSDQualifier_value \
        -block INSDFeature -unless INSDQualifier_name -equals organism -lbl "\-" \
        -block INSDQualifier -if INSDQualifier_name -equals type_material -element INSDQualifier_value \
        -block INSDFeature -unless INSDQualifier_name -equals type_material -lbl "\-" \
        -block INSDQualifier -if INSDQualifier_name -equals specimen_voucher -element INSDQualifier_value \
        -block INSDFeature -unless INSDQualifier_name -equals specimen_voucher -lbl "\-" \
        -block INSDQualifier -if INSDQualifier_name -equals isolate -element INSDQualifier_value \
        -block INSDFeature -unless INSDQualifier_name -equals isolate -lbl "\-" \
        -block INSDQualifier -if INSDQualifier_name -equals isolation_source -element INSDQualifier_value \
        -block INSDFeature -unless INSDQualifier_name -equals isolation_source -lbl "\-" \
        -block INSDQualifier -if INSDQualifier_name -equals tissue_type -element INSDQualifier_value \
        -block INSDFeature -unless INSDQualifier_name -equals tissue_type -lbl "\-" \
        -block INSDQualifier -if INSDQualifier_name -equals culture_collection -element INSDQualifier_value \
        -block INSDFeature -unless INSDQualifier_name -equals culture_collection -lbl "\-" \
        -block INSDQualifier -if INSDQualifier_name -equals geo_loc_name -element INSDQualifier_value \
        -block INSDFeature -unless INSDQualifier_name -equals geo_loc_name -lbl "\-" \
        -block INSDQualifier -if INSDQualifier_name -equals collection_date -element INSDQualifier_value \
        -block INSDFeature -unless INSDQualifier_name -equals collection_date -lbl "\-" \
        -block INSDQualifier -if INSDQualifier_name -equals collected_by -element INSDQualifier_value \
        -block INSDFeature -unless INSDQualifier_name -equals collected_by -lbl "\-" \
        -block INSDQualifier -if INSDQualifier_name -equals identified_by -element INSDQualifier_value \
        -block INSDFeature -unless INSDQualifier_name -equals identified_by -lbl "\-" \
        -block INSDQualifier -if INSDQualifier_name -equals note -sfx "\t" -element INSDQualifier_value \
        -block INSDFeature -unless INSDQualifier_name -equals note -sfx "\t" -lbl "\-" \
    -group INSDFeature -if INSDFeature_key -equals misc_RNA -clr -lbl "#misc_RNA:" \
        -block INSDQualifier -if INSDQualifier_name -equals note -deq " " -element INSDQualifier_value \
        -block INSDFeature -unless INSDQualifier_name -equals note -deq " " -lbl "\-" \
        -block INSDQualifier -if INSDQualifier_name -equals product -deq " / " -sfx " " -element INSDQualifier_value \
        -block INSDFeature -unless INSDQualifier_name -equals product -deq " / " -sfx " " -lbl "\-" \
    -group INSDFeature -if INSDFeature_key -equals rRNA -clr -lbl "#rRNA:" \
        -block INSDQualifier -if INSDQualifier_name -equals product -deq " " -sfx " " -element INSDQualifier_value \
        -block INSDFeature -unless INSDQualifier_name -equals product -deq " " -sfx " " -lbl "\-" \
    -group INSDFeature -if INSDFeature_key -equals gene -clr -lbl "#gene:" \
        -block INSDQualifier -if INSDQualifier_name -equals gene -deq " " -sfx " " -element INSDQualifier_value \
        -block INSDFeature -unless INSDQualifier_name -equals gene -deq " " -sfx " " -lbl "\-" \
    -group INSDFeature -if INSDFeature_key -equals CDS -clr -lbl "#CDS:" \
        -block INSDQualifier -if INSDQualifier_name -equals gene -deq " " -element INSDQualifier_value \
        -block INSDFeature -unless INSDQualifier_name -equals gene -deq " " -lbl "\-" \
        -block INSDQualifier -if INSDQualifier_name -equals product -deq " / " -sfx " " -element INSDQualifier_value \
        -block INSDFeature -unless INSDQualifier_name -equals product -deq " / " -sfx " " -lbl "\-" \
    -group INSDSeq_other-seqids -sep "|" -element INSDSeqid \
> "$ENTREZ_RESULT"

