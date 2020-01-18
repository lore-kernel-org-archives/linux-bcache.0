From: Clodoaldo Neto <clodoaldo.pinto.neto@gmail.com>
Subject: Re: undo make-bcache (was: Re: Can't mount an encrypted backing device)
Date: Sat, 18 Jan 2020 09:22:34 -0300
Message-ID: <CA+Z73LFpXFOcWNzn3nMN7kCWjzUa0myQiOc+tozFbNZGemxXhA@mail.gmail.com>
References: <CA+Z73LFJLiP7Z2_cDUsO4Om_8pdD6w1jTSGQB0jY5sL-+nw1Wg@mail.gmail.com>
 <CA+Z73LGvXa_V8t=KYPkrmeJ-xmEXmz1uAnaT=Yj5AReZgLeqhg@mail.gmail.com>
 <65c05b80-679b-2ccb-1bd1-a9a6887c9c51@suse.de> <20200113124415.Horde.G9hpYwu_fqvg2w0msexL3ri@webmail.nde.ag>
 <0c6c3fea-5580-3a71-264c-b383b5b4fe66@suse.de> <CA+Z73LGG1pBtT=0WN5vEyqEvzxEnqMRZ26S_2x4Gd5JPSmuXmQ@mail.gmail.com>
 <CA+Z73LFNxP8kDMSq74DBKDbCXpbtMA9svpc1KddkUmrk-cfnOA@mail.gmail.com>
 <CA+Z73LGXJOwYEb+GmPuuDi3TcJbGG=NLv-5vCRcEvB+kgr4a+A@mail.gmail.com>
 <32fb3244-cb9e-460d-3156-99e418dda44f@suse.de> <CA+Z73LE8GEHqvsFqNuQ3+aSbSmC93D68zd+gTw8Hk=78RjUj7A@mail.gmail.com>
Reply-To: clodoaldo.pinto.neto@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qk1-f171.google.com ([209.85.222.171]:43140 "EHLO
        mail-qk1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbgARMWr (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 18 Jan 2020 07:22:47 -0500
Received: by mail-qk1-f171.google.com with SMTP id t129so25504255qke.10
        for <linux-bcache@vger.kernel.org>; Sat, 18 Jan 2020 04:22:46 -0800 (PST)
In-Reply-To: <CA+Z73LE8GEHqvsFqNuQ3+aSbSmC93D68zd+gTw8Hk=78RjUj7A@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: "Jens-U. Mozdzen" <jmozdzen@nde.ag>, linux-bcache@vger.kernel.org

On Sat, Jan 18, 2020 at 7:54 AM Clodoaldo Neto
<clodoaldo.pinto.neto@gmail.com> wrote:
>
> On Thu, Jan 16, 2020 at 9:59 PM Coly Li <colyli@suse.de> wrote:
> >
> > On 2020/1/17 5:52 =E4=B8=8A=E5=8D=88, Clodoaldo Neto wrote:
> > >
> > > Em seg, 13 de jan de 2020 11:19, Coly Li <colyli@suse.de
> > > <mailto:colyli@suse.de>> escreveu:
> > >>
> > >> On 2020/1/13 8:44 =E4=B8=8B=E5=8D=88, Jens-U. Mozdzen wrote:
> > >> > Hi Coly,
> > >> >
> > >> > jumping in here, because I was looking for a way to revert from bc=
ache
> > >> > to plain device:
> > >> >
> > >> > Zitat von Coly Li <colyli@suse.de <mailto:colyli@suse.de>>:
> > >> >> The super block location of the backing disk is occupied by bcach=
e. You
> > >> >> cannot mount the file system directly from the backing disk which=
 is
> > >> >> formated as bcache backing device [...] (bcache offset all I/Os o=
n
> > >> >> bcache device 4KB behind the requesting
> > >> >> LBA on backing disk).
> > >> >
> > >> > Assuming that no caching device is associated with a backing devic=
e (so
> > >> > the backing device is "clean" as in "containing all data blocks wi=
th the
> > >> > current content"), could one convert the content of a backing devi=
ce to
> > >> > a "non-bcached device" by removing the first 4096 octets of the ba=
cking
> > >> > device content?
> > >> >
> > >> > Something like "dd if=3Dbackingdev of=3Dnewdev skip_bytes=3D4096 .=
.."?
> > >>
> > >> Hi Jens-U,
> > >>
> > >> you may try dmsetup to setup a linear device mapper target, and the =
map
> > >> table just skipping the first 4KB (bcache superblock area). If you a=
re
> > >> lucky, I mean the real file system is not corrupted, the created dev=
ice
> > >> mapper target can be mounted directly.
> > >
> > >
> > > I'm trying dmsetup but it does not accept anything other than 0 and 0
> > > at the beginning and end of the table:
> > >
> > > # echo '0 3774578672 linear /dev/mapper/backing-device 8' | dmsetup
> > > create dmb
> > > device-mapper: reload ioctl on dmb  failed: Invalid argument
> > > Command failed.
> >
> > The above line should work, if 3774578672 is a correct size number in
> > sectors.
>
> I took it from the original map:
>
> # dmsetup table /dev/mapper/backing-device
> 0 3774578672 crypt aes-xts-plain64
> :64:logon:cryptsetup:7e2c0b40-8dec-4b13-8d00-b53b55160775-d0 0 251:0
> 32768

It works like this:

# echo '0 3774578664 linear /dev/mapper/backing-device 8' | dmsetup create =
dmb

But then I can't mount it:

# mount /dev/mapper/dmb /r
mount: /r: wrong fs type, bad option, bad superblock on
/dev/mapper/dmb, missing codepage or helper program, or other error.

>
> >
> > >
> > > # echo '8 3774578664 linear /dev/mapper/backing-device 0' | dmsetup
> > > create dmb
> > > device-mapper: reload ioctl on dmb  failed: Invalid argument
> > > Command failed.
> > >
> > > I'm not sure about how it works. Is it not 8 sectors for 4k bytes?
> > >
> >
> > It works on my side, my kernel is Linux v5.5-rc2, lvm2 version is
> > 2.02.180, dmsetup version is 1.02.149. The difference is the device
> > size, my disk size is much less.
> >
> > --
> >
> > Coly Li
