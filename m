From: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Subject: Detaching a cachine device
Date: Sun, 15 Sep 2013 17:07:14 +0200
Message-ID: <5235CD22.8000507@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi,

I'm probably overlooking the obvious, but (as part of a test) I want to 
replace my caching device with a bigger one. So I think the first step 
should to detach the current caching device. I can find instructions 
about detaching a backing device, but that's not wat I want (the backing 
device holds the (slow) data, the important data). I can't figure out 
though how to detach a caching the device.

Any suggestions would be welcome,

Thanks,

Rolf
