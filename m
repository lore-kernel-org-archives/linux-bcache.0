From: Jonathan Tripathy <jonnyt-Nf8S+5hNwl710XsdtD+oqA@public.gmane.org>
Subject: Windows IOPS Benchmark
Date: Thu, 30 Aug 2012 01:09:10 +0100
Message-ID: <503EAF26.6020009@abpni.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Hi Everyone,

I'm using bcache with a RAID1 pair of SSDs (for the cache) with a 
MD-RAID10 spindle array for the backing device. On top of this is LVM. 
This setup is used with the Xen Hypervisor. Bcache is formatted with a 
sector size of 512 bytes.

If I use an LV for a Linux DomU, I get fantastic disk performance using 
fio (about 23k random write). However, when I use IOMeter in a Windows 
HVM DomU (with GPLPV drivers installed), my avg IOPS is around 4000. I 
am using the "default" Access Specification. Am I doing something wrong? 
Changing the number of workers doesn't seem to help.

Any advice is appreciated.

Thanks
