# DebianTools

## Setup

This section explains how to install and uninstall the project.

Install pip package from GitHub.

```sh
pip3 install git+https://git@github.com/FunTimeCoding/debian-tools.git#egg=debian-tools
```

Install pip package from DevPi.

```sh
pip3 install -i https://testpypi.python.org/pypi debian-tools
```

Uninstall package.

```sh
pip3 uninstall debian-tools
```


## Usage

This section explains how to use the project.

Run program.

```sh
dt
```

Show help.

```sh
dt --help
```

Generate a preconfiguration.

```sh
dt --hostname example --domain example.org --root-password root --user-name example --user-password example --user-real-name "Example User" > preseed.cfg
```

Generate a preconfiguration with plain text passwords.

```sh
dt --hostname example --domain example.org --root-password root --user-name example --user-password example --user-real-name "Example User" --insecure > preseed.cfg
```

Generate a preconfiguration and pass a proxy.

```sh
dt --hostname example --domain example.org --root-password root --user-name example --user-password example --user-real-name "Example User" --proxy http://proxy:8080 > preseed.cfg
```

Download example preconfiguration files.

Official documentation:
- https://www.debian.org/releases/jessie/amd64/apbs04.html.en
- https://www.debian.org/releases/stretch/amd64/apbs04.html.en

```sh
bin/download-preconfiguration-examples.sh
```


## Development

This section explains how to improve the project.

Configure Git on Windows before cloning. This avoids problems with Vagrant and VirtualBox.

```sh
git config --global core.autocrlf input
```

Build project. This installs dependencies.

```sh
script/build.sh
```

Run tests, check style and measure metrics.

```sh
script/test.sh
script/check.sh
script/measure.sh
```

Build package.

```sh
script/package.sh
```

Install Debian package.

```sh
sudo dpkg --install build/python3-debian-tools_0.1.0-1_all.deb
```

Show files the package installed.

```sh
dpkg-query --listfiles python3-debian-tools
```
