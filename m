From: James Harper <james.harper-NMzNsA1hOHcW+bLBXbPJGg@public.gmane.org>
Subject: RE: SSD failure modes
Date: Fri, 25 Jan 2013 02:26:53 +0000
Message-ID: <6035A0D088A63A46850C3988ED045A4B3563FFDB@BITCOM1.int.sbss.com.au>
References: <6035A0D088A63A46850C3988ED045A4B35638C4A@BITCOM1.int.sbss.com.au>
 <20130124225205.GL26407@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130124225205.GL26407-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

> I just wrote some documentation about error handling - tell me if that
> helps:
> http://atlas.evilpiepirate.org/git/linux-
> bcache.git/tree/Documentation/bcache.txt?h=bcache-dev
> 
> Not quite sure I get the scenario you're describing though - you unplug
> the SSD, then reboot?
> 

No what I was describing is if the SSD fails completely and as far as Linux is concerned it's just gone. I've seen a few harddisks fail like that just recently (heatwave over here in AU) where the computer seems to be working okay then things just freeze up, and after a reboot there is no harddisk anymore. I haven't used SSD's enough to have seen something like that yet, but if it's a controller failure then it's possible.

I was just wondering how data integrity would fare in such a case. I guess it's the same as if there was a power failure and then you removed the SSD before booting up again, except that I believe bcache can bypass the cache for certain types of streaming writes so there is the potential for things to get out of sync, maybe?

James
