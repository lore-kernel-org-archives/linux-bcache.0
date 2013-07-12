From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: Re: kernel 3.10 + applied bcache patches unable to handle kernel
 NULL pointer dereference
Date: Fri, 12 Jul 2013 01:19:01 -0700
Message-ID: <20130712081901.GB8339@kmo-pixel>
References: <51D542EB.7070404@profihost.ag>
 <51D56066.80106@profihost.ag>
 <20130712014017.GE17799@kmo-pixel>
 <51DF9E21.3060601@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51DF9E21.3060601-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefan Priebe - Profihost AG <s.priebe-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Fri, Jul 12, 2013 at 08:11:45AM +0200, Stefan Priebe - Profihost AG wrote:
> Am 12.07.2013 03:40, schrieb Kent Overstreet:
> > On Thu, Jul 04, 2013 at 01:45:42PM +0200, Stefan Priebe - Profihost AG wrote:
> >> fix is this one: http://pastebin.com/raw.php?i=LBFJRvEt
> > 
> > Oh I see, the patch that introduced this is an old version of the patch
> > - the bcache-for-3.11 had this fixed, and I forgot to update that
> > branch. Thanks, I'll apply it there.
> 
> thanks - which commit id is the fix in? i can't find it.

The patch that introduced it wasn't ever destined for 3.10 anyways, and
I just deleted the bcache/bcache-3.9 branches because they'd gotten out
of sync and weren't getting updated with bcache-dev/bcache-for-3.11.

So just stick with bcache-for-3.10, I just backported all the important
bugfixes to it - I'll be sending that stuff to Greg K-H for 3.10.1 in
the next couple days too.
