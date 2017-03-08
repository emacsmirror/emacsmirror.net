---
layout: default
---

The Emacsmirror is a growing collection of [Emacs] Lisp packages.  All
mirrored packages are available as [Git] repositories.  In most cases
this is done by mirroring the upstream Git repository, but if upstream
uses something else, then the mirror nevertheless makes the package
available as a Git repository.

<img src="/assets/emacsmirror.png">

One primary purpose of the Emacsmirror is to provide a comprehensive
list of available Emacs packages, including packages that have gone
out of fashion (but might later prove to be useful still).

Older efforts attempting to provide a comprehensive list of available
packages, such as the [Emacs Lisp List][ell], over time collected an
impressive list of dead links to packages that were no longer
available anywhere.

With the Emacsmirror this won't happen.  If a package's upstream
disappears, then a copy remains available on the mirror.  Once its
upstream has disappeared a package is usually moved from the
[Emacsmirror] to the [Emacsattic], where it is no longer updated. (The
Emacsattic is a Github "organization" separate from the Emacsmirror
organization, but it is considered part of the Emacsmirror project.)

If other mirrored packages still depend on a package whose upstream
has disappeared or no longer maintains the package, then it is copied
to the [Emacsorphanage].  The Emacsmirror then mirrors that repository
from the orphanage.  The orphanage repository serves as a temporary
home until someone volunteers to take over as maintainer.  While a
package is in the orphanage, the maintainer of the Emacsmirror makes
an effort to merge pull requests from users.

Note that in the past I have sometimes removed packages completely,
instead of moving them to the attic, but going forward that should
only happen in exceptional cases.

<br/><br/>

***Please consider supporting my work on the Emacsmirror and related
tools such as [`epkg.el`] and [`borg.el`] by [making a donation](/donate).***

<center><img class="clear" width="16" height="16" src="https://assets-cdn.github.com/images/icons/emoji/unicode/2764.png"></center>

Using the Emacsmirror
=====================

As mentioned above, you could use the Emacsmirror to obtain packages
that are not available anywhere else anymore.  Likewise you could get
a package from the mirror in form of a Git repository, even if
upstream doesn't use Git, which would be useful e.g. if you prefer to
install packages as Git submodules.

A package's Emacsmirror or Emacsattic repository on Github is usually
among the top results when doing a web serch for `<package-name>
emacs`, so you don't need anything but a browser and Git, to use the
mirror like this.  However...

Getting a local copy
--------------------

To make full use of the Emacsmirror, you should obtain a local copy,
which you can do by cloning the [`epkgs`][epkgs] repository.

{% highlight shell %}
git clone git@github.com:emacsmirror/epkgs.git ~/.emacs.d/epkgs
{% endhighlight %}

This repository contains:

* A SQLite database with information about all mirrored packages, as
  well as all shelved packages (those in the attic) and all built-in
  packages.
* Submodules for all mirrored and shelved packages.  (If you don't
  want to use these submodules, then you can just forgo checking them
  out.)

Browsing the database with epkg.el
----------------------------------

The [`epkg.el`] package provides a user interface for browsing the
[Emacsmirror package database][epkgs].  It is very similar to the
interface provided by `package.el`, but there is more information and
some goodies.

But Epkg isn't a package manager.  See [this blog post][20160517] for
information about the related [`borg.el`] package manager.

`epkg.el` can be installed from Melpa using `M-x install-package RET
epkg RET`.  Installation and usage instructions can be found
in [the manual](/manual/epkg).

<img src="/assets/epkg.png">

Checking out submodules
-----------------------

All mirrored and shelved packages are tracked as submodules of the
`epkgs` repository.  The Emacsmirror modules are located inside
`mirror/` and the Emacsattic modules are located inside `attic/`.

To checkout all modules run:

{% highlight shell %}
cd ~/.emacs.d/epkgs
git submodule init
git submodule update
{% endhighlight %}

If you only want to checkout the modules for the mirrored packages,
then you could use `git submodule init mirror/` instead.

Run the `git submodule` subcommands `init` and `update` separately, do
not use `update --init`.  If the update step fails e.g. due to network
issues, then it helps if the `init` step is already complete.

If `update` fails to clone one module, then it unfortunately does not
proceed with the remaining modules.  If that happens, then first try
to update just that one package using `update mirror/<package>`.  If
that fails again, then there probably is an issue on the Emacsmirror,
and you should skip the package using `deinit mirror/<package>`.  Then
resume updating the remaining modules, but limit which modules are
updated.  For example if `foobar` failed, then use `update
mirror/[f-z]*` to avoid wasting time on the modules named `attic/*`
and `mirror/[a-e]*`.

In `.gitmodules` all urls have the form
{% highlight shell %}
git@github.com:[emacsmirror|emacsattic]/<package>.git
{% endhighlight %}
but if you prefer
{% highlight shell %}
https://github.com/[emacsmirror|emacsattic]/<package>.git
{% endhighlight %}

then you can either edit `.git/config` accordingly after running
`init` but before running `update`, or you could rewrite all such urls
using

{% highlight shell %}
git config --global url.https://github.com/.insteadOf git@github.com:
{% endhighlight %}

Once you have checked out the modules you can no longer use Magit in
the super repository &mdash; even just `git status` takes twenty
seconds.

Adding new packages
-------------------

Most packages that are available from Melpa are also available from
the Emacsmirror.  New packages are added to Melpa on a regular basis
and after a short delay these packages are also semi-automatically
added to the Emacsmirror.  So there is no need to ask for new Melpa
additions to be added to the Emacsmirror too.  It will happen, but it
might take a few days.

To get a new package added to the mirror add it to Melpa instead.
That way Melpa users benefit too.

Some packages that have been available from Melpa for a long time are
not available from the Emacsmirror.  See [these lists][not-mirror] and
[these pages][stats] for the various reasons.

If, after consulting these resources, you still think that it makes
sense to ask me to add a particular package, then please
[open an issue][issues].

What the Emacsmirror is not
---------------------------

The Emacsmirror isn't an Elpa package archive.  While it could be used
to provide such an archive, I don't think that there is a need for
that because [Melpa] already serves that purpose very well.

But like the Emacsmirror misses some package that are available from
Melpa, Melpa too isn't complete.  [Here][not-melpa] you can find some
lists of such packages, in case you would like to help making Melpa
more complete.

<br/><b/>

*Page [CC BY 3.0](https://creativecommons.org/licenses/by/3.0)
by    [Jonas Bernoulli](https://emacsair.me),
image [CC BY-NC-SA 2.0](https://creativecommons.org/licenses/by-nc-sa/2.0)
by    [David Bygott](https://www.flickr.com/photos/davidbygott).*

[Emacsmirror]:    https://github.com/emacsmirror
[Emacsattic]:     https://github.com/emacsattic
[Emacsorphanage]: https://github.com/emacsorphanage
[epkgs]:          https://github.com/emacsmirror/epkgs
[issues]:         https://github.com/emacsmirror/p/issues/new
[`epkg.el`]:      https://github.com/emacscollective/epkg
[`borg.el`]:      https://github.com/emacscollective/borg
[stats]:          /stats/
[not-mirror]:     /stats/compare.html#org56f65cd
[not-melpa]:      /stats/melpa-missing.html

[20160517]: https://emacsair.me/2016/05/17/assimilate-emacs-packages-as-git-submodules

[Emacs]: https://www.gnu.org/software/emacs/emacs.html
[Git]:   https://git-scm.com

[Melpa]: https://melpa.org
[ell]:   http://damtp.cam.ac.uk/user/sje30/emacs/ell.html
