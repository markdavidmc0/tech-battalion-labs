!/bin/bash

sudo apt-get update && sudo apt -y install apache2


echo '<!doctype html><html><body><h1>Hello if you see this then you are in Production.!</h1></body></html>' | sudo tee /var/www/html/index.html