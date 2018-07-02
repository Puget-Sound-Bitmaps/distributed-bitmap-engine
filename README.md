# distributed-bitmap-engine
DBIE is a distributed application supporting bitmap index storage and
querying.
## Getting started
Be sure to check out the submodules:
```bash
git clone --recurse-submodules https://github.com/Puget-Sound-Bitmaps/distributed-bitmap-engine.git
```
## Docker support
To run the application/experiments yourself, you can use Docker containers.
This will put you into the ubuntu shell of a node:
```bash
docker build -t master . # Create master image, in top-level of repo
docker run -it master /bin/bash
```
## Running the system
In each of your slave nodes:
```bash
./start-slave.sh
```
In the master node, you'll need to fill out `SLAVELIST` properly (each line is
the IP address of each slave). Then run
```bash
./tpc-test.sh
```
in the same directory as the slave node to run the test on TPC-C data.
## Paper
The corresponding capstone paper for this project can be found [here]
(https://smburdick.github.io/dbie/submitted-paper.pdf).
You can render the paper yourself by running `latexmk` in `report`;
doing so requires `pdfTeX`.
## Authors
### Distributed Bitmap Engine
- Sam Burdick
- Jahrme Risner
## Acknowledgements
These projects (Bitmap Engine and DBIE) have been advised by Professor David Chiu at the
University of Puget Sound.
