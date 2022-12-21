#!/bin/bash

source /opt/OpenFOAM/OpenFOAM-8/etc/bashrc
/opt/OpenFOAM/ThirdParty-8/Allwmake
wmRefresh
/opt/OpenFOAM/OpenFOAM-8/Allwmake -j 8