From: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: bcache-tools: changes to make the udev rules work
Date: Mon, 26 Aug 2013 23:28:50 +0200
Message-ID: <521BC892.40601@gmail.com>
References: <521B1E94.8090802@rolffokkens.nl> <kvfs5h$j12$1@ger.gmane.org> <521BC237.9000802@rolffokkens.nl> <521BC829.9080303@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <521BC829.9080303-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

>> I tried, but with the blkid check first my /dev/bcache* devices are
>> not reliably created. I have 2 in total (/dev/bcache0 and
>> /dev/bcach1) and with the blkid there's only one after any reboot.
>> Although the name varies (bcache0 or bcache1) it actually is always
>> the /dev/bcache* device for the 'second' bcache device that is
>> created. second one means: the first one is the combi of /dev/sda3 &
>> /dev/sdb1, the second one is the combi of /dev/sdc1 and /dev/sdd1.
>> I'm not sure how I can figure out what's actually happening during
>> boot.
>
> Possibly /dev/sdc1 or /dev/sdd1 has a stray non-bcache superblock.

(I mean the other two, your "first" pair)

> You can check with wipefs, and remove it with wipefs -a.
