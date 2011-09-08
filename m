From: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: New stuff up in git
Date: Thu, 8 Sep 2011 01:49:11 -0700
Message-ID: <CAC7rs0tjhf73fRGE6rvVGjiCGc1coCAZTQNFqoC0iAn+YmGZng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Damien Churchill <damoxc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mark Hills <mark-UrrBsZIrrsb10XsdtD+oqA@public.gmane.org>, xiaoqiangnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Justin Rush <jarush-Ub+6UvMsOfg@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

I just finished updating both the bcache (off 2.6.34) and the
bcache-3.1 branches with the latest stable code.

Also got cgit set up and working, finally. Need to stick a link in the
wiki to it..

http://evilpiepirate.org/git

I still haven't figured out how to pack a git repository so cloning it
doesn't take > 80% of my linode's ram, but cloning works for me so I'm
done screwing with it for now.

The bcache branch compiles but hasn't been tested. I don't expect any
issues though, it's pretty close to what I normally develop/test on.

The bcache-3.1 branch still doesn't quite compile, but it's pretty
close - I'm try and get a working version pushed tomorrow, I did boot
a linux 3.1 + bcache kernel at one point...
