From: Alain Spineux <aspineux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: howto unregister disks and unload bcache module
Date: Wed, 4 Jul 2012 11:15:32 +0200
Message-ID: <CACgTii9ZvM=jxJzhaQOZHuca3666KArQPf2AhkKUepg5N5Fb9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi

I'm trying to unregister disks to unload the bcache module and reuse
the disk for other tests.

Can someone tell me how to unload module bcache after having run these command ?

Thanks.

#first load module
# modprobe bcache

I created a cache device on /dev/sdb1
# ./make-bcache -C -b512k -w4k --writeback /dev/sdb1

and a backing device on /dev/sdz.
# ./make-bcache -B /dev/sdz

# ./probe-bcache /dev/sdb1
5f42bdd1-4342-4ab6-8dda-855989a09604: UUID="" TYPE="bcache"

# ./probe-bcache /dev/sdz
6bbac9a4-afbd-4d40-9562-cdd290622c5d: UUID="" TYPE="bcache"


I then registered them by:
# echo /dev/sdb1 >/sys/fs/bcache/register
# echo /dev/sdz  >/sys/fs/bcache/register

I have /dev/bcache0.
/dev/bcache0 maps /dev/sdz except the first blocks
/dev/bcache0 is not yet cached by anything

# ls /sys/fs/bcache/
887d3bb6-0161-4e54-b9d8-801de9f7df83  register  register_quiet

"887d3bb6-0161-4e54-b9d8-801de9f7df83"
is the id of the bcache "pool" composed by the only caching device /dev/sdb1

# now I attach /dev/sdz to this pool
echo "887d3bb6-0161-4e54-b9d8-801de9f7df83" > /sys/block/sdz/bcache/attach



-- 
Alain Spineux                   |  aspineux gmail com
Monitor your iT & Backups |  http://www.magikmon.com
Free Backup front-end       | http://www.magikmon.com/mksbackup
Your email 100% available |  http://www.emailgency.com
