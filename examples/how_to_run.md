# Webserver examples
This is a very easy and simple webserver. It uses one webserver config file (`webserver.conf`) and one html document (`frontend/index.html`).

## Run webserver
1. Run script (options -f and -c is optional)
    
    ```bash
    webserver -f <path_to_frontend_folder> -c <path_to_webserver.conf_file>
    ```

2. Select "Development Webserver" by pressing `space` followed by `enter`.

3. Select "Run webserver" by pressing `space` followed by `enter`.

4. Type your domain name (because you are in development this does not need to be a valid domain).

> Skip 5-6 if you entered your path to `frontend` and `webserver.conf` as a option in first step

5. Enter the path to `frontend`

6. Enter the path to `webserver.conf`

5. Choose a port between `1-9999`