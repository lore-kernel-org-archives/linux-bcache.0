From: Liang C <liangchen.linux@gmail.com>
Subject: Re: [PATCH 2/2] [PATCH] bcache: __write_super to handle page sizes
 other than 4k
Date: Fri, 6 Dec 2019 19:23:35 +0800
Message-ID: <CAKhg4t+LTwny9_xs4YWuSzz9oeqWK81=JRr8V92JTc0HSQ7ANQ@mail.gmail.com>
References: <1575622543-22470-1-git-send-email-liangchen.linux@gmail.com>
 <1575622543-22470-2-git-send-email-liangchen.linux@gmail.com> <20191206092336.GA7650@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191206092336.GA7650@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Coly Li <colyli@suse.de>, Kent Overstreet <kent.overstreet@gmail.com>, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

Thanks for the advise.
Yeah, calculating the offset based on the buffer size is possible. I
just wanted to avoid making a dependency on some buffer head
internal logic here, like the way it dividesthe page into equal sized
buffers, and at the same time keep the patch less intrusive.

On Fri, Dec 6, 2019 at 5:23 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Fri, Dec 06, 2019 at 04:55:43PM +0800, Liang Chen wrote:
> > __write_super assumes super block data starts at offset 0 of the page
> > read in with __bread from read_super, which is not true when page size
> > is not 4k. We encountered the issue on system with 64K page size - commonly
> >  seen on aarch64 architecture.
> >
> > Instead of making any assumption on the offset of the data within the page,
> > this patch calls __bread again to locate the data. That should not introduce
> > an extra io since the page has been held when it's read in from read_super,
> > and __write_super is not on performance critical code path.
>
> No need to use buffer heads here, you can just use offset_in_page
> to calculate the offset.  Similarly I think the read side shouldn't
> use buffer heads either (it is the only use of buffer heads in bcache!),
> a siple read_cache_page should be all that is needed.
