From: James Harper <james.harper-NMzNsA1hOHcW+bLBXbPJGg@public.gmane.org>
Subject: how much of ssd to use?
Date: Sat, 2 Mar 2013 06:19:24 +0000
Message-ID: <6035A0D088A63A46850C3988ED045A4B3876B655@BITCOM1.int.sbss.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

I've read that SSD drives work best when you only use some percentage of them (75%, 50%, etc) because by leaving unused space it allows the SSD more headroom to shuffle data around internally to keep things optimal. Those articles are most likely written for a filesystem on an OS that might not know about TRIM/UNMAP etc.

Has anyone done any testing on sustained random write throughput on a (say) 60GB flash drive with only 50% dedicated to bcache, or 75%, or 100%?

Thanks

James
