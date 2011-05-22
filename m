From: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: chache multiple devices with one cache
Date: Sat, 21 May 2011 19:41:59 -0700
Message-ID: <BANLkTinDRhwGX4ww9nqjO6iVhYQwRbHzgg@mail.gmail.com>
References: <2049151873.5591305976195268.JavaMail.root@shiva>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2049151873.5591305976195268.JavaMail.root@shiva>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: LuVar <luvar-2S8i3W4CjuIzjkFyG6Beag@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Yes, you can attach multiple backing devices to a cache (up to 256, cur=
rently).

On Sat, May 21, 2011 at 4:09 AM, LuVar <luvar-2S8i3W4CjuIzjkFyG6Beag@public.gmane.org> wrote:
> Hi,
> I have question about using bcache in "standard" instalation of linux=
=2E I have some partitions (/boot, /home, /usr/portage, /var/lib/boinc,=
=2E..) and I have one ssd hdd. I vant to use it as cache for root parti=
tion and for example for /home partition. Is it possible without partit=
ioning ssd drive? I want from bcache to compute which of my partitions =
need more space for caching.
>
> Simply I want to tel bcache that /home and / partitions should be cha=
ced on /dev/sdg device. Is it possible with current version of bcache?
>
> PS: I hope, reformatting my partitions will be easy as I am on lvm (o=
n top of raid5 :-/
>
> Have a nice day,
> LuVar
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcach=
e" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
