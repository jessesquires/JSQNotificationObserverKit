# JSQNotificationObserverKit `gh-pages`

## Documentation

[Docs](http://www.jessesquires.com/JSQNotificationObserverKit/) generated with [jazzy](https://github.com/realm/jazzy). Hosted by [GitHub Pages](https://pages.github.com).

## Setup

The `gh-pages` branch includes `develop` as a [git submodule](http://git-scm.com/book/en/v2/Git-Tools-Submodules) in order to generate docs.

````bash
$ git clone https://github.com/jessesquires/JSQNotificationObserverKit.git
$ cd JSQNotificationObserverKit/
$ git checkout gh-pages
$ git submodule init
$ git submodule update
````

## Generate

````bash
$ ./build_docs.sh
````

## Preview

````bash
$ open index.html -a Safari
````

## Publish

````bash
$ ./publish_docs.sh
````
