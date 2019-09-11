# Overview

smaau -- smart monitoring and alert unit

## Usage

Shinken default user: admin
default password: admin

## Customize

put your customized config files under `/opt/etc`

## Continuous Delivery

A sample Jenkins Pipeline file is provided.

create a Pipeline project and provide build parameters as follow:

+ `GIT_URL` git repository URL
+ `IMG_CLI` image build command
+ `IMG_UID` UID for processes
+ `IMG_NAME` image name
+ `IMG_DEFAULT_TAG` default image tag
+ `IMG_PUSH_DELAY` delay on parallel tasks to wait for authentication
+ `IMG_REPO_HOST` image registry server
+ `IMG_REPO_NAMESPACE` image repository namespace
+ `CLOUD_CLI` cloud operation command
+ `CLOUD_API_HOST` cloud API server
+ `CLOUD_USER_AUTH` cloud user account credentials (must exist in Jenkins credentials storage)
+ `CLOUD_NAMESPACE` cloud application namespace
+ `CLOUD_APP_DEPLOYCONF` cloud application config name

## License

GNU Affero General Public License Version 3 or any later version.
