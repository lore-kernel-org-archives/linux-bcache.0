From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: Re: Bcache hangs with Debian 7 (Wheezy), sync does not come back
Date: Tue, 17 Sep 2013 14:34:52 -0700
Message-ID: <20130917213452.GD32037@kmo-pixel>
References: <loom.20130916T150548-751@post.gmane.org>
 <20130917020316.GC10907@kmo-pixel>
 <loom.20130917T122135-908@post.gmane.org>
 <20130917203741.GA32037@kmo-pixel>
 <loom.20130917T224603-574@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <loom.20130917T224603-574-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hubert Kempkensteffen <hubert-39zlLzowylnAQEp6PLVxx6xOck334EZe@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Tue, Sep 17, 2013 at 08:54:57PM +0000, Hubert Kempkensteffen wrote:
> Kent Overstreet <kmo@...> writes:
> 
> > 
> > Are you saying you've tested it both with and without software raid?
> > Which kind of raid (raid 1, 10, 5, etc.)?
> 
> Sorry, my english.
> I have no raid and no LVM. There are both ordinary machines.
> And I just want to speed up the data disk!

Oh, another question - were you running in writeback or writethrough
mode?
