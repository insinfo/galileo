# Deploying an Angel instance underneath a `nginx` server on Ubuntu
This is pretty simple, and doesn't require much in the way of DevOps.

[![YouTube thumbnail](https://i.ytimg.com/vi/7tpO9vhUhf4/hqdefault.jpg)](https://www.youtube.com/watch?v=7tpO9vhUhf4&t=986s&list=PLl3P3tmiT-frEV50VdH_cIrA2YqIyHkkY&index=6)

Watch the video tutorial [here](https://www.youtube.com/watch?v=7tpO9vhUhf4&t=986s&list=PLl3P3tmiT-frEV50VdH_cIrA2YqIyHkkY).

1. Create unprivileged user `web`
  a. Can only operate in `/home/web`, where we'll host the application.
2. Install Dart for `web`
3. Set `ANGEL_ENV=production` in `web` account
4. Sync changes with the server
  a. Use SFTP
  b. Or, sync from a private Git repo
  c. Host a local Git server to sync changes
  d. Git version histories take up more space, so probably just use SFTP for this guide.
5. Set up `ufw` for `80`, `443`, `ssh`
6. Use `systemd` (comes with Ubuntu) to start server on system boot, and restart if it crashes
  a. https://askubuntu.com/questions/919054/how-do-i-run-a-single-command-at-startup-using-systemd
7. Basic nginx setup with `proxy_pass`
  * Don't run your application server as `root`
  * Serve static files via `nginx` instead of Angel
    * Even though `CachingVirtualDirectory` is extremely simple to use, it would be served via proxy
    * It's faster for `nginx` to serve your static files directly.
  