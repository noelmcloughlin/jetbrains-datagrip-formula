
Changelog
=========

`1.0.2 <https://github.com/saltstack-formulas/jetbrains-datagrip-formula/compare/v1.0.1...v1.0.2>`_ (2020-07-28)
--------------------------------------------------------------------------------------------------------------------

Bug Fixes
^^^^^^^^^


* **cmd.run:** wrap url in quotes (zsh) (\ `bb6d8ed <https://github.com/saltstack-formulas/jetbrains-datagrip-formula/commit/bb6d8ed980a13c50a51def3a4dac54370232e6d6>`_\ )
* **macos:** correct syntax (\ `88c68f0 <https://github.com/saltstack-formulas/jetbrains-datagrip-formula/commit/88c68f02b110fd71f052b87f6b7b43edce8726c1>`_\ )
* **macos:** do not create shortcut file (\ `f4e2def <https://github.com/saltstack-formulas/jetbrains-datagrip-formula/commit/f4e2defa3d95f7939d7d04165ede52ba41c904c0>`_\ )
* **macos:** do not create shortcut file (\ `70e10f7 <https://github.com/saltstack-formulas/jetbrains-datagrip-formula/commit/70e10f7e2fd8c3e9f8cc22d724d642debf920eb8>`_\ )
* **macos:** do not create shortcut file (\ `94f39df <https://github.com/saltstack-formulas/jetbrains-datagrip-formula/commit/94f39df36aed9d11d8de499e010e63fc4c954e53>`_\ )

Code Refactoring
^^^^^^^^^^^^^^^^


* **jetbrains:** align all jetbrains formulas (\ `55cc389 <https://github.com/saltstack-formulas/jetbrains-datagrip-formula/commit/55cc3898ad8fab2f40749dc2a75575129ef38f6b>`_\ )

Continuous Integration
^^^^^^^^^^^^^^^^^^^^^^


* **kitchen:** use ``saltimages`` Docker Hub where available [skip ci] (\ `e6cc07d <https://github.com/saltstack-formulas/jetbrains-datagrip-formula/commit/e6cc07d11f4f34562b7cee32c29d81cf42fadfc7>`_\ )

Styles
^^^^^^


* **libtofs.jinja:** use Black-inspired Jinja formatting [skip ci] (\ `a3cae55 <https://github.com/saltstack-formulas/jetbrains-datagrip-formula/commit/a3cae55620d2d115052c651a549768ac6bfae91b>`_\ )

`1.0.1 <https://github.com/saltstack-formulas/jetbrains-datagrip-formula/compare/v1.0.0...v1.0.1>`_ (2020-06-15)
--------------------------------------------------------------------------------------------------------------------

Bug Fixes
^^^^^^^^^


* **edition:** better edition jinja code (\ `932c8d2 <https://github.com/saltstack-formulas/jetbrains-datagrip-formula/commit/932c8d2f3733eec2627c333d1e02d992f4771545>`_\ )

Continuous Integration
^^^^^^^^^^^^^^^^^^^^^^


* **kitchen+travis:** add new platforms [skip ci] (\ `f0e3519 <https://github.com/saltstack-formulas/jetbrains-datagrip-formula/commit/f0e3519c161d2b65393fff70fe9cde1b5d98d3d3>`_\ )
* **travis:** add notifications => zulip [skip ci] (\ `a6bf0b6 <https://github.com/saltstack-formulas/jetbrains-datagrip-formula/commit/a6bf0b6d0464a8376a88ebcfbb1845a01d9175c8>`_\ )

Documentation
^^^^^^^^^^^^^


* **readme:** format update (\ `d1ca6b2 <https://github.com/saltstack-formulas/jetbrains-datagrip-formula/commit/d1ca6b240988abe5fd34120f90fbb7e13957197b>`_\ )

1.0.0 (2020-05-14)
------------------

Continuous Integration
^^^^^^^^^^^^^^^^^^^^^^


* **kitchen+travis:** adjust matrix to add ``3000.3`` (\ `ec3be91 <https://github.com/saltstack-formulas/jetbrains-datagrip-formula/commit/ec3be91a9eaf5fd24ac3f3e6d5a83649ee074207>`_\ )

Documentation
^^^^^^^^^^^^^


* **readme:** add depth one (\ `c800f65 <https://github.com/saltstack-formulas/jetbrains-datagrip-formula/commit/c800f65d77a3ab7106aecc112bdbddcbc042267c>`_\ )

Features
^^^^^^^^


* **formula:** align to template-formula; add ci (\ `5f60355 <https://github.com/saltstack-formulas/jetbrains-datagrip-formula/commit/5f6035596b008599f484eb57125ff87888c9176c>`_\ )
* **formula:** align to template-formula; add ci (\ `9cd742b <https://github.com/saltstack-formulas/jetbrains-datagrip-formula/commit/9cd742bdb55acb934f211eb073a981d4173c959b>`_\ )
* **semantic-release:** standardise for this formula (\ `a84bdba <https://github.com/saltstack-formulas/jetbrains-datagrip-formula/commit/a84bdbafd85aa0d4a05f4d4178834aac32b78bb7>`_\ )

BREAKING CHANGES
^^^^^^^^^^^^^^^^


* **formula:** Major refactor of formula to bring it in alignment with the
  template-formula. As with all substantial changes, please ensure your
  existing configurations work in the ways you expect from this formula.
