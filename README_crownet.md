# Simu5G in CrowNet: Overview of Modifications
This fork of the Simu5G project includes several adaptations for CrowNet. 
While some are specific for CrowNet, we have and will continue to submit
pull request for all adaptions which are of general use for the Simu5G
community. 

We would like to thank all developers who contributed to Simu5G and in 
particular Giovanni Nardini, Giovanni Stea and Antonio Virdis for creating
and publishing this great project. Please refer to their homepage at
https://simu5g.org/ for any further information about Simu5G.

## D2D Resource Domains (enforced in LtePhyUeD2D.cc)
* a new boolean value can be set to limit D2D sidelink communication to a single cell (resource domain)
* this is verify by a test in CrowNet: tests/omnetpp/Dpmm_RsdNeighborhoodCount.test

## Adapted default locations
* INET framework is assumed to be in ../inet4 (e.g. in Makefile and fingerprints)

## Fingerprint tests
* test script updated to fail if any subcommand fails (so gitlab displays the correct state of the pipeline)

## INET Version
* use the 'hm_master' branch of INET since we need to compile with CrowNet lateron

## Bugfix for MAC throughput calculation
In src/stack/mac/buffer/harq/LteHarqBufferRx.h, a single static variable was used to sum up all received bytes. This is ok, if we have a scenario with a single base station - however, with multiple base stations, all base stations will add to this single static variable, leading to incorrect values reported for throughput. Please not that since now packet events and the throughput(...) calculation is used, the unit has also changed from Byte/s (Bps) to bits/s (bps).

## Add a new statistic "macNodeId" 
It reports the MacId assigned to a node by the binder.

## LteAmc logging messages corrected
Fixes to log messages in LteAmc: misleading logs in LteAmc.cc are correct now.

## Updated fingerprints 
We provide updated fingerprints, as these are required due to the added statistics.



