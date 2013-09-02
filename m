From: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Suspend and Hibernation Bugs
Date: Mon, 02 Sep 2013 11:58:43 +0200
Message-ID: <52246153.2040006@gmail.com>
References: <52238303.6040509@bahj.com> <5223999F.2050508@gmail.com> <5223CA04.4010607@bahj.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5223CA04.4010607-J5qI5MFTcs8@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zachary Palmer <zep_bcache-J5qI5MFTcs8@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

> Interesting; it does indeed have a stale header of some kind:
>
>     zpalmer@thirtyseven:~$ sudo blkid /dev/sda7
>     /dev/sda7: UUID="b56e8430-2594-436a-9fba-b91617cdaa5e" TYPE="crypto_LUKS"
>     zpalmer@thirtyseven:~$ sudo /sbin/wipefs /dev/sda7
>     offset               type
> ----------------------------------------------------------------
>     0x0                  crypto_LUKS   [crypto]
>                         UUID: b56e8430-2594-436a-9fba-b91617cdaa5e
>
> But /dev/sda7 is a bcache backing volume.
>
>     zpalmer@thirtyseven:~$ sudo probe-bcache /dev/sda7
>     4b6ead1d-3341-407c-9e16-dd9e639268e4: UUID="" TYPE="bcache"
>
> Doesn't bcache put its superblock in the first part of the block
> device? How is it possible that the device looks like a bcache
> backing volume and a LUKS encrypted volume at the same time? (For the
> record, I know that the LUKS volume identified above is the stale
> one; when I used LVM to move everything around, I created a fresh
> LUKS encrypted volume which has a different UUID than the old one
> shown above.)
>
> Thanks,

The first 4k of the device weren't erased; the bcache superblock comes
after that.  Fixed now.  You can erase with wipefs -a, and do the same
look/erase thing on /dev/sdb3.

I'm on bcache-for-3.11 which doesn't have shutdown issues.
I see your kernel is based on stable kernel 3.10.4, which backports
a fix for #715019.  I'd consider the suspend issue a separate one.
