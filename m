From: Jonathan Tripathy <jonnyt-Nf8S+5hNwl710XsdtD+oqA@public.gmane.org>
Subject: Re: Block Size for Windows
Date: Mon, 27 Aug 2012 20:43:02 +0100
Message-ID: <503BCDC6.9010807@abpni.co.uk>
References: <503BC71A.6050207@abpni.co.uk> <CAH+dOxJ1GPQgmgDv4T3On-QovazSshU89GdVp=EHFmpaAzAGnQ@mail.gmail.com> <503BC82F.1030107@abpni.co.uk> <CAH+dOxJZEH9=ZEsB4RsS-8MdH-AGRh3jvo31bMUwXsMdirLMMQ@mail.gmail.com> <503BC897.3020606@abpni.co.uk> <CAH+dOxKx=kaW4duTyhRYrFH-5mYDUT6CGgY7WX9vqsMD_CpJaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH+dOxKx=kaW4duTyhRYrFH-5mYDUT6CGgY7WX9vqsMD_CpJaQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 27/08/2012 20:22, Kent Overstreet wrote:
> echo 1 > /sys/fs/bcache/<uuid>/unregister
>
> echo 1 > /sys/block/bcache0/bcache/stop
Ok, so I managed to recreate everything with a block size of 512 bytes. 
However, 2 bad things have happened:

1) In my Linux DomU, my fio randomwrite test have gone from about 28k 
iops to about 800 iops. Can this be fixed? changing bs and ba to 512 in 
the fio config file didn't hep.

2) The windows setup didn't complain that it couldn't install on the LV, 
but once I clicked 'next', the Dom0 crashed and the server rebooted. A 
lot of output was displayed on screen but quickly vanished as the system 
rebooted. I'm trying to see if the output was saved anywhere. Any ideas 
why this could of happened and/or where the output might be saved?

Thanks
