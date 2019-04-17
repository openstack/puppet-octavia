Team and repository tags
========================

[![Team and repository tags](https://governance.openstack.org/tc/badges/puppet-octavia.svg)](https://governance.openstack.org/tc/reference/tags/index.html)

<!-- Change things from this point on -->

octavia
=======

#### Table of Contents

1. [Overview - What is the octavia module?](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [Setup - The basics of getting started with octavia](#setup)
4. [Implementation - An under-the-hood peek at what the module is doing](#implementation)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Beaker-Rspec - Beaker-rspec tests for the project](#beaker-rpsec)
7. [Development - Guide for contributing to the module](#development)
8. [Contributors - Those with commits](#contributors)
9. [Release Notes - Release notes for the project](#release-notes)
10. [Repository - The project source code repository](#repository)

Overview
--------

The octavia module is a part of [OpenStack](https://git.openstack.org), an effort by the OpenStack infrastructure team to provide continuous integration testing and code review for OpenStack and OpenStack community projects not part of the core software.  The module its self is used to flexibly configure and manage the scalable load balancer service for OpenStack.

Module Description
------------------

The octavia module is a thorough attempt to make Puppet capable of managing the entirety of octavia.  This includes manifests to provision region specific endpoint and database connections.  Types are shipped as part of the octavia module to assist in manipulation of configuration files.

Setup
-----

**What the octavia module affects**

* [Octavia](https://docs.openstack.org/octavia/latest/), the scalable load balancer service for OpenStack.

### Installing octavia

    octavia is not currently in Puppet Forge, but is anticipated to be added soon.  Once that happens, you'll be able to install octavia with:
    puppet module install openstack/octavia

### Beginning with octavia

To utilize the octavia module's functionality you will need to declare multiple resources.

Implementation
--------------

### octavia

octavia is a combination of Puppet manifest and ruby code to delivery configuration and extra functionality through types and providers.

Limitations
------------

* All the octavia types use the CLI tools and so need to be ran on the octavia node.

Beaker-Rspec
------------

This module has beaker-rspec tests

To run the tests on the default vagrant node:

```shell
bundle install
bundle exec rake acceptance
```

For more information on writing and running beaker-rspec tests visit the documentation:

* https://github.com/puppetlabs/beaker-rspec/blob/master/README.md

Development
-----------

Developer documentation for the entire puppet-openstack project.

* https://docs.openstack.org/puppet-openstack-guide/latest/

Contributors
------------

* https://github.com/openstack/puppet-octavia/graphs/contributors

Release Notes
-------------

* https://docs.openstack.org/releasenotes/puppet-octavia

Repository
----------

* https://git.openstack.org/cgit/openstack/puppet-octavia
