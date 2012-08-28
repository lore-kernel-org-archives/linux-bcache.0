From: Jonathan Tripathy <jonnyt-Nf8S+5hNwl710XsdtD+oqA@public.gmane.org>
Subject: Re: Block Size for Windows
Date: Tue, 28 Aug 2012 23:43:47 +0100
Message-ID: <503D49A3.4090100@abpni.co.uk>
References: <503BC71A.6050207@abpni.co.uk> <CAH+dOxJ1GPQgmgDv4T3On-QovazSshU89GdVp=EHFmpaAzAGnQ@mail.gmail.com> <503BC82F.1030107@abpni.co.uk> <CAH+dOxJZEH9=ZEsB4RsS-8MdH-AGRh3jvo31bMUwXsMdirLMMQ@mail.gmail.com> <503BC897.3020606@abpni.co.uk> <CAH+dOxKx=kaW4duTyhRYrFH-5mYDUT6CGgY7WX9vqsMD_CpJaQ@mail.gmail.com> <503BCDC6.9010807@abpni.co.uk> <CAH+dOxLaYdqOi+n=NF2MSoEVsSz-C6QazbQrdwGCO02aDZXxDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH+dOxLaYdqOi+n=NF2MSoEVsSz-C6QazbQrdwGCO02aDZXxDg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 27/08/2012 20:55, Kent Overstreet wrote:
> On Mon, Aug 27, 2012 at 12:43 PM, Jonathan Tripathy <jonnyt-Nf8S+5hNwl710XsdtD+oqA@public.gmane.org> wrote:
>> On 27/08/2012 20:22, Kent Overstreet wrote:
>>> echo 1 > /sys/fs/bcache/<uuid>/unregister
>>>
>>> echo 1 > /sys/block/bcache0/bcache/stop
>> Ok, so I managed to recreate everything with a block size of 512 bytes.
>> However, 2 bad things have happened:
>>
>> 1) In my Linux DomU, my fio randomwrite test have gone from about 28k iops
>> to about 800 iops. Can this be fixed? changing bs and ba to 512 in the fio
>> config file didn't hep.
> Ouch!
>
> Bet the ssd doesn't like those 512 byte journal writes. I'm going to
> have to think about that...
Hi Kent,

Ok, a little good news. I managed to sort out the low IOPS issue. When I 
formatted bcache0 with a 512 block size, I forgot to set the caching 
mode back to writeback. Once I did that, the IOPS were nice and high 
again (circa 26k IOPS). Sorry about the noise regarding that non-issue.

I re-tried the windows setup with writeback enabled for the 512B 
formatted cache. It kernel paniced as per-usual, however for some 
reason, it's kernel panicking upon every boot now, whereas when it was 
formatted with 4k sectors, once the system came back up, it was stable 
(until I tried another windows setup). The debug trace appears to be the 
same as the one I posted to the list (kernel BUG at fs/bio.c:420! 
invalid opcode: 0000 [#1] SMP).

I appreciate your time.

Thanks
