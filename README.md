# traefik_compose

Reference: https://technotim.live/posts/traefik-3-docker-certificates/#links

# Configuration
1. Traefik Dashboard Password & .env
    1. Create the password if needed
        1. Install htpasswd on linux to generate the base64 password  
           `sudo apt update`  
           `sudo apt install apache2-utils`  
    
        1. Generate the credential pair  
        `echo $(htpasswd -nB admin) | sed -e s/\\$/\\$\\$/g`
        1. Add the variables to the .env file
        .env file
        ```
        TRAEFIK_DASHBOARD_CREDENTIALS=admin:<base64_taken>
        CF_API_EMAIL=<email>
        DOMAIN=<domain>
        ````
### Encrypt/Decrypt
.env
```
# encrypt
age -p .env > .env-encrypted
# decrypt
age -d .env-encrypted > .env
```
cf_api_token.txt 
```
# encrypt
age -p cf_api_token.txt > cf_api_token.txt-encrtpted 
# decrypt
age -d cf_api_token.txt-encrtpted  > cf_api_token.txt
```

# Deploy
### deploy_traefik_compose.sh
git clone https://github.com/guanz808/traefik_compose.git
This script does the following:
* clones the traefik_compose GitHub repository to the local computer  
* decrypts the .env-encrypted and cf_api_token.txt-encrtpted files  
* starts the docker compose stack 

deploy_traefik_compose.sh 
```
wget -O - https://raw.githubusercontent.com/guanz808/traefik_compose/main/deploy.sh | bash
```

To pull for changes from GitHub and redeploy run the following command:  
`./deploy.sh`

### Start the stack
`docker compose up -d --force-recreate`


