# Build NCBI Lineages

Extract taxonomic lineages from NCBI based on assembly_summary files

This tool is used to create files for use with `sourmash tax` and
`sourmash lca index`, for taxonomic summaries.  It ingests
[assembly summary](https://ftp.ncbi.nlm.nih.gov/genomes/README_assembly_summary.txt)
files, and produces output file(s) formatted like so:

```
ident,taxid,superkingdom,phylum,class,order,family,genus,species,strain,taxpath
GCF_900128725.1,9,Bacteria,Pseudomonadota,Gammaproteobacteria,Enterobacterales,Erwiniaceae,Buchnera,Buchnera aphidicola,,2|1224|1236|91347|1903409|32199|9
GCF_008244535.1,14,Bacteria,Dictyoglomi,Dictyoglomia,Dictyoglomales,Dictyoglomaceae,Dictyoglomus,Dictyoglomus thermophilum,,2|68297|203486|203487|203488|13|14
GCF_001735525.1,23,Bacteria,Pseudomonadota,Gammaproteobacteria,Alteromonadales,Shewanellaceae,Shewanella,Shewanella colwelliana,,2|1224|1236|135622|267890|22|23
GCF_019654935.1,23,Bacteria,Pseudomonadota,Gammaproteobacteria,Alteromonadales,Shewanellaceae,Shewanella,Shewanella colwelliana,,2|1224|1236|135622|267890|22|23
GCF_019655395.1,23,Bacteria,Pseudomonadota,Gammaproteobacteria,Alteromonadales,Shewanellaceae,Shewanella,Shewanella colwelliana,,2|1224|1236|135622|267890|22|23
```

## Run the Workflow:

### Install Snakemake if needed

If you already have snakemake installed, you can skip this step.
If not, you can install with [mamba](https://mamba.readthedocs.io/en/latest/) from this directory, with:
```
mamba env create -f environment.yml
conda activate build-ncbi-lineages
```

This activates an isolated conda/mamba environment with Snakemake installed. When you're finished running this and want
to return to your base environment, run `conda deactivate` or close your terminal.

> If you don't have `mamba`:
>  - If you have `conda`, substitute with conda: `conda env create -f environment.yml`
>  - If not, you can install mamba (with conda) by following instructions [here](https://mamba.readthedocs.io/en/latest/installation.html#installation).


### Test the workflow

Execute the test:

```snakemake -c1```


This will generate an output file `example.lineages.csv` based
on the input file `example.assembly_summary.txt`.  Note that snakemake
will download all of the necessary support files, including NCBI taxonomy files.


### Build NCBI lineages file for each domain

The full workflow will build lineages files for the following domains: `archaea`, `fungi`, `protozoa`, `bacteria`, `viral`

Run:

```snakemake all -c1``` 

This will generate one lineages file per domain, e.g. `bacteria.lineages.csv`.
The workflow will download the required `{domain}.assembly_summary.txt` files.
(and NCBI taxonomy files, if not download as part of testing, above).

> Note, if you want to build a combined lineages file for all domains, use `snakemake combined -c1`.

Code based on https://github.com/dib-lab/2018-ncbi-lineages and https://github.com/ctb/2022-assembly-summary-to-lineages.

2023-02-07 NTP, CTB
