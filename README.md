# genie_he_data

Each folder contains the following files

- `hedis-sf`: Precomputed tables of HEDIS structure functions for tunes GHE19_00a,GHE19_00b,GHE19_00c,GHE19_00d.
- `photon-sf`: Precomputed tables of HELepton structure functions.
- `pdfs`: Precomputed tables of PDFs used in HEDIS and HELepton.
- `splines`: Precomputed splines for free nucleons in tunes GHE19_00a, GHE19_00b. They include the follwing channels: HEDIS, GLRES, HENuEl, PhotonRES, PhotonCOH. For the PhotonCOH we also include nuclei (1000080160,1000110230,1000120240,1000130270,1000140280,1000190390,1000200400,1000220480,1000260560,1000280580)

- `setup_genie_he_data.sh`: When sourced from bash or zsh shell this script defines the necessary shell variables to use this package:
  - `GENIE_HE_DATA_DIR`:  the top level directory
  - `HEDIS_SF_DATA_DIR`:  hedis-sf data
  - `PHOTON_SF_DATA_DIR`:  photon-sf data
  - `LHAPDF_DATA_PATH`:  pdf data (added to any existing value)
    - also adds the result of: `lhapdf-config --datadir` in case the library has been moved from where it was orginally compiled/installed.
