Contributing Guide
====================

ReadTheDocs Integration
------------------------

The E4S project is built via `readthedocs <https://readthedocs.org>`_ platform and the project is hosted at
https://readthedocs.org/projects/e4s/. If you need access to readthedocs project please contact `wspear <https://github.com/wspear>`_
or `shahzebsiddiqui <https://github.com/shahzebsiddiqui>`_. You must create an account at https://readthedocs.org/accounts/signup/ in
order to gain access.

We have enabled a `webhook integration <https://docs.readthedocs.io/en/stable/webhooks.html>`_ between readthedocs and Github project
(https://github.com/E4S-Project/e4s) so that incoming Pull Request are built on the platform. In addition, we have enabled
`Pull Request Builds <https://docs.readthedocs.io/en/stable/pull-requests.html>`_ so one can see the rendered documentation
before merging to main branch.

Building Docs Locally
-----------------------

If you want to build the user docs locally, please have a python 3.x environment and install the dependencies via ``pip`` as follows::

    pip install -r docs/requirements.txt

Next, you should navigate to the ``docs`` directory and build the docs as follows::

    cd docs
    make html

Shown below is a preview of the documentation build if done correctly

.. code-block:: console

    (e4s) bash-3.2$ make html
    Running Sphinx v4.1.2
    loading pickled environment... done
    building [mo]: targets for 0 po files that are out of date
    building [html]: targets for 1 source files that are out of date
    updating environment: 0 added, 1 changed, 0 removed
    reading sources... [100%] contributing
    looking for now-outdated files... none found
    pickling environment... done
    checking consistency... done
    preparing documents... done
    writing output... [100%] index
    generating indices... genindex done
    writing additional pages... search done
    copying images... [100%] ../logos/E4S-dark-green.png
    copying static files... done
    copying extra files... done
    dumping search index in English (code: en)... done
    dumping object inventory... done
    build succeeded.

    The HTML pages are in _build/html.

The documentation is built via `sphinx <https://www.sphinx-doc.org/en/master/>`_ via the Makefile which
will generate the html pages under ``_build/html`` directory. You can view the docs locally by opening
the page in your browser or run the following::

    open _build/html/index.html

The `.readthedocs.yml <https://github.com/E4S-Project/e4s/blob/master/.readthedocs.yml>`_ configuration file is responsible
for configuring readthedocs setting during documentation build. This file can be found in the root of the repo. For more details
please see https://docs.readthedocs.io/en/stable/config-file/v2.html