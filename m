From: "Gerrit Tamboer" <gtamboer-JFNXyGN8thM@public.gmane.org>
Subject: Quick howto?
Date: Mon, 9 Apr 2012 13:23:41 +0200
Message-ID: <001901cd1643$3801e2c0$a805a840$@snow.nl>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
References: 
In-Reply-To: 
Content-Language: nl
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi!

I am currently trying to test bcache stability in combination with the btrfs
filesystem. I am currently stuck with some unanswered questions and I was
hoping that someone could help me out on the following;

1. The documentation on the website is out of date, this means there is not
quickstart guide on how to actually use bcache. I was able to compile the
kernel with bcache support but how do I further configure it? I have a sata
disk on sda with sda1 and sda2 used for / and /home. My sdb is an
unformatted SSD which I want to use for caching. In this particular setup,
how do I configure the kernel to use sdb for caching sda1 and sda2?

2. Currently the git repo is a full kernel with bcache support, is there a
way to only fetch the bcache patch for other kernels? I have a linux box
with linux 2.6.x and I would like to patch bcache into it instead of
compiling 3.1.x and migrating to it.

3. If I would temporarily want to disable caching to do maintenance, is
there a way to flush the current queue to disk?

Thanks in advance!

Regards,

Gerrit Tamboer
