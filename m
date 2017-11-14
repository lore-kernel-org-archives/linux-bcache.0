From: Nix <nix@esperi.org.uk>
Subject: Re: bcache failure hangs something in kernel
Date: Tue, 14 Nov 2017 18:25:01 +0000
Message-ID: <87inecyayq.fsf@esperi.org.uk>
References: <efb67a88-3f4c-d268-3d2a-59c00824b5e7@xenlab.one>
        <b574aee6-1f6f-8eb3-d78a-ee3fd8f9bfb3@lyle.org>
        <b4cf93d3-7e15-9f20-941b-7f11269c510b@xenlab.one>
        <024c8d28-9ddb-09fe-c2b0-8a7d0aed493d@lyle.org>
        <87r2t1xa6w.fsf@esperi.org.uk>
        <CAJ+L6qc+DKZ4tkfk3whUBZOjdTByMqxUrvOOQ0yhR_fSYq+oSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from icebox.esperi.org.uk ([81.187.191.129]:32828 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753595AbdKNSZF (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 14 Nov 2017 13:25:05 -0500
In-Reply-To: <CAJ+L6qc+DKZ4tkfk3whUBZOjdTByMqxUrvOOQ0yhR_fSYq+oSw@mail.gmail.com>
        (Michael Lyle's message of "Tue, 14 Nov 2017 09:20:56 -0800")
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: Alexandr Kuznetsov <progmachine@xenlab.one>, linux-bcache@vger.kernel.org

On 14 Nov 2017, Michael Lyle outgrape:

> On Tue, Nov 14, 2017 at 5:27 AM, Nix <nix@esperi.org.uk> wrote:
>> Every time I rebooted I got warnings that bcache couldn't clean up
> in time, and I suspect this caused corruption in the end (fairly fast,
> actually, less than a month after starting using bcache: it had only
> just finished populating).
>
> What did you see?  A message like this is normal:
>
> [    2.224767] bcache: bch_journal_replay() journal replay done, 432
> keys in 243 entries, seq 40691386
>
> but anything else is strange...  If you were consistently seeing other
> messages that means something unusual was happening (an already
> badly-corrupted volume or bad hardware).

This registration code:

# Register all bcaches.
if [ -f /sys/fs/bcache/register_quiet ]; then
    for name in /dev/sd*[0-9]* /dev/md/*; do
        echo $name > /sys/fs/bcache/register_quiet 2>&1
    done
    # New devices registered: create them, after a short delay
    # to let the registration happen.
    sleep 1
    /sbin/mdev -s
fi

... did this (including the messages showing that the md array it's
caching is happy):

[   11.281907] md: md125 stopped.
[   11.294948] md/raid:md125: device sda3 operational as raid disk 0
[   11.305620] md/raid:md125: device sdf3 operational as raid disk 4
[   11.315899] md/raid:md125: device sdd3 operational as raid disk 3
[   11.325770] md/raid:md125: device sdc3 operational as raid disk 2
[   11.335245] md/raid:md125: device sdb3 operational as raid disk 1
[   11.344688] md/raid:md125: raid level 6 active with 5 out of 5 devices, algorithm 2
[   11.353810] md125: detected capacity change from 0 to 15761089757184

[   11.468956] bcache: prio_read() bad csum reading priorities
[   11.478010] bcache: prio_read() bad magic reading priorities
[   11.497911] bcache: error on 314dcdd2-9869-4110-99cc-9cd3a861afa6: 
[   11.497914] bad checksum at bucket 28262, block 0, 36185 keys
[   11.507021] , disabling caching
[   11.529823] bcache: register_cache() registered cache device sde2
[   11.539054] bcache: cache_set_free() Cache set 314dcdd2-9869-4110-99cc-9cd3a861afa6 unregistered
[   11.558596] bcache: register_bdev() registered backing device md125

The hardware is fine (zero other problems ever encountered: the RAM is
all ECC and has had zero errors ever, and the disks and SSD are
otherwise faultless -- so far! -- and are in fairly heavy use for other
things, like the XFS and RAID journals, without incident). The cached
(XFS) volume was in use as my rootfs (not only / but also /usr/src and
/home: 4TiB, ~10% full) until the previous reboot. There had been a lot
of writes to the cache device becuase I'd only enabled the cache a week
before, rebooting several times after doing that as part of system
bringup.

Reboots with the cache enabled always featured a message from bcache an
instant before reboot saying it had timed out: from the code, the
timeout is based on a (short!) delay without any concern for whether,
say, the SSD is in the middle of writing a bunch of data, and the delay
is way too short for the SSD in question (an ATA-connected DC3510) to
write more than a GiB or so, a small fraction of the 350GiB I have
devoted to bcache.

I note that the SMART data's bus reset count on the SSD suggests that
rebooting resets the bus as part of POST (the count of bus resets is
identical to the count of OS reboots plus firmware upgrades from the
IPMI event log), which likely halts any ongoing writes. I suspect this
alone could explain the problem, but it's all speculation.

However, SMART also says

0x04  0x010  4               0  ---  Resets Between Cmd Acceptance and Completion

which I believe suggests that this cannot be the problem.

Indeed,

199 CRC_Error_Count         -OSRCK   100   100   000    -    0
171 Program_Fail_Count      -O--CK   100   100   000    -    0
172 Erase_Fail_Count        -O--CK   100   100   000    -    0

suggests zero problems. However I do also see

174 Unsafe_Shutdown_Count   -O--CK   100   100   000    -    17

(whatever *that* means. What defines a safe shutdown to Intel SSDs?
Search me.)

> I have not experienced bcache corruption yet, though that doesn't say
> there's not an issue.  This doesn't sound at all like what Alexandr
> experienced, either.

Indeed not.

> There's not a bucket corruption message in the kernel, -- maybe you
> saw a bad btree message at bucket xxxxx, block xxx, dev xxxx?

dmesg above. Sorry, vague memory caused trouble there. I posted a
fuller description on 7th June, which got no response:

<https://www.spinics.net/lists/linux-bcache/msg04668.html>

> What SSD are you using?  A known issue is that there are families of
> SSDs that do not do the right thing on shutdown-- e.g. some devices
> based around LSI/SandForce that do emergency-writeback-from-RAM that
> have underprovisioned / missing capacitors.

This is an Intel DC3510. I believe Intel SSDs are the single model that
actually *work* reliably when powerfail happens (btw Corsair are
rumoured to be even worse, sometimes bricking the whole device on
powerfail! "Corsair" seems to be an appropriate manufacturer name in
this case). SMART says:

175 Power_Loss_Cap_Test     PO--CK   100   100   010    -    5350 (33 1413)

which I believe means "all is fine". isdct says that things are fine too:

DeviceStatus : Healthy
EnduranceAnalyzer : 1102.31 years
LatencyTrackingEnabled : False
WriteCacheEnabled : True
WriteCacheReorderingStateEnabled : True
WriteCacheState : 1
WriteCacheSupported : True
WriteErrorRecoveryTimer : 0

(Hm is it write caching that's doing it? Not given that the thing has
capacitors, surely.)

(In any case this machine has never experienced a power loss. :) )
