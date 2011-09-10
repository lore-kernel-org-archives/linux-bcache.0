From: Mark Hills <mark-UrrBsZIrrsb10XsdtD+oqA@public.gmane.org>
Subject: First observations with bcache
Date: Sat, 10 Sep 2011 14:44:56 +0100 (BST)
Message-ID: <1109101110320.2733@stax.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

I took some time to try out bcache, on an x86 Dell PC with OCZ Agility 3 
SSD.

The good news is that once I had applied various workarounds, thing seems 
to work as expected, both with 2.6.34 and with an updated 3.1 branch.

I had to make a few modifications to get going, and then more to enable 
the various debug options.

The most awkward problems seem to be the result of 32-bit architecture, 
and I think are highlighted by building as a module.

I'll follow-up this email with the patches (based on bcache-3.1 branch), 
though I don't consider them to be long-term solutions; they show the 
changes I made.

I some cases I've proposed a better solution, but thought I'd raise them 
here for discussion first.

-- 
Mark
