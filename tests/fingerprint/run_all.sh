#!/bin/bash
cd LTE
omnetpp exec ./fingerprints
read
cd ..
cd NR
omnetpp exec ./fingerprints
read
cd mec
omnetpp exec ./fingerprints
cd ..

