class d3r::open
{
  #epel repo
  exec { 'install_epel':
    command => '/bin/yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm',
    creates => '/etc/yum.repos.d/epel.repo'
  }

  Package { ensure => 'installed' }
  $python_deps    = [ 'python2-pip', 'python-psutil', 'python-virtualenv', 'python-tox', 'pylint', 'python-coverage' ]
  $perl_deps      = [ 'perl-Archive-Tar', 'perl-List-MoreUtils' ]
  $other_packages = [ 'libXft', 'openbabel', 'xorg-x11-xauth', 'screen', 'bzip2', 'which', 'rsync', 'ncftp' ]
  $pymol_deps     = [ 'subversion', 'gcc', 'gcc-c++', 'kernel-devel', 'python-devel', 'tkinter', 'python-pmw', 'glew-devel', 'freeglut-devel', 'libpng-devel', 'freetype-devel', 'libxml2-devel']
  $mesa_packages  = [ 'mesa-libGL-devel','mesa-libEGL-devel','mesa-libGLES-devel' ]
  $pip_packages   = [ 'argparse','psutil','biopython','xlsxwriter','ftpretty','wheel','flake8','lockfile','easywebdav','d3r', 'numpy' ]
  package { $python_deps: }
  package { $perl_deps: }
  package { $other_packages: }
  package { $mesa_packages: }
  package { $pymol_deps: }

  exec { 'install_pymol':
    command => '/bin/cd /tmp; /bin/wget --no-check-certificate -O pymol-v1.8.4.0.tar.bz2 https://sourceforge.net/projects/pymol/files/pymol/1.8/pymol-v1.8.4.0.tar.bz2/download;
                /bin/tar -xjvf  pymol-v1.8.4.0.tar.bz2;
                cd pymol;
                python2.7 setup.py build install --home=/opt/pymol --install-scripts=/opt/pymol --install-lib=/opt/pymol/modules;
                /bin/ln -s /opt/pymol/pymol /usr/bin/pymol;
                cd /tmp;
                /bin/rm pymol-v1.8.4.0.tar.bz2;
                /bin/rm -rf pymol',
    creates => '/opt/pymol/pymol'
  }

  yumrepo { 'giallu-rdkit':
    baseurl             => 'https://copr-be.cloud.fedoraproject.org/results/giallu/rdkit/epel-$releasever-$basearch/',
    descr               => 'Copr repo for rdkit owned by giallu',
    enabled             => 1,
    gpgcheck            => 1,
    gpgkey              => 'https://copr-be.cloud.fedoraproject.org/results/giallu/rdkit/pubkey.gpg',
    repo_gpgcheck       => 0,
    skip_if_unavailable => 'true'
  }

  exec { 'install_conda':
    command => '/bin/cd ~; /bin/wget https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh;
                /bin/chmod a+x Miniconda2-latest-Linux-x86_64.sh;
                /bin/sh Miniconda2-latest-Linux-x86_64.sh -b -p /opt/miniconda2;
                export PATH="/opt/miniconda2/bin:$PATH";
                conda update --yes conda;
                conda install -y -c rdkit rdkit=2016.03.3;
                /bin/rm Miniconda2-latest-Linux-x86_64.sh',
    creates => '/opt/miniconda2'
  }

  package { 'python-rdkit':
    require => Yumrepo['giallu-rdkit']
  }

  package { $pip_packages:
    ensure   => 'installed',
    provider => 'pip',
    require  => Package['python2-pip'],
  }

  # Openeye install that will work in puppet in versions older then 4.1
  exec { 'install_openeye':
    command => '/usr/bin/pip install -i https://pypi.anaconda.org/OpenEye/simple OpenEye-toolkits==2018.2.1',
    creates => '/usr/bin/openeye_tests.py'
  }

  #blast
  exec { 'install_blast':
    command => '/bin/yum install -y ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.3.0/ncbi-blast-2.3.0+-1.x86_64.rpm',
    creates => '/usr/bin/blastp'
  }

  #manual INSTALL Schrodinger_Suites_2016-2_Linux-x86_64
  exec { 'install_schrodinger':
    path => [ '/usr/bin', '/usr/sbin', '/bin', '/usr/local/bin'],
    command => 'cd /tmp;
                /bin/tar -xf Schrodinger*.tar;
                /bin/rm Schrodinger*.tar;
                cd Schrodinger*;
                ./INSTALL -d `pwd` /opt/schrodinger -b -s /opt/schrodinger -k /tmp -t `pwd`/thirdparty mmshare*.gz glide*.gz maestro*gz;
                cd /tmp;
                /bin/rm -rf Schrodinger*',
    onlyif => '/bin/test -e /tmp/Schr*.tar',
    creates => '/opt/schrodinger'
  } 
}
