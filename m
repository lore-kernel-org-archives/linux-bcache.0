From: Ashim Saikia <akhim.saikia-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: bcache patch for kernel version 3.0
Date: Wed, 7 Aug 2013 09:17:48 +0530
Message-ID: <CAM+ADaxb-d3Kj0Wu87im8grKWt7ihX4sc2uODG37z2DSq+yEOA@mail.gmail.com>
References: <CAM+ADaxMfE3PpsDZ+1sAAthX6=6H5SNMne3QgdADj3ZOGt74hQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAM+ADaxMfE3PpsDZ+1sAAthX6=6H5SNMne3QgdADj3ZOGt74hQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi Matthew,

I have bcache patch for 3.7 kernel. But I was trying to use bcache in
an android device which has a 3.0 kernel. So, I tried to back port
bcache patch to 3.0. But the bio handling in case of 3.0 is having
issues. Tried the git, but was not able to get a 3.0 compatible patch.

Regards
Ashim

On Tue, Aug 6, 2013 at 2:29 PM, Ashim Saikia <akhim.saikia-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi,
>
> I am new to bcache and I am looking for a bcache patch for linux kernel
> version 3.0.
>
> Initially, form a 3.7 kernel, I prepared a patch and applied to 3.0 kernel.
> But in this case, I encounter "null pointer dereference".
>
> I am trying to use ramdisk as cache device and mmc partiton as backing
> device.
>
>
> Unable to handle kernel NULL pointer dereference at virtual address 00000000
> kernel BUG at fs/bio.c:424!
> Unable to handle kernel NULL pointer dereference at virtual address 00000000
> pgd = c0004000
> [00000000] *pgd=00000000
> Internal error: Oops: 817 [#1] PREEMPT
> Modules linked in:
> CPU: 0    Not tainted  (3.0.8-00054-gece392b-dirty #5)
> PC is at __bug+0x1c/0x24
> LR is at __bug+0x18/0x24
> pc : [<c003c584>]    lr : [<c003c580>]    psr: 60000193
> sp : f0bf7d88  ip : f0bf7cc0  fp : 00000000
> r10: f02f3000  r9 : e2b70400  r8 : e2b70400
> r7 : 00000000  r6 : 00000800  r5 : 00000000  r4 : 00000000
> r3 : 00000000  r2 : 00000001  r1 : 00000002  r0 : 00000022
> Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
> Control: 10c5387d  Table: 4da00019  DAC: 00000015
>
> PC: 0xc003c504:
>
> So, I am trying to debug this issue. My guess is back porting bcache from
> 3.7 kernel may not be the right way.
> I am looking for help in getting a bcache 3.0 patch. If anybody can give me
> some pointers in order to get that patch, that will be really helpful to me.
>
> Regards
> Ashim
