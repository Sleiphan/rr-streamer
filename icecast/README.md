# Radio Revolt's Icecast Server

Welcome to Radio Revolt's Icecast server!
This server's responsibility is to serve audio and video streams to our listeners over the internet.

It does nothing more that just receive media streams from various sources, and send it to people who wants to listen in!

## Running the server for the first time

This section covers how to set up the server.

### Overview: The basic componenets

The icecast server has two main components:

- The Icecast executable
- The configuration file

The first component can be installed by simply running:

> apk update && apk add icecast

The configuration file decides the behaviour of the icecast server, and defines some values (e.g. passwords) for it to use while it is running.

### 1. Setting the password

The only thing you should need to do, is to run the script for setting the passwords in the configuration file.

Run that script with the following command:

> ./setup-icecast.sh

It requires you to set the following passwords:

- Admin password
- Source password
- Relay password

The admin password will be used by admins (Teknisk) to login to the admin web interface.

The source password will be used by any software (e.g. radiorevolt.no) to

The relay password is only required if you are going to setup any relay servers (other icecast servers reading from this icecast server). If you don't use any relay servers, just enter som gibberish for the relay password.

### 2. Starting the server

To start the server, run the following command:

> su -s /bin/sh -c "nohup icecast -c /rr-icecast.xml > /dev/null 2>&1 &" icecast

This command starts the server as the user "icecast". Icecast requires itself to be started as non-root, and the icecast user is a non root user. Note: the icecast user was generated when icecast was installed.

The ending ampersand (&) pushes the process to the background.

The "nohup" keyword makes sure that the command continues to run after you logout from the server.

## EMERGENCY! How do I start the server again?

Simply run the following command:

> su -s /bin/sh -c "nohup icecast -c /rr-icecast.xml > /dev/null 2>&1 &" icecast

This command assumes that you are running the command as a root user, and that the configuration file you want to use is "/rr-icecast.xml".

If you are logged in as a non-root user, run this command instead:

> nohup icecast -c /rr-icecast.xml > /dev/null 2>&1 &

## Why use Icecast?

Icecast servers are used worldwide to deliver audio and video streams. The main reason being that Icecast is specialized and optimized for delivering these streams to millions of people. They are also more secure and reliable, mainly because of their limited scope of responsibility.

## How to editi the configuration

To change the behaviour and variables used by the Icecast server, you must edit the file /rr-icecast.xml or whatever file you want to use as icecast configuration.

When you are done editing the file, you must restart the server. If the process is running in the foreground (e.g. you cannot enter any commands), then simply press ctrl+c.

To learn about Icecast scripting, check the docs at https://icecast.org/docs/.
