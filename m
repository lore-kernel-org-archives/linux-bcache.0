From: kernel neophyte <neophyte.hacker001-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Possible Bcache Bug
Date: Wed, 28 Aug 2013 20:16:37 -0700
Message-ID: <CAFkUHxfXdVZRLqfMoPYcsw_-pvdXexKrawd6qLD=obeZDHFUEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Hi Kent,

I have configured Bcache as follows:

echo /dev/sda3 > /sys/fs/bcache/register
echo /dev/sdb1 > /sys/fs/bcache/register
echo 5fd1b675-ea67-4039-82f6-caa325d10559 > /sys/block/bcache0/bcache/attach
echo 0 > /sys/block/bcache0/bcache/sequential_cutoff
echo 0 > /sys/fs/bcache/5fd1b675-ea67-4039-82f6-caa325d10559/congested_read_threshold_us
echo 0 > /sys/fs/bcache/5fd1b675-ea67-4039-82f6-caa325d10559/congested_write_threshold_us
echo 0 > /sys/fs/bcache/5fd1b675-ea67-4039-82f6-caa325d10559/synchronous
echo writeback > /sys/block/bcache0/bcache/cache_mode
echo 0 > /sys/block/bcache0/bcache/writeback_running
echo 0 > /sys/block/bcache0/bcache/writeback_metadata

in other words for I am trying to get some benchmarking numbers by
using ssd only ie not use hdd for anything. by doing the above I
expected hdd will never be used and all reads and writes will happen
to and from the ssd...

How ever to my shock random writes started happening to the HDD

even iostat confirmed it

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.00    0.00    0.40   16.05    0.00   83.55

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda             236.30         0.00       945.20          0       9452
sdb               0.00         0.00         0.00          0          0
bcache0         236.30         0.00       945.20          0       9452

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.02    0.00    0.42   16.08    0.00   83.48

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda             226.90         0.00       908.00          0       9080
sdb               0.00         0.00         0.00          0          0
bcache0         226.50         0.00       906.00          0       9060

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.02    0.00    0.37   16.08    0.00   83.53

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda             235.40         0.00       941.60          0       9416
sdb               0.00         0.00         0.00          0          0
bcache0         235.40         0.00       941.60          0       9416

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.02    0.00    0.32   16.06    0.00   83.61

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda             238.50         0.00       954.00          0       9540
sdb               0.00         0.00         0.00          0          0
bcache0         238.50         0.00       954.00          0       9540

This looks like a possible bug to me. Could you please confirm ?
