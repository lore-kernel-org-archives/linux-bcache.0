From: luvar-2S8i3W4CjuIzjkFyG6Beag@public.gmane.org
Subject: Re: Installation of bcache
Date: Sat, 25 Dec 2010 23:49:35 +0100 (GMT+01:00)
Message-ID: <510878981.29681293317375797.JavaMail.root@shiva>
References: <160099935.29661293317149028.JavaMail.root@shiva>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <160099935.29661293317149028.JavaMail.root@shiva>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, info <info-2S8i3W4CjuIzjkFyG6Beag@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Hi,

I have now a new questions. I had compiled kernel from your git (it doesnt have functional btrfs driver probably, because of kernel panic when mounting btrfs partition from fstab at startup). I am running it right now. I see sysfs interface to bcache. I had compiled make-bcache tool. Here I get stucked. According to http://bcache.evilpiepirate.org/GettingStarted and also according to documentation in Documentation/bcache.txt I should run something like this:

make-bcache -b128k /dev/sde

When I run this command (with 512k param), it will give me this error:
blacktroja bcache-tools # ./make-bcache -b512k /dev/sda1 
Must specify one of -C or -B
blacktroja bcache-tools #

I have had a look at make-bcache implementation and <delete>as Iam sw engineer I dont like it (I dont like also many of my own codes).</delete> I get lost in it. It seems that I should give it one of parameter B or C. If I give it C, it will affect bucket size. If Ill give it B, it will affect bucket size and some version field in some structure. I think that it will create writethrough or writeback cache from device. Is this right?

Questions:
1. What parameter should I use, if I want cache (write-back) my root filesystem located on top of raid (/dev/md2)?
2. Is it possible to cache root file system in write-back style? (yes, I found an answer on bcache web. I hope, initramfs wont kill me till new year...)
3. What to do in shutdown script to be all right? (all dirti blocks from writeback device copied to main device. So I can on next boot omit using cache -> if any problems setting up cache in initramfs)
4. Can I register 3 partitons of single ssd disk as three cache devices and associate them with concrete filesystems? (so for example /home partition will be cached on 5G cache partition and / partition will be cached on 10G cache partition) (I think this is not possible right now)

PS: I want to set up cache and try to make chart/graph for booting times of my desktop. I hope, it will be lovering after some reboots. If anybody want to catch any other parameter than booting time, let me know.

Have a nice feriae days,
--
LuVar

----- luvar-2S8i3W4CjuIzjkFyG6Beag@public.gmane.org wrote:

> Hi,
> ----- "Kent Overstreet" <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
> > On 12/16/2010 11:39 PM, LuVar wrote:
> > > Hi,
> > >
> > > I have started an installation process of bcache. Till now I was
> (as
> > an beginner foo in this type of tasks) able only to checkout (clone)
> > an git repositories. Second one has tools. I had compiled them
> without
> > problem.
> > >
> > > Iam having some troubles with second one repository. I had
> > downloaded it (~317MB) and it appears to be an linux kernel. Iam
> > running 2.6.34-gentoo-r12 kernel now and I want to keep this kernel
> > and apply to its sources just patch, witch will add bcache
> > functionality. Is it possible?
> >
> > Just do a git diff v2.6.35...HEAD to get a patch. If that applies
> > cleanly against your gentoo kernel you should be good to go.
> 
> Sorry, Iam too lame in this area. Would you mind to send me exact
> commands which to run? ("git diff v2.6.35...HEAD" complained something
> about unknown version). I have now 2.6.36 kernel (which have some
> cache capability mentioned in
> Documentation/filesystems/caching/cachefiles.txt) in /usr/src/linux
> directory (symlinked). Your git repository I have cloned in my home
> dir.
> 
> PS: In few minutes Iam going to try your "TRIM whole ssd disk" script
> after running first iozone test on my new disk.
> 
> Have a nice Christmas time to all. (especially to them, who had bought
> a new ssd disk to himself :)
--
To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
