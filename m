From: Michael Lyle <mlyle@lyle.org>
Subject: Re: Regression in 4.14: wrong data being read from bcache device
Date: Thu, 16 Nov 2017 19:07:40 -0800
Message-ID: <CAJ+L6qf=6-dBxNf+LdeXNNu0qkXNE_xEUqU_rb6ZASonV6=1sw@mail.gmail.com>
References: <1321800569.20171116152838@pvgoran.name> <CAPerZE-KiYVWXtBsu+SR0wCgbSJgzZAufm+3NYdoybjq+6ySbQ@mail.gmail.com>
 <aa11e8f1-5120-9089-c1ad-43ac5057c029@lyle.org> <8a3d34b9-c49f-3870-fc7f-d337f7077c32@kernel.dk>
 <3474003b-b49f-d811-4116-e2d5fac730ce@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <3474003b-b49f-d811-4116-e2d5fac730ce@lyle.org>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Campbell Steven <casteven@gmail.com>, Pavel Goran <via-bcache@pvgoran.name>
Cc: linux-bcache <linux-bcache@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>, hch@lst.de
List-Id: linux-bcache@vger.kernel.org

Jens, Christoph & everyone--

Hi-- I believe I have a general idea what's going on.

On Thu, Nov 16, 2017 at 3:02 PM, Michael Lyle <mlyle@lyle.org> wrote:
> On 11/16/2017 12:31 PM, Jens Axboe wrote:
> > I'd suggest just doing a bisect between 4.13 and 4.14, sounds like the
> > issue is trivially reproducible.
> Took me awhile to get a repro but I have one now.  Will start bisecting
> tonight.

It looks like the regression came from commit is
74d46992e0d9dee7f1f376de0d56d31614c8a17a (3/3 repros with it, 0/3
repros without it and hacked to build).

I don't have time to analyze this tonight as I have a couple other
things to do, but will look at fully analyzing it tomorrow morning.

I think the probable cause is this: we construct bios based on
previously completed bios in a few places, but blk_partition_remap
sets the partno to 0 and adjusts the disk offset.  It seems like a lot
of potential uses of bio_copy_dev could be dangerous for this reason.

Mike
