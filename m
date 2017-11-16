From: Michael Lyle <mlyle@lyle.org>
Subject: Re: Regression in 4.14: wrong data being read from bcache device
Date: Thu, 16 Nov 2017 15:02:22 -0800
Message-ID: <3474003b-b49f-d811-4116-e2d5fac730ce@lyle.org>
References: <1321800569.20171116152838@pvgoran.name>
 <CAPerZE-KiYVWXtBsu+SR0wCgbSJgzZAufm+3NYdoybjq+6ySbQ@mail.gmail.com>
 <aa11e8f1-5120-9089-c1ad-43ac5057c029@lyle.org>
 <8a3d34b9-c49f-3870-fc7f-d337f7077c32@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <8a3d34b9-c49f-3870-fc7f-d337f7077c32@kernel.dk>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Campbell Steven <casteven@gmail.com>, Pavel Goran <via-bcache@pvgoran.name>
Cc: linux-bcache@vger.kernel.org, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>
List-Id: linux-bcache@vger.kernel.org

On 11/16/2017 12:31 PM, Jens Axboe wrote:> I'd suggest just doing a
bisect between 4.13 and 4.14, sounds like the> issue is trivially
reproducible.
Took me awhile to get a repro but I have one now.  Will start bisecting
tonight.

Mike
