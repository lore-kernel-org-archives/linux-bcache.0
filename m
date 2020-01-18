From: Clodoaldo Neto <clodoaldo.pinto.neto@gmail.com>
Subject: Re: undo make-bcache (was: Re: Can't mount an encrypted backing device)
Date: Sat, 18 Jan 2020 08:44:53 -0300
Message-ID: <CA+Z73LFCAx-TfczrvNd47aNy2mGmkF9r-0ovEp-Zm62Z6wm1Ow@mail.gmail.com>
References: <CA+Z73LFJLiP7Z2_cDUsO4Om_8pdD6w1jTSGQB0jY5sL-+nw1Wg@mail.gmail.com>
 <CA+Z73LGvXa_V8t=KYPkrmeJ-xmEXmz1uAnaT=Yj5AReZgLeqhg@mail.gmail.com>
 <65c05b80-679b-2ccb-1bd1-a9a6887c9c51@suse.de> <20200113124415.Horde.G9hpYwu_fqvg2w0msexL3ri@webmail.nde.ag>
 <0c6c3fea-5580-3a71-264c-b383b5b4fe66@suse.de> <CA+Z73LGG1pBtT=0WN5vEyqEvzxEnqMRZ26S_2x4Gd5JPSmuXmQ@mail.gmail.com>
 <CA+Z73LFNxP8kDMSq74DBKDbCXpbtMA9svpc1KddkUmrk-cfnOA@mail.gmail.com>
 <CA+Z73LGXJOwYEb+GmPuuDi3TcJbGG=NLv-5vCRcEvB+kgr4a+A@mail.gmail.com>
 <CA+Z73LGmM2YV1PkADFpQghqaNVNqAGjPg+LF8NSG9UTahcxGtg@mail.gmail.com> <alpine.LRH.2.11.2001162259580.23088@mx.ewheeler.net>
Reply-To: clodoaldo.pinto.neto@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qk1-f176.google.com ([209.85.222.176]:35181 "EHLO
        mail-qk1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727109AbgARLpF (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 18 Jan 2020 06:45:05 -0500
Received: by mail-qk1-f176.google.com with SMTP id z76so25464643qka.2
        for <linux-bcache@vger.kernel.org>; Sat, 18 Jan 2020 03:45:05 -0800 (PST)
In-Reply-To: <alpine.LRH.2.11.2001162259580.23088@mx.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: linux-bcache@vger.kernel.org

On Thu, Jan 16, 2020 at 8:01 PM Eric Wheeler <bcache@lists.ewheeler.net> wr=
ote:
>
> On Thu, 16 Jan 2020, Clodoaldo Neto wrote:
>
> > Em seg, 13 de jan de 2020 11:19, Coly Li <colyli@suse.de> escreveu:
> > >
> > > On 2020/1/13 8:44 =E4=B8=8B=E5=8D=88, Jens-U. Mozdzen wrote:
> > > > Hi Coly,
> > > >
> > > > jumping in here, because I was looking for a way to revert from bca=
che
> > > > to plain device:
> > > >
> > > > Zitat von Coly Li <colyli@suse.de>:
> > > >> The super block location of the backing disk is occupied by bcache=
. You
> > > >> cannot mount the file system directly from the backing disk which =
is
> > > >> formated as bcache backing device [...] (bcache offset all I/Os on
> > > >> bcache device 4KB behind the requesting
> > > >> LBA on backing disk).
> > > >
> > > > Assuming that no caching device is associated with a backing device=
 (so
> > > > the backing device is "clean" as in "containing all data blocks wit=
h the
> > > > current content"), could one convert the content of a backing devic=
e to
> > > > a "non-bcached device" by removing the first 4096 octets of the bac=
king
> > > > device content?
> > > >
> > > > Something like "dd if=3Dbackingdev of=3Dnewdev skip_bytes=3D4096 ..=
."?
> > >
> > > Hi Jens-U,
> > >
> > > you may try dmsetup to setup a linear device mapper target, and the m=
ap
> > > table just skipping the first 4KB (bcache superblock area). If you ar=
e
> > > lucky, I mean the real file system is not corrupted, the created devi=
ce
> > > mapper target can be mounted directly.
> >
> >
> > I'm trying dmsetup but it does not accept anything other than 0 and 0
> > at the beginning and end of the table:
> >
> > # echo '0 3774578672 linear /dev/mapper/backing-device 8' | dmsetup cre=
ate dmb
> > device-mapper: reload ioctl on dmb  failed: Invalid argument
> > Command failed.
> >
> > # echo '8 3774578664 linear /dev/mapper/backing-device 0' | dmsetup cre=
ate dmb
> > device-mapper: reload ioctl on dmb  failed: Invalid argument
> > Command failed.
> >
> > I'm not sure about how it works. Is it not 8 sectors for 4k bytes?
>
> Does dmesg give a hint?
>

# echo '0 3774578672 linear /dev/mapper/backing-device 8' | dmsetup create =
dmb
device-mapper: reload ioctl on dmb  failed: Invalid argument
Command failed.

# dmesg | grep -E "bcache|device-mapper"
[    0.854520] device-mapper: uevent: version 1.0.3
[    0.854586] device-mapper: ioctl: 4.41.0-ioctl (2019-09-16)
initialised: dm-devel@redhat.com
[   52.719925] bcache: bch_journal_replay() journal replay done, 0
keys in 1 entries, seq 1
[   52.722965] bcache: register_cache() registered cache device sdb1
[   52.934796] bcache: register_bdev() registered backing device md127
[   55.628944] bcache: bch_journal_replay() journal replay done, 0
keys in 1 entries, seq 31
[   55.629200] bcache: register_cache() registered cache device dm-2
[  851.024624] device-mapper: table: 253:3: linear: Gap in table
[  851.024626] device-mapper: ioctl: error adding target to table

>
> --
> Eric Wheeler
>
>
>
> >
> >
> > Clodoaldo
> >
> > >
> > > --
> > >
> > > Coly Li
> > >
> >
