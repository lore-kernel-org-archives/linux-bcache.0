From: Jonathan Tripathy <jonnyt-Nf8S+5hNwl710XsdtD+oqA@public.gmane.org>
Subject: Re: Block Size for Windows
Date: Mon, 27 Aug 2012 20:19:11 +0100
Message-ID: <503BC82F.1030107@abpni.co.uk>
References: <503BC71A.6050207@abpni.co.uk> <CAH+dOxJ1GPQgmgDv4T3On-QovazSshU89GdVp=EHFmpaAzAGnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH+dOxJ1GPQgmgDv4T3On-QovazSshU89GdVp=EHFmpaAzAGnQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 27/08/2012 20:17, Kent Overstreet wrote:
> On Mon, Aug 27, 2012 at 12:14 PM, Jonathan Tripathy <jonnyt-Nf8S+5hNwl710XsdtD+oqA@public.gmane.org> wrote:
>> Hi Everyone,
>>
>> I'm running bcache on my md raid device for use with my xen machine (via
>> LVM). It works very well for Linux DomUs. However, I'm having some trouble
>> installing Windows. When I enter the WIndows 2008 setup, it refuses to
>> install to the LV volume. Reading the mailing lists, I feel this may have
>> something to do with the block size that bcache is using.
>>
>> Assuming that my cache is md0, and my spindles are md1, it is my
>> understanding that to change the block size I would have to do:
>>
>> make-bcache --block 512 --cache /dev/md0
>> and
>> make-bcache --block 512 --bdev /dev/md1
>>
>> However, this doesn't appear to work is both of the above devices are
>> already set for bcache (The block size seems to still be '1' according to
>> the output that make-bcache gives).
> That's the output you want - it's displaying in units of 512 byte sectors
Hi Kent,

Thanks for the reply. However, my device appears to still have a block 
size of 4.0k:

# cat /sys/fs/bcache/c215aa0a-c722-48e4-afcb-0ab8946d303c/block_size
4.0k

Maybe I have to deregister the devices first?

Thanks
