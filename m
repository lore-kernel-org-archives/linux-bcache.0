From: Ming Lin <mlin@kernel.org>
Subject: Re: [PATCH 04/10] bcache: clean up hacks around bio_split_pool
Date: Tue, 28 Apr 2015 22:43:23 -0700
Message-ID: <CAF1ivSb5BwVZG844+ZbvWN+UW0WYq5hNOuhdXAQLQ0Ose6iinA@mail.gmail.com>
References: <1430203717-13307-1-git-send-email-mlin@kernel.org>
	<1430203717-13307-5-git-send-email-mlin@kernel.org>
	<20150428121438.GB10479@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150428121438.GB10479@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kent.overstreet@gmail.com>, Dongsu Park <dongsu.park@profitbricks.com>, linux-bcache@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On Tue, Apr 28, 2015 at 5:14 AM, Christoph Hellwig <hch@lst.de> wrote:
> On Mon, Apr 27, 2015 at 11:48:31PM -0700, Ming Lin wrote:
>> From: Kent Overstreet <kent.overstreet@gmail.com>
>>
>> There has been workarounds only in bcache, for splitting pool as well
>> as submitting bios. Since generic_make_request() is able to handle
>> arbitrarily sized bios, it's now possible to delete those hacks.
>
> The Subject and description look confusing to me.
>
> From me reading of the code I'd word it as:
>
> Subject: bcache: remove driver private bio splitting code
>
> The bcache driver has always accepted arbitrarily large bios and split
> them internally.  Now that every driver must accept arbitrarily large
> bios this code isn't nessecary anymore.

Will update it.
