From: Tobias Reinhard <trtracer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Error "unsupported bset version"
Date: Sat, 24 Aug 2013 13:47:46 +0200
Message-ID: <52189D62.7010603@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi all,

I'm running bcache to speed up my 4 TB HDD with a 64 GB partition on my 
SSD. After a reboot bcache didn't start automatically. So I stopped 
bcache, unloaded the module, reloaded it and tried to register the SSD 
and HDD again.

Registering the SSD gave me this error:
error on f1e69e99-940d-447a-900e-4956bd607933: unsupported bset version 
at bucket 108098, block 0, 855650560 keys, disabling caching

The bcache was running in writeback mode but I think it was almost clean 
so I forced the device to go online and made an fsck. Everything looks 
ok, so no data loss. But surely this should not happen, right? Is there 
any way to check why? (I made an image of the cache device)

Kernel is  3.10.7; setup with "make-bcache -C -w 512 /dev/sdb2" and 
"make-bcache -B -w 512 /dev/sda2 --data-offset=2048"


Regards

Tobias
