From: ching <lsching17@gmail.com>
Subject: Re: scrub backing device
Date: Mon, 16 May 2016 07:56:46 +0800
Message-ID: <CE3A0A9A-B4F1-4CF2-A7B8-D2A4AE357F3C@gmail.com>
References: <CACHiF8Bm9i=m-nCVv2MnSFVDcgmnOzSytzYo0gzjkfp0u8Y52A@mail.gmail.com> <alpine.LRH.2.11.1605101814280.22680@mx.ewheeler.net> <CACHiF8AdwiO3FKV9=sNrFMom8pb1DiUzXAdvb4ze+k+U0N_-1g@mail.gmail.com> <alpine.LRH.2.11.1605111212540.22680@mx.ewheeler.net> <E3BCB47C-9466-4B3F-8AE2-DC7183B3B08D@gmail.com> <20160511235748.GR18290@merlins.org> <20160513222133.GA3784@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:36101 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbcEOX46 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sun, 15 May 2016 19:56:58 -0400
Received: by mail-pa0-f65.google.com with SMTP id xm6so2395577pab.3
        for <linux-bcache@vger.kernel.org>; Sun, 15 May 2016 16:56:58 -0700 (PDT)
In-Reply-To: <20160513222133.GA3784@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>, Marc MERLIN <marc@merlins.org>
Cc: Eric Wheeler <bcache@lists.ewheeler.net>, linux-bcache@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

it seems to be a kernel config, and the kernel panic cannot be handled by userspace program

On May 14, 2016 6:21:33 AM GMT+08:00, Kent Overstreet <kent.overstreet@gmail.com> wrote:
>On Wed, May 11, 2016 at 04:57:48PM -0700, Marc MERLIN wrote:
>> On Thu, May 12, 2016 at 07:34:26AM +0800, ching wrote:
>> > for example
>https://btrfs.wiki.kernel.org/index.php/Manpage/btrfs-scrub
>>
>> btrfs scrub is designed to make sure all the blocks and checksums are
>> consistent.
>> Ching makes a good point that it would be helpful to have a way to
>> access the underlying backing device directly to ensure it is
>> consistent.
>>
>> I think currently you can use dmsetup with an offset to get the real
>> filesystem past the bcache header, mount that read only somewhere and
>> scrub that.
>> Not ideal because scrub will not be able to fix issues that are
>fixable,
>> but at least it should report errors.
>
>Look at the verify code in drivers/md/bcache/debug.c, there's a
>CONFIG_BCACHE_DEBUG mode where every time it reads clean cached data it
>reads
>the data from the backing device and compares.
>
>But for a scrub though you really want to walk all the _cached_ data,
>so it'd
>take a bit more code than that.
-----BEGIN PGP SIGNATURE-----
Version: APG v1.1.1

iQQ6BAEBCgAkBQJXOQy8HRxjaGluZyA8dG9tLmx1QGFsdW1uaS51c3QuaGs+AAoJ
EJh7yMFRxEtkK/cgAN9XBFqqZ7mhctx8IzSKKZx5GrP4xv7Ew7rITiX4J6J2JLqn
5NZUW9rGReRXKj1MaVz0MGFeD/Lnndzf5gRLwD6cwQtPQAydTm6krd0qsld1V4O+
o9plFThE9IjdKRhWoIr6yA11wKN04MmIInucGtjtNITVBx+vut3MHAcDuRxeIG/Y
sGmTrA4VbI34agltybanTn7XfnKULFdXOpfmf35dyqyrgShk22+5atcOW4hug112
5sPOpBo2S1jAwVZLKorwh4gIqeII4pFl+sfo5axJ60qLAZNXHwWeOGidmpcXFJMG
/NnSsWRmbrJvMlSsRk/hKTHjvkzZ/Ci7ZU9aB+ICkZQgqk58udRLXc990RhKMpvK
mKv9SHhltVYls+zoaaITxM6dS5rlIUwk++OhOU0qjjCOu9TI4yGmeBM5YmA29srb
hOc5mtwWnjORcWAf7uttfNS1ECxJ0AlYJIRL9rF5FFCvxEugfxd1UQnZXz3qBj6q
KDJo5JARiJvx+ayAw8I3cuh49Gc1U7VktUbRn5y/9Pm+Lj483Eb2Mp5kDyyAZTG5
X2baUtmkH0SkNID62ZzpBT7LE29oaw+PQ02czODIRYgAgJfuuCTEiCq0Q6zvRCDr
rG6SO6K4W4CsgN3Hm5W5b832vRuGK/pfWj/DaNmK2XJ30XlckQSGXXV92MitHrs+
bF82odaF2qFHQQA8/W3MX1CcaPazyulvZfVMh6n6+K0cehOd3Gb94J/yQSdcRIM6
ynVu/7DJ+Ig9aH/2MvpzH/y6X1UZZEPvhV+CUyQPcXIXfhm5VMbLEKRq8gpZaq24
3+z/Tf2Vcbw4Wa4+GShGssavHljNr7Q2s4D8Nf6Mfn2fLb6tjIciAms//t+ywXnV
DbLx34csTWTRWADq/Izsg2qJT5nAJ82HsAoY0Zg16pJHVgqCvg8gQPUnMvd06VK6
VPr9jcFv6yC3nijC/y78hkCcj2KVU4sx02hk4nxPo7mbbj2dJtrzdMW0HhT4iXhW
ELIuNnDYbRX7OzkkggDO9092Y+oCuRPyJdkfVp/kxtpHVBaZzI8BPmJHVusEzanx
6IvS4QgPDTVfmYfvyxHqfRL8d5jc7uvws2uwnsM3hEBoOvTq/bAPSdoM/wibsU9f
LmxEs2y5tX+AEHsT62o2FT1hc6ilvHzuRdJzNY+MPIsIFTBCPMF0wJFeL77tYYWE
71SUNDrBL8zT/eqeeneqfn1rbgEuDxucKOUuwLz0oYkWYGk0bhYieoWBrqyZGuq8
CKg2KPUB+2KJuS9Y9wXfL93QohzQOLc8RzOwf2oqCio7uVKn+DNyyE0gF66k0WOV
HfSvyfdcSb83CnQxXwVtQbEz9jHyUFe0J5Y6CK4=
=aTFB
-----END PGP SIGNATURE-----
