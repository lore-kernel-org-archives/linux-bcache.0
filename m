From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: caching device setup
Date: Sat, 11 Apr 2015 00:26:06 +0200
Message-ID: <u8vlvb-ciu.ln1@hurikhan77.spdns.de>
References: <CAK1hC9vTG=TEsUzNgxym=+0swhPoxBNaaPAiWk1kBf-D+_Hftg@mail.gmail.com> <498317a297a1038028f1393da9b49231@de.mcbf.net> <98agvb-l7r.ln1@hurikhan77.spdns.de> <55265CE0020000E100020423@relay2.provo.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44272 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755750AbbDJW0S (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Fri, 10 Apr 2015 18:26:18 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1YghNP-0000RR-Ko
	for linux-bcache@vger.kernel.org; Sat, 11 Apr 2015 00:26:15 +0200
Received: from ip18864262.dynamic.kabel-deutschland.de ([24.134.66.98])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Sat, 11 Apr 2015 00:26:15 +0200
Received: from hurikhan77 by ip18864262.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Sat, 11 Apr 2015 00:26:15 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Lidong Zhong <lzhong@suse.com> schrieb:

>>>> On 4/9/2015 at 02:56 AM, in message
>>>> <98agvb-l7r.ln1@hurikhan77.spdns.de>, Kai
> Krakow <hurikhan77@gmail.com> wrote:
>> David Mohr <david@mcbf.net> schrieb:
>> =20
>> > On 2015-04-06 09:44, arnaud gaboury wrote:
>> >> Here is my overall plan:
>> >> =20
>> >> root filesystem & OS on a SSD
>> >> DB and other stuff on HD.
>> >> Use ssd as caching device and HD as backing.
>> >> =20
>> >> Shall I partition the SSD with : one partition for OS and one emp=
ty
>> >> for bcache? Or install the OS on the whole SSD and use the whole =
SSD
>> >> as caching device?
>> >> =20
>> >> Thank you for hint.
>> > =20
>> > So this is just depending on your preference, how big the SSD is, =
and
>> > how much space you expect your OS to take up.
>> > =20
>> > Personally I split my SSD into two partitions: one for the root FS=
, and
>> > the other as a caching device for /home.
>> =20
>> The other preference is valid, too: I chose to put bcache only on th=
e SSD
>> to
>> =20
>> get maximum benefit from its capacity, rootfs and home dynamically s=
hare
>> the
>> =20
> I am curious about how rootfs and home share the SSD dynamically. Are=
 they
> on the same partition? Sorry for stupid questions since I just touche=
d
> bcache recently.

Cache and backing device association is not 1:1. You can attach multipl=
e=20
backing partitions (even from distinct filesystems) to the one and same=
=20
caching partition. So, accesses to one of the cached filesystems will g=
o=20
through the same bcache, thus sharing the cache space through bcache's =
LRU=20
implementation (or if you change it from the default, even something el=
se=20
like LRU).

Here's my setup (shortened):

=E2=94=9C=E2=94=80sdb3        8:19   0  79,5G  0 part
=E2=94=82 =E2=94=9C=E2=94=80bcache0 252:0    0 925,5G  0 disk
=E2=94=82 =E2=94=9C=E2=94=80bcache1 252:1    0 925,5G  0 disk
=E2=94=82 =E2=94=94=E2=94=80bcache2 252:2    0 925,5G  0 disk

with sdb3 being the one and only bcache partition on SSD:

$ ls -al /sys/fs/bcache/
insgesamt 0
drwxr-xr-x  3 root root    0 11. Apr 00:25 .
drwxr-xr-x 11 root root    0  6. Apr 19:07 ..
drwxr-xr-x  7 root root    0  8. Apr 20:33 bf2b67f9-a261-4d27-
a6ef-2961f2ce2cc2
--w-------  1 root root 4096  8. Apr 20:33 register
--w-------  1 root root 4096  6. Apr 19:08 register_quiet

$ ls -al /sys/fs/bcache/bf2b67f9-a261-4d27-a6ef-2961f2ce2cc2/
insgesamt 0
drwxr-xr-x 7 root root    0 11. Apr 00:25 .
drwxr-xr-x 3 root root    0 11. Apr 00:25 ..
-r--r--r-- 1 root root 4096  8. Apr 20:33 average_key_size
lrwxrwxrwx 1 root root    0  8. Apr 20:33 bdev0 ->=20
=2E./../../devices/pci0000:00/0000:00:1f.2/ata3/host2/target2:0:0/2:0:0=
:0/block/sdc/sdc2/bcache
lrwxrwxrwx 1 root root    0  8. Apr 20:33 bdev1 ->=20
=2E./../../devices/pci0000:00/0000:00:1f.2/ata4/host3/target3:0:0/3:0:0=
:0/block/sdd/sdd2/bcache
lrwxrwxrwx 1 root root    0  8. Apr 20:33 bdev2 ->=20
=2E./../../devices/pci0000:00/0000:00:1f.2/ata5/host4/target4:0:0/4:0:0=
:0/block/sde/sde2/bcache
-r--r--r-- 1 root root 4096  8. Apr 20:33 block_size
-r--r--r-- 1 root root 4096  8. Apr 20:33 btree_cache_size
-r--r--r-- 1 root root 4096  8. Apr 20:33 bucket_size
lrwxrwxrwx 1 root root    0  8. Apr 20:33 cache0 ->=20
=2E./../../devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0=
:0/block/sdb/sdb3/bcache
[...]


--=20
Replies to list only preferred.
