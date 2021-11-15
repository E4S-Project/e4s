E4S Distribution via spack.yaml
================================

21.11
-------

E4S 21.11 is based on Spack branch `e4s-21.11 <https://github.com/spack/spack/tree/e4s-21.11>`_. Shown
below is the spack configuration from Univ of Oregon system. The specs are pushed to buildcache which
can be retrieved using the following commands

.. code-block:: console

    $ spack mirror add E4S https://cache.e4s.io/21.11
    $ spack buildcache keys -it

.. literalinclude:: ../environments/21.11/spack-x86_64.yaml
    :language: yaml

21.08
-------

E4S 21.08 is based on Spack branch `e4s-21.08 <https://github.com/spack/spack/tree/e4s-21.08>`_. Shown
below is the spack configuration from Univ of Oregon system. The specs are pushed to buildcache which
can be retrieved using the following commands

.. code-block:: console

    $ spack mirror add E4S https://cache.e4s.io/21.08
    $ spack buildcache keys -it

.. literalinclude:: ../environments/21.08/spack.yaml
    :language: yaml

21.05
------

E4S 21.05 uses Spack branch `e4s-21.05 <https://github.com/spack/spack/tree/e4s-21.05>`_

Spack Build Cache:

- https://cache.e4s.io

- https://cache.e4s.io/21.05

.. literalinclude:: ../environments/21.05/spack.yaml
   :language: yaml


21.02
------

February 2021 release of E4S (21.02)

E4S 21.02 is based on Spack tag `e4s-21.02 <https://github.com/spack/spack/releases/tag/e4s-21.02>`_

.. literalinclude:: ../environments/21.02/spack.yaml
   :language: yaml

20.10
------

This is the October 2020 release of E4S (20.10)

E4S 20.10 is based on Spack version `0.15.4-1620-e1e0bbb4c`

- commit: `e1e0bbb4cbe11a3f0d7e50466ffa86071ee653b7 <https://github.com/spack/spack/commit/e1e0bbb4cbe11a3f0d7e50466ffa86071ee653b7>`_

- `Thu Oct 22 15:05:18 2020 -0400`

.. literalinclude:: ../environments/20.10/spack.yaml
   :language: yaml
