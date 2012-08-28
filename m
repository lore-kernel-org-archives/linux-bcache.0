From: Brad Campbell <brad-+nnirC7rrGZibQn6LdNjmg@public.gmane.org>
Subject: Re: Block Size for Windows
Date: Tue, 28 Aug 2012 10:06:37 +0800
Message-ID: <503C27AD.9000405@fnarfbargle.com>
References: <503BC71A.6050207@abpni.co.uk> <CAH+dOxJ1GPQgmgDv4T3On-QovazSshU89GdVp=EHFmpaAzAGnQ@mail.gmail.com> <503BC82F.1030107@abpni.co.uk> <CAH+dOxJZEH9=ZEsB4RsS-8MdH-AGRh3jvo31bMUwXsMdirLMMQ@mail.gmail.com> <503BC897.3020606@abpni.co.uk> <CAH+dOxKx=kaW4duTyhRYrFH-5mYDUT6CGgY7WX9vqsMD_CpJaQ@mail.gmail.com> <503BCDC6.9010807@abpni.co.uk> <503BD1E8.7060402@abpni.co.uk> <503BD37C.9010403@abpni.co.uk> <503BD55D.2060408@abpni.co.uk> <CAOzFzEi6AzHFJVUGGc+J2p7QYe2f2i_XKrpad8wHDXo2xO=buA@mail.gmail.com> <503BEE7F.4020202@abpni.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <503BEE7F.4020202-Nf8S+5hNwl710XsdtD+oqA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Tripathy <jonnyt-Nf8S+5hNwl710XsdtD+oqA@public.gmane.org>
Cc: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 28/08/12 06:02, Jonathan Tripathy wrote:
>
> What should my next step be? Try and find a serial cable to capture the debug output?
>

If the machine has a network port and you have another machine nearby you could use netconsole. It's 
much quicker and easier than trying to cobble up a serial cable if you don't already have one handy.

You'll find the documentation in your kernel source tree here ---> 
Documentation/networking/netconsole.txt

I have my server set up to log to the rsyslog daemon on my desktop machine. This way if it panics 
and auto-reboots, I get a good copy of the oops.

Regards,
Brad
