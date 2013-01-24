From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Creating a patch against upstream kernel 3.7.4
Date: Thu, 24 Jan 2013 15:41:47 -0800
Message-ID: <20130124234147.GP26407@google.com>
References: <50FF3EA9.1020109@crc.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <50FF3EA9.1020109-tY1ak9Q0PTWHXe+LvDLADg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steven Haigh <netwiz-tY1ak9Q0PTWHXe+LvDLADg@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Wed, Jan 23, 2013 at 12:36:41PM +1100, Steven Haigh wrote:
> Hi all,
> 
> I'm quite a n00b when it comes to the ins and outs of using git...
> My last real project using something like this was when CVS was all
> the rage!
> 
> I'm wanting to try to make an automated method to create a single
> patch file for all the changes required against the upstream kernel
> version. This will allow me to easily manage changes until things
> are merged. It will also allow a one-liner in my Xen Dom0 scripting
> to let me patch bcache into the kernel (good!).
> 
> Does git have a way to do this?

Yeah. You don't have to deal with actual patches. Just clone one
repository, then add the other as a remote

cd linux-bcache
git remote add linux-stable git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
git fetch --all

git checkout bcache
git merge linux-stable/linux-3.7.y

Later, to get the latest linux-stable changes you can just rerun that
git merge command, but when I update the bcache branch since I always
force update/rewrite history you'll have to reset and start over:

git reset --hard origin/bcache
git merge linux-stable/linux-3.7.y

> I just tried to check out the bcache tree, but I just got:
> $ git clone http://evilpiepirate.org/git/linux-bcache.git
> Initialized empty Git repository in /home/netwiz/linux-bcache/.git/
> error: RPC failed; result=22, HTTP code = 405

Old version of git that doesn't support http redirects - you'll need to
upgrade git, or use
git clone http://atlas.evilpiepirate.org/git/linux-bcache.git
