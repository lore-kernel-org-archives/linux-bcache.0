From: Piergiorgio Sartor <piergiorgio.sartor-KvP5wT2u2U0@public.gmane.org>
Subject: Re: Formatting of backing device
Date: Fri, 17 Feb 2012 00:17:54 +0100
Message-ID: <20120216231754.GA14206@lazy.lzy>
References: <20120201214443.GA8544@lazy.lzy>
 <CAHYUNGYyPafQzmwMdS-tRAPsYYM+9uRpN-38Av4uDJwtwY_d=A@mail.gmail.com>
 <20120202190122.GA2353@lazy.lzy>
 <20120202221101.GA26768@google.com>
 <20120202222431.GA7171@lazy.lzy>
 <loom.20120216T200235-190@post.gmane.org>
 <20120216203332.GA6597@lazy.lzy>
 <CA++fp8wcxTDJ=mbsKmWi27+yRZg-tyNdWgmhWU6=UeWgC0TZuw@mail.gmail.com>
 <20120216223554.GA6947@lazy.lzy>
 <CAOzFzEhO+6ECN-WjvtMK+-2g7Dwo+DPwQMVWuCZG=Y3BVRNEBw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAOzFzEhO+6ECN-WjvtMK+-2g7Dwo+DPwQMVWuCZG=Y3BVRNEBw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Cc: Piergiorgio Sartor <piergiorgio.sartor-KvP5wT2u2U0@public.gmane.org>, Alex Elsayed <eternaleye-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi joseph,

> Your reasoning is quite sound assuming the cache device is present at
> activation time.
> 
> In the case where the cache device has failed but the backing device
> has persisted the failure then the case looks somewhat more like this:
> 1) OS probes all devices, searches for caches and finds none.
> 2) Activate the raw backing device with possibly corrupt data....

as I mentioned, this is a bit borderline.

One reason is that it would be a failure in
any case, depending on what the system will
do with the backing device.

Second, as per md, the configuration could
be in a file in initramfs, which will allow
to support this type of failure *and* have
the backing device unformatted.

In other words, it does not need to be
activated automatically by kernel, it can
be done by the user, like md...

As wrote before, I'm fine with the formatting,
very clear and understandable.

bye,

-- 

piergiorgio
