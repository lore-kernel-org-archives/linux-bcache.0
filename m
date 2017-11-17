From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH] bio: ensure __bio_clone_fast copies bi_partno
Date: Fri, 17 Nov 2017 09:02:17 -0800
Message-ID: <ecaa268f-c98d-3476-da8b-7943546b06f1@lyle.org>
References: <20171117074725.22536-1-mlyle@lyle.org>
 <1510937438.2846.16.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1510937438.2846.16.camel@wdc.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Cc: "hch@lst.de" <hch@lst.de>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>
List-Id: linux-bcache@vger.kernel.org

Jens & everyone-- thanks for the speedy review and handling.  I've
updated my test cases to ensure that volumes from old releases work,
even when I "don't think" there's been a disk format change.

Bart--

On 11/17/2017 08:50 AM, Bart Van Assche wrote:
> Have you considered to use bio_copy_dev() instead of open-coding it?

One could... Right now almost all the uses of bio_copy_dev are in bcache
and they need to change for other reasons.  (e.g. macro uses parameter
more than once, function is passed in as parameter).  There's a whole
lot of places to change if it's desired to make bio_copy_dev universally
used to copy device information.

> Additionally, there is more code that copies these fields, e.g. the code in
> bio_clone_bioset(). Shouldn't that code be modified such that it also copies
> bi_partno?

Yes, when I was grepping around there were other things that looked
possibly unsafe.  I don't have test environments for all of these other
subsystems.

I wanted to get the minimal fix for this in, though, because people are
actively losing data to the problem it triggers with bcache.

Mike
