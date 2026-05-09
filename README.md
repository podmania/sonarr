# sonarr

Smart PVR for newsgroup and BitTorrent users.

Upstream: [Sonarr/Sonarr](https://github.com/Sonarr/Sonarr)  
Documentation: [wiki.servarr.com/en/sonarr](https://wiki.servarr.com/en/sonarr)

## Ports

- `8989` — Web UI

## Volumes

- `/config` — Configuration, database, logs

## Environment Variables

Variables use the format `SONARR__<SECTION>__<KEY>` (double underscores, case-sensitive). They override `config.xml` entries and require a restart to take effect.

### App

| Variable | Default | Description |
| --- | --- | --- |
| `SONARR__APP__INSTANCENAME` | `Sonarr` | Instance display name |
| `SONARR__APP__THEME` | _(default)_ | UI theme |
| `SONARR__APP__LAUNCHBROWSER` | `true` | Launch browser on start |

### Auth

| Variable | Default | Description |
| --- | --- | --- |
| `SONARR__AUTH__APIKEY` | _(auto-generated)_ | API key for external access |
| `SONARR__AUTH__ENABLED` | `false` | (Legacy) Enable authentication |
| `SONARR__AUTH__METHOD` | `None` | Auth method: `None`, `Basic`, `Forms` |
| `SONARR__AUTH__REQUIRED` | `Enabled` | When auth is required: `Enabled`, `DisabledForLocalAddresses` |

### Server

| Variable | Default | Description |
| --- | --- | --- |
| `SONARR__SERVER__PORT` | `8989` | HTTP port |
| `SONARR__SERVER__BINDADDRESS` | `*` | IP to bind to |
| `SONARR__SERVER__URLBASE` | _(empty)_ | URL base for reverse proxy (e.g. `/sonarr`) |
| `SONARR__SERVER__ENABLESSL` | `false` | Enable HTTPS |
| `SONARR__SERVER__SSLPORT` | _(empty)_ | HTTPS port |
| `SONARR__SERVER__SSLCERTPATH` | _(empty)_ | Path to SSL certificate |
| `SONARR__SERVER__SSLCERTPASSWORD` | _(empty)_ | SSL certificate password |

### Log

| Variable | Default | Description |
| --- | --- | --- |
| `SONARR__LOG__LEVEL` | `Info` | File log level: `Trace`, `Debug`, `Info`, `Warn`, `Error`, `Fatal` |
| `SONARR__LOG__CONSOLELEVEL` | _(empty)_ | Console log level |
| `SONARR__LOG__CONSOLEFORMAT` | _(default)_ | Console log format |
| `SONARR__LOG__ANALYTICSENABLED` | _(default)_ | Send anonymous usage data |
| `SONARR__LOG__FILTERSENTRYEVENTS` | _(default)_ | Filter Sentry error reports |
| `SONARR__LOG__SQL` | _(default)_ | Log SQL queries |
| `SONARR__LOG__ROTATE` | _(default)_ | Enable log file rotation |
| `SONARR__LOG__SIZELIMIT` | _(default)_ | Max log file size before rotation |
| `SONARR__LOG__DBENABLED` | _(default)_ | Enable database logging |
| `SONARR__LOG__SYSLOGSERVER` | _(empty)_ | Syslog server hostname |
| `SONARR__LOG__SYSLOGPORT` | `514` | Syslog server port |
| `SONARR__LOG__SYSLOGLEVEL` | _(same as Level)_ | Syslog log level |

### PostgreSQL

| Variable | Default | Description |
| --- | --- | --- |
| `SONARR__POSTGRES__HOST` | _(empty = SQLite)_ | PostgreSQL server hostname |
| `SONARR__POSTGRES__PORT` | `5432` | PostgreSQL server port |
| `SONARR__POSTGRES__USER` | _(empty)_ | PostgreSQL username |
| `SONARR__POSTGRES__PASSWORD` | _(empty)_ | PostgreSQL password |
| `SONARR__POSTGRES__MAINDB` | _(empty)_ | Main database name |
| `SONARR__POSTGRES__LOGDB` | _(empty)_ | Log database name |

### Update

| Variable | Default | Description |
| --- | --- | --- |
| `SONARR__UPDATE__MECHANISM` | `BuiltIn` | Update method: `BuiltIn`, `Script`, `External`, `Docker` |
| `SONARR__UPDATE__AUTOMATICALLY` | _(platform default)_ | Auto-install updates |
| `SONARR__UPDATE__SCRIPTPATH` | _(empty)_ | Path to custom update script |
| `SONARR__UPDATE__BRANCH` | `main` | Update branch: `main` or `develop` |

<a href="https://www.buymeacoffee.com/bhoehn" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="41" width="174"></a>
