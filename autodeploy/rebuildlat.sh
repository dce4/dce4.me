#!/bin/bash

echo "Pulling latest from Git"
cd ~/<repositoryname> && git pull origin master

echo "Building Jekyll Site";
jekyll build --source /home/<user>/<repositoryname> --destination /home/<user>/_site/;
echo "Jekyll Site Built";

echo "Copying Site to /var/www/html/";
cp -rf /home/<user>/_site/* /var/www/<repositoryname>/_site/;
echo "Site Rebuilt Successfully";

