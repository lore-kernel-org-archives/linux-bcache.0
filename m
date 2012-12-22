From: Thomas Fjellstrom <thomas-T/OQ2aoscs6U4IzBdx3r/Q@public.gmane.org>
Subject: recomended bcache setup
Date: Fri, 21 Dec 2012 20:06:41 -0700
Message-ID: <201212212006.41906.thomas@fjellstrom.ca>
Reply-To: thomas-T/OQ2aoscs6U4IzBdx3r/Q@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

I'm setting up a little home NAS here, and I've been thinking about using 
bcache to speed up the random access bits on the "big" raid6 array (7x2TB).

How does one get started using bcache (custom patched kernel?), and what is 
the recommended setup for use with mdraid? I remember reading ages ago that it 
was recommended that each component device was attached directly to the cache, 
and then mdraid put on top, but a quick google suggests putting the cache on 
top of the raid instead.

Also, is it possible to add a cache to an existing volume yet? I have a 
smaller array (7x1TB) that I wouldn't mind adding the cache layer to.

-- 
Thomas Fjellstrom
thomas-T/OQ2aoscs6U4IzBdx3r/Q@public.gmane.org
