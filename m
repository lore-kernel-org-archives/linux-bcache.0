From: Kent Overstreet <kmo@daterainc.com>
Subject: Re: 3.17-rc6: bcache_gc: BUG: soft lockup - CPU#2 stuck for 23s!
Date: Fri, 21 Nov 2014 15:20:30 -0800
Message-ID: <CALJ65znHdPCoYLKuGXrRtg9aUkoKgxmOVn=Bw04WP5f=Vt_DxA@mail.gmail.com>
References: <alpine.DEB.2.00.1409281651340.15834@ware.dreamhost.com>
	<20141101204447.GB22219@kmo-pixel>
	<546FC2B4.5020201@message-id.invalid.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-vc0-f171.google.com ([209.85.220.171]:59207 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaKUXUb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 21 Nov 2014 18:20:31 -0500
Received: by mail-vc0-f171.google.com with SMTP id hy4so814896vcb.16
        for <linux-bcache@vger.kernel.org>; Fri, 21 Nov 2014 15:20:30 -0800 (PST)
In-Reply-To: <546FC2B4.5020201@message-id.invalid.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Stefan Seyfried <stefan.seyfried@googlemail.com>
Cc: Eric Wheeler <linux-bcache@lists.ewheeler.net>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, Ross Anderson <rosander@dsotm.net>, Stefan Priebe <s.priebe@profihost.ag>

Before the patch goes upstream I need it tested so I know if it fixes
the actual issue or not.

On Fri, Nov 21, 2014 at 2:54 PM, Stefan Seyfried
<stefan.seyfried@googlemail.com> wrote:
> Hi Kent,
>
> Am 01.11.2014 um 21:44 schrieb Kent Overstreet:
>> On Sun, Sep 28, 2014 at 05:25:37PM -0700, Eric Wheeler wrote:
>>> Hello Kent, Ross, all:
>>>
>>> We're getting bcache_gc backtraces and soft lockups; the system con=
tinues to
>>> be responsive and eventually recovers.  We are running 3.17-rc6. (T=
his
>>> appears to be a continuation of the thread from 2014-09-15)
>>>
>>> Please see the following two backtraces.  The first shows up in
>>> btree_gc_count_keys(), the other is triggered somehow by rcu_sched.=
  We will
>>> test with -rc7 this week, though I didn't see any bcache commits in=
 rc7.
>>>
>>> The server is quite busy:
>>>   dd in userspace from dm-thinp snapshots to another server
>>>   two DRBD verify's active backed by dm-thinp volumes
>>>   note that, dd fills up the buffers so this could be operating wit=
h few
>>>   pages free. (Though we have min-mem set to 256MB.)
>>>
>>> I see we are hitting functions like bch_ptr_bad() and bch_extent_ba=
d().
>>> Could that indicate a cache corruption on our volume?
>>
>> No - those are the normal "check the validity of medata" functions.
>>
>>> I'm happy to test patches if you have any suggestions or tests that=
 I should
>>> run it through.
>>
>> I think it might just be a missing cond_resched()... there's a check=
 during
>> garbage collection for need_resched() but it appears we might not ac=
tually be
>> calling schedule() then.
>
> I'm still hitting this quite often (once per week?), the machine does
> not recover and for I cannot shut it down but need to reboot it hard.
>
> I have seen this with 3.16.6 (openSUSE 13.2 standard kernel) and 3.17=
=2E2
> (latest stable as of that boot).
>
> This is on an old core2 duo, one CPU is always spinning in the kernel
> when this happens.
> I have also seen the machine recover from this, but the last occurenc=
es
> have been deadly.
>
> My setup is:
> * a 60GB LV on a Crucial CT240M500 SSD as cache device (other LVs on
> that SSD are for testing other stuff)
> * 30GB /home   on rotating rust (a LV on a 2TB WD 2.5" drive)
> * 750GB /space a LV on the same rotating rust
> * 4GB /var/log/journal again a LV on the 2.5" drive
>
> /space is used for both big-file storage (ISOs, some videos) and for
> lots-of-small-files storage (yocto project embedded development, ccac=
he
> directory, ....)
> /var/log/journal is the latest addition to the bcache set, after
> updating to openSUSE 13.2. I would say that I only see the problems
> since I added /var/log/journal, but that happened directly after
> updating to 13.2 which also includes a kernel update from 3.11.10 to
> 3.16.x, so it could be both.
>
> I cannot see that any specific action triggers the but, the machine i=
s
> just idling along and suddenly the soft lockup detector triggers...
>
>>
>> Try this patch:
>>
>> commit a64afc92e17e709bdd1618edd04bc608f6a44c55
>> Author: Kent Overstreet <kmo@daterainc.com>
>> Date:   Sat Nov 1 13:44:13 2014 -0700
>>
>>     bcache: Add a cond_resched() call to gc
>>
>>     Change-Id: Id4f18c533b80ddb40df94ed0bb5e2a236a4bc325
>>
>> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
>> index 00cde40db5..218f21ac02 100644
>> --- a/drivers/md/bcache/btree.c
>> +++ b/drivers/md/bcache/btree.c
>> @@ -1741,6 +1741,7 @@ static void bch_btree_gc(struct cache_set *c)
>>       do {
>>               ret =3D btree_root(gc_root, c, &op, &writes, &stats);
>>               closure_sync(&writes);
>> +             cond_resched();
>>
>>               if (ret && ret !=3D -EAGAIN)
>>                       pr_warn("gc failed!");
>>
>
> I have rebuilt the 3.17.3 bcache module with this patch now and will =
see
> if that helps. This is not yet in 3.18-rc, is there a reason why this=
 is
> not going upstream? The issue is certainly annoying...
>
> Best regards,
>
>         Stefan
> --
> Stefan Seyfried
> Linux Consultant & Developer
> Mail: seyfried@b1-systems.de GPG Key: 0x731B665B
>
> B1 Systems GmbH
> Osterfeldstra=C3=9Fe 7 / 85088 Vohburg / http://www.b1-systems.de
> GF: Ralph Dehner / Unternehmenssitz: Vohburg / AG: Ingolstadt,HRB 353=
7
