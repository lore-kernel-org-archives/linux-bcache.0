From: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Subject: configuration for kvm vps on disk
Date: Thu, 17 Oct 2013 22:48:44 +0400
Message-ID: <CACaajQt5FV=hLROyFtF-dQHpKzwq0guwwTonYjYF=q4MtW9q2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi all. I'm very happy with bcache. Now i'm try tune some params  for own nedds.
Firstly i want to run 50 vps on disk and get to it greate performance
(im not warry about ssd disk failure).
What fs best of all for that? ext4 or btrfs?
What parameters in bcache i need to tune to get maximum performance?
I'm try to disable sequential cutoff


Now i'm get something like this, Why i have very bad random read speed?

        Auto Mode
        OPS Mode. Output is in operations per second.
        File size set to 3145728 KB
        Command line used: iozone -a -i0 -i1 -i2 -O -s3G
        Time Resolution = 0.000001 seconds.
        Processor cache size set to 1024 Kbytes.
        Processor cache line size set to 32 bytes.
        File stride size set to 17 * record size.
                                                            random
random    bkwd   record   stride
              KB  reclen   write rewrite    read    reread    read
write    read  rewrite     read   fwrite frewrite   fread  freread
         3145728       4  112681  101056    97197    94559    3641   40138
         3145728       8   68963   67357    35151    39137    2789   49231
         3145728      16   28620   34762    20139    22825    2303   28583
         3145728      32   13285   16637    10209    11520    1848   13074
         3145728      64    6875    8470     5229     5817    1268    7887
         3145728     128    3946    4078     2660     2943     905    4004
         3145728     256    1983    2183     1350     1452     593    1801
         3145728     512     988     971      672      727     418    1079
         3145728    1024     474     527      345      375     280     552
         3145728    2048     265     255      170      183     158     235
         3145728    4096     135     129       89       91      85     121
         3145728    8192      67      63       45       45      43      63
         3145728   16384      34      32       22       22      22      33

i mount ext4 via

/dev/bcache0 /var/lib/libvirt/images ext4
rw,relatime,journal_checksum,journal_async_commit,errors=remount-ro,min_batch_time=15000,max_batch_time=60000,data=ordered
0 0

-- 
Vasiliy Tolstov,
e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
jabber: vase-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
