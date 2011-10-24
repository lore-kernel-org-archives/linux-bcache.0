From: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: "Benchmarks"
Date: Mon, 24 Oct 2011 13:10:57 -0400
Message-ID: <CAC7rs0s3qCDYGnkbMv3NmxFR740mo48vV0mZa54TKbomFB7kjg@mail.gmail.com>
References: <4EA20E4E.8050402@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4EA20E4E.8050402-+nnirC7rrGZibQn6LdNjmg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Brad Campbell <lists2009-+nnirC7rrGZibQn6LdNjmg@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Cool!

The thing I'd be really curious about is what the benchmarks would
look like if you were using only the SSD, no bcache.

How happy are you with it?

On Fri, Oct 21, 2011 at 8:29 PM, Brad Campbell
<lists2009-+nnirC7rrGZibQn6LdNjmg@public.gmane.org> wrote:
> I use the term loosely.
>
> This is with the raw drive being a Maxtor MaxlineII 250GB 7200RPM SAT=
A unit.
> It's about a 2004 vintage with over 30,000 hours on it. Slow and stea=
dy.
>
> The Cache device is an OCZ Vertex Plus 120GB Unit. Not all that fast =
or
> clever. The Cache has writeback enabled and is formatted with -w512 s=
o that
> direct IO worked as previously discussed.
>
> The benchmark is conducted inside an XP VM running under KVM. The dev=
ice is
> a qcow2 backing file formatted NTFS. I ran the test multiple times wi=
thout
> the cache until the numbers stabilised (the backing file was being ex=
panded
> as required)
>
> http://www.fnarfbargle.com/private/111022_bcache/Without_Cache.png
> http://www.fnarfbargle.com/private/111022_bcache/With_Cache.png
>
> As expected a significant improvement in random small I/O. The VM is =
far
> more responsive with the cache.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcach=
e" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
