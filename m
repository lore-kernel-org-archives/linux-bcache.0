From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Block Size for Windows
Date: Mon, 27 Aug 2012 12:55:22 -0700
Message-ID: <CAH+dOxLaYdqOi+n=NF2MSoEVsSz-C6QazbQrdwGCO02aDZXxDg@mail.gmail.com>
References: <503BC71A.6050207@abpni.co.uk>
	<CAH+dOxJ1GPQgmgDv4T3On-QovazSshU89GdVp=EHFmpaAzAGnQ@mail.gmail.com>
	<503BC82F.1030107@abpni.co.uk>
	<CAH+dOxJZEH9=ZEsB4RsS-8MdH-AGRh3jvo31bMUwXsMdirLMMQ@mail.gmail.com>
	<503BC897.3020606@abpni.co.uk>
	<CAH+dOxKx=kaW4duTyhRYrFH-5mYDUT6CGgY7WX9vqsMD_CpJaQ@mail.gmail.com>
	<503BCDC6.9010807@abpni.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <503BCDC6.9010807-Nf8S+5hNwl710XsdtD+oqA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Tripathy <jonnyt-Nf8S+5hNwl710XsdtD+oqA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Mon, Aug 27, 2012 at 12:43 PM, Jonathan Tripathy <jonnyt-Nf8S+5hNwl710XsdtD+oqA@public.gmane.org> wrote:
> On 27/08/2012 20:22, Kent Overstreet wrote:
>>
>> echo 1 > /sys/fs/bcache/<uuid>/unregister
>>
>> echo 1 > /sys/block/bcache0/bcache/stop
>
> Ok, so I managed to recreate everything with a block size of 512 bytes.
> However, 2 bad things have happened:
>
> 1) In my Linux DomU, my fio randomwrite test have gone from about 28k iops
> to about 800 iops. Can this be fixed? changing bs and ba to 512 in the fio
> config file didn't hep.

Ouch!

Bet the ssd doesn't like those 512 byte journal writes. I'm going to
have to think about that...
