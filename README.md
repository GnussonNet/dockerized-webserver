[![contributors](https://img.shields.io/github/contributors/GnussonNet/dockerized-webserver.svg?style=for-the-badge)](https://github.com/GnussonNet/dockerized-webserver/graphs/contributors)
[![forks](https://img.shields.io/github/forks/GnussonNet/dockerized-webserver.svg?style=for-the-badge)](https://github.com/GnussonNet/dockerized-webserver/network/members)
[![stars](https://img.shields.io/github/stars/GnussonNet/dockerized-webserver.svg?style=for-the-badge)](https://github.com/GnussonNet/dockerized-webserver/stargazers)
[![issues](https://img.shields.io/github/issues/GnussonNet/dockerized-webserver.svg?style=for-the-badge)](https://github.com/GnussonNet/dockerized-webserver/issues)
[![license](https://img.shields.io/github/license/GnussonNet/dockerized-webserver.svg?style=for-the-badge)](https://github.com/GnussonNet/dockerized-webserver/blob/main/LICENSE)
[![LinkedIn](https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555)](https://linkedin.com/in/gnussonnet)
  
<br />
<div align="center">
  <a href="https://github.com/GnussonNet/dockerized-webserver">
  <img src="https://github.com/GnussonNet/dockerized-webserver/blob/main/.github/logo.svg" alt="logo" width="150" height="150">
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

<br />

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
      <li><a href="#uninstall">Uninstall</a></li>
    </ul>
  </li>
  <li>
    <a href="#usage">Usage</a>
    <ul>
      <li><a href="#setup-webserver">Setup Webserver</a></li>
      <li><a href="#webserver-command-line-options">Command-line options</a></li>
    </ul>
  </li>
  <li><a href="#contributing">Contributing</a></li>
  <li><a href="#license">License</a></li>
  <li><a href="#contact">Contact</a></li>
  <li><a href="#acknowledgments">Acknowledgments</a></li>
</ol>
  
<br />

## About the Project
<img title="Product Screenshot" alt="Product screenshot" src="https://github.com/GnussonNet/dockerized-webserver/blob/main/.github/preview.png">

Via a simple menu you can easily create and renew a webserver with  SSL certificates for free using [Let's Encrypts](https://letsencrypt.org/) client, called [Certbot](https://github.com/certbot/certbot). This docker image is modified from [Jonas Alfredssons](https://github.com/JonasAlfredsson) repository [docker-nginx-certbot](https://github.com/JonasAlfredsson/docker-nginx-certbot/blob/master/src/Dockerfile-alpine) and is "built on top of the official [official Nginx Docker images](https://github.com/nginxinc/docker-nginx)", alpine version. The script uses a modified arrow key menu by miu in a thread on stackexchange.com called [Arrow key/Enter menu](https://unix.stackexchange.com/a/673436).

<br />

## Built With
* [Docker](https://www.docker.com/)
* [NGINX](https://nginx.org/)
* [Bash (scripts)](https://www.gnu.org/software/bash/)

<br />

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
   sudo curl -o /usr/local/bin/webserver -L https://github.com/GnussonNet/dockerized-webserver/releases/download/1.0.1-alpha/webserver && sudo chmod +x /usr/local/bin/webserver
   ```
   
### Uninstall
For now simply remove the file form /usr/local/bin with `rm` (DO AT YOUR OWN RISK)

1. Clone this repo and cd into directory
   ```sh
   sudo rm -rf /usr/local/bin/webserver
   ```

<br />

## Usage
This script is farley straight forward to use

### Setup Webserver
1. Run the script
   ```sh
   webserver [OPTIONS] [ARGUMENTS]
   ```

   Then follow the instructions on the screen

### Webserver command-line options
Option | Values  | Description
---|---|---
-m | `dev/development` `prod/production` | Skips first question regarding dev/prod menu | null
-d | `domain.com` | Your domain is passed to Certbot and NGINX | null
-f | `PATH to frontend directory` | Path to your frontend directory | null
-c | `PATH to nginx config file` | Path to your nginx config file | null
-p | `0-9999` | Port to expose host (only development) | null
-e | `name@domain.com` | Email to register certificate (passed directly to Certbot) | null


<br />

## Contributing
Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<br />

## License
Distributed under the MIT License. See `LICENSE` for more information.

<br />

## Contact
Filip "Gnusson" Magnusson - [@GnussonNet](https://twitter.com/GnussonNet) - admin@gnusson.net

Project Link: [Github.com/GnussonNet/dockerized-webserver](https://github.com/GnussonNet/dockerized-webserver)

<br />

## Acknowledgments
Special thanks to the below users who gave me a great start when creating this project.

* [Jonas Alfredssons](https://github.com/JonasAlfredsson) repository [docker-nginx-certbot](https://github.com/JonasAlfredsson/docker-nginx-certbot/blob/master/src/Dockerfile-alpine)
* Mius arrow menu [Arrow key/Enter menu](https://unix.stackexchange.com/a/673436)
* [othneildrews](https://github.com/othneildrew) readme template [Best README Template](https://github.com/othneildrew/Best-README-Template)
