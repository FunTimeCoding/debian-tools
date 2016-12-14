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
