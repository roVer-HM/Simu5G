# Simu5G in CrowNet: Overview of Modifications

## D2D Resource Domains (enforced in LtePhyUeD2D.cc)
* a new boolean value can be set to limit D2D sidelink communication to a single cell (resource domain)
* this is verify by a test in CrowNet: tests/omnetpp/Dpmm_RsdNeighborhoodCount.test

## Adapted default locations
* INET framework is assumed to be in ../inet4 (e.g. in Makefile and fingerprints)

## Fingerprint tests
* test script updated to fail if any subcommand fails (so gitlab displays the correct state of the pipeline)

## INET Version
* use the 'hm_master' branch of INET since we need to compile with CrowNet lateron
