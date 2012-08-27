From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Block Size for Windows
Date: Mon, 27 Aug 2012 12:22:55 -0700
Message-ID: <CAH+dOxKx=kaW4duTyhRYrFH-5mYDUT6CGgY7WX9vqsMD_CpJaQ@mail.gmail.com>
References: <503BC71A.6050207@abpni.co.uk>
	<CAH+dOxJ1GPQgmgDv4T3On-QovazSshU89GdVp=EHFmpaAzAGnQ@mail.gmail.com>
	<503BC82F.1030107@abpni.co.uk>
	<CAH+dOxJZEH9=ZEsB4RsS-8MdH-AGRh3jvo31bMUwXsMdirLMMQ@mail.gmail.com>
	<503BC897.3020606@abpni.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <503BC897.3020606-Nf8S+5hNwl710XsdtD+oqA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Tripathy <jonnyt-Nf8S+5hNwl710XsdtD+oqA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

echo 1 > /sys/fs/bcache/<uuid>/unregister

echo 1 > /sys/block/bcache0/bcache/stop

On Mon, Aug 27, 2012 at 12:20 PM, Jonathan Tripathy <jonnyt-Nf8S+5hNwl710XsdtD+oqA@public.gmane.org> wrote:
> On 27/08/2012 20:19, Kent Overstreet wrote:
>>
>> Yes - unregister, format, reregister
>>
>>
> What's the command to unregister?
>
> Thanks
>
