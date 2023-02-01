# API Documentation

This project contains Open API Specification documents for Bink APIs. 
The project also uses the redoc-cli tool to convert YAML files to HTML. 

YAML or HTML files can be added to any directory within this project, once referenced in the `Dockerfile` they'll be included in all future builds until the reference is removed.

## Compiling a Open API Document:

Modify the Dockerfile to include your new Open API Document:

```dockerfile
RUN redoc-cli build battlestar/galactica.yaml --output /output/battlestar/galactica.html
```

## Including a HTML File:

Modify the Dockerfile to include your new HTML file:

```dockerfile
RUN mv battlestar/pegasus.html /output/battlestar/pegasus.html
```

## Configuring the Application

Configuration is performed in GitOps and requires modifying a TOML file that specifies a map of routes and files that are to be exposed for any given environment.

Using the above two examples of `battlestar/galactica.html` and `battlestar/pegasus.html` we can setup a TOML file like this:

```toml
[general]
"root_redirect_path" = "/bsg75"

[routes]
"bsg75" = "battlestar/galactica.html"
"bsg62" = "battlestar/pegasus.html"
```

If we were to fictionally deploy this to production, we'd be able to access the following URLs:

* https://docs.gb.bink.com/
    * Return Redirect to https://docs.gb.bink.com/bsg75
* https://docs.gb.bink.com/bsg75
    * Returns HTML within `battlestar/galactica.html`
* https://docs.gb.bink.com/bsg62
    * Returns HTML within `battlestar/pegasus.html`
* https://docs.gb.bink.com/routes
    * Returns JSON `{"routes":["bsg75","bsg62"]}`

## Enabling Password Authentication

Password authentication is handled within Kubernetes Ingress to keep things simple within this project.

As `ingress-nginx` is our Kubernetes Ingress system of choice, documentation for seting up .htaccess files can be found [here](https://kubernetes.github.io/ingress-nginx/examples/auth/basic/)

Please raise a ticket within the [DevOps Project](https://hellobink.atlassian.net/browse/devops) with the following information:

* The environment or FQDN
* The required routes to be protected by a password, e.g. `/bsg75`
* The usernames and passwords

## Enabling IP Authentication

IP Authentication is handled within the Azure Front Door Web Application Firewall, this is because the Documentation Server is unaware of Client IP Addresses after the various layers of network segmentation have been traversed. In a purely IPv6 world, this would not be an issue, but IPv4 ruins this for everybody.

Please raise a ticket within the [DevOps Project](https://hellobink.atlassian.net/browse/devops) with the following information:

* The environment or FQDN
* The required routes to be protected by the Web Application Firewall, e.g. `/bsg75`
* The allowed IP addresses

## Publicly available Doc Servers

* https://docs.gb.bink.com/
* https://docs.staging.gb.bink.com/
* https://docs.sandbox.gb.bink.com/
* https://docs.dev.gb.bink.com/
