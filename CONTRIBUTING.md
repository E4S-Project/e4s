Getting Started
================

Contribution is not easy, so we created this document to describe how to get you setup
so you can contribute back and make everyone's life easier. All contributions will be made via
[pull request](https://github.com/E4S-Project/e4s/pulls) which goes through review 
process. We have disabled push to main branch, therefore all changes must go through pull request.

GitHub Account
--------------

If you don't have a GitHub account please [register](http://github.com/join) your account.

Default Branch
--------------

The default branch is [master](https://github.com/E4S-Project/e4s/tree/master). This branch
is protected to ensure no-one accidently deletes this branch. All PRs are sent to `main` branch.

Contribution
--------------

Please **Fork** this repo located in top-right corner before you start contribution. If your product is part of 
[E4S DocPortal](https://e4s-project.github.io/DocPortal.html) you may proceed with contribution, if not please 
[contact E4S](https://e4s-project.github.io/contact.html) before you contribute to this repo.

This repo contains CI badges for each E4S product, if you have badges in top-level **README** you should verify the 
badges are consistent with this repo. For example if you are the Kokkos team you should verify the CI badges in 
Kokkos [README](https://github.com/kokkos/kokkos/blob/master/README.md) are consistent with the Kokkos entry in the 
[README.md](https://github.com/E4S-Project/e4s-ci-badges/blob/main/README.md) table.

We use [shields.io](https://shields.io/) to extract default badges found in most github projects. You can use 
this as reference if you want to add additional badges.

Setup
--------------

Assuming you have forked the repo, you will want to clone your fork repo. 


```
git clone git@github.com:YOUR\_GITHUB\_LOGIN/e4s.git
```

You might need to setup your SSH keys in your git profile if you are using ssh option for cloning. For more details on
setting up SSH keys in your profile, follow instruction found in
https://help.github.com/articles/connecting-to-github-with-ssh/

SSH key will help you pull and push to repository without requesting for password for every commit. Once you have forked the 
repo, clone your local repo

Next let's navigate to the directory and add the ``upstream`` repo endpoint as follows:
```
cd e4s
git remote add upstream git@github.com:E4S-Project/e4s.git
```

The ``upstream`` tag is used to sync your local fork with upstream repo.

Make sure you set your user name and email set properly in git configuration.
We don't want commits from unknown users. This can be done by setting the following:

```
git config user.name "First Last"
git config user.email "abc@example.com"
```

For more details see [First Time Git Setup](https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup).


Sync your branch from upstream
-------------------------------

The ``main`` from upstream will get Pull Requests from other contributors, in-order
to sync your forked repo with upstream, run the commands below:

```
cd e4s
git checkout master
git fetch upstream master
git pull upstream master
```

Once the changes are pulled locally you can sync your upstream fork by pushing local changes on `master` branch to your fork:

```
git push origin main
```


Feature Branch
------------------

Please make sure to create a new branch when adding and new feature. Do not
push to ``main`` branch on your fork or upstream.

Create a new feature branch from ``master`` as follows:

```
 git checkout master
 git checkout -b <BRANCHNAME>
```

Once you are ready to push to your fork repo do the following:

```
git push origin <BRANCHNAME>
```

Once the branch is created in your fork, you can issue a Pull Request to ``master``
branch for ``upstream`` repo (https://github.com/E4S-Project/e4s).

Please check the [CI actions](https://github.com/E4S-Project/e4s/actions) reported in your pull request and make sure they
pass. The [urlchecker workflow](https://github.com/E4S-Project/e4s/blob/master/.github/workflows/urlcheck.yml)
is responsible for checking urls, this is using github action [urlstechie/urlchecker-action](https://github.com/urlstechie/urlchecker-action). 
If the CI check reports a failure on url that is valid please exclude the url in the check. For more details on urlchecker-action see
the [documentation](https://github.com/urlstechie/urlchecker-action/blob/master/README.md). 



