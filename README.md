<img src="https://img.shields.io/github/issues/GnussonNet/dockerized-webserver" alt="issues">

<br />
<div align="center">
  <a href="https://github.com/othneildrew/Best-README-Template">
  <img src="https://github.com/GnussonNet/dockerized-webserver/blob/main/.github/logo.svg" alt="logo" width="80" height="80">
  </a>

  <h3 align="center">Dockerized Webserver with SSL</h3>

  <p align="center">
    This dockerized webserver is loaded with NGINX and<br /> Let's Encrypt certificate to establish a secure and stable website
    <br />
    <a href="https://github.com/GnussonNet/dockerized-webserver#about-the-project"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/GnussonNet/dockerized-webserver/issues/new?assignees=&labels=&template=bug_report.md">Report Bug</a>
    ·
    <a href="https://github.com/GnussonNet/dockerized-webserver/issues/new?assignees=&labels=&template=feature_request.md">Request Feature</a>
  </p>
</div>

## Table of Contents

<ol>
  <li>
    <a href="#about-the-project">About The Project</a>
    <ul>
      <li><a href="#built-with">Built With</a></li>
    </ul>
  </li>
  <li>
    <a href="#getting-started">Getting Started</a>
    <ul>
      <li><a href="#prerequisites">Prerequisites</a></li>
      <li><a href="#installation">Installation</a></li>
    </ul>
  </li>
  <li><a href="#usage">Usage</a></li>
  <li><a href="#contributing">Contributing</a></li>
  <li><a href="#license">License</a></li>
  <li><a href="#contact">Contact</a></li>
  <li><a href="#acknowledgments">Acknowledgments</a></li>
</ol>
  
## About the Project

<img title="Product Screenshot" alt="Product screenshot" src="https://github.com/GnussonNet/dockerized-webserver/blob/main/.github/preview.png">

Via a simple menu you can easily create and renew a webserver with  SSL certificates for free using [Let's Encrypts](https://letsencrypt.org/) client, called [Certbot](https://github.com/certbot/certbot). This docker image is modified from [Jonas Alfredssons](https://github.com/JonasAlfredsson) repository [docker-nginx-certbot](https://github.com/JonasAlfredsson/docker-nginx-certbot/blob/master/src/Dockerfile-alpine) and is "built on top of the official [official Nginx Docker images](https://github.com/nginxinc/docker-nginx)", alpine version. The script uses a modified arrow key menu by miu in a thread on stackexchange.com called [Arrow key/Enter menu](https://unix.stackexchange.com/a/673436).

## Built With
* [Docker](https://www.docker.com/)
* [NGINX](https://nginx.org/)
* [Bash (scripts)](https://www.gnu.org/software/bash/)

## Getting Started
This project is still in alpha which means it have not been tested on other machines, USE AT YOUR OWN RISK.

### Perquisites
Your system must have these following packages installed:

* [Docker](https://www.docker.com/)
* [Bash (scripts)](https://www.gnu.org/software/bash/)

### Installation
As mentioned above, USE AT YOUR OWN RISK.

1. Clone this repo and cd into directory
   ```sh
   git clone https://github.com/GnussonNet/dockerized-webserver.git && cd dockerized-webserver
   ```

2. Make the script executable
   ```sh
   chmod 700 webserver.sh
   ```

## Usage
This script is farley straight forward to use

1. Run the script
   ```sh
   ./webserver.sh
   ```

   Then follow the instructions on the screen

## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

## Contact

Filip "Gnusson" Magnusson - [@GnussonNet](https://twitter.com/GnussonNet) - admin@gnusson.net

Project Link: [Github.com/GnussonNet/dockerized-webserver](https://github.com/GnussonNet/dockerized-webserver)

## Acknowledgments
Special thanks to the below users who gave me a great start when creating this project.

* [Jonas Alfredssons](https://github.com/JonasAlfredsson) repository [docker-nginx-certbot](https://github.com/JonasAlfredsson/docker-nginx-certbot/blob/master/src/Dockerfile-alpine)
* Mius arrow menu [Arrow key/Enter menu](https://unix.stackexchange.com/a/673436)
* [othneildrews](https://github.com/othneildrew) readme template [Best README Template](https://github.com/othneildrew/Best-README-Template)
