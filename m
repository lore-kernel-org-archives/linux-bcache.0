From: Justin Rush <jarush-Ub+6UvMsOfg@public.gmane.org>
Subject: can't attach caching device to backing device
Date: Mon, 14 Nov 2011 23:10:32 +0000
Message-ID: <8C67A0427441E84B879B0D6058D20D5222410FE6@EXCH-MBX-1.epic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Using 3.1.0-rc9

I created a cache device on /dev/sdk1
# ./make-bcache -C -b512k -w4k --writeback /dev/sdk1

and a backing device on /dev/md127p1.
./make-bcache -B /dev/md127p1

# ./probe-bcache /dev/sdk1
5f42bdd1-4342-4ab6-8dda-855989a09604: UUID="" TYPE="bcache"

# ./probe-bcache /dev/md127p1
6bbac9a4-afbd-4d40-9562-cdd290622c5d: UUID="" TYPE="bcache"

I then registered them by:
# echo /dev/sdk1 >/sys/fs/bcache/register # echo /dev/md127p1 >/sys/fs/bcache/register

I have /dev/bcache0

When I try to attach the cache, I get this:
# echo "5f42bdd1-4342-4ab6-8dda-855989a09604" >/sys/block/md127/md127p1/bcache/attach
-bash: echo: write error: No such file or directory

I believe this problem is due to the UUIDs for the two devices, but this is just a guess.  The UUID for /dev/sdk1 and /dev/md127p1 doesn't appear to be registering properly as they don't show up in blkid.  I tried specifying the UUID to use with the -U option when creating the devices, but that didn't seem to help.  I do have the udev rules file from the tools in place

Does anyone know what is going on here and how to fix it?

Justin Rush
jarush-Ub+6UvMsOfg@public.gmane.org
