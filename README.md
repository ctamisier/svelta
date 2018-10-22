# Svelta

Compare CSV files, resulting with:
 * A file (_upsert.csv) with the newly created/updated lines
 * A file (_delete.csv) with the deleted lines

# How

`svelta.sh old_data.csv new_data.csv`

# Example

Having `new_data.csv`...

    id,first_name,last_name,email,gender,ip_address
    6,Hildy,Loram,hloram5@ezinearticles.com,Female,149.73.190.209
    4,Marthena,Fernando,mfernando3@homestead.com.UPDATED,Female,100.128.150.95
    1,Leyla,Culligan,lculligan0@sfgate.com,Female,214.35.5.12
    2,Melloney,Lafontaine,mlafontaine1@zdnet.com,Female,59.173.34.20
    3,Amye,Grafhom,agrafhom6@mit.edu,Female,103.211.219.108
    5,Zachariah,Kenway UPDATED,zkenway4@prlog.org,Male,195.4.181.117

...and `old_data.csv`...

    id,first_name,last_name,email,gender,ip_address
    2,Melloney,Lafontaine,mlafontaine1@zdnet.com,Female,59.173.34.20
    7,Bertram,Limpkin,blimpkin2@google.co.uk,Male,191.68.118.149
    4,Marthena,Fernando,mfernando3@homestead.com,Female,100.128.150.95
    5,Zachariah,Kenway,zkenway4@prlog.org,Male,195.4.181.117
    1,Leyla,Culligan,lculligan0@sfgate.com,Female,214.35.5.12
    6,Hildy,Loram,hloram5@ezinearticles.com,Female,149.73.190.209
    3,Amye,Grafhom,agrafhom6@mit.edu,Female,103.211.219.108

...will generate `new_data_upsert.csv`...

    id,first_name,last_name,email,gender,ip_address
    4,Marthena,Fernando,mfernando3@homestead.com.UPDATED,Female,100.128.150.95
    5,Zachariah,Kenway UPDATED,zkenway4@prlog.org,Male,195.4.181.117

...and `new_data_delete.csv`...

    id,first_name,last_name,email,gender,ip_address
    7,,,,,