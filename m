From: luvar-2S8i3W4CjuIzjkFyG6Beag@public.gmane.org
Subject: Re: Installation of bcache
Date: Thu, 23 Dec 2010 21:30:42 +0100 (GMT+01:00)
Message-ID: <940839149.29381293136242461.JavaMail.root@shiva>
References: <236510559.29361293135943963.JavaMail.root@shiva>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <236510559.29361293135943963.JavaMail.root@shiva>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, info <info-2S8i3W4CjuIzjkFyG6Beag@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Hi,
----- "Kent Overstreet" <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On 12/16/2010 11:39 PM, LuVar wrote:
> > Hi,
> >
> > I have started an installation process of bcache. Till now I was (as
> an beginner foo in this type of tasks) able only to checkout (clone)
> an git repositories. Second one has tools. I had compiled them without
> problem.
> >
> > Iam having some troubles with second one repository. I had
> downloaded it (~317MB) and it appears to be an linux kernel. Iam
> running 2.6.34-gentoo-r12 kernel now and I want to keep this kernel
> and apply to its sources just patch, witch will add bcache
> functionality. Is it possible?
> 
> Just do a git diff v2.6.35...HEAD to get a patch. If that applies 
> cleanly against your gentoo kernel you should be good to go.

Sorry, Iam too lame in this area. Would you mind to send me exact commands which to run? ("git diff v2.6.35...HEAD" complained something about unknown version). I have now 2.6.36 kernel (which have some cache capability mentioned in Documentation/filesystems/caching/cachefiles.txt) in /usr/src/linux directory (symlinked). Your git repository I have cloned in my home dir.

PS: In few minutes Iam going to try your "TRIM whole ssd disk" script after running first iozone test on my new disk.

Have a nice Christmas time to all. (especially to them, who had bought a new ssd disk to himself :)
--
To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
