From: Javier Marcet <jmarcet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Raid5 slower with bcache
Date: Wed, 27 Mar 2013 19:42:50 +0100
Message-ID: <CAAnFQG-1YzRS_z1sKNWtN7hQfAY-FGuWJSj2Tbk918KZQs8jCQ@mail.gmail.com>
References: <CAAnFQG9Uafe2PLgA33Uve95W06hb_EHMOqC5FQg9mUbuH-hznw@mail.gmail.com>
 <20130327182536.GA22232@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130327182536.GA22232-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Linux BCache Mailing List <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On Wed, Mar 27, 2013 at 7:25 PM, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

> > I've been using bcache since last summer, caching a 4x3TB raid5.
> >
> > Last week one of my disks died so after replacing it, I also got a new
> > SSD and began to do some tests. There is something which, while not
> > proving anything, worries me anyway. Better than describing it, just
> > see this (caches were flushed before each hdparm):
>
> I think I may have finally figured this one out - bcache wasn't setting
> readahead_pages, and raid5/6 needs it to be set based on the number of
> devices in the array. Can you try the version I just pushed?

Sure. It's compiling right now, give me a few minutes and I'll report back.


--
Javier Marcet <jmarcet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
