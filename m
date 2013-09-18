From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: Re: running iozone on bcache0 device yields wrongly read data
Date: Tue, 17 Sep 2013 21:45:51 -0700
Message-ID: <20130918044551.GD32386@kmo-pixel>
References: <5238AAE5.8000800@aei.mpg.de>
 <20130917204059.GB32037@kmo-pixel>
 <52392D4D.3020506@aei.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <52392D4D.3020506-l1a6w7hxd2yELgA04lAiVw@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Carsten Aulbert <Carsten.Aulbert-l1a6w7hxd2yELgA04lAiVw@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Wed, Sep 18, 2013 at 06:34:21AM +0200, Carsten Aulbert wrote:
> Hi
> 
> On 09/17/2013 10:40 PM, Kent Overstreet wrote:
> > What's your setup? Are you running md, lvm? What filesystem?
> 
> Very basic, no md or LVM involved. /dev/sda2 is the backing device and
> /dev/sdb is the cache device. On top of bcache0 I'm running xfs:

Writeback or writethrough?
