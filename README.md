# DebianTools

## Setup

This section explains how to install and uninstall this project.

Install the project.

```sh
pip3 install git+https://git@github.com/FunTimeCoding/debian-tools.git#egg=debian-tools
```

Uninstall the project.

```sh
pip3 uninstall debian-tools
```


## Usage

This section explains how to use this project.

Run the main program.

```sh
bin/dt
```

Show help.

```sh
bin/dt --help
```

Generate a preconfiguration.

```sh
bin/dt --hostname example --domain example.org --root-password root --user-name example --user-password example --user-real-name "Example User" > preseed.cfg
```

Generate a preconfiguration with plain text passwords.

```sh
bin/dt --hostname example --domain example.org --root-password root --user-name example --user-password example --user-real-name "Example User" --insecure > preseed.cfg
```

Generate a preconfiguration and pass a proxy.

```sh
bin/dt --hostname example --domain example.org --root-password root --user-name example --user-password example --user-real-name "Example User" --proxy http://proxy:8080 > preseed.cfg
```

Download example preconfiguration files.

Official documentation:
- https://www.debian.org/releases/jessie/amd64/apbs04.html.en
- https://www.debian.org/releases/stretch/amd64/apbs04.html.en

```sh
bin/download-preconfiguration-examples.sh
```


## Development

This section explains commands to help the development of this project.

Install the project from a clone.

```sh
./setup.sh
```

Run tests, style check and metrics.

```sh
./run-tests.sh
./run-style-check.sh
./run-metrics.sh
```

Build the project.

```sh
./build.sh
```
