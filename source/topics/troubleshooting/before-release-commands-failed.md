If any of the `before_release` commands in your `.aptible.yml` file fails (i.e., exits with a nonzero status code), the entire deploy will fail.

If this happens, the build log will contain the output of the `before_release` command that failed. This should aid in debugging the root cause of the problem but as always, if you have questions please [contact support](https://support.aptible.com/contact).
