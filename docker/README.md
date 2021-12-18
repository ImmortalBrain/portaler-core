# Running Portaler in a Docker container

TLDR:

0) Install curl
1) Curl the script
2) Curl the .env file
3) Fill-in stuff in the .env file
4) Launch script
5) Cry, because it doesn't work


**Disclaimer:** This guide was written by a hardware/operations engineer with limited Linux experience and not by the developer of Portaler.
The way I implemented everything is janky, very janky, but it does work. Hopefully someone better experienced than I am can fix this.
Most likely there are better ways to self-host Portaler but this is what i use. I am not responsible for any damage you do to your system while following this guide.

I tried my best to make this guide as newbie-friendly as possible so it should work even for people with basically no Linux experience.
In case you'll encounter an error during installation you can usually google it and find a fix without any problems. Asking on the discord server works too.

## Requirements

1) Any kind of Linux machine where you have root privileges and can access the terminal.
2) A public routable (preferably static) ip-address.
3) A Domain name you own.
4) Understanding on how DNS/domain names/routing/port-forwarding works. It isn't difficult, you can get the grasp of it in a couple hours
Finally, the combination of the above - a domain name poiting to your Linux machine that is reachable from the internet.

This guide was tested on **Debian 11**, but should work with almost any Linux distro.

### Explanation about domain names structure

Due to how Portaler is made you can't just use "yourdomain.com" for your domain name. You need to have a subdomain.
That means portaler needs to be accessible with yoursubdomain.yourdomain.com instead.
To create a subdomain, go to the DNS server provider you use (i use cloudflare for example) and add a CNAME record with your subdomain pointing to your domain.

You can either do it like this:

<img src="https://i.imgur.com/v5MKyO1.png" width="350px" alt="screenshot" />

Or you can do it like this:

<img src="https://i.imgur.com/9awWAkf.png" width="350px" alt="screenshot" />

Do not forget to also add a CNAME record for www (ex. www.subdomain.domain.com should point to subdomain.domain.com)
In the steps to follow I'll be using "yoursubdomain" and "yourdomain" as substitutes for the domain and subdomain names you own.

### Before your begin:

Register at github.com and get a github access token. You can learn how to get it here: [Creating a Personal Access Token](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token)

You don't need to select any permissions for you token.

You will need to create an application using [discord developer portal](https://discord.com/developers/applications). You can name it however you want.

Go to the "Bot" page and press Add Bot, check **Presence Intent** and **ServerMember Intent**.
On the OAuth2 page press "Add Redirect" and put there http://yoursubdomain.yourdomain.com/api/auth/callback. Don't forget to save changes.

You will need **ClientID**, **ClientSecret**, **PublicKey** from the "General Information" page and **Token** from the "Bot" page for the next steps.

Now that you have those values we can begin

## Steps

Connect to your server using ssh or, if you can access the gui, launch the terminal.

Root yourself by using `su` (or `sudo -i` if you have sudo installed)

Pick a folder. For this guide I will be using `/opt/docker-portaler`

```Shell
mkdir /opt/docker-portaler
cd /opt/docker-portaler
```

Install curl:

```Shell
apt-get update
apt-get install -y curl
```

Download the .env file and the install script and make it executable:

```Shell
curl https://raw.githubusercontent.com/Logoffski/portaler-core/docker_test/docker/install.sh --output ./install.sh
curl https://raw.githubusercontent.com/Logoffski/portaler-core/docker_test/docker/.env.docker --output ./.env.docker
chmod +x ./install.sh
```

Fill in all the values under "REQUIRED" in the `.env.docker` file:

You can use any text editor you like. If you are using Debian you will most likely have `Vim` and `nano` installed. If you've never used `Vim` before, I suggest you use `nano` instead.

If you don't have anything but `Vim` installed - you can either use google-fu and learn how to use it or just `apt-get install -y nano` to have `nano` installed

```Shell
nano .env.docker
```

Brief explanation of everything you need to edit:

**HOST=** Fill it with your domain name, not including the subdomain (ex. yourdomain.com and NOT yoursubdomain.yourdomain.com)

**SUBDOMAIN=** Fill it with your subdomain name, not including the domain name (ex. yoursubdomain and NOT yoursubdomain.yourdomain.com)

**ADMIN_KEY=** Chose one for yourself but don't make it too long

**CERTBOT_EMAIL=** Your valid email. It will be used for certbot notifications in case something goes wrong

**ACCESS_TOKEN=** Your github access token you've created in the beginning.

**DISCORD_REDIRECT_URI=** http://yoursubdomain.yourdomain.com/api/auth/callback (same stuff you've put into the Discord OAuth page)

**DISCORD_BOT_TOKEN=** Token from "Bot" page.

**DISCORD_PUBLIC_TOKEN**= PublicKey from "General Information" page.

**DISCORD_CLIENT_TOKEN**= ClientID from "General Information" page.

**DISCORD_SECRET_TOKEN**= ClientSecret from "General Information" page.

`ctrl-x` to exit, don't forget to save your changes.

Launch the script and pray to the gods it works. There will be several prompts for use input during the installation, dont miss those.

```Shell
./install.sh
```

It works? Wow, congratulations!