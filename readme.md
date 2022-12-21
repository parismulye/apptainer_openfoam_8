## Instructions for use
1. Install Apptainer (Linux/Mac/Windows)
2. Build the container (Basic/Advanced)
3. Run the container to execute various commands of OpenFOAM

## (1) Install Apptainer/Singularity
Need to have the singularity/apptainer (both are same now). 

https://docs.sylabs.io/guides/3.0/user-guide/installation.html


## (2) Building the container (Basic)
The basic mode creates a single container file in binary (```.sif```) after building. The definition file (```.def```) contains the script to build this container. 

```
apptainer build openfoam_8.sif script_openfoam_8.def
```
## (3) Running the container (Basic)
There are two possible ways to run the container which are explained here with an example. The test folder contains the lid-driven cavity test case. Get into that folder or start a terminal in that folder.
```
cd test/cavity
```

### (a) Get into the container shell and run commands manually
Open a shell terminal inside the container.
```
apptainer shell ../../openfoam_8.sif
```
Now the terminal should look like the following (which means you are inside the container):
```
Apptainer>
```
Do blockMesh and launch icoFoam
```
blockMesh
icoFoam
```
Now the solution files can be seen in the test folder. You can now exit the container (```ctrl+D```)

### (b) Run the commands directly without getting into the container shell
This part is helpful in case one wants to automate the full pipeline of several commands to execute. For example in order to do the same thing as above:
```
apptainer run ../../openfoam_8.sif blockMesh
apptainer run ../../openfoam_8.sif icoFoam
```
Every line basically opens the container, launches a given command, and then exits the container.

*Note: For performing multiple actions without closing the container after every command:*
```
apptainer run ../../openfoam_8.sif blockMesh; icoFoam
```

## Only for Advanced Users:

## Building the container in sandbox mode
The advanced mode creates a folder structure of the container (```.simg```) after building. This is in the sandbox mode which enables to see and edit any files of the container manually. The definition file (```.def```) contains the script to build this container which remains the same as the basic mode. 

```
apptainer build --sandbox openfoam_8.simg script_openfoam_8.def
```
## Running the container in writable mode
Same two ways as in case of the basic mode, but here we add the keyword ```--writable``` to open the container in the writable mode (permits modifications of the files)
```
apptainer shell --writable openfoam_8.simg 
```
