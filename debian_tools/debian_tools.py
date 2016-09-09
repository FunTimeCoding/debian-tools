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
            help='Select a Debian release. Default: ' + default_release,
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
            help='Set a mirror for setup. Default: ' + default_mirror,
            default=default_mirror
        )

        return parser

    @staticmethod
    def get_valid_releases():
        return ['jessie', 'wheezy', 'squeeze']

    @staticmethod
    def encrypt_password(plain_text: str):
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
                mirror=self.parsed_arguments.mirror
            )
        except UndefinedError as exception:
            exit_code = 1
            output = 'UndefinedError: ' + str(exception)

        print(output)

        return exit_code
