From: Heiko Wundram <modelnine-EqIAFqbRPK3NLxjTenLetw@public.gmane.org>
Subject: Re: bcache hangs with continuous write I/O to SSD device, bcache
 device stops working
Date: Wed, 27 Mar 2013 20:17:42 +0100
Message-ID: <515345D6.1060803@modelnine.org>
References: <514C4FC1.6090804@modelnine.org> <20130322141613.GA29496@gmail.com> <514C687C.4010304@modelnine.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <514C687C.4010304-EqIAFqbRPK3NLxjTenLetw@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Am 22.03.2013 15:19, schrieb Heiko Wundram:
> In my case, the syncing was still going on after around 16 hours (I
> simply let the system run after it got locked in this state). As I've
> only got around 2GB of page cache in the corresponding system that was
> used as the test bed, most probably, the system wasn't (still) flushing
> data, but rather spinning on something else.

I'm not entirely sure what difference I made, but it seems that this 
problem has disappeared (hasn't surfaced over the last three days, 
whereas before it was a matter of hours).

I've updated the kernel to statically contain bcache and the DM/md 
infrastructure (which should be unrelated, except for being part of a 
stack of block devices). Anyway, that seems to have done the trick, in 
case anybody else is experiencing this.

-- 
--- Heiko.
