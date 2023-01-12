# simple-bash
me bash for do stuff

## Installation

### Ubuntu
Run the following command to clone the repository, and install the dependencies:

```sh
git clone https://github.com/johnyww/simple-bash.git
cd simple-bash
sudo su
chmod +x script-ubuntu-all-in-one.sh
sudo ./script-ubuntu-all-in-one
```

start the server with the following command:

```sh
npm start #or yarn start
```
Now the server is running on http://localhost:3000

### Raspberry Pi
Docker image is available at [Docker Hub](https://hub.docker.com/).

run the following command to pull and run the docker image.

```sh
docker pull 
docker run -p 3000:3000 
```
This will start the server on port 3000. You can access the server at http://localhost:3000/, And can change the port by changing the -p option to `-p <port>:3000`.

You can add `-d` flag to run the server in detached mode.
