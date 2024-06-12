# ECTyper

This markdown document explains how ECTyper was run on the 'All-The-Bacteria' v0.2 release.

ECTyper v1.0.0 was run using database version 1.0.

All programs were installed using conda. The environment used is available in the `ectyper_conda_env.yml` file.

The bash script used to run ECTyper directly on the compressed archives is available at `run_ectyper.sh`.

### Set up ECTyper commands

```bash
for TAR_XZ_FILE in ./ecoli_assemblies/*.asm.tar.xz
do
    chunk=$(basename $TAR_XZ_FILE .asm.tar.xz)
    mkdir "ectyper_results/${chunk}"
    echo tar xf $TAR_XZ_FILE --to-command="'./run_ectyper.sh \${TAR_FILENAME} ./ectyper_results/${chunk}'" >> cmds_ectyper.txt
done
```

### Run jobs in parallel, one for each archive file

```bash
parallel -j 79 --joblog parallel_ectyper.log --progress < cmds_ectyper.txt 
```

### Combine results into a single TSV file

```bash
head -n1 escherichia_coli__01/SAMD00089310.tsv > combined_ectyper_results.tsv

for f in ./escherichia_coli__*/*.tsv
do
    tail -n +2 $f >> combined_ectyper_results.tsv
done

gzip combined_ectyper_results.tsv
```