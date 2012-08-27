From: Jonathan Tripathy <jonnyt-Nf8S+5hNwl710XsdtD+oqA@public.gmane.org>
Subject: Re: Block Size for Windows
Date: Mon, 27 Aug 2012 21:00:40 +0100
Message-ID: <503BD1E8.7060402@abpni.co.uk>
References: <503BC71A.6050207@abpni.co.uk> <CAH+dOxJ1GPQgmgDv4T3On-QovazSshU89GdVp=EHFmpaAzAGnQ@mail.gmail.com> <503BC82F.1030107@abpni.co.uk> <CAH+dOxJZEH9=ZEsB4RsS-8MdH-AGRh3jvo31bMUwXsMdirLMMQ@mail.gmail.com> <503BC897.3020606@abpni.co.uk> <CAH+dOxKx=kaW4duTyhRYrFH-5mYDUT6CGgY7WX9vqsMD_CpJaQ@mail.gmail.com> <503BCDC6.9010807@abpni.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <503BCDC6.9010807-Nf8S+5hNwl710XsdtD+oqA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org


>
> 2) The windows setup didn't complain that it couldn't install on the 
> LV, but once I clicked 'next', the Dom0 crashed and the server 
> rebooted. A lot of output was displayed on screen but quickly vanished 
> as the system rebooted. I'm trying to see if the output was saved 
> anywhere. Any ideas why this could of happened and/or where the output 
> might be saved?
>
>
I'd also like to add that after the server came back up, the md raid 
array started rebuilding. I wondering if that's just a coincidence (due 
to the forced reboot), or a sign of something wrong with the md 
integration with bcache?

I'm going to see if Windows installs natively on the md array (it's RAID 
10 btw) and post back here.
