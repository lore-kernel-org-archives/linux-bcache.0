From: Georg =?utf-8?Q?Sch=C3=B6nberger?=
	<gschoenberger-qD/LZSXtZz5FYGZjsVlUvw@public.gmane.org>
Subject: Flushing dirty data after bcache detach
Date: Wed, 21 Aug 2013 10:48:57 +0200 (CEST)
Message-ID: <1057573722.337424.1377074937216.JavaMail.root@thomas-krenn.com>
References: <423285490.335846.1377074174264.JavaMail.root@thomas-krenn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <423285490.335846.1377074174264.JavaMail.root-qD/LZSXtZz5FYGZjsVlUvw@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi bcache team,

we are currently developing performance test scripts with Fio for bcach=
e.
At the end of a test we want to detach and destroy the cache. Therefore=
 we did:
    echo 1 > /sys/block/$dev/bcache/detach
    echo 1 > /sys/block/$dev/bcache/stop

    echo 1 > /sys/fs/bcache/*/stop
    echo 1 > /sys/fs/bcache/*/unregister

With a simple randwrite test with we had about 2GB dirty data in the ca=
che. After detaching the dirty data flush rate was about 900KB/s from S=
SD to HDD.
Is there a way to accelerate flushing of dirty data?
What is the correct way to detach/destroy a writeback caching device?

* Kernel:  3.11.0-2-generic #5-Ubuntu SMP Mon Aug 12 16:09:51 UTC 2013 =
x86_64 x86_64 x86_64 GNU/Linux
* Kernel module info:
filename:       /lib/modules/3.11.0-2-generic/kernel/drivers/md/bcache/=
bcache.ko
author:         Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
license:        GPL
license:        GPL
author:         Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
srcversion:     EE441BF41AAB31C3E44F5D2
depends:       =20
intree:         Y
vermagic:       3.11.0-2-generic SMP mod_unload modversions=20
* iostat while flushing after detach:
Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda               0.00         0.00         0.00          0          0
sdc             229.50       912.00         6.00       1824         12
sdb             228.00         0.00       912.00          0       1824
bcache0           0.00         0.00         0.00          0          0

Thanks a lot for your help in advance, Georg.
--
: Georg Sch=C3=B6nberger
: Research & Development Executive
: Thomas-Krenn.AG | The server-experts
: http://www.thomas-krenn.com | http://www.thomas-krenn.com/wiki
