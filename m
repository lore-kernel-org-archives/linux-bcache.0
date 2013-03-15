From: CoRpO <corpo-Zp/rcV4kTj0@public.gmane.org>
Subject: Re: Strange behavior
Date: Fri, 15 Mar 2013 17:36:43 +0100
Message-ID: <4271bfb6841e67a219d414be472cf46e@gruk.org>
References: <d7d9ba24c29c31d9d462490a7e978814@gruk.org>
 <8f2e763728d77626e40d33b9e2d5f6b2@gruk.org>
 <CAH+dOxKfB4sPw2VPE9bWSnMfES3UNVsR4i80-J8SpV_YK5uOnw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH+dOxKfB4sPw2VPE9bWSnMfES3UNVsR4i80-J8SpV_YK5uOnw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

I've forgotten to mention that I've also put=20
congested_read_threshold_us
and congested_write_threshold_us at 0 before posting here

I don't understand what's happening

Le 2013-03-15 16:42, Kent Overstreet a =C3=A9crit :

> Can you try disabling congested_threshold? That's the one other=20
> option
> that allows data to bypass the cache.
