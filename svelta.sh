#!/bin/bash

before_file="$1"
after_file="$2"
# the number of identifiers in the CSV file (3rd argument)
nb_ids="${3:-1}" # if $3 is not provided, default value is 1

# get the newest (2nd argument) filename without the extention
filename_to="${2%.*}"

# get the extension of this filename
filename_to_extension="${2##*.}"
delete_file_tmp="${filename_to}_delete.${filename_to_extension}.tmp"
delete_file_tmp_2="${filename_to}_delete.${filename_to_extension}.tmp2"
delete_file="${filename_to}_delete.${filename_to_extension}"
upsert_file="${filename_to}_upsert.${filename_to_extension}"
upsert_file_tmp="${filename_to}_upsert.${filename_to_extension}.tmp"

# constructs $ids (e.g with $nb_ids=3, ids will be '$1,$2,$3')
ids=$(for i in $(seq 1 "$nb_ids"); do echo -n "$""$i",; done | sed 's/,$//')

# get a timestamp of right now in seconds
start_seconds=$(date +%s)

# comm (stands for common) taking 2 files as argument
# they need to be sorted (comm prerequisites)
# 2 outputs are expected...
#
#... the first one is the lines that only exists in the oldest CSV
# tee is make a 'Y' (or a 'T' actually...) in the pipe mechanism
# the awk command extracts the first columns (print $1) which contain lines existing only in the oldest CSV
#
#... the second one is the lines that only exists in the newest CSV file
# the awk command extracts the second columns (print $2) which contains lines existing only in the newest CSV
comm -3 <(sort "$before_file") <(sort "$after_file") \
| tee >(awk -F'\t' '{print $1}' | grep -Ev "^$" > "$delete_file_tmp") \
| awk -F'\t' '{print $2}' | grep -Ev "^$" > "$upsert_file_tmp"

# $delete_file_tmp contains also lines that are updated in the $upsert_file so we don't want them in the final "to_delete" file
# we perform another comm on those files containing only the identifiers of records
# this way we eliminate records that are updated in the newest CSV files and keeping records that really need to be deleted
comm -23 <(cat "$delete_file_tmp" | awk -F',' '{print '"$ids"'}') <(cat "$upsert_file_tmp" | awk -F',' '{print '"$ids"'}') > "$delete_file_tmp_2"
rm "$delete_file_tmp"

# add the header
echo $(head -1 "$after_file") > "$upsert_file"
cat "$upsert_file_tmp" >> "$upsert_file"
rm "$upsert_file_tmp"

# add the header
echo $(head -1 "$after_file") > "$delete_file"
cat "$delete_file_tmp_2" >> "$delete_file"
rm "$delete_file_tmp_2"

echo lines count: $(wc -l "$upsert_file")
echo lines count: $(wc -l "$delete_file")

# get a second timestamp of right now in seconds
end_seconds=$(date +%s)

echo Done in $(($end_seconds-$start_seconds)) seconds
