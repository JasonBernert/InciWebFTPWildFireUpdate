#Inciweb FTP Wildfire Data Pull

**A shell script for pulling up-to-date shapefiles from Inciweb's FTP and converting to GEOjson variables**


wget to download the latest files from urls listed in wildfireDownloadList.txt 
```
#!/bin/bash
wget -i wildfireDownloadList.txt -P nwcc_ftp_shapefiles/
```

Move to a sperate folder to stay organized
```
cd nwcc_ftp_shapefiles/
```

Timestamps any previous fire data to create an archive
```
DATE=$(date +%Y%m%d%H)
mv "NWCC_POINT_DAILY.geojson" "NWCC_POINT_DAILY"_$DATE.geojson
mv "NWCC_POLY_DAILY.geojson" "NWCC_POLY_DAILY"_$DATE.geojson
```

Converts the .shp into a GEOjson with ogr2ogr (GDAL)
```
ogr2ogr -f GeoJSON -t_srs crs:84 NWCC_POINT_DAILY.geojson NWCC_POINT_DAILY.shp
ogr2ogr -f GeoJSON -t_srs crs:84 NWCC_POLY_DAILY.geojson NWCC_POLY_DAILY.shp
```

Turns the GEOjson into a variable to be read by leaflet.js
```
echo 'var fires = ' | cat - NWCC_POINT_DAILY.geojson > temp && mv temp NWCC_POINT_DAILY.geojson
echo 'var perimeters = ' | cat - NWCC_POLY_DAILY.geojson > temp && mv temp NWCC_POLY_DAILY.geojson
```

Remove shapefiles
```
rm $(<../removeShapefiles.txt)
```

Remove JSON files older than 10 Days
```
find nwcc_ftp_shapefiles/ -mtime +10 -type f -delete
```
