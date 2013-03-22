From: Heiko Wundram <modelnine-EqIAFqbRPK3NLxjTenLetw@public.gmane.org>
Subject: bcache hangs with continuous write I/O to SSD device, bcache device
 stops working
Date: Fri, 22 Mar 2013 13:34:09 +0100
Message-ID: <514C4FC1.6090804@modelnine.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hey!

I've checked out multiple trunks over the last two weeks of the current 
bcache repository (all 3.8.0+), and they all exhibit the same kind of 
broken behaviour: after some time (generally around 6 hours), I/O to the 
bcache device stops working (I have layered LVM on top of it, and those 
devices also stop working, naturally), and the SSD that's part of the 
cache set spins continuously at around 50MB/s I/O on write. It is 
irrelevant whether I enable discard or not. I've only tested this with 
writeback mode.

Is this a known problem?

-- 
--- Heiko.
