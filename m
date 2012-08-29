From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Block Size for Windows
Date: Wed, 29 Aug 2012 03:03:09 -0400
Message-ID: <CAH+dOxJYNE=UiKX-GaCUmhWOgoHqkGrBnF=sOc7mXDUoFKu36Q@mail.gmail.com>
References: <503BC71A.6050207@abpni.co.uk>
	<CAH+dOxJ1GPQgmgDv4T3On-QovazSshU89GdVp=EHFmpaAzAGnQ@mail.gmail.com>
	<503BC82F.1030107@abpni.co.uk>
	<CAH+dOxJZEH9=ZEsB4RsS-8MdH-AGRh3jvo31bMUwXsMdirLMMQ@mail.gmail.com>
	<503BC897.3020606@abpni.co.uk>
	<CAH+dOxKx=kaW4duTyhRYrFH-5mYDUT6CGgY7WX9vqsMD_CpJaQ@mail.gmail.com>
	<503BCDC6.9010807@abpni.co.uk>
	<503BD1E8.7060402@abpni.co.uk>
	<503BD37C.9010403@abpni.co.uk>
	<503BD55D.2060408@abpni.co.uk>
	<CAOzFzEi6AzHFJVUGGc+J2p7QYe2f2i_XKrpad8wHDXo2xO=buA@mail.gmail.com>
	<503BEE7F.4020202@abpni.co.uk>
	<CAOzFzEg7v6U6sTYjTsGDzPE_yGRp-WULzngAn-1TCygp2jo76w@mail.gmail.com>
	<CAH+dOxLnh34vQ+56JUfKtA2PyA1cyeDZvfBdWvSUhZC_pV2YMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH+dOxLnh34vQ+56JUfKtA2PyA1cyeDZvfBdWvSUhZC_pV2YMQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Cc: Jonathan Tripathy <jonnyt-Nf8S+5hNwl710XsdtD+oqA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

I just went ahead and backed out the problematic change. Haven't even
tried building the code yet - but if you feel lucky, it's up. I bet it
fixes it.

On Wed, Aug 29, 2012 at 1:56 AM, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> On Mon, Aug 27, 2012 at 3:06 PM, Joseph Glanville
> <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org> wrote:
>> The issue is probably in fs/bio.c, some of the bio splitting changes
>> could effect md without even having bcache in use.
>>
>> Kent, I will try get a test box up running more recent code then the
>> stuff we run (which doesn't have said issue).
>
> Well, sounds like it's definitively just raid10 that triggers it -
> that helps a lot. I think I know a sure workaround for it now, I'll
> try and upload a new version tomorrow that should fix it.
