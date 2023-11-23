import glob
import tempfile
import os
import os.path

import pytest
from build import ProjectBuilder
from build.env import DefaultIsolatedEnv


EXAMPLE_PROJECTS = glob.glob(os.path.join(os.path.dirname(__file__), "example_projects/*"))


def build_project(src, out):
    with DefaultIsolatedEnv() as env:
        # Install the local copy of cython-cmake. This assumes that tests are being run
        # somewhere alongside the code.
        path_to_cython_cmake = os.path.abspath(
            os.path.join(os.path.dirname(__file__), '../cython-cmake')
        )
        # Have to specify relative to localhost, see
        # https://github.com/pypa/pip/issues/6658
        env.install([f"file://localhost{path_to_cython_cmake}"])

        builder = ProjectBuilder.from_isolated_env(env, src)
        env.install(builder.build_system_requires)
        env.install(builder.get_requires_for_build("wheel"))
        return builder.build("wheel", out)


@pytest.mark.parametrize("project", EXAMPLE_PROJECTS)
def test_build_project(project):
    with tempfile.TemporaryDirectory() as tmp:
        build_project(project, tmp)
