APP_NAME = Gogs: Go Git Service
RUN_USER = git
RUN_MODE = prod

[database]
DB_TYPE  = sqlite3
HOST     = 127.0.0.1:5432
NAME     = gogs
USER     = root
PASSWD   =
SSL_MODE = disable
PATH     = data/gogs.db

[repository]
ROOT = /data/git/gogs-repositories

[server]
DOMAIN       = TOKEN_EXTERNAL_DOMAIN
HTTP_PORT    = 3000
ROOT_URL     = TOKEN_EXTERNAL_URL
DISABLE_SSH  = true
SSH_PORT     = 22
OFFLINE_MODE = true

[mailer]
ENABLED = false

[service]
REGISTER_EMAIL_CONFIRM = false
ENABLE_NOTIFY_MAIL     = false
DISABLE_REGISTRATION   = false
ENABLE_CAPTCHA         = false
REQUIRE_SIGNIN_VIEW    = false

[picture]
DISABLE_GRAVATAR = true

[session]
PROVIDER = file

[log]
MODE      = file
LEVEL     = Info
ROOT_PATH = /app/gogs/log

[security]
INSTALL_LOCK = true
SECRET_KEY   = tGXGZIlmmrAGejM
