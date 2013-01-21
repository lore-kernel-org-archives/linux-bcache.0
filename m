From: Nitin Kshirsagar <nshirsagar-FZ1t8LVTR2ZWk0Htik3J/w@public.gmane.org>
Subject: Not able compile bcache-tools source code
Date: Mon, 21 Jan 2013 21:19:11 +0800
Message-ID: <C4B5704C6FEB5244B2A1BCC8CF83B86B0A6257C7C6@MYMBX.MY.STEC-INC.AD>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org


Hi All,

Source code URL: http://bcache.evilpiepirate.org/
Compilation fails:=20
[root@annu bcache-tools]# ls -1=20
61-bcache.rules
bcache.c
bcache.h
bcache.o
bcache-test.c
COPYING
initramfs
make-bcache.8
make-bcache.c
Makefile
probe-bcache.8
probe-bcache.c
README
[root@annu bcache-tools]# make=20
cc -O2 -Wall -g    make-bcache.c bcache.o  -luuid -o make-bcache
make-bcache.c:20:23: error: uuid/uuid.h: No such file or directory
make-bcache.c: In function =91write_sb=92:
make-bcache.c:212: warning: implicit declaration of function =91uuid_un=
parse=92
make-bcache.c:246: warning: implicit declaration of function =91uuid_ge=
nerate=92
make-bcache.c: In function =91main=92:
make-bcache.c:280: warning: implicit declaration of function =91uuid_pa=
rse=92
make: *** [make-bcache] Error 1


--=20
Thanks & Regards

Nitin Kshirsagar
Software Engr, QA
Cell 997.566.3985

STEC india private Limited, Pune | The SSD Company TM
NASDAQ STEC =95 Web www.stec-inc.com

PROPRIETARY-CONFIDENTIAL INFORMATION INCLUDED=0D
=0D
This electronic transmission, and any documents attached hereto, may co=
ntain confidential, proprietary and/or legally privileged information. =
The information is intended only for use by the recipient named above. =
If you received this electronic message in error, please notify the sen=
der and delete the electronic message. Any disclosure, copying, distrib=
ution, or use of the contents of information received in error is stric=
tly prohibited, and violators will be pursued legally.
