#!/usr/bin/env python3
from setuptools import setup

setup(
    name='debian-tools',
    version='0.1',
    description='Stub description for debian-tools.',
    install_requires=[],
    scripts=['bin/dt'],
    packages=['debian_tools'],
    package_data={'debian_tools': ['template/*']},
    author='Alexander Reitzel',
    author_email='funtimecoding@gmail.com',
    url='http://example.org',
    download_url='http://example.org/debian-tools.tar.gz'
)
