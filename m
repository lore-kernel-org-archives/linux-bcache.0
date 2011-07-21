From: i- <itooo-xVucS5mfmt0AvxtiuMwx3w@public.gmane.org>
Subject: Git Repo lacks memory ?
Date: Thu, 21 Jul 2011 15:07:31 +0000 (UTC)
Message-ID: <loom.20110721T165958-17@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi,

Trying to clone the repository fails with the following error :

root@VM# git clone git://evilpiepirate.org/~kent/linux-bcache.git
Initialized empty Git repository in /root/bcache/linux-bcache/.git/
remote: fatal: Out of memory, realloc failed
remote: aborting due to possible repository corruption on the remote side.
fatal: early EOF
fatal: index-pack failed

Can you take a look ?

Thanks,
