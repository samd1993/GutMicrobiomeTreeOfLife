#trying to install birdman but with the arviz and cmdstanpy versions from before

conda create -n birdmanbase 
mamba install -c conda-forge biom-format patsy xarray arviz=0.17.1 cmdstanpy=1.0.7
pip install birdman

#create kernel I can use with ipykernel

mamba install ipykernel
python -m ipykernel install --user --name=birdmanbase

#got a cmdstan error in jupyter

mamba install -c conda-forge cmdstan

#doesnt work..now trying to launch jupyter from interactive in terminal instead of jupyter hub
#works after installing jupyter notebook in that conda environment

#try downgrading jupyter notebook to 6.5.5

pip install jupyter notebook==6.5.5

#not working trying mamba install -c conda-forge cmdstanpy as this was the error in jupyter hub specifically

mamba install -c conda-forge cmdstanpy=1.0.7


#didnt work.. trying this

pip uninstall cmdstanpy
mamba install -c conda-forge cmdstanpy


#randomly trying install_cmdstan in terminal and its installing cmdstan which i guess is diff from cmdstanpy?

install_cmdstan

conda install -c conda-forge cmdstanpy


#trying local installation to check sanity

curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh
bash ~/Miniconda3-latest-MacOSX-arm64.sh

touch ~/.zshrc
touch ~/.bashrc

source ~/.zshrc
source ~/.bashrc

#apparently on mac mini silicon there is no bashrc and zshrc had to touch myself. Then rm miniconda

rm -rf miniconda3 

#and now reinstall miniconda
bash ~/Miniconda3-latest-MacOSX-arm64.sh

source ~/.zshrc

conda create -n birdmanbase python=3.8

conda install -c conda-forge biom-format patsy xarray arviz cmdstanpy
pip install birdman
pip install cmdstanpy
install_cmdstan
#not working

conda install -c conda-forge cmdstanpy

pip install notebook

pip install biom-format

conda install -c conda-forge ipykernel
python -m ipykernel install --user --name=birdmanbase

pip install jupyter notebook

# so in summary I am getting errors in every single birdman. In base birdman I am getting errors about cmdstan installation and so now I am trying to untinstall cmdstanpy via conda and install via pip to do cmd_install

pip install cmdstanpy
install_cmdstan

#trying new env qiime2

conda env create -n qiime2-2024.5 --file https://data.qiime2.org/distro/amplicon/qiime2-amplicon-2024.5-py39-linux-conda.yml

#and trying on mac

CONDA_SUBDIR=osx-64 conda env create -n qiime2-2024.5 --file https://data.qiime2.org/distro/amplicon/qiime2-amplicon-2024.5-py39-osx-conda.yml
conda activate qiime2-2024.5
conda config --env --set subdir osx-64

conda install -c conda-forge cmdstanpy

pip install birdman==0.1.0

conda install -c conda-forge ipykernel

python -m ipykernel install --user --name=qiime2-2024.5

#remove birdmantest environment

conda env remove -n birdmantest

#make birdmantest with python 3.12

conda create -n birdmantest2 python=3.12

conda install -c conda-forge cmdstanpy=1.2.4
conda install -c conda-forge cmdstan=2.35.0

pip install birdman==0.1.0

conda install jupyterlab

python -m ipykernel install --user --name=birdmantest

~~~~~~~~~~~~~~

#trying with lucas's exact versions

conda create -n birdmantest2 python=3.10.14
conda activate birdmantest2
conda install -c conda-forge cmdstanpy=1.2.4
conda install -c conda-forge cmdstan=2.35.0
pip install birdman==0.1.0


import biom
import pandas as pd
import glob

#fpath = glob.glob("templates/*.txt")[0]
table = biom.load_table("GMTOLsong_table2024_N20_f2all_V4_Vert.biom")
metadata = pd.read_csv("Mar1_25_GMTOL_metadata_Vert.txt",
    sep="\t",
    index_col=0
)

metadata.head()


import birdman
from birdman import NegativeBinomial

nb = NegativeBinomial(
    table=table,
    formula="Chordata",
    metadata=metadata,
)

nb.compile_model()
nb.fit_model()

#trying with lucas's exact versions on barnacle

conda create -n birdmanlucas python=3.10.14
conda activate birdmanlucas
conda install -c conda-forge cmdstanpy=1.2.4
conda install -c conda-forge cmdstan=2.35.0
pip install birdman==0.1.0

pip install pandas
pip install biom-format
#script
python
import biom
import pandas as pd
import glob

#fpath = glob.glob("templates/*.txt")[0]
table = biom.load_table("GMTOLsong_table2024_N20_f2all_V4_Vert.biom")
metadata = pd.read_csv("Mar1_25_GMTOL_metadata_Vert.txt",
    sep="\t",
    index_col=0
)

metadata.head()

import birdman
from birdman import NegativeBinomial

nb = NegativeBinomial(
    table=table,
    formula="Chordata",
    metadata=metadata
)

