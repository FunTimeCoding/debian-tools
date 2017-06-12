import subprocess
from os import path

from jinja2 import Environment, FileSystemLoader, StrictUndefined
from jinja2 import UndefinedError
from python_utility.custom_argument_parser import CustomArgumentParser


class DebianTools:
    def __init__(self, arguments: list):
        parser = self.get_parser()
        self.parsed_arguments = parser.parse_args(arguments)
        directory = path.dirname(path.abspath(__file__))
        loader = FileSystemLoader(path.join(directory, '..', 'template'))
        self.environment = Environment(loader=loader, undefined=StrictUndefined)

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
        valid_releases = DebianTools.get_valid_releases()
        default_release = valid_releases[0]
        parser.add_argument(
            '--release',
            help='Select a Debian release. Default: {}'.format(default_release),
            choices=valid_releases,
            default=default_release
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
            help='Configure address, netmask, gateway and nameserver manually.',
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
    def get_valid_releases() -> list:
        return ['jessie', 'wheezy']

    @staticmethod
    def encrypt_password(plain_text: str) -> str:
        process = subprocess.Popen(
            ['mkpasswd', '--method=sha-512', '--stdin'],
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE
        )
        out, err = process.communicate(input=plain_text.encode())

        return out.decode().strip()

    def run(self) -> int:
        template = self.environment.get_template('preseed.cfg.j2')
        exit_code = 0

        try:
            root_password = DebianTools.encrypt_password(
                self.parsed_arguments.root_password
            )
            user_password = DebianTools.encrypt_password(
                self.parsed_arguments.user_password
            )
            output = template.render(
                hostname=self.parsed_arguments.hostname,
                domain=self.parsed_arguments.domain,
                root_password=root_password,
                user_name=self.parsed_arguments.user_name,
                user_real_name=self.parsed_arguments.user_real_name,
                user_password=user_password,
                proxy=self.parsed_arguments.proxy,
                release=self.parsed_arguments.release,
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

        print(output)

        return exit_code
