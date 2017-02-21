From: shiva rkreddy <shiva.rkreddy@gmail.com>
Subject: Re: Fwd: bcache-register blocked
Date: Mon, 20 Feb 2017 22:33:58 -0600
Message-ID: <CAPntomBZ-g0SAqzGDH8iXvMoLCuZ5rcgNvf4w+vA0zJwc8+fVA@mail.gmail.com>
References: <CAPntomDbBMBcfeX0ZJisWDb8D=29u_vcYRSi3P+Ljtybvtm7QA@mail.gmail.com>
 <CAPntomAZif6a4yoHzM0EYVr2PWq8MBe7VcLfUVOfiQq6R7oPQg@mail.gmail.com>
 <alpine.LRH.2.11.1702171556110.19857@mail.ewheeler.net> <CAPntomBViD79LheXnTWdP-GwH8zSE2vPN8P2-nDJGbYAv=qqHw@mail.gmail.com>
 <alpine.LRH.2.11.1702171947330.19857@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-yb0-f193.google.com ([209.85.213.193]:35579 "EHLO
        mail-yb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751126AbdBUEeA (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 20 Feb 2017 23:34:00 -0500
Received: by mail-yb0-f193.google.com with SMTP id u130so2922463ybb.2
        for <linux-bcache@vger.kernel.org>; Mon, 20 Feb 2017 20:33:59 -0800 (PST)
In-Reply-To: <alpine.LRH.2.11.1702171947330.19857@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: linux-bcache@vger.kernel.org

It worked fine with 4.4.0.62 (Ubuntu Xenial) kernel.

Thanks!

On Fri, Feb 17, 2017 at 9:48 PM, Eric Wheeler <bcache@lists.ewheeler.net> w=
rote:
> On Fri, 17 Feb 2017, shiva rkreddy wrote:
>
>> Hi Eric:
>>
>> Kernel version: 4.2.0.42
>>
>> It was 3.13 (Ubuntu Trusty) kernel that was upgraded to Ubuntu
>> "linux-generic-lts-wily". This upgrade made the kernel version to
>> 4.2.0.42.
>> The devices were created after kernel upgrade to 4.2.0.42.
>
> I'm not sure what Ubuntu has patched in, and 4.2 isn't a supported
> upstream kernel.  Try 4.1.38 or 4.4.49.
>
> --
> Eric Wheeler
>
>
>>
>> I can reproduce and provide more details if needed.
>>
>> This was the whole backtrace from dmesg:
>>
>> =3D=3D=3D
>> [ 53.752177] bcache: register_cache() registered cache device nvme0n1p17
>> [ 58.641878] bcache: register_bdev() registered backing device sdj
>> [ 253.701153] INFO: task bcache_allocato:496 blocked for more than 120 s=
econds.
>> [ 253.953639] bcache_allocato D ffff88085fe16640 0 496 2 0x00000000
>> [ 253.953670] [<ffffffffc01311e3>] bch_bucket_alloc+0x163/0x320 [bcache]
>> [ 253.953682] [<ffffffffc014fa36>] ? bch_crc64+0x36/0x50 [bcache]
>> [ 253.953689] [<ffffffffc0146de4>] bch_prio_write+0x184/0x310 [bcache]
>> [ 253.953693] [<ffffffffc0131019>] bch_allocator_thread+0x3d9/0x440 [bca=
che]
>> [ 253.953699] [<ffffffffc0130c40>] ? invalidate_buckets+0x920/0x920 [bca=
che]
>> [ 253.953716] INFO: task bcache-register:525 blocked for more than 120 s=
econds.
>> [ 254.206187] bcache-register D ffff88085fe16640 0 525 1 0x00000004
>> [ 254.206202] [<ffffffffc01311e3>] bch_bucket_alloc+0x163/0x320 [bcache]
>> [ 254.206208] [<ffffffffc013152c>] __bch_bucket_alloc_set+0xec/0x140 [bc=
ache]
>> [ 254.206213] [<ffffffffc01315ce>] bch_bucket_alloc_set+0x4e/0x70 [bcach=
e]
>> [ 254.206218] [<ffffffffc0145866>] __uuid_write+0x46/0xe0 [bcache]
>> [ 254.206223] [<ffffffffc0146806>] bch_uuid_write+0x16/0x40 [bcache]
>> [ 254.206228] [<ffffffffc0147493>] bch_cached_dev_attach+0x153/0x490 [bc=
ache]
>> [ 254.206249] [<ffffffffc0149645>] register_bcache+0xa25/0x13b0 [bcache]
>> [ 254.206317] INFO: task bcache-register:527 blocked for more than 120 s=
econds.
>> [ 254.458788] bcache-register D ffff88105f456640 0 527 1 0x00000004
>> [ 254.458812] [<ffffffffc0148e5e>] register_bcache+0x23e/0x13b0 [bcache]
>> [ 254.458832] INFO: task bcache-register:548 blocked for more than 120 s=
econds.
>> [ 254.711311] bcache-register D ffff88105f456640 0 548 1 0x00000004
>> =3D=3D=3D
>>
>> Thanks
>> Shiva
>>
>> On Fri, Feb 17, 2017 at 5:57 PM, Eric Wheeler <bcache@lists.ewheeler.net=
> wrote:
>> > Hi Shiva,
>> >
>> > What kernel version?
>> >
>> > Also, see if you can paste the trace without wrapping and include the
>> > whole backtrace including kernel version and line numbers if any.
>> >
>> > --
>> > Eric Wheeler
>> >
>> > On Fri, 17 Feb 2017, shiva rkreddy wrote:
>> >
>> >> Greetings to all!
>> >>
>> >> I'm experimenting bcache with sas disks as backing devices and nvme a=
s
>> >> cache. The backing devices are used as ceph osd mount points.
>> >> I was able to make them part of ceph cluster and have the ceph mount
>> >> points added to fstab using the bcache uuid.
>> >>
>> >> These bcache backing devices are disappearing after rebooting the hos=
t
>> >> that has these devices. dmesg shows, bcache_allocto blocked and later
>> >> bcache-register blocked.
>> >> bcache cache device is registered successfully though.
>> >>
>> >> Digged the mailing list and couldn't find consumable information. Did
>> >> anyone encounter this problem ? Any thoughts on troubleshooting ..
>> >>
>> >> Appreciate your help!
>> >>
>> >> Here is excerpt from dmesg:
>> >>
>> >> [   53.752029] bcache: bch_journal_replay() journal replay done, 2173
>> >> keys in 153 entries, seq 331031
>> >>                                    =E2=94=82
>> >>
>> >> [   53.752177] bcache: register_cache() registered cache device
>> >> nvme0n1p17
>> >>                                          =E2=94=82
>> >>
>> >> [   58.641878] bcache: register_bdev() registered backing device sdj
>> >>
>> >>                                   =E2=94=82
>> >>
>> >> [  253.701153] INFO: task bcache_allocato:496 blocked for more than
>> >> 120 seconds.
>> >>                                      =E2=94=82
>> >>
>> >> [  253.953639] bcache_allocato D ffff88085fe16640     0   496      2
>> >> 0x00000000
>> >>                                     =E2=94=82
>> >>
>> >> [  253.953670]  [<ffffffffc01311e3>] bch_bucket_alloc+0x163/0x320
>> >> [bcache]
>> >>                                        =E2=94=82
>> >>
>> >> [  253.953682]  [<ffffffffc014fa36>] ? bch_crc64+0x36/0x50 [bcache]
>> >>
>> >>                                   =E2=94=82
>> >>
>> >> [  253.953689]  [<ffffffffc0146de4>] bch_prio_write+0x184/0x310
>> >> [bcache]
>> >>                                          =E2=94=82
>> >>
>> >> [  253.953693]  [<ffffffffc0131019>] bch_allocator_thread+0x3d9/0x440
>> >> [bcache]
>> >>                                    =E2=94=82
>> >>
>> >> [  253.953699]  [<ffffffffc0130c40>] ? invalidate_buckets+0x920/0x920
>> >> [bcache]
>> >>                                    =E2=94=82
>> >>
>> >> [  253.953716] INFO: task bcache-register:525 blocked for more than
>> >> 120 seconds.
>> >>                                      =E2=94=82
>> >>
>> >> [  254.206187] bcache-register D ffff88085fe16640     0   525      1
>> >> 0x00000004
>> >>                                     =E2=94=82
>> >>
>> >> [  254.206202]  [<ffffffffc01311e3>] bch_bucket_alloc+0x163/0x320
>> >> [bcache]
>> >>                                        =E2=94=82
>> >>
>> >> [  254.206208]  [<ffffffffc013152c>] __bch_bucket_alloc_set+0xec/0x14=
0
>> >> [bcache]
>> >>                                   =E2=94=82
>> >>
>> >> [  254.206213]  [<ffffffffc01315ce>] bch_bucket_alloc_set+0x4e/0x70
>> >> [bcache]
>> >>                                      =E2=94=82
>> >>
>> >> [  254.206218]  [<ffffffffc0145866>] __uuid_write+0x46/0xe0 [bcache]
>> >>
>> >>                                   =E2=94=82
>> >>
>> >> [  254.206223]  [<ffffffffc0146806>] bch_uuid_write+0x16/0x40 [bcache=
]
>> >>
>> >>                                   =E2=94=82
>> >>
>> >> [  254.206228]  [<ffffffffc0147493>] bch_cached_dev_attach+0x153/0x49=
0
>> >> [bcache]
>> >>                                   =E2=94=82
>> >>
>> >> [  254.206249]  [<ffffffffc0149645>] register_bcache+0xa25/0x13b0
>> >> [bcache]
>> >>                                        =E2=94=82
>> >>
>> >> [  254.206317] INFO: task bcache-register:527 blocked for more than
>> >> 120 seconds.
>> >>                                      =E2=94=82
>> >>
>> >> [  254.458788] bcache-register D ffff88105f456640     0   527      1
>> >> 0x00000004
>> >>                                     =E2=94=82
>> >>
>> >> [  254.458812]  [<ffffffffc0148e5e>] register_bcache+0x23e/0x13b0
>> >> [bcache]
>> >>                                        =E2=94=82
>> >>
>> >> [  254.458832] INFO: task bcache-register:548 blocked for more than
>> >> 120 seconds.
>> >>                                      =E2=94=82
>> >>
>> >> [  254.711311] bcache-register D ffff88105f456640     0   548      1 =
0x00000004
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe linux-bcach=
e" in
>> >> the body of a message to majordomo@vger.kernel.org
>> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >>
>>
