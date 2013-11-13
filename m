From: Francis Moreau <francis.moro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: bcache and SSD over provisioning
Date: Wed, 13 Nov 2013 09:42:54 +0100
Message-ID: <CAC9WiBiuQ2zG6C9XJio-STz-ScnfzzYb+Rz23u6JW+vFni8PNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hello,

I've recently learnt that SSDs (all ?) need to be over provisioned. My
SSD is a kingstom SSDNOW MS200 (controller is
SandForce-SF2241).

First I'd like to know if over-provisioning is still needed when
bcache is used ?

I'm assuming that I need over-provisioning.

Currently my whole SSD is used a cache device and my backing device is
a 900Mo partition with ext4 and no over-provisioning was foreseen.

What's the best practice to make my SSD over-provisioned ?

  - Should I create 2 partitions with one left emtpy and whose size is
roughly 7% of the device size ?
  - Should I create a "Host Protected Area" by using hdparm ?

And finally, can I create the over-provisioning without lost the
content of my backing device ?

Thanks for your help.
-- 
Francis
