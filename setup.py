#!/usr/bin/env python3
from setuptools import setup

setup(
    name='debian-tools',
    version='0.1.0',
    description='Stub description.',
    url='https://github.com/FunTimeCoding/debian-tools',
    author='Alexander Reitzel',
    author_email='funtimecoding@gmail.com',
    license='MIT',
    classifiers=[
        'Development Status :: 4 - Beta',
        'Environment :: Console',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: MIT License',
        'Natural Language :: English',
        'Operating System :: MacOS :: MacOS X',
        'Operating System :: POSIX :: Linux',
        'Programming Language :: Python :: 3.3',
        'Programming Language :: Python :: 3.4',
        'Programming Language :: Python :: 3.5',
        'Programming Language :: Python :: 3.6',
        'Topic :: Software Development',
    ],
    keywords='development project skeleton',
    packages=['debian_tools'],
    package_data={'debian_tools': ['template/*.j2']},
    install_requires=['pyyaml'],
    python_requires='>=3.2',
    entry_points={
        'console_scripts': [
            'dt=debian_tools.debian_tools:'
            'DebianTools.main',
        ],
    },
)
