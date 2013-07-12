From: Stefan Priebe - Profihost AG <s.priebe-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
Subject: Re: label devices got removed after format
Date: Fri, 12 Jul 2013 07:15:42 +0200
Message-ID: <82A5ED40-7A77-42A0-80B6-2C9FF562F9DA@profihost.ag>
References: <51DE7E3A.5070709@profihost.ag> <20130712012806.GB17799@kmo-pixel>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130712012806.GB17799@kmo-pixel>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Cc: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Am 12.07.2013 um 03:28 schrieb Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>:

> On Thu, Jul 11, 2013 at 11:43:22AM +0200, Stefan Priebe - Profihost AG wrote:
>> Hi,
>> 
>> after doing mkfs.xfs -f /dev/bcache/by-label/mybcachelabel
>> 
>> /dev/bcache/by-label/mybcachelabel gots removed...
>> 
>> Only a reboot brings it back.
>> 
>> Stefan
> 
> Gabriel - I bet the uevent bcache is emitting is conflicting with the
> name of an existing label uevent; there'll be a symlink for the
> filesystem's label - for the same block device - so the mkfs could be
> causing another uevent to be emitted overwriting our label.
No it always seems to happen if udev gets triggered. It also happens on manually executing udevadm trigger. 

Stefan--
To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
