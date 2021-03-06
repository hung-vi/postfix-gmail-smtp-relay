# Postfix and gmail SMTP relay
Docker file for postfix using gmail as a SMTP relay

## Getting Started
These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites
Change your gmail account access for less secure apps follow the instruction below:
https://support.google.com/accounts/answer/6010255?hl=en

### Installing

1. Build image

```
docker build -t image_name .
```

2. Create a container from image

```
docker run -d --name container_name image_name
```

Create a container which run under a network
```
docker run --network=network_name -d --name container_name image_name
```


## Running the tests
1. SSH into docker container

```
docker exec -it container_name bash
```

2. Send an email to your_email_addr@gmail.com

```
mail -s "This is the subject" your_email_addr@gmail.com
CC:
This is the content
```
`Ctrl + D` (Windows) or `Cmd + D` (Mac OS X) to break

3. Check your inbox. The email should appear in your inbox

4. In case of email sending failed, check the log file for details

```
tail -f 1000 /var/log/mail.log
```

5. Grant permission to send email from other containers running under the network
Add subnet (i.e. 172.18.0.0/16) of the network to the `mynetworks` in `etc/postfix/main.cf` file

Example:
```
mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128, 172.18.0.0/16
```

Do postfix reload

```
postfix reload
```