nb.compile_model()
nb.fit_model()
from pandas import identical
#checking that indexes and columns match
tb=table.to_dataframe()
idx1=pd.Index(tb.columns.values)
idx1
idx2=pd.Index(metadata.index.values)
idx1.identical(idx2)

ids1=idx1.sort_values()
ids2=idx2.sort_values()
ids1.identical(ids2)

idx1.where(idx1==idx2)

#was true so now im confused. not an ID problem
nan_indices = metadata['Chordata'].isna()
print(nan_indices.sum())

#trying birdman on filtered GrpSpcies data

GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_10_2_Grpspecies2.biom
GrpSpeciesMetadataFeb20_25_underscore.txt

import biom
import pandas as pd
import glob

#fpath = glob.glob("templates/*.txt")[0]
table = biom.load_table("GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_10_2_Grpspecies2.biom")
metadata = pd.read_csv("GrpSpeciesMetadataFeb20_25_underscore.txt",
    sep="\t",
    index_col=0
)

metadata.head()

tb=table.to_dataframe()
tb.head()

#filter metadata to only include samples in table even if it has values that aren't in the table

metadata2=metadata.loc[metadata.index.isin(tb.columns)]
metadata2.head()

idx1=pd.Index(tb.columns.values)
idx1
idx2=pd.Index(metadata2.index.values)
idx1.identical(idx2)

ids1=idx1.sort_values()
ids2=idx2.sort_values()
ids1.identical(ids2)

len(tb.columns)
len(metadata2)

#now trying birdman

import birdman
from birdman import NegativeBinomial

nb = NegativeBinomial(
    table=table,
    formula="Chordata",
    metadata=metadata2
)

nb.compile_model()
nb.fit_model()

~~~~~~~~~~~
#trying it on test files macaque_tbl.biom and macaque_metadata.tsv

import biom
import pandas as pd
import glob


table = biom.load_table("macaque_tbl.biom")
mcac = pd.read_csv("macaque_metadata.txt",
    sep="\t",
    index_col=0,
    dtype={"sample_name": str}
)

mcac.head()

tb=table.to_dataframe()
tb.head()
tb.shape
mcac.shape

import birdman
from birdman import NegativeBinomial

nb = NegativeBinomial(
    table=table,
    formula="host_common_name",
    metadata=mcac
)

nb.compile_model()
nb.fit_model()

idx1=pd.Index(tb.columns.values)
idx1
idx2=pd.Index(metadata.index.values)
idx1.identical(idx2)

ids1=idx1.sort_values()
ids2=idx2.sort_values()
ids1.identical(ids2)

metadata2 = metadata.set_index(['sample_name'])
metadata2=metadata2.rename_axis(None,axis="columns")
metadata2.head()

metadata2.index.names = ['']

#import chdir

import os
#and go up a directory

os.chdir("..")
mvert = pd.read_csv("Mar1_25_GMTOL_metadata_Vert.txt",
    sep="\t",
    index_col=0
)
mtxt.head()

idv2=pd.Index(mvert.index.values)
idv2

idm2=pd.Index(mtxt.index.values)
idm2

~~~~~~~~~~~~~
#trying this on ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2species2.biom with metadata file GrpSpeciesMetadataFeb20_25_underscore.txt

import biom
import pandas as pd
import glob


table = biom.load_table("GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2.biom")
metaf = pd.read_csv("GrpSpeciesMetadataFeb20_25_underscore.txt",
    sep="\t",
    index_col=0,
    dtype={"sample_name": str}
)

metaf.head()

tb=table.to_dataframe()
tb.head()
tb.shape
metaf.shape

metaf2=metaf.loc[metaf.index.isin(tb.columns)]
metaf2.head()
metaf2.shape

metaf2.index.names = ['sample_name']
metaf2 = metaf2.set_index(['sample_name']) #doesnt work prob cuz sample_name already is index
metaf2.head()

idx1=pd.Index(tb.columns.values)
idx1
idx2=pd.Index(metaf2.index.values)
idx1.identical(idx2)

ids1=idx1.sort_values()
ids2=idx2.sort_values()
ids1.identical(ids2)


import birdman
from birdman import NegativeBinomial

nb = NegativeBinomial(
    table=table,
    formula="Chordata",
    metadata=metaf2
)

nb.compile_model()
nb.fit_model()

#still get same error

#write tsv of metaf2

metaf2.to_csv("GrpSpeciesMetadataFeb20_25_underscore_filtered.tsv", sep="\t")

mv GrpSpeciesMetadataFeb20_25_underscore_filtered.tsv /ddn_scratch/sdegregori/birdmantest/GrpSpeciesMetadataApr10_25_underscore_filtered.tsv

#move the biom file as well

mv GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2.biom /ddn_scratch/sdegregori/birdmantest/lucas_table_Grpspecies2.biom

mv /ddn_scratch/sdegregori/birdmantest/GrpSpeciesMetadataApr10_25_underscore_filtered.tsv /ddn_scratch/sdegregori/birdmantest/lucas_metadata_Grpspecies2.tsv

