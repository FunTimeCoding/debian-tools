# DebianTools

## Usage

This section explains how to use this project.

Run the main entry point program.

```sh
PYTHONPATH=. bin/dt --help
```

Generate a preconfiguration.

```sh
PYTHONPATH=. bin/dt --hostname example --domain example.org --root-password root --user-name example --user-password example --user-real-name "Example User" > preseed.cfg
```

Generate a preconfiguration with plaintext passwords.

```sh
PYTHONPATH=. bin/dt --hostname example --domain example.org --root-password root --user-name example --user-password example --user-real-name "Example User" --insecure > preseed.cfg
```

Generate a preconfiguration and pass a proxy.

```sh
PYTHONPATH=. bin/dt --hostname example --domain example.org --root-password root --user-name example --user-password example --user-real-name "Example User" --proxy http://proxy:8080 > preseed.cfg
```

Download example preconfiguration files.

Official documentation:
- https://www.debian.org/releases/jessie/amd64/apbs04.html.en
- https://www.debian.org/releases/wheezy/amd64/apbs04.html.en
- https://www.debian.org/releases/squeeze/amd64/apbs04.html.en

```sh
bin/download-example-preseed-configs.sh
```


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


## Development

This section explains commands to help the development of this project.

Install the project from a local clone.

```sh
./development-setup.sh
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


## Skeleton

This section explains details of the project skeleton.

- The `tests` directory is not called `test` because there is a package with that name.
- Dashes in project names become underscores in Python.
