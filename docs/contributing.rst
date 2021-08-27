Contributing Guide
====================


User Contribution Guide
-------------------------

Contribution is not easy, so we created this document to describe how to get you setup
so you can contribute back and make everyone's life easier. All contributions will be made via
`pull request <https://github.com/E4S-Project/e4s/pulls>`_ which goes through review
process. We have disabled push to main branch, therefore all changes must go through pull request.

You must have a GitHub account to contribute back, if you don't have one please
`register <http://github.com/join>`_ to create your account.

Default Branch
~~~~~~~~~~~~~~~~

The default branch is `master <https://github.com/E4S-Project/e4s/tree/master>`_. This branch
is protected to ensure no-one accidently deletes this branch. All PRs are sent to `master` branch.

Setup
~~~~~~~

Assuming you have forked the repo, you will want to clone your fork repo::

    git clone git@github.com:YOUR\_GITHUB\_LOGIN/e4s.git

You might need to setup your SSH keys in your git profile if you are using ssh option for cloning. For more details on
setting up SSH keys in your profile, follow instruction found in
https://help.github.com/articles/connecting-to-github-with-ssh/

SSH key will help you pull and push to repository without requesting for password for every commit. Once you have forked the
repo, clone your local repo

Next let's navigate to the directory and add the ``upstream`` repo endpoint as follows::

    cd e4s
    git remote add upstream git@github.com:E4S-Project/e4s.git


The ``upstream`` tag is used to sync your local fork with upstream repo.

Make sure you set your user name and email set properly in git configuration.
We don't want commits from unknown users. This can be done by setting the following::

    git config user.name "First Last"
    git config user.email "abc@example.com"


For more details see this article `Getting Started - First Time Git Setup. <https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup>`_


Sync your branch from upstream
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The ``master`` from upstream will get Pull Requests from other contributors, in-order
to sync your forked repo with upstream, you must sync your local ``master`` branch and push
changes to your fork. This can be done by running the following commands::

    git checkout master
    git fetch upstream master
    git pull upstream master

Once the changes are pulled locally you can push your changes to your fork by running::

    git push origin main


Feature Branch
~~~~~~~~~~~~~~~~

Please make sure to create a new branch when adding and new feature. Do not
push to ``master`` branch on your fork or upstream.

Create a new feature branch from ``master`` as follows::

    git checkout master
    git checkout -b <BRANCHNAME>


Now you are ready to make any changes to your feature branch, once you are ready
you can commit and push your changes to your fork. This can be done as follows::

    git add <file1> <file2> <dir1> <dir2>
    git commit -m <COMMIT_MESSAGE>
    git push origin <BRANCHNAME>

Once the branch is created in your fork, you can issue a Pull Request to ``master``
branch for ``upstream`` repo (https://github.com/E4S-Project/e4s).

Please check the `CI actions <https://github.com/E4S-Project/e4s/actions>`_ reported in your pull request and make sure they
pass. The `urlchecker workflow <https://github.com/E4S-Project/e4s/blob/master/.github/workflows/urlcheck.yml>`_
is responsible for checking urls, this is using github action `urlstechie/urlchecker-action <https://github.com/urlstechie/urlchecker-action>`_.
If the CI check reports a failure on url that is valid please exclude the url in the check. For more details on urlchecker-action see
the `documentation <https://github.com/urlstechie/urlchecker-action/blob/master/README.md>`_.


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