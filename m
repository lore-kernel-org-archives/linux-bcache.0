From: Jonathan Tripathy <jonnyt-Nf8S+5hNwl710XsdtD+oqA@public.gmane.org>
Subject: Re: Windows IOPS Benchmark
Date: Thu, 30 Aug 2012 01:13:10 +0100
Message-ID: <503EB016.10603@abpni.co.uk>
References: <503EAF26.6020009@abpni.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <503EAF26.6020009-Nf8S+5hNwl710XsdtD+oqA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On 30/08/2012 01:09, Jonathan Tripathy wrote:
> Hi Everyone,
>
> I'm using bcache with a RAID1 pair of SSDs (for the cache) with a 
> MD-RAID10 spindle array for the backing device. On top of this is LVM. 
> This setup is used with the Xen Hypervisor. Bcache is formatted with a 
> sector size of 512 bytes.
>
> If I use an LV for a Linux DomU, I get fantastic disk performance 
> using fio (about 23k random write). However, when I use IOMeter in a 
> Windows HVM DomU (with GPLPV drivers installed), my avg IOPS is around 
> 4000. I am using the "default" Access Specification. Am I doing 
> something wrong? Changing the number of workers doesn't seem to help.
>
> Any advice is appreciated.
>
> Thanks
>
Actually nvm, I forgot to enable the dist target for each of the works. 
Now I'm getting an avg iops of about 34k.

But this does leave me with a question: is the number of "workers" in 
IOMeter akin to "IO Depth" in fio?

Thanks
