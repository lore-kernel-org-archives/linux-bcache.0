From: Brad Campbell <brad-+nnirC7rrGZibQn6LdNjmg@public.gmane.org>
Subject: Re: New version up with fix for md and other block devices
Date: Fri, 09 Dec 2011 10:18:21 +0800
Message-ID: <4EE16FED.5080809@fnarfbargle.com>
References: <20111121101402.GA17787@dhcp-172-18-216-138.mtv.corp.google.com>	<4ED47771.9030309@fnarfbargle.com>	<20111129063126.GA14194@dhcp-172-18-216-138.mtv.corp.google.com>	<4ED48A64.4080406@fnarfbargle.com>	<20111129075440.GB14194@dhcp-172-18-216-138.mtv.corp.google.com>	<4ED4981E.6040501@fnarfbargle.com>	<20111206034553.GA25438@moria>	<CAC7rs0saVh=a587mNCTCJwbVi7-u7kRuXu6-pZuJ6CRs1AACsw@mail.gmail.com>	<CAC7rs0ttY4Ama4v7yTepVTc65TyCo3+T4aPFoHJW1CwA8mDuUA@mail.gmail.com> <CAH+dOxLW71YKpC1YL61osFq6oDVWxoj4ajLht3EqMUiWTYogTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH+dOxLW71YKpC1YL61osFq6oDVWxoj4ajLht3EqMUiWTYogTA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 06/12/11 14:01, Kent Overstreet wrote:
> Ok, it looks like as long as your cache's bucket size is not greater
> than 1 mb everything should work, including writeback. Look forward t=
o
> hearing if it works for you :)

I saw you re-based the repository so I cloned fresh this morning and ge=
t=20
this compile error :

brad@test:/raid10/src/linux-bcache$ make
   CHK     include/linux/version.h
   CHK     include/generated/utsrelease.h
   CALL    scripts/checksyscalls.sh
   CHK     include/generated/compile.h
   CHK     kernel/config_data.h
   CC      drivers/block/bcache/super.o
drivers/block/bcache/super.c: In function =91lioctl_dev=92:
drivers/block/bcache/super.c:1209: error: =91const struct=20
block_device_operations=92 has no member named =91locked_ioctl=92
drivers/block/bcache/super.c: At top level:
drivers/block/bcache/super.c:1215: error: unknown field =91locked_ioctl=
=92=20
specified in initializer
make[3]: *** [drivers/block/bcache/super.o] Error 1
make[2]: *** [drivers/block/bcache] Error 2
make[1]: *** [drivers/block] Error 2
make: *** [drivers] Error 2

Regards,
Brad
