From: "Lidong Zhong" <lzhong@suse.com>
Subject: Re: caching device setup
Date: Mon, 13 Apr 2015 01:58:41 -0600
Message-ID: <552BE7B1020000E100020AE9@relay2.provo.novell.com>
References: <CAK1hC9vTG=TEsUzNgxym=+0swhPoxBNaaPAiWk1kBf-D+_Hftg@mail.gmail.com>
 <498317a297a1038028f1393da9b49231@de.mcbf.net>
 <98agvb-l7r.ln1@hurikhan77.spdns.de>
 <55265CE0020000E100020423@relay2.provo.novell.com>
 <u8vlvb-ciu.ln1@hurikhan77.spdns.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from relay2.provo.novell.com ([137.65.250.214]:38111 "EHLO
	relay2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbbDMH6u (ORCPT
	<rfc822;groupwise-linux-bcache@vger.kernel.org:1:1>);
	Mon, 13 Apr 2015 03:58:50 -0400
In-Reply-To: <u8vlvb-ciu.ln1@hurikhan77.spdns.de>
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

>> On 4/11/2015 at 06:26 AM, in message <u8vlvb-ciu.ln1@hurikhan77.spdn=
s.de>, Kai
Krakow <hurikhan77@gmail.com> wrote:=20
> Lidong Zhong <lzhong@suse.com> schrieb:=20
> =20
>>>>> On 4/9/2015 at 02:56 AM, in message=20
>>>>> <98agvb-l7r.ln1@hurikhan77.spdns.de>, Kai=20
> > Krakow <hurikhan77@gmail.com> wrote:=20
> >> David Mohr <david@mcbf.net> schrieb:=20
> >>  =20
> > I am curious about how rootfs and home share the SSD dynamically. A=
re they=20
> > on the same partition? Sorry for stupid questions since I just touc=
hed=20
> > bcache recently.=20
> =20
> Cache and backing device association is not 1:1. You can attach multi=
ple =20
> backing partitions (even from distinct filesystems) to the one and sa=
me =20
> caching partition. So, accesses to one of the cached filesystems will=
 go =20
> through the same bcache, thus sharing the cache space through bcache'=
s LRU =20
> implementation (or if you change it from the default, even something =
else =20
> like LRU).=20
> =20
> Here's my setup (shortened):=20
> =20
> =E2=94=9C=E2=94=80sdb3        8:19   0  79,5G  0 part=20
> =E2=94=82 =E2=94=9C=E2=94=80bcache0 252:0    0 925,5G  0 disk=20
> =E2=94=82 =E2=94=9C=E2=94=80bcache1 252:1    0 925,5G  0 disk=20
> =E2=94=82 =E2=94=94=E2=94=80bcache2 252:2    0 925,5G  0 disk=20
> =20
> with sdb3 being the one and only bcache partition on SSD:=20
> =20
> $ ls -al /sys/fs/bcache/=20
> insgesamt 0=20
> drwxr-xr-x  3 root root    0 11. Apr 00:25 .=20
> drwxr-xr-x 11 root root    0  6. Apr 19:07 ..=20
> drwxr-xr-x  7 root root    0  8. Apr 20:33 bf2b67f9-a261-4d27-=20
> a6ef-2961f2ce2cc2=20
> --w-------  1 root root 4096  8. Apr 20:33 register=20
> --w-------  1 root root 4096  6. Apr 19:08 register_quiet=20
> =20
> $ ls -al /sys/fs/bcache/bf2b67f9-a261-4d27-a6ef-2961f2ce2cc2/=20
> insgesamt 0=20
> drwxr-xr-x 7 root root    0 11. Apr 00:25 .=20
> drwxr-xr-x 3 root root    0 11. Apr 00:25 ..=20
> -r--r--r-- 1 root root 4096  8. Apr 20:33 average_key_size=20
> lrwxrwxrwx 1 root root    0  8. Apr 20:33 bdev0 -> =20
> ../../../devices/pci0000:00/0000:00:1f.2/ata3/host2/target2:0:0/2:0:0=
:0/bloc=20
> k/sdc/sdc2/bcache=20
> lrwxrwxrwx 1 root root    0  8. Apr 20:33 bdev1 -> =20
> ../../../devices/pci0000:00/0000:00:1f.2/ata4/host3/target3:0:0/3:0:0=
:0/bloc=20
> k/sdd/sdd2/bcache=20
> lrwxrwxrwx 1 root root    0  8. Apr 20:33 bdev2 -> =20
> ../../../devices/pci0000:00/0000:00:1f.2/ata5/host4/target4:0:0/4:0:0=
:0/bloc=20
> k/sde/sde2/bcache=20
> -r--r--r-- 1 root root 4096  8. Apr 20:33 block_size=20
> -r--r--r-- 1 root root 4096  8. Apr 20:33 btree_cache_size=20
> -r--r--r-- 1 root root 4096  8. Apr 20:33 bucket_size=20
> lrwxrwxrwx 1 root root    0  8. Apr 20:33 cache0 -> =20
> ../../../devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0=
:0/bloc=20
> k/sdb/sdb3/bcache=20
> [...]=20
> =20
Thank you for your detailed explanation.

Regards,
Lidong
> =20
> -- =20
> Replies to list only preferred.=20
> =20
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-bcach=
e" in=20
> the body of a message to majordomo@vger.kernel.org=20
> More majordomo info at  http://vger.kernel.org/majordomo-info.html=20
> =20
> =20
