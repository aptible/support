
You can set a maintenance page URL using the Aptible CLI when you've deployed a
version of your application that is failing. All 500 level errors will render
the URL set as `MAINTENANCE_PAGE_URL` until you can deploy fixes or roll your
application back to a working state.

`aptible config:set MAINTENANCE_PAGE_URL=[URL of static page]`
