# OHBM2025_EduCourse_Harmonics
Code and data for OHBM 2025 Educational Course on Brain Eigenmodes

This repo accompanies my presentation at the OHBM 2025 Educational Course on Brain Eigenmodes

It consists of simple code and some example data to explore connectome harmonics aka structural eigenmodes ([Atasoy et al., 2016 Nature Communications](https://doi.org/10.1038/ncomms10340) and [Atasoy et al., 2017 Scientific Reports](https://doi.org/10.1038/s41598-017-17546-0))

First, it guides the user through extracting harmonics from a structural connectome and visualising them, comparing different atlas scales to appreciate differences in granularity.
Second, use the harmonics to characterise some brain maps in terms of relative contribution from different harmonics.

## Requirements
For full functionality (visualisation) please ensure to include in your MATLAB path the [ENIGMA Toolbox](https://github.com/MICA-MNI/ENIGMA.git) by Lariviere et al. (2021) _Nature Methods_.
% They also have full Python usability if you prefer.


## Repository Structure
### Main script
The main file is [structural_eigenmodes_example_workflow.m](structural_eigenmodes_example_workflow.m)
This script should work out of the box, if run from the parent directory. To run, ensure you are in the main directory of the repo.

### `data`
The [data](data/) folder contains all the data you need to make this code run: 
- Empirical structural connectomes (kindly provided by the ENIGMA Toolbox) from diffusion tractography of HCP participants, in the 400-ROI and 100-ROI Schaefer cortical atlas;
- Brain maps in the Schaefer-400 atlas, with different granularity/smoothness. 

### `utils`
The [utils](utils/) folder contains support functions:
- `fcn_extract_connectome_eigenmodes.m` - this function takes a connectome and returns the connectome harmonics and associated eigenvalues (graph frequencies);
- `fcn_harmonic_energy.m` - this function takes one or more (concatenated) brain maps as inputs, alongside harmonics and their frequencies, and returns the energy (normalised contribution) of each harmonic for each input brain map;
- `fcn_plot_brain_ENIGMA.m` - this function plots a brian map in the Schaefer atlas. It requires ENIGMA Toolbox; if not available, a much simpler plot will be provided.

