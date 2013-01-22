From: Nitin Kshirsagar <nshirsagar-FZ1t8LVTR2ZWk0Htik3J/w@public.gmane.org>
Subject: RE: Not able compile bcache-tools source code
Date: Tue, 22 Jan 2013 13:36:52 +0800
Message-ID: <C4B5704C6FEB5244B2A1BCC8CF83B86B0A6257C7C7@MYMBX.MY.STEC-INC.AD>
References: <C4B5704C6FEB5244B2A1BCC8CF83B86B0A6257C7C6@MYMBX.MY.STEC-INC.AD>,<CAC7rs0uCU9B1SP4G4P1Di05hF=hZd1JJkipKd2UFrBBqEG2PBw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAC7rs0uCU9B1SP4G4P1Di05hF=hZd1JJkipKd2UFrBBqEG2PBw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Hi,

make install fails =20
[root@annu bcache-tools]# make install
install -m0755 make-bcache	/usr/sbin/
install -m0755 probe-bcache	/sbin/
install -m0644 61-bcache.rules	/lib/udev/rules.d/
install -m0755 initramfs/script /etc/initramfs-tools/scripts/init-premo=
unt/bcache
install -m0755 initramfs/hook	/etc/initramfs-tools/hooks/bcache
install: cannot create regular file `/etc/initramfs-tools/hooks/bcache'=
: No such file or directory
make: *** [install] Error 1

--
Thanks & Regards

Nitin Kshirsagar
Software Engr, QA
Cell 997.566.3985

STEC india private Limited, Pune | The SSD Company TM
NASDAQ STEC =95 Web www.stec-inc.com
________________________________________
=46rom: Kent Overstreet [kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
Sent: Monday, January 21, 2013 9:27 AM
To: Nitin Kshirsagar
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: Not able compile bcache-tools source code

apt-get install libuuid-dev

On Mon, Jan 21, 2013 at 5:19 AM, Nitin Kshirsagar
<nshirsagar-FZ1t8LVTR2ZWk0Htik3J/w@public.gmane.org> wrote:
>
> Hi All,
>
> Source code URL: http://bcache.evilpiepirate.org/
> Compilation fails:
> [root@annu bcache-tools]# ls -1
> 61-bcache.rules
> bcache.c
> bcache.h
> bcache.o
> bcache-test.c
> COPYING
> initramfs
> make-bcache.8
> make-bcache.c
> Makefile
> probe-bcache.8
> probe-bcache.c
> README
> [root@annu bcache-tools]# make
> cc -O2 -Wall -g    make-bcache.c bcache.o  -luuid -o make-bcache
> make-bcache.c:20:23: error: uuid/uuid.h: No such file or directory
> make-bcache.c: In function =91write_sb=92:
> make-bcache.c:212: warning: implicit declaration of function =91uuid_=
unparse=92
> make-bcache.c:246: warning: implicit declaration of function =91uuid_=
generate=92
> make-bcache.c: In function =91main=92:
> make-bcache.c:280: warning: implicit declaration of function =91uuid_=
parse=92
> make: *** [make-bcache] Error 1
>
>
> --
> Thanks & Regards
>
> Nitin Kshirsagar
> Software Engr, QA
> Cell 997.566.3985
>
> STEC india private Limited, Pune | The SSD Company TM
> NASDAQ STEC =95 Web www.stec-inc.com
>
> PROPRIETARY-CONFIDENTIAL INFORMATION INCLUDED
>
> This electronic transmission, and any documents attached hereto, may =
contain confidential, proprietary and/or legally privileged information=
=2E The information is intended only for use by the recipient named abo=
ve. If you received this electronic message in error, please notify the=
 sender and delete the electronic message. Any disclosure, copying, dis=
tribution, or use of the contents of information received in error is s=
trictly prohibited, and violators will be pursued legally.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcach=
e" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

PROPRIETARY-CONFIDENTIAL INFORMATION INCLUDED=0D
=0D
This electronic transmission, and any documents attached hereto, may co=
ntain confidential, proprietary and/or legally privileged information. =
The information is intended only for use by the recipient named above. =
If you received this electronic message in error, please notify the sen=
der and delete the electronic message. Any disclosure, copying, distrib=
ution, or use of the contents of information received in error is stric=
tly prohibited, and violators will be pursued legally.
