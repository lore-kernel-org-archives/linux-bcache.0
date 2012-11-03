From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Always cache?
Date: Sat, 3 Nov 2012 16:29:38 -0700
Message-ID: <CAH+dOxK5Q-EZUJ_4KPPVA8FWcZQ_rDoWDyV_DQauP5iyp7DVTg@mail.gmail.com>
References: <loom.20121103T193709-932@post.gmane.org>
	<CAH+dOx+Sj6xovbfgy-tzB2QtJsYtV6=Vx2qxUGxLZRUpMHKbkQ@mail.gmail.com>
	<93462A6BCE1CD840B94554FBBEE4C93603075DA08D@THHS2E12BE8X.hostedservice2.net>
	<93462A6BCE1CD840B94554FBBEE4C93603075DA08E@THHS2E12BE8X.hostedservice2.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <93462A6BCE1CD840B94554FBBEE4C93603075DA08E-DfMK7iAD4PJfakIiyABxvNnpRUX5XqCHU7KNoL8tkdc@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Sefton <james-3k2nYdb70uTQXOPxS62xeg@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On Sat, Nov 3, 2012 at 4:22 PM, James Sefton <james-3k2nYdb70uTQXOPxS62xeg@public.gmane.org> wrote:
> Aha,
>
> Setting mode to writethrough does cause all writes to be written to both cache and backing disk simultaneously - so not what I was looking for.
>
> However, it seems the congestion option is what I was looking for.
>
> Setting cache_mode to writeback and then setting both congested_[read/write]_threshold_us to 0 as you directed seems to do pretty much exactly what I want.  (at least it appears that almost all writes are going to cache first and then starts sending the data to the backing store about 30 seconds later as expected)
>
> Perfect, thank-you.
>
> Any chance you could briefly explain what the two congestion values do?

They're for when your cache device is slower than your backing
device(s) - to prevent the cache device from being a bottleneck, it
starts cranking down the bypass threshold when latency to the SSD goes
over that threshold
