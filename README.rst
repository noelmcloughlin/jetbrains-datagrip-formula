========
jetbrains-datagrip
========

Formula for DATAGRIP IDE from Jetbrains. Standard edition. For Linux and MacOS.

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``datagrip``
------------

Downloads, and unpacks, the archive from Jetbrains website and installs IDE to the Operating System.

.. note::

    The latest available release will always get installed.


``datagrip.developer``
------------
Create Desktop shortcuts. Optional shared preference file handling.


``datagrip.linuxenv``
------------
On Linux, the PATH is set for all system users by adding software profile to /etc/profile.d/ directory. Full support for linux alterntives system in supported Linux distributions (i.e. not Archlinux derivatives).

.. note::

    Enable alternatives system by setting nonzero 'altpriority' pillar value; otherwise feature is disabled.

