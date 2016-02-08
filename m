From: Nikolaus Rath <Nikolaus@rath.org>
Subject: Re: bcache and LVM
Date: Mon, 08 Feb 2016 14:02:52 -0800
Message-ID: <87r3gmrhbn.fsf@thinkpad.rath.org>
References: <87k2mgo2rz.fsf@vostro.rath.org>
	<20160208144419.Horde.Ci1_2KcBCEnOa-WxsDN90oU@www3.nde.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51072 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464AbcBHWIO (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Mon, 8 Feb 2016 17:08:14 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1aStyc-0005LV-9t
	for linux-bcache@vger.kernel.org; Mon, 08 Feb 2016 23:08:10 +0100
Received: from ebox.rath.org ([45.79.69.51])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Mon, 08 Feb 2016 23:08:10 +0100
Received: from Nikolaus by ebox.rath.org with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Mon, 08 Feb 2016 23:08:10 +0100
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

On Feb 08 2016, "Jens-U. Mozdzen" <jmozdzen@nde.ag> wrote:
> Hi Nikolaus,
>
> Zitat von Nikolaus Rath <Nikolaus@rath.org>:
>> Hello,
>>
>> The internet claims that using bcache with LVM is not a good idea
>> (eg. on https://wiki.archlinux.org/index.php/Bcache )- but I wasn't =
able
>> to find any substantial information other than this general
>> recommendation.
>
> looking at that article, it only references possibly ill-handled
> "discard" operations, when running bcache on top of LVM.

Well, it says:

| Warning:
|=20
|     it is widely recommended to use Bcache underneath any other block
|    layer.


To me this implies that running it on top of another block layer is
dangerous (why warn about it otherwise?).=20

> The article itself does positively mention sub-dividing bcache device=
s
> using LVM.

Yep, but the talk page then says:

| Initially, LVM did not recognize my /dev/bcache0 when I wanted to
| create a physical volume on it. For anyone else who has that issue,
| this may be relevant:
| http://www.redhat.com/archives/linux-lvm/2012-March/msg00005.html.


>> Is this still (or has ever been) correct? If so, what issues can ari=
se?
>> And does this happen only when using bcache on top of an LVM LV, or =
also
>> when using a bcache device as an LVM PV?
>
> We're running bcache between MD-RAID (RAID6 for the HDD backing store
> and RAID1 for caching SSDs) and LVM2 (using bcache0 as the only PV fo=
r
> the volume group) without any noticeable problem, for moderate to
> significant load (SAN/NAS servers with NFS, Samba, and virtual
> machines' storage via SCST/FC and SCST/iSCSI).

Thanks for the datapoint! What kernel version do you use?


Best,
-Nikolaus

--=20
GPG encrypted emails preferred. Key id: 0xD113FCAC3C4E599F
=46ingerprint: ED31 791B 2C5C 1613 AF38 8B8A D113 FCAC 3C4E 599F

             =C2=BBTime flies like an arrow, fruit flies like a Banana.=
=C2=AB
