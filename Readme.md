Pull this image for docker hub:
```
docker pull legion2/ilias-test-docker
```

## Getting Started

client_id: `myilias`

## Users
### root
Login: `root`
Password: `password`
PHPSESSID: `3jjug62mvjau5urpe94sbr5vn4`
User ID: `6`

### test
Login: `test`
Password: `password`
PHPSESSID: `j9i00gspeannhe2jhmrpqh3297`
User ID: `274`

## Development
### New Ilias version
For new versions of Ilias the `templates/iliascleandb.sql` must be recreated.
Start the docker image and open `setup/setup.php` and do all Database Updates.
Use `mysqldump ilias > iliascleandb.sql` to create the `iliascleandb.sql`.
Replace the session expire date off all user sessions in the `usr_session` table with the placeholder `insertsessionexpiredate`.
