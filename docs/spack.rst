E4S Distribution via spack.yaml
================================

22.08
-------

E4S 22.08 is based on Spack branch `e4s-22.08 <https://github.com/spack/spack/tree/e4s-22.08>`_. This release comes with
100+ full product releases. Shown below is the spack configuration from Univ of Oregon system. The specs are pushed to buildcache
which can be retrieved using the following commands

.. code-block:: console

    $ spack mirror add E4S https://cache.e4s.io/22.08
    $ spack buildcache keys -it

Shown below is the spack configuration for CUDA based build for X86_64 platform.

.. literalinclude:: ../environments/22.08/cuda-x86_64.spack.yaml
    :language: yaml

22.05
-------

E4S 22.05 is based on Spack branch `e4s-22.05 <https://github.com/spack/spack/tree/e4s-22.05>`_. This release comes with
100+ full product releases. Shown below is the spack configuration from Univ of Oregon system. The specs are pushed to buildcache
which can be retrieved using the following commands

.. code-block:: console

    $ spack mirror add E4S https://cache.e4s.io/22.05
    $ spack buildcache keys -it

Shown below is the spack configuration for CUDA based build for X86_64 platform.

.. literalinclude:: ../environments/22.05/cuda-x86_64.spack.yaml
    :language: yaml

22.02
-------

E4S 22.02 is based on Spack branch `e4s-22.02 <https://github.com/spack/spack/tree/e4s-22.02>`_. This release comes with
100 full product releases. Shown below is the spack configuration from Univ of Oregon system. The specs are pushed to buildcache
which can be retrieved using the following commands

.. code-block:: console

    $ spack mirror add E4S https://cache.e4s.io/22.02
    $ spack buildcache keys -it

.. literalinclude:: ../environments/22.02/spack-x86_64.yaml
    :language: yaml


21.11
-------

E4S 21.11 is based on Spack branch `e4s-21.11 <https://github.com/spack/spack/tree/e4s-21.11>`_. This release comes with
91 full product releases. Shown below is the spack configuration from Univ of Oregon system. The specs are pushed to buildcache
which can be retrieved using the following commands

.. code-block:: console

    $ spack mirror add E4S https://cache.e4s.io/21.11
    $ spack buildcache keys -it

.. literalinclude:: ../environments/21.11/spack-x86_64.yaml
    :language: yaml

21.08
-------

E4S 21.08 is based on Spack branch `e4s-21.08 <https://github.com/spack/spack/tree/e4s-21.08>`_. This release contains
88 full product releases. Shown below is the spack configuration from Univ of Oregon system. The specs are pushed to buildcache which
can be retrieved using the following commands

.. code-block:: console

    $ spack mirror add E4S https://cache.e4s.io/21.08
    $ spack buildcache keys -it

.. literalinclude:: ../environments/21.08/spack.yaml
    :language: yaml

21.05
------

The E4S 21.05 release is based on spack branch `e4s-21.05 <https://github.com/spack/spack/tree/e4s-21.05>`_ which comes with
76 full product releases. The specs are pushed to build cache which can accessed by running the following command:

.. code-block:: console

    $ spack mirror add E4S https://cache.e4s.io/21.05
    $ spack buildcache keys -it

Shown below is the spack configuration built at Univ of Oregon.

.. literalinclude:: ../environments/21.05/spack.yaml
   :language: yaml


21.02
------

E4S 21.02 is is based on spack tag `e4s-21.02 <https://github.com/spack/spack/releases/tag/e4s-21.02>`_ which comes
with 67 product releases. Shown below is the spack configuration built at Univ of Oregon machine.

.. literalinclude:: ../environments/21.02/spack.yaml
   :language: yaml

20.10
------

E4S 20.10 is the first release E4S that is distributed as a spack configuration (`spack.yaml`) that can be used by facilities to
install E4S stack from source. This release is based on Spack commit `e1e0bbb4cbe11a3f0d7e50466ffa86071ee653b7 <https://github.com/spack/spack/commit/e1e0bbb4cbe11a3f0d7e50466ffa86071ee653b7>`_.
This release comes with 67 product. Shown below is the spack configuration for Univ of Oregon.


.. literalinclude:: ../environments/20.10/spack.yaml
   :language: yaml
