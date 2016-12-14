from debian_tools.debian_tools import DebianTools


def test_run_without_arguments() -> None:
    try:
        DebianTools([])
        assert False
    except SystemExit as exception:
        assert str(exception) == '1'


def test_run_with_help_argument() -> None:
    try:
        DebianTools(['--help'])
        assert False
    except SystemExit as exception:
        assert str(exception) == '0'


def test_generate() -> None:
    application = DebianTools([
        '--hostname', 'example',
        '--domain', 'example.org',
        '--root-password', 'root',
        '--user-name', 'example',
        '--user-password', 'example',
        '--user-real-name', 'Example User'
    ])
    assert application is not None


def test_generate_static_networking() -> None:
    application = DebianTools([
        '--hostname', 'example',
        '--domain', 'example.org',
        '--root-password', 'root',
        '--user-name', 'example',
        '--user-password', 'example',
        '--user-real-name', 'Example User',
        '--static-networking',
        '--address', '10.0.0.2',
        '--netmask', '255.0.0.0',
        '--gateway', '10.0.0.1',
        '--nameserver', '10.0.0.1'
    ])
    assert application is not None
