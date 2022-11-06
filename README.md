# JDK 17 Build System

Build JDK 17

## Run the image build

```bash
git clone https://github.com/veita/cont-build-jdk17.git build-jdk17
cd build-jdk17
./build-container.sh
```

To build an image with a specific Debian version
(`buster`, `bullseye`, `bookworm`) run

```bash
./build-container.sh bookworm
```

## Run the container

Run the container interactively, e.g.

```bash
git clone https://github.com/openjdk/jdk17u-dev.git
cd jdk17u-dev

podman run --name build-jdk17 --hostname build-jdk17 --mount type=bind,source="`pwd`",target=/qsk/jdk -it localhost/build-jdk17:latest
```

Inside the container:

```bash
cd /qsk/jdk
bash configure --with-jtreg=/opt/jtreg
make images
make test-tier1
```

