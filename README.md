# Seafile to mkdocs

This is an [mkdocs](https://github.com/mkdocs/mkdocs) project to show [Seafile documentation](https://github.com/haiwen/seafile-docs) into a web site with HTML pages.

# Usage

## Static files

Pre-built HTML static files for different languages are in ``site_*`` subfolders.
Just serve these file with an http server and browse them.

## Build localized documentation

[WIP]

To use it, please follow next lines:
```bash
$ git clone https://github.com/felag/seafile-mkdocs
[…]
$ cd seafile-mkdocs
$ git clone https://github.com/felag/seafile-docs
[…]
$ cd seafile-docs
$ git checkout translation
$ cd build_tools
$ ./prepare_mkdocs.sh
$ cd ..
$ mkdoc serve
```

## License

Licence is the same one as seafile-docs license.
