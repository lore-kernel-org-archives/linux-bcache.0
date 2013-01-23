From: James Harper <james.harper-NMzNsA1hOHcW+bLBXbPJGg@public.gmane.org>
Subject: SSD failure modes
Date: Wed, 23 Jan 2013 02:56:40 +0000
Message-ID: <6035A0D088A63A46850C3988ED045A4B35638C4A@BITCOM1.int.sbss.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

What is the expected behaviour of bcache when an SSD wears out? Do SSD's internally do a verify after write to ensure that the data has made it to the 'media' correctly and report a failure if that's the case? Does (or can) bcache do a verify itself?

And what about an SSD that fails hard (eg linux detects an unplug)? A system crash is acceptable in such a case if the cache was in write-back mode, but what are the chances of rebooting successfully with the outstanding cached writes now lost?

Thanks

James
