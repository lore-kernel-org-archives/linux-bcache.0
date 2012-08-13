From: James Harper <james.harper-NMzNsA1hOHcW+bLBXbPJGg@public.gmane.org>
Subject: 4K sectors
Date: Mon, 13 Aug 2012 07:19:50 +0000
Message-ID: <6035A0D088A63A46850C3988ED045A4B299F682F@BITCOM1.int.sbss.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

I notice on my system that bcache presents 4K sectors to Linux. This is causing me problems with Windows on Xen using my PV drivers (problem = doesn't work). I haven't figured out if it's my PV drivers that don't tell Windows the right thing, or if Windows just doesn't like 4K sectors.

Is the 4K sector thing intentional? I assume there is a performance improvement in doing so.

And what would be the performance impact if I just told Windows that it was dealing with 512 byte sectors (eg fake it)?

Thanks

James
