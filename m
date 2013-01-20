From: Steven Haigh <netwiz-tY1ak9Q0PTWHXe+LvDLADg@public.gmane.org>
Subject: Re: Adding caching to existing volumes?
Date: Sun, 20 Jan 2013 19:02:46 +1100
Message-ID: <50FBA4A6.7020709@crc.id.au>
References: <17989056.10.1358618905144.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <17989056.10.1358618905144.JavaMail.root@zimbra>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 20/01/2013 5:08 AM, Roy Sigurd Karlsbakk wrote:
> Hi all
>
> As far as I can understand from the bcache docs, a volume cached with bcache, must be formatted and setup for bcache in the first place. I come from a ZFS environment, where adding SLOG or L2ARC is done dynamically, so I have a few questions:
>
> - Would it be somewhat possible to add caching to an existing volume and its data?
> - What would happen if the cache device dies - does the whole filesystem become inaccessible?

I've actually been wondering a bit about this - its not exactly clear in 
the docs as to what I should do to set up bcache.

In my case, I have a RAID6 over 4 x 2Tb drives. It lives as /dev/md2. 
/dev/md[01] are RAID1 on a pair of 80Gb drives for boot and LVM.

As the system is a Xen Dom0, all the DomU (guests) run from their own LV 
on the RAID6. So - it would make sense to add bcache to /dev/md2.

I'm a bit confused from reading the docs if I can attach to the existing 
/dev/md2 or I have to create something from scratch. Obviously, 
attaching to an existing RAID device is going to be the preferred method.

Covering this in the docs or even on the web site would probably be 
beneficial for a lot of people - especially as I feel that this is 
getting closer to be merged with the upstream kernel.

--
Steven Haigh

Email: netwiz-tY1ak9Q0PTWHXe+LvDLADg@public.gmane.org
Web: https://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897
Fax: (03) 8338 0299
