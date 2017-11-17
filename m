From: Michael Lyle <mlyle@lyle.org>
Subject: Re: Regression in 4.14: wrong data being read from bcache device
Date: Fri, 17 Nov 2017 09:04:47 -0800
Message-ID: <CAJ+L6qeLBZ7447PeLF8AW1FJyDeQFL38ufXGtwQV_NwfbE_Pxg@mail.gmail.com>
References: <1321800569.20171116152838@pvgoran.name> <CAPerZE-KiYVWXtBsu+SR0wCgbSJgzZAufm+3NYdoybjq+6ySbQ@mail.gmail.com>
 <aa11e8f1-5120-9089-c1ad-43ac5057c029@lyle.org> <8a3d34b9-c49f-3870-fc7f-d337f7077c32@kernel.dk>
 <3474003b-b49f-d811-4116-e2d5fac730ce@lyle.org> <CAJ+L6qf=6-dBxNf+LdeXNNu0qkXNE_xEUqU_rb6ZASonV6=1sw@mail.gmail.com>
 <20171117150828.GA24694@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171117150828.GA24694@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Campbell Steven <casteven@gmail.com>, Pavel Goran <via-bcache@pvgoran.name>, linux-bcache <linux-bcache@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>
List-Id: linux-bcache@vger.kernel.org

On Fri, Nov 17, 2017 at 7:08 AM, Christoph Hellwig <hch@lst.de> wrote:
> On Thu, Nov 16, 2017 at 07:07:40PM -0800, Michael Lyle wrote:
>> I think the probable cause is this: we construct bios based on
>> previously completed bios in a few places,
>
> That is an extremely bad idea in many ways, so I think we'll need
> to fix this as the priority.

Yah, sorry, this wasn't actually the case.  I was sleep deprived and
hadn't been able to follow it all yet.

Bart points out that there's many remaining cases of assignment of
disk where partno isn't assigned as well-- so I wonder if there are
other potential problems from this.

Mike
