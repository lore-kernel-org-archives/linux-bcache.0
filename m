From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: bcache hangs..
Date: Tue, 25 Sep 2012 16:32:49 -0700
Message-ID: <20120925233249.GE22647@google.com>
References: <CAPKZHbX86Jw6JYEkO8zSJqxXezXtEg_+mRGOSjzhz4NZHn-ueQ@mail.gmail.com>
 <loom.20120925T221213-151@post.gmane.org>
 <CAOzFzEiWDfot2KkWXGowvp4thY5o+rvWHNvW=ORZTHNeyucefQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAOzFzEiWDfot2KkWXGowvp4thY5o+rvWHNvW=ORZTHNeyucefQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Cc: Brad Walker <bwalker-WlSugiYO8JFBDgjK7y7TUQ@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Wed, Sep 26, 2012 at 08:21:44AM +1000, Joseph Glanville wrote:
> On 26 September 2012 06:12, Brad Walker <bwalker-WlSugiYO8JFBDgjK7y7TUQ@public.gmane.org> wrote:
> > Brad Walker <bwalker@...> writes:
> >
> >>
> >> I have a problem where BCache is hanging.
> >>
> >>
> >
> > Forgot to mention this is the latest BCache.
> >
> > I cloned it from the tree using
> >     git clone http://evilpiepirate.org/git/linux-bcache.git
> >
> > bwalker@nellis:~> uname -a
> > Linux nellis 3.6.0-rc3-0.5-default+ #1 SMP Tue Sep 25 11:12:26 MDT 2012 x86_64
> > x86_64 x86_64 GNU/Linux
> > bwalker@nellis:~>
> >
> > -brad w.
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Hi,
> 
> You might have better luck with the stable bcache branch, usually bcache-3.2

Yeah - sorry I've been quiet lately, but the bcache master branch is
based on my recent block layer work which is in flux and needs more
testing.

I have been continuing to fix bugs in the bcache-3.2 branch, though.

Once I get my block layer stuff in through making generic_make_request()
handle arbitrary size bios, I'll be spending more time on bcache again -
I'll rebase bcache master on top of that, and hopefully push it into
staging. Right now though my brain is stuffed full with this block layer
stuff, and it's really hard to switch back and forth :P
