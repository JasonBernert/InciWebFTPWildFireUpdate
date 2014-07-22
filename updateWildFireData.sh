#!/bin/bash
wget -i wildfireDownloadList.txt -P /Users/Download/Wherever/You/Want
cd nwcc_ftp_shapefiles/
DATE=$(date +%Y%m%d%H)
mv "NWCC_POINT_DAILY.geojson" "NWCC_POINT_DAILY"_$DATE.geojson
mv "NWCC_POLY_DAILY.geojson" "NWCC_POLY_DAILY"_$DATE.geojson
ogr2ogr -f GeoJSON -t_srs crs:84 NWCC_POINT_DAILY.geojson NWCC_POINT_DAILY.shp
ogr2ogr -f GeoJSON -t_srs crs:84 NWCC_POLY_DAILY.geojson NWCC_POLY_DAILY.shp
echo 'var fires = ' | cat - NWCC_POINT_DAILY.geojson > temp && mv temp NWCC_POINT_DAILY.geojson
echo 'var perimeters = ' | cat - NWCC_POLY_DAILY.geojson > temp && mv temp NWCC_POLY_DAILY.geojson
rm $(<../removeShapefiles.txt)
