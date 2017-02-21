[pymol]: https://sourceforge.net/projects/pymol/
[rdkit]: http://www.rdkit.org/
[blast]: https://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastDocs&DOC_TYPE=Download
[vina]: http://vina.scripps.edu/
[mgltools]: http://mgltools.scripps.edu/downloads
# puppet-D3R
Contains puppet configuration to provision a machine that can run D3R software.

### Software installed

* [Pymol][pymol]
* [Rdkit][rdkit]
* [NCBI Blast][blast]
* [Auto Dock Vina][vina]
* [MGL Tools][mgltools]


### Applying this configuration manually

Although not correct, one way to apply this configuration is
to install puppet 4 on a Linux node and run these commands assuming
**git** is also installed:

```Bash
git clone https://github.com/drugdata/puppet-d3r.git
echo -e "\n# Run the d3r open class\nclass { 'd3r::open': }\n" >> puppet-d3r/manifests/open.pp
puppet apply puppet-d3r/manifests/open.pp
```

