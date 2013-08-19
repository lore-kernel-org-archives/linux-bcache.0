From: Damien Churchill <damoxc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] bcache-status
Date: Mon, 19 Aug 2013 12:48:17 +0100
Message-ID: <CAFtEh-eWjZDKu3SCr-9czx9Mqrg+gUPPar7y7W2EZMyy3JoZ4g@mail.gmail.com>
References: <20130815233508.GB6949@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130815233508.GB6949-yuuUpGxbzT9UbpRmUfBrXUB+6BGkLq7r@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>, bcache <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Hi,

On 16 August 2013 00:35, Darrick J. Wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> Hi all,
>
> I wrote a script to dump out various stats about a bcache.

I've put your script in a gist[0] and modified a few things, all
cosmetic. Switched to use argparse and changed a few conditionals to
be slightly more pythonic.

[0] https://gist.github.com/damoxc/6267899
