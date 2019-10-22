# DebianTools

## Setup

Install project dependencies:

```sh
script/setup.sh
```

Install pip package from GitHub:

```sh
pip3 install git+https://git@github.com/FunTimeCoding/debian-tools.git#egg=debian-tools
```

Install pip package from DevPi:

```sh
pip3 install -i https://testpypi.python.org/pypi debian-tools
```

Uninstall package:

```sh
pip3 uninstall debian-tools
```


## Usage

Run the main program:

```sh
bin/dt
```

Run the main program inside the container:

```sh
docker run -it --rm funtimecoding/debian-tools
```

Show help:

```sh
dt --help
```

Generate a preconfiguration:

```sh
dt --hostname example --domain example.org --root-password root --user-name example --user-password example --user-real-name "Example User" > preseed.cfg
```

Generate a preconfiguration with plain text passwords:

```sh
dt --hostname example --domain example.org --root-password root --user-name example --user-password example --user-real-name "Example User" --insecure > preseed.cfg
```

Generate a preconfiguration and pass a proxy:

```sh
dt --hostname example --domain example.org --root-password root --user-name example --user-password example --user-real-name "Example User" --proxy http://proxy:8080 > preseed.cfg
```

Download example preconfiguration files:

Official documentation:
- https://www.debian.org/releases/jessie/amd64/apbs04.html.en
- https://www.debian.org/releases/stretch/amd64/apbs04.html.en
- https://www.debian.org/releases/buster/amd64/apbs04.en.html

```sh
bin/download-preconfiguration-examples.sh
```


## Development

Configure Git on Windows before cloning:

```sh
git config --global core.autocrlf input
```

Install NFS plugin for Vagrant on Windows:

```bat
vagrant plugin install vagrant-winnfsd
```

Create the development virtual machine on Linux and Darwin:

```sh
script/vagrant/create.sh
```

Create the development virtual machine on Windows:

```bat
script\vagrant\create.bat
```

Run tests, style check and metrics:

```sh
script/test.sh [--help]
script/check.sh [--help]
script/measure.sh [--help]
```

Build project:

```sh
script/build.sh
```

Install Debian package:

```sh
sudo dpkg --install build/python3-debian-tools_0.1.0-1_all.deb
```

Show files the package installed:

```sh
dpkg-query --listfiles python3-debian-tools
```
