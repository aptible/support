If any of the `before_release` commands in your `.aptible.yml` file fails (i.e., exits with a nonzero status code), the entire deploy will fail.

If this happens, the build log will contain the output of the `before_release` command that failed. This should aid in debugging the root cause of the problem but as always, if you have questions feel free to email us at [support@aptible.com](mailto:support@aptible.com).
