# TeamStatus.TV

This is source code powering [TeamStatus.TV](https://teamstatus.tv)

## Developing on your machine

Install PostgreSQL and Redis

`brew install postgresql redis`

Install [pow](http://pow.cx/)

`curl get.pow.cx | sh`

Download dependencies

`bundle install`

Symlink to pow

`ln -sf $(pwd)/website ~/.pow/teamstatus`

Open in a browser

http://teamstatus.dev

### Troubleshooting

If you get `ActionController::InvalidAuthenticityToken` make sure that you access the site using teamstatus.dev, also make sure that `application.yml` has `COOKIE_DOMAIN` set correctly (should be `.teamstatus.dev`).