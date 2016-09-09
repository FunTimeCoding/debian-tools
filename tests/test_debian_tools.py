from debian_tools.debian_tools import DebianTools


def test_return_code() -> None:
    application = DebianTools([])
    assert application.run() == 0
