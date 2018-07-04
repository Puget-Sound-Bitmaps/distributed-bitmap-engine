# distributed-bitmap-engine
DBIE is a distributed application supporting bitmap index storage and
querying.
## Getting started
Be sure to check out the submodules:
```bash
git clone --recurse-submodules https://github.com/Puget-Sound-Bitmaps/distributed-bitmap-engine.git
```
## Docker support
[Docker image](https://hub.docker.com/r/samburdick/dbie/)<br>
To run the application/experiments yourself, you can use Docker containers.
This will put you into the ubuntu shell of a node:
```bash
docker build -t master . # Create master image, in top-level of repo
docker run -it master /bin/bash
```
## Running the system
It's important to note that running these commands has the side effect of
generating a `SLAVELIST` file which contains the IP addresses of all the
slaves. You'll need to modify these scripts or manually generate these lists
if you're using different IP addresses.
### Master node
If you're using docker:
```bash
./tpc-test.sh n
```
where `n` is the number of nodes. **Make sure to spawn the master container first, and
the remaining slaves.**
### Slave node
```bash
./start-slave.sh
```
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
