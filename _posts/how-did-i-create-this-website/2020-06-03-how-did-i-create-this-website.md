---
title: How did I create this website?
date: 2020-06-03 20:58:47 +03:00
modified: 2020-06-04 16:49:47 +03:00
tags: [unix/linux, server, hosting, jekyll, Klise]
description: Instructions of this website
image:
---

In this post we will be talking about how to set your own static website up, how to host it in your VPS and how to deploy it automatically with GitHub Webhooks when a push event happened in website's GitHub repository.

First things first, we'll be using Jekyll static website generator on Linux, Ruby for building our website and Ubuntu 19.10 built in our [VPS](https://en.wikipedia.org/wiki/Virtual_private_server).  Therefore, installation process may differ on other OS'es. If you're looking for building a static website with Windows instructions or using different Template/Language usage on development, see [further reading](http://www.dce4.me/how-did-i-create-this-website/#further-reading) section down below. In addition to my initial sentences, behold! Because substantially we'll be using Vim to edit things and if you are unexperienced about it, you may find yourself Googling ***how to quit Vim :(((((((***. Joking, its easy.

### Creating your website with Jekyll
Prerequisites:
- Ruby-Full
- Jekyll
- Bundler Gems


We can install Ruby with:
```bash
sudo apt-get install ruby-full build-essential zlib1g-dev
echo '# Install Ruby Gems to ~/gems' >> ~/.bashrc
echo 'export GEM_HOME="$HOME/gems"' >> ~/.bashrc
echo 'export PATH="$HOME/gems/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

and Jekyll:

```bash
gem install jekyll bundler
```

You can check the version with
```bash
ruby -v
```

After then, you can choose to start with a simple default theme of Jekyll, or choose to download one and make tweaks on it for yourself. If you wish to start with a default theme, then:

```bash
jekyll new newblog
cd newblog
bundle exec jekyll serve
```

and default template should be running at [http://localhost:4000](http://localhost:4000)

But if you wish to find a default theme and make tweaks on it, go to [here](https://jamstackthemes.dev/#ssg=jekyll) and look for one. Usually those website themes have a demo with them so you can check them out before start using them.

After you find your theme, download it from its source(usually GitHub) and change director(cd) in it. In our case, we will be using [Klisé](https://github.com/piharpi/jekyll-klise) as I did while building this website.

to download it from its GitHub source, simply clone and cd to it:
```bash
git clone https://github.com/piharpi/jekyll-klise.git
cd jekyll-klise
```

after then, we need to install the theme's gem dependencies while in the same directory by this command:

```bash
bundle install
```

and its going to install all gem dependencies which stated in the <b>Gemfile</b>. We can start changing the template according to our needs and desires. Files we should avoid changing are written in <b>.gitignore</b> file because these files are created or updated as we serve the website according to our configurations on other files. One of these directories is named as "\_site"  and this folder will be served as our website which we will explain in the next sections.

All posts located in \_posts folder and enhanced with useful and easy-to-use language named [Markdown](https://en.wikipedia.org/wiki/Markdown) hence you may need to check out [this cheat sheet](https://www.markdownguide.org/cheat-sheet/) to have an initial knowledge about it. Examples located within and there are the codes of this post aswell. :)
<figure>
<img src="/how-did-i-create-this-website/code.png" alt="">
<figcaption>This posts codes</figcaption>
</figure>

On the top of each post you'll see a section marked between three dashes(---) which named <b>front matter</b> and you can write this section either **JSON** or **YAML**. You can add a date, title, layout or more there. Please check the example usages of those so you'll be able to use them for your individual purposes.

# Hosting your website

### Hosting with GitHub Pages
After you create your website, we need to host it somewhere and we can think of the options to host our website. One of them-and easiest- is Using GitHub Pages and the other one is hosting our website at our <abbr title="Virtual Private Server">VPS</abbr> as I did. In my opinion, hosting it in our website is much educative and fun so I recommend you to do the same. But lets start with GitHub Pages option since its easier. We are starting with creating a GitHub Repository that has an extension of **"github.io"** :
<figure>
<img src="/how-did-i-create-this-website/github1.png" alt="">
<figcaption>Creating Repository</figcaption>
</figure>

Then clone this repo and copy-paste your all content. Don't forget to copy hidden files aswell. After then, you need to push the changes to your repo so you can turn on GitHub Pages settings to master branch from settings of this repo:

```bash
git add --all
git commit -m "initial commit"
git push -u origin master
```
After pushing the codes to new repo, we need to Turn On source options from settings:

<figure>
<img src="/how-did-i-create-this-website/github2.png" alt="">
<figcaption>Source Options</figcaption>
</figure>

It must be pretty much it. After then, you should be able to reach your blog from `yourblog.github.io`.

### Hosting on your own server
But if you want to put a little more effort and money to host your website on your own server, there is an another way. First of all, you need to rent a server first from VPS providers such as [Linode](https://www.linode.com) and [Digital Ocean](https://www.digitalocean.com) then you need to install dependencies to it. I'll be explaining how to serve a website with NGINX so mind that there are another options such as Apache.

I'm assuming you've already bought your server and made SSH connection to it, so I'm starting with installing NGINX and creating our config file:

```bash
sudo apt install nginx
cd /etc/nginx/conf.d/
sudo vim yoursite.com.conf
```
Your config file should like this before you made the changes on certain areas:

```bash
server {
    listen         80;
    listen         [::]:80;
    server_name    yoursite.com www.yoursite.com;
    root           /var/www/yoursite.com/_site;
    index          index.html;

    gzip             on;
    gzip_comp_level  3;
    gzip_types       text/plain text/css application/javascript image/*;
}
```

Then, we are creating our folder which we will serve our static files in and deleting default website NGINX has:
```bash
sudo mkdir -p /var/www/yoursite.com
sudo rm /etc/nginx/sites-enabled/default
```

Allowing NGINX and SSH-just in case- on our firewall with the code below, checking if NGINX is running:

```bash
sudo ufw allow 'NGINX Full'
sudo ufw allow ssh
sudo ufw enable
sudo systemctl status nginx
```
It's time to create our available site config and make a link to enabled sites with:

```bash
cd /etc/nginx/sites-available/
sudo vim yoursite.com
sudo ln -s /etc/nginx/sites-available/yoursite.com /etc/nginx/sites-enabled/yoursite.com
```
Our nginx/sites-available/yoursite.com file should look like this:

```bash
server {
    listen   80;
    server_name yoursite.com www.yoursite.com;
    root /var/www/yoursite.com/_site;

    location / {
            return 301 https://$host$request_uri;
    }
}
```
After we are done with configurations, we can install Ruby and Gems to our server, so it can build and deploy the website codes:

```bash
sudo apt-get install ruby-full build-essential zlib1g-dev
echo '# Install Ruby Gems to ~/gems' >> ~/.bashrc
echo 'export GEM_HOME="$HOME/gems"' >> ~/.bashrc
echo 'export PATH="$HOME/gems/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
gem install jekyll bundler
```

At this point, our site will be working under `/var/www/yoursite.com/_site` build it to `_site` folder and enter our machine IP address to browser. We need to get site files to our server machine, and we have options about doing it. We can use SCP-which I don't recommend- or we can push our site's codes to GitHub and clone it to our machine. I recommmend GitHub option because it's crucial to use GitHub if we want to have an automated deployment system.
If you haven't already, push your codes to GitHub. Then we are going to clone it to our home folder, then build from home folder to `/var/www/yoursite.com/_site`:

```bash
cd ~
git clone https://github.com/youruid/yoursite.com
cd yoursite.com
jekyll build --source ~/yoursite --destination /var/www/yoursite.com/_site/
```
And it should be working but it's not automatically deploying when a push happened in GitHub. So lets continue with Auto Deployment.

### Auto Deployment with GitHub Webhooks

We are going to use Flask to handle Webhook that comes from GitHub, and a small bash script to deploy our website. Let us start with installing ***pip*** and ***Flask*** :

```bash
sudo apt install python-pip
pip install Flask
```
Then we can create a Webhook handler and a script that is going to build the website to `_site` folder:

```python
#This is our Webhook handler, webhand.py
from flask import Flask
from flask import request
from flask import Flask
import subprocess
import os

app = Flask(__name__)

@app.route('/autodeploy', methods=['POST'])
def blogrefresh():
    script_path = "~/rebuildlat.sh"
    subprocess.call([os.path.expanduser(script_path)])
    return "Success"

if __name__ == "__main__":
    app.run(host='0.0.0.0') #place your server ip here.
```
This code listens 5000 port to incoming POST requests, and if when it have one, triggers our script.
Don't forget to change `0.0.0.0` with your server ip.

```bash
#This is our deploy script, rebuildlat.sh
#!/bin/bash

echo "Pulling latest from Git"
cd ~/yoursite.com && git pull origin master

echo "Building Jekyll Site";
jekyll build --source ~/yoursite.com --destination ~/_site/;
echo "Jekyll Site Built";

echo "Copying Site to /var/www/html/";
cp -rf ~/_site/* /var/www/yoursite.com/_site/;
echo "Site Rebuilt Successfully";
```
When its triggered, pulls the latest version of website located in GitHub to home folder, builds it to `home/user/_site` then copies all files in `_site` folder to `/var/www/yoursite.com/_site`

After we place those two files, we need to give them appropriate permissions to do their job.
```bash
chmod +x rebuildlat.sh
chmod +x webhand.py
sudo chown <username>:<usergroup> /var/www/yoursite
sudo ufw allow 5000/tcp
```

Only one step left before having our automated website, and this is creating a webhook and running the webhook handler in background. After we go to our repo settings, we'll see the Webhooks tab, and we can easily set a webhook there:
<figure>
<img src="/how-did-i-create-this-website/webhook.png" alt="">
<figcaption>Creating Webhook</figcaption>
</figure>
Mind that, it needs to use port ***5000*** and the specific URI we listen in ***webhand.py***

Lastly, we need to run webhook handler background and make sure it is still going to work after we finish SSH connection:
<br>`screen ~/webhand.py` then `CTRL+A` and `CTRL+D`




### Some tips and alerts
- Our webhook handler is vulnerable to some attacks at this point, we kept it that way intentionally to make it simple. Please do use your secret key given in webhook creation process before triggering the script and create a new low privileged user to handle all of this website deployment processes.
- Please feel free to get in touch if you have any trouble with a step, I would be more than happy to help.

### Sources
- [Giraffe Academy videos](https://www.youtube.com/playlist?list=PLLAZ4kZ9dFpOPV5C5Ay0pHaa0RJFhcmcB)
- [Creator of this theme I'm using](https://github.com/piharpi/jekyll-klise)
- [For auto deploy](https://ryanharrison.co.uk/2018/07/05/jekyll-rebuild-github-webhook.html)
- [Running processes background](https://medium.com/@arnab.k/how-to-keep-processes-running-after-ending-ssh-session-c836010b26a3)
### Further Reading
- [https://www.staticgen.com/](https://www.staticgen.com/) for different language/template combinations.
- [https://youtu.be/LfP7Y9Ja6Qc](https://youtu.be/LfP7Y9Ja6Qc) windows installation.
