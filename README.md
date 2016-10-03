# cd-summit-ams-2016

To run this demo:

* Install Docker and Docker-compose
* Clone this repository where you can run docker and docker-compose commands
* Run from the command line:

```
# Preload data and prepare env
$ docker-compose -f ./prepare-docker-compose.yml up

... Wait a bit, time to load stuff...

# Launch the infrastructure
$ docker-compose up --build -d
```

Then, just open http://localhost:5500 to access the base page.

Credentials have been autoloaded:

* On Jenkins ( http://localhost:5500/jenkins/ ), it is `admin` for both user and password

* On Gogs ( http://localhost:5500/gitserver/ ), it is `butler` for both username and password.
