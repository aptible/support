To view real-time logs for your app at any time, just run:

    aptible logs --app $APP_HANDLE

This will follow your app's `stdout` and `stderr` streams, and prefix each log line with the process label from your Procfile (e.g. `web` or `worker`), along with an integer identifying the app container which generated the logs.
