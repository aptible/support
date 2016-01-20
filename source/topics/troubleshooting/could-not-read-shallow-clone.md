Your app may fail to build with an error message including:

    error: Could not read COMMIT_HASH

    fatal: revision walk setup failed

    fatal: reference is not a tree: COMMIT_HASH


(Where `COMMIT_HASH` is a long hexadecimal number)

This error is caused by pushing from [a shallow clone][0]. Those are typically used by
CI and CD platforms in order to optimize build times.

To solve this problem, update your build script to run this command before pushing
to Aptible:

    git fetch --unshallow || true

  [0]: https://www.perforce.com/blog/141218/git-beyond-basics-using-shallow-clones
