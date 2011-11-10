From: Marcus Sorensen <shadowsor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Fwd: bcache.patch
Date: Wed, 9 Nov 2011 20:53:33 -0700
Message-ID: <CALFpzo5Ft9vLm8GKDet+gH6UC9QrfbkiFPQ+aZCff_S5B2Legg@mail.gmail.com>
References: <CALFpzo5VbD6WB=NEua4t-tEgyieNGWaVhBXDCucGDyw0tq74Nw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALFpzo5VbD6WB=NEua4t-tEgyieNGWaVhBXDCucGDyw0tq74Nw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

---------- Forwarded message ----------
=46rom: Marcus Sorensen <shadowsor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Wed, Nov 9, 2011 at 8:49 PM
Subject: bcache.patch
To: kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org


Was looking for bcache.patch and it's not obvious where I should be
able to find these for various kernel versions. I did suck down the
3.1 kernel tree in the git repo, but I've put some work into my
existing kernel tree and would like to use that.

=A0Also, various sources seem to state that it relies on filesystem
UUID, I'm assuming this means that I cannot use it to speed up a block
device that I'm exporting elsewhere (e.g. a logical volume exported as
iscsi or Fibre Channel target, that the client has
partitioned/formatted), because locally I should not be aware of or
using the filesystem, but perhaps I could use it if I were exporting
flat files as volumes to be used elsewhere (cached against the local
fs on which the flat files reside). Is this correct?

Thanks,
Marcus Sorensen
