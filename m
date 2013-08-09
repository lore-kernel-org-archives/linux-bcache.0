From: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Converting existing partition to bcache backing device without
 loss of data
Date: Fri, 09 Aug 2013 03:00:32 +0200
Message-ID: <52043F30.5080401@gmail.com>
References: <CAO9TOLddUrQCSchv_2-Xf=xjp_AOfN+NyePMPfiQYwqA+gx4ew@mail.gmail.com> <20130809003657.GF15409@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130809003657.GF15409@kmo-pixel>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>, Adam Brenner <aebrenne-sXc7qaQca9o@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

ven. 09 ao=C3=BBt 2013 02:36:57 CEST, Kent Overstreet a =C3=A9crit :
> On Thu, Aug 08, 2013 at 09:27:33AM -0700, Adam Brenner wrote:
>> Howdy,
>>
>> I am in the process of testing bcache on our HPC cluster to act as
>> cache for our gluster storage (~750TB).
>>
>> I notice that during the setup process on our test cluster, our
>> backing device (where all our data is stored) will need to be
>> formatted in order to support bcache.
>>
>> Does a way exist so we do not have to format our backing device? Or =
is
>> working being done to support this?
>
> Unfortunately, there's no general purpose way - the faq explains why =
(I
> just fixed the wiki so it's there again :)
>
> http://bcache.evilpiepirate.org/FAQ/
>
> However, Gabriel de Perthuis has a tool to do in place conversion - I
> can't remember if it was limited to lvm devices or not - Gabriel, wha=
t
> was the link to that again? I should stick a link to it in the wiki o=
r
> give you an account on it so you can.

Yup, here is my conversion tool: https://github.com/g2p/blocks

I've added it to the FAQ.
