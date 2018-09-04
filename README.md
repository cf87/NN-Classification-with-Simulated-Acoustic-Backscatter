# NN Classification with Simulated Sonar Data
# Updated 9/3/2018

Offline simulations were done in MATLAB and COMSOL and their results are in the mat files. For details on the simulation of the data, see Engquist, B., Frederick, C., Huynh, Q., & Zhou, H. 2017. "Seafloor identification in sonar imagery via simulations of Helmholtz equations and discrete optimization." Journal of Computational Physics, 338, 477-492.

# List of files
.m files: seafloorClassification.m selectData.m classifyMaterial.m classifyThickness.m generateRoughInterface.m templateCell.m

Datasets: oneLayerSeabed_N=400.mat twoLayerSeabed_N=8000.mat

# To use

- Run classifyMaterial.m or classifyThickness with datasets in the correct directories to view NN pattern recognition results.

- run generateRoughInterface to produce a .txt file with an example rough interface

- If you have COMSOL Multiphysics software, the templateCell.m will generate the .mph file that I use if you run it using LiveLink with MATLAB.

- To view a HTML report, open either folder and double click on the .html file

# Disclaimer

This is my first github, so there will likely be confusion. Feel free to email me at christin@njit.edu if you need help.
