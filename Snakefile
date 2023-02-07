DOMAINS=['archaea',
         'fungi',
         'protozoa',
         'bacteria',
         'viral']

rule demo:
    input:
        "example.lineages.csv"

rule all:
    input:
        expand("{domain}.lineages.csv", domain=DOMAINS)

rule download_taxdump:
    output:
        "taxdump/nodes.dmp",
        "taxdump/names.dmp"
    shell:
        "curl -L ftp://ftp.ncbi.nlm.nih.gov/pub/taxonomy/taxdump.tar.gz | (mkdir -p taxdump && cd taxdump && tar xzvf -)"


rule download_assembly_summary:
    output:
        "{name}.assembly_summary.txt",
    params:
        link=lambda w: f"https://ftp.ncbi.nlm.nih.gov/genomes/refseq/{w.name}/assembly_summary.txt"
    shell:
        "curl -L {params.link} -o {output}"


rule make_lineage_csv:
    input:
        "{name}.assembly_summary.txt",
        "taxdump/nodes.dmp",
        "taxdump/names.dmp"
    output:
        "{name}.lineages.csv"
    shell:
        "./make-lineage-csv.py taxdump/{{nodes.dmp,names.dmp}} {input[0]} -o {output}"

