DOMAINS=['archaea',
         'fungi',
         'protozoa',
         'bacteria',
         'viral']

rule demo:
    input:
        "example.lineages.csv"

rule all:
    message: "Produce a taxonomic lineages file for each domain"
    input:
        expand("{domain}.lineages.csv", domain=DOMAINS)

rule combined:
    message: "Produce a single taxonomic lineages file for all domains"
    input:
        expand("genbank.lineages.csv")


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


rule combine_assembly_summaries:
    input:
        expand("{domain}.assembly_summary.txt", domain=DOMAINS)
    output:
        "genbank.assembly_summary.txt"
    shell:
        """
        cat {input} > {output}
        """
        # we could be cleaner about this to keep just one header, e.g.:
        #head -n 2 {input[0]} > {output}
	#tail -n +3 -q {input} >> {output}


rule make_lineage_csv:
    input:
        "{name}.assembly_summary.txt",
        "taxdump/nodes.dmp",
        "taxdump/names.dmp"
    output:
        "{name}.lineages.csv"
    shell:
        "./make-lineage-csv.py taxdump/{{nodes.dmp,names.dmp}} {input[0]} -o {output}"

