From: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Subject: Re: Bcache causes data lose / BTRFS
Date: Sat, 09 Nov 2013 11:25:33 +0100
Message-ID: <527E0D9D.9020200@rolffokkens.nl>
References: <CAMJW5=23t=jQRObnB5NHU8hTRBg6bCyW2m0+HCgtS8dxd82rRg@mail.gmail.com>	<20131107202211.GG3842@kmo> <CAGqt0zy08jmT5NW62OEwV_1nH1aeN=ZYW7XiD9UwG3TSRk4R8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGqt0zy08jmT5NW62OEwV_1nH1aeN=ZYW7XiD9UwG3TSRk4R8A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuxuan Shui <yshuiv7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 11/08/2013 05:13 AM, Yuxuan Shui wrote:
> My SSD drive is Samsung 840EVO 120G. I'm not using md or lvm, just
> btrfs on top of bcache.
While testing bcache in Fedora I noticed BTRFS reporting checksum errors 
in kernels <= 3.11.4. Not knowing if it was a BRTFS issue or a bcache 
issue and the fact that there's no proper fsck for BTRFS I stopped using 
BTRFS.

Could BTRFS be a good way to test bcache because it has checksumming? Or 
will it only complicate testing?

Rolf
