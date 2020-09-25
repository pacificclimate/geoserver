# geoserver
![Docker Publishing](https://github.com/pacificclimate/geoserver/workflows/Docker%20Publishing/badge.svg)

PCIC's custom geoserver image used primarily to serve BC Region data for Plan2Adapt
## Configuration

GeoServer is built with default variables and config overrides. Details are below: 

### Environment Variables

`JAVA_OPTS`
* Defaults to `JAVA_OPTS=-Xms128m -Xmx512m -XX:MaxPermSize=512m`
* When setting Xms and Xmx remember that there is a memory limit in the docker-compose file

`GEOSERVER_HOME`
* Defaults to `GEOSERVER_HOME=/opt/geoserver`
* GeoServer Home - if you're changing this, make sure you also update `GEOSERVER_DATA_DIR`

`GEOSERVER_DATA_DIR`
* Defaults to `GEOSERVER_DATA_DIR=/opt/geoserver/data_dir`
* You can override this and mount in a separate GeoServer data dir 

### Config Overrides

`webapps/geoserver/WEB-INF/web.xml`
* This override allows CORS 

`data_dir/security/usergroup/default/users.xml` and `data_dir/security/masterpw.digest`
* Configure users in GeoServer

`data_dir/global.xml`
* Configure contact info 

`data_dir/workspaces/bc_regions` and `data_dir/data/bc_regions`
* Provide BC Regions files 

## Releasing

Creating a versioned release involves:

1. Summarize the changes from the last release in `NEWS.md`
2. Commit these changes, then tag the release:

  ```bash
git add NEWS.md
git commit -m"Bump to version x.x.x_xx"
git tag -a -m"x.x.x_xx" x.x.x_xx
git push --follow-tags
  ```
