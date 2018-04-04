[pymol]: https://sourceforge.net/projects/pymol/
[rdkit]: http://www.rdkit.org/
[blast]: https://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastDocs&DOC_TYPE=Download
[openeye]: https://www.eyesopen.com/
# puppet-D3R
Contains puppet configuration to provision a machine that can run D3R software.

### Software installed

* [Pymol][pymol] 1.8.4
* [Rdkit][rdkit] 2016.03.3
* [NCBI Blast][blast] 2.3.0
* [Openeye][openeye] (2017.6.1)

### Applying this configuration manually

Although not correct, one way to apply this configuration is
to install puppet 4 on a Linux node and run these commands assuming
**git** is also installed:

```Bash
git clone https://github.com/drugdata/puppet-d3r.git
echo -e "\n# Run the d3r open class\nclass { 'd3r::open': }\n" >> puppet-d3r/manifests/open.pp
puppet apply puppet-d3r/manifests/open.pp
```

