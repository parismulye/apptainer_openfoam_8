## Table of Contents
1. How to install Apptainer
2. How to build the container
3. How to run the container to execute various commands of OpenFOAM
4. How to add a new openFOAM solver
5. Some notes

## 1. How to install Apptainer/Singularity (Linux/Mac/Windows)
Follow the instructions here based on your operating system.

https://docs.sylabs.io/guides/3.0/user-guide/installation.html


## 2. How to build the container
The basic mode creates a single container file in binary (```.sif```) after building. The definition file (```.def```) contains the script to build this container. 

```
apptainer build openfoam_8.sif script_openfoam_8.def
```
## How to run the container to execute various commands of OpenFOAM
There are two possible ways to run the container which are explained here with an example. The test folder contains the lid-driven cavity test case. Get into that folder or start a terminal in that folder.
```
cd tests/cavity
```
The two methods are (a) and (b), you can use either of them.

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
Now the solution files can be seen in the ```tests/cavity``` folder. You can now exit the container (```ctrl+D```)

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

## 4. How to add a new solver 
The user solvers should be added to ```/opt/OpenFOAM/UserFOAM/applications/solver``` inside the container.

In this tutorial, a new solver (https://openfoamwiki.net/index.php/How_to_add_temperature_to_icoFoam) is built is called ```icoFoamTherm``` which can be seen in this folder. The objective is to see how this can be added into the existing container.

### (1) Convert the container into a sandbox mode 
This will basically convert the binary container into a folder structure (it is the Linux folder structure of the container)
```
apptainer build --sandbox openfoam_8.simg openfoam_8.sif 
```
*Note: Converting is much much faster than recompiling the whole code in the sandbox mode.*

After this, one should see a folder structure named openfoam_8.simg which you can navigate into from the file explorer (i.e. without starting the container)

### (2) Add the solver folder into container folder
The folder of the solver should now be copied to ```/opt/OpenFOAM/UserFOAM/applications/solver``` inside ```openfoam_8.sing```. You can use either the command line of the terminal or just the file explorer.

### (3) Start the sandbox container in the editable mode
The next step is to compile the solver, for which we should go into the editable mode of the container.
```
apptainer shell --wrtiable openfoam_8.simg
```

### (4) Compile the solver
Navigate to the solver from the container shell and compile, in this case the solver is ```icoFoamTherm```
```
cd /opt/OpenFOAM/UserFOAM/applications/solver/icoFoamTherm
wmake
```
This should build a new binary file for the solver

### (5) Convert the container back to .sif format
This step is optional but is recommended. You can replace the existing ```.sif``` container or create a new one.
```
apptainer build openfoam_8_icoFoamTherm.sif opemnfoam_8.simg
```

### (6) Testing the new solver
An example has been added in ```tests``` folder called ```cavity_therm``` which is basically lid-driven cavity but with a thermal coupling.
```
cd tests/cavity_therm
apptainer run ../../openfoam_8_icoFoamTherm.sif blockMesh; icoFoamTherm
```
*Note: The method of launching the commands one by one using the container shell is valid as usual.


## 5. Some Notes
* The build time can be around 20-30 minutes depending on your hardware configuration. But building has to happen only once. In future, if there is repository for storing ```*.sif``` images somewhere, it will be much easier to just pull the image from the cloud.
* The size of ```*.simg``` image is around 2.5 GB whereas the size of the ```*.sif``` image is around 750 MB for this case. This is also one of the reasons why one converts the container to ```*.sif``` format.
* paraFoam is not added in the container, as I think one can just use the paraview in their system (you may have to create an empty file ```*.foam```) in the given test folder for paraview to understand that it is a openfoam folder structure.