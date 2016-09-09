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

This section explains how to install this project and how to include it in another.

Install the project from a local clone.

```sh
pip3 install --user --editable .
```

Install the project from GitHub.

```sh
pip3 install git+ssh://git@github.com/FunTimeCoding/debian-tools.git#egg=debian-tools
```

Uninstall the project.

```sh
pip3 uninstall debian-tools
```

Require this repository in another projects `requirements.txt`.

```
git+ssh://git@github.com/FunTimeCoding/debian-tools.git#egg=debian-tools
```


## Development

This section explains how to use scripts that are intended to ease the development of this project.

Install tools on Debian Jessie.

```sh
apt-get install shellcheck
```

Install tools on OS X.

```sh
brew install shellcheck
```

Install pip requirements.

```sh
pip3 install --upgrade --user --requirement requirements.txt
```

Run code style check, metrics and tests.

```sh
./run-style-check.sh
./run-metrics.sh
./run-tests.sh
```

Build the project like Jenkins.

```sh
./build.sh
```


## Skeleton details

* The `tests` directory is not called `test` because that package already exists.
* Dashes in the project name become underscores in Python.
