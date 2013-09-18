From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: Re: [PATCH] bcache: Possible flush fix
Date: Wed, 18 Sep 2013 13:43:03 -0700
Message-ID: <20130918204303.GC19161@kmo-pixel>
References: <loom.20130916T150548-751@post.gmane.org>
 <20130917020316.GC10907@kmo-pixel>
 <loom.20130917T122135-908@post.gmane.org>
 <20130917203741.GA32037@kmo-pixel>
 <loom.20130917T224603-574@post.gmane.org>
 <20130917214043.GF32037@kmo-pixel>
 <loom.20130918T134845-142@post.gmane.org>
 <20130918202809.GB19161@kmo-pixel>
 <loom.20130918T223347-893@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <loom.20130918T223347-893-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hubert Kempkensteffen <hubert-39zlLzowylnAQEp6PLVxx6xOck334EZe@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Wed, Sep 18, 2013 at 08:39:10PM +0000, Hubert Kempkensteffen wrote:
> Kent Overstreet <kmo@...> writes:
> 
> 
> > > I am currently testing the patch. (writethrough)
> > > The kernel is: git clone http://evilpiepirate.org/git/linux-bcache.git
> > 
> > What branch?
> > 
> 
> I thing:  Head bcache-3.10-stable
> 
> I had also already tested 3,10,11.
> The result was basically the same, but I had not enough time.
> Early morning I can say more.

I just rebased bcache-3.10-stable and added the fix you tested to it.

Also, HEAD in the bcache repository now points to bcache-3.10-stable and
not bcache-for-3.10.

Can you run echo t > /proc/sysrq-trigger when things get stuck, and give
me the full dmesg output?
