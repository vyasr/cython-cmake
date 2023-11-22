import glob
import tempfile
import os.path

import pytest
from build import ProjectBuilder
from build.env import DefaultIsolatedEnv


PROJECTS = glob.glob(os.path.join(os.path.dirname(__file__), "projects/*"))


def build_project(src, out):
    with DefaultIsolatedEnv() as env:
        builder = ProjectBuilder.from_isolated_env(env, src)
        env.install(builder.build_system_requires)
        env.install(builder.get_requires_for_build("wheel"))
        return builder.build("wheel", out)


@pytest.mark.parametrize("project", PROJECTS)
def test_build_project(project):
    # TODO: Need to modify pyproject.toml for each project so that it pulls the latest
    # version of cython-cmake when e.g. making PRs.
    with tempfile.TemporaryDirectory() as tmp:
        build_project(project, tmp)
