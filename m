From: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Subject: (util-linux) blkid and wipefs to identify bcache
Date: Sat, 31 Aug 2013 21:29:35 +0200
Message-ID: <5222441F.1010105@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi!

Based on the sources of probe-bcache and bcache-super-show I built a 
patch for util-linux to identify bcache superblocks:

https://bugzilla.redhat.com/show_bug.cgi?id=1001120

Any feeback is welcome,

Rolf
