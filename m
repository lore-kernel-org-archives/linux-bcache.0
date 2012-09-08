From: Alex Pyrgiotis <apyrgio-Hpc4xzY4zrDSDkk6z29a7FAUjnlXr6A1@public.gmane.org>
Subject: Did I hear anyone say "deadlock"?
Date: Sat, 08 Sep 2012 22:04:51 +0300
Message-ID: <504B96D3.9020802@cslab.ece.ntua.gr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi Kent and list,

I may have stumbled upon a deadlock in the latest code for bcache. Since 
I see this is a hot issue between you and the guys working on dm, you 
might want to take a look.

I have compiled your latest commit in master branch 
(66f5a1f7311d5cc24bdff876ca2cfed88a3cc5d1) and running it raw on my home 
laptop - not using a VM or something.
For benchmarking reasons, I'm using a RAMdisk (brd module) as a cache 
set for an HDD disk. These are the steps that I take:

# Load ramdisks with max size 2.5GB (/dev/ram[0-15])
modprobe brd rd_size=2621440

#Format ramdisk as bcache cache set
make-bcache -C /dev/ram0

#Register the cache set
echo /dev/ram0 > /sys/fs/bcache/register

The last command fails to finish. The system hangs and nothing gets to 
be written in kern.log.
On the other hand, on another bcache kernel that is installed in the 
same system, everything runs smoothly. This kernel was taken from the 
bcache-dev branch and based on linux kernel version 3.5.0 rc2.

It is probably not a big issue, but i thought it'd be helpful to share it.
So, is the proposed code somewhere in your git tree? In this case, I 
could try it out and check if this problem is solved.

Thanks,
Alex
