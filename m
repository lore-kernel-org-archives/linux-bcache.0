From: Josep Lladonosa <jlladono-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Fwd: low speed writing in device
Date: Mon, 19 Aug 2013 10:47:55 +0200
Message-ID: <CAPBO7TYh5hG7gd16wPBRLNF1WYNMuaJYQ1S7X_VzygpQG=m3rA@mail.gmail.com>
References: <CAPBO7TZxbg9PMHNOcB_OMoNNZA6P95kRD0EkSMaz-X9YzprLNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPBO7TZxbg9PMHNOcB_OMoNNZA6P95kRD0EkSMaz-X9YzprLNw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Hello,


I wrote some days ago about low rates on "intense" writes, and tried
the given patch in the reply. It did not work for me.
Kernel 3.11.0-rc5 with last bcache from git was also not solving this issue.

Today I have tried  3.11.0-rc6 and unfortunately, I get similar results.
I add here results of iostat while dpkg -i linux-headers (or
installation of a linux-image). They take minutes, minutes,
minuuuuuutes... ;)


# iostat -d 5
Linux 3.11.0-rc6 (minijep)     19/08/13     _x86_64_    (8 CPU)

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda              19,70        78,48       350,69      34506     154188
sdb              64,05       913,99       306,53     401856     134772
bcache0          96,15       915,06       350,68     402322     154184

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda             409,20         0,80     14871,20          4      74356
sdb            1299,60         6,40     10969,60         32      54848
bcache0        2434,00         7,20     14871,20         36      74356

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda              10,60         0,00        26,40          0        132
sdb              10,80         0,00        67,20          0        336
bcache0          16,80         0,00        26,40          0        132

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda              10,40         0,00        15,20          0         76
sdb              10,60         0,00        56,80          0        284
bcache0          13,80         0,00        15,20          0         76

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda              10,60         0,00        16,80          0         84
sdb              10,60         0,00        56,80          0        284
bcache0          14,40         0,00        16,80          0         84

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda              10,80         0,00        28,00          0        140
sdb              11,20         0,00        70,40          0        352
bcache0          17,20         0,00        28,00          0        140

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda             125,60         0,00      3951,20          0      19756
sdb              22,20         0,00      3906,40          0      19532
bcache0         971,20         0,00      3951,20          0      19756

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda              16,40         0,00       274,40          0       1372
sdb              18,40         0,00       327,20          0       1636
bcache0          22,00         0,00       274,40          0       1372

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda              10,60         0,00        15,20          0         76
sdb              10,60         0,00        55,20          0        276
bcache0          13,80         0,00        15,20          0         76




-- 
--
Salutacions...Josep
--
