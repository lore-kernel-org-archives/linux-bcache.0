From: Jason Warr <jason-/cow75dQlsI@public.gmane.org>
Subject: Re: bcache vs enhanceio?
Date: Tue, 19 Feb 2013 10:41:15 -0600
Message-ID: <5123AB2B.9020209@warr.net>
References: <1514139.9.1361276600610.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1514139.9.1361276600610.JavaMail.root@zimbra>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roy Sigurd Karlsbakk <roy-ooPBL11mRiZbRRN4PJnoQQ@public.gmane.org>, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Thrift <andrew-3e6jenk95VYpDvLZ8AWkcaVXKuFTiq87@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org


On 02/19/2013 06:23 AM, Roy Sigurd Karlsbakk wrote:
> ----- Opprinnelig melding -----
>> ZFS is not just a filesystem. It is a complete block device storage
>> management stack that has a filesystem component.
> I know ZFS quite well, so I'm aware of the comparison is somewhat unf=
air.=20
Unfair is an understatement.  But I also think it is quite a sham how
many things that Sun and now Oracle has been bromising to put in for
years that seem now to be fairy tails.  The two biggest ones that I can
think of are VDEV removal and RAIDZ[2,3] stripe expansion.

I've been working with ZFS since I was able to get the first internal
alpha from the team at Sun that would apply to the Nevada dev tree.  I
think that was about build 17.  I believe it was 27a that it finally
made it in to the ON consolidation.  Really smart bunch of guys working
on that at the time.  Almost all of them have jumped ship now though.
>
>> The Linux tool chain can be more complicated but it is vastly more
>> flexible. With the addition of a caching target all of the pieces ar=
e
>> there to be able to build a tiering storage system in any way your u=
se
>> case needs it to be.
> Still, flashcache/enhanceio seems to be able to handle this in a very=
 flexible way. I really don't want to recreate my home RAID (7,2TiB) ju=
st to add cache to it=E2=80=A6
I can agree with this on principal but having to re-do it for cache can
have some other positive effects.  Some that I can think of is it give
you an opportunity to get LV's re-aligned if your like most and have
extended them one or more times, Perhaps your volume layout is not idea=
l
and you have been putting off fixing that, etc...

Chances are that if your wanting to add a cache the filesystems are
relatively busy and may benefit from being re-created to reduce file
fragmentation.

It would be very nice to be able to do but in order for it to happen
your entire block tool chain would have to be prepared for it to be a
possibility for it to happen.  That's why ZFS can do that.

A question for Kent, once you have bcache and it's tools built,
installed and running, is there anything to stop a user from always
tagging devices of whatever type you choose from having the superblock
info to accept a cache dynamically?  Example, if I create an MD RAID
device and before I pvcreate or anything else with it I prep it for
bcache but don't actually attach a cache device, is there any negative
effects that can come from that?  Can I then at anytime attach a cache
device to it?  I realize that once attached in writeback it becomes
non-detachable.  Same question for raw sd devices and LVM volumes.

> Vennlige hilsener / Best regards
>
> roy
> --
> Roy Sigurd Karlsbakk
> (+47) 98013356
> roy-ooPBL11mRiZbRRN4PJnoQQ@public.gmane.org
> http://blogg.karlsbakk.net/
> GPG Public key: http://karlsbakk.net/roysigurdkarlsbakk.pubkey.txt
> --
> I all pedagogikk er det essensielt at pensum presenteres intelligibel=
t. Det er et element=C3=A6rt imperativ for alle pedagoger =C3=A5 unng=C3=
=A5 eksessiv anvendelse av idiomer med xenotyp etymologi. I de fleste t=
ilfeller eksisterer adekvate og relevante synonymer p=C3=A5 norsk.
