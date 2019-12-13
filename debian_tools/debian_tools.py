from subprocess import Popen, PIPE
from os import open as file_open, fdopen, O_WRONLY, O_CREAT, remove
from os import name as os_name
from os.path import exists, join, dirname, abspath
from sys import argv
import platform

from jinja2 import Environment, FileSystemLoader, StrictUndefined
from jinja2 import UndefinedError
from debian_tools.custom_argument_parser import CustomArgumentParser
from passlib.hash import sha512_crypt

import debian_tools


class DebianTools:
    def __init__(self, arguments: list):
        self.parsed_arguments = self.get_parser().parse_args(arguments)
        self.environment = Environment(
            loader=FileSystemLoader(
                join(
                    dirname(
                        abspath(debian_tools.__file__)
                    ),
                    'template'
                )
            ),
            undefined=StrictUndefined
        )

    @staticmethod
    def main():
        application = DebianTools(argv[1:])
        exit(application.run())

    @staticmethod
    def get_parser() -> CustomArgumentParser:
        parser = CustomArgumentParser(
            description='generate preseed.cfg for Debian'
        )
        required = parser.add_argument_group('required named arguments')
        required.add_argument(
            '--hostname',
            help='Example: example',
            required=True
        )
        required.add_argument(
            '--domain',
            help='Example: example.org',
            required=True
        )
        required.add_argument(
            '--root-password',
            help='Example: root',
            required=True
        )
        required.add_argument(
            '--user-name',
            help='Example: example',
            required=True
        )
        required.add_argument(
            '--user-real-name',
            help='Example: "Example User"',
            required=True
        )
        required.add_argument(
            '--user-password',
            help='Example: example',
            required=True
        )
        parser.add_argument(
            '--output-document',
            help='Create file with 600 permissions and write to it instead of'
                 ' printing to stdout.',
            default=''
        )
        parser.add_argument(
            '--proxy',
            help='Set proxy for setup. Example: http://proxy:8080',
            default=''
        )
        default_mirror = 'ftp.de.debian.org'
        parser.add_argument(
            '--mirror',
            help='Set the mirror hostname. Default: {}'.format(default_mirror),
            default=default_mirror
        )
        default_mirror_directory = '/debian'
        parser.add_argument(
            '--mirror-directory',
            help='Set the mirror directory. Default: {}'.format(
                default_mirror_directory
            ),
            default=default_mirror_directory
        )
        parser.add_argument(
            '--non-free',
            help='Enable non-free sources.',
            action='store_true'
        )
        parser.add_argument(
            '--contrib',
            help='Enable contrib sources.',
            action='store_true'
        )
        parser.add_argument(
            '--static-networking',
            help='Configure address, netmask, gateway and nameserver'
                 ' manually.',
            action='store_true'
        )
        parser.add_argument(
            '--address',
            help='Example: 10.0.0.2',
            default=''
        )
        parser.add_argument(
            '--netmask',
            help='Example: 255.0.0.0',
            default=''
        )
        parser.add_argument(
            '--gateway',
            help='Example: 10.0.0.1',
            default=''
        )
        parser.add_argument(
            '--nameserver',
            help='Example: 10.0.0.1',
            default=''
        )

        return parser

    @staticmethod
    def encrypt_password_mkpasswd(plain_text: str) -> str:
        process = Popen(
            ['mkpasswd', '--method=sha-512', '--stdin'],
            stdin=PIPE,
            stdout=PIPE
        )
        standard_output, standard_error = process.communicate(
            input=plain_text.encode()
        )

        return standard_output.decode().strip()

    @staticmethod
    def encrypt_password_passlib(plain_text: str) -> str:
        return sha512_crypt.encrypt(plain_text)

    def run(self) -> int:
        template = self.environment.get_template('buster.txt')
        exit_code = 0

        try:
            if 'nt' == os_name or 'Darwin' == platform.system():
                root_password = DebianTools.encrypt_password_passlib(
                    self.parsed_arguments.root_password
                )
                user_password = DebianTools.encrypt_password_passlib(
                    self.parsed_arguments.user_password
                )
            else:
                root_password = DebianTools.encrypt_password_mkpasswd(
                    self.parsed_arguments.root_password
                )
                user_password = DebianTools.encrypt_password_mkpasswd(
                    self.parsed_arguments.user_password
                )

            output = template.render(
                hostname=self.parsed_arguments.hostname,
                domain=self.parsed_arguments.domain,
                root_password=root_password,
                user_name=self.parsed_arguments.user_name,
                user_full_name=self.parsed_arguments.user_real_name,
                user_password=user_password,
                proxy=self.parsed_arguments.proxy,
                mirror=self.parsed_arguments.mirror,
                mirror_directory=self.parsed_arguments.mirror_directory,
                static_networking=self.parsed_arguments.static_networking,
                address=self.parsed_arguments.address,
                netmask=self.parsed_arguments.netmask,
                gateway=self.parsed_arguments.gateway,
                nameserver=self.parsed_arguments.nameserver,
                non_free=self.parsed_arguments.non_free,
                contrib=self.parsed_arguments.contrib
            )
        except UndefinedError as exception:
            exit_code = 1
            output = 'UndefinedError: {}'.format(str(exception))

        if self.parsed_arguments.output_document == '':
            print(output)
        else:
            if exists(self.parsed_arguments.output_document):
                remove(self.parsed_arguments.output_document)

            with fdopen(
                    file_open(
                        self.parsed_arguments.output_document,
                        (O_WRONLY | O_CREAT),
                        0o600
                    ),
                    'w'
            ) as handle:
                handle.write(output + '\n')

        return exit_code
