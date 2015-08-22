From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: Re: [ANNOUNCE] bcachefs - a general purpose COW filesystem
Date: Sat, 22 Aug 2015 14:33:47 -0700
Message-ID: <1440279227.2683.17.camel@ubuntu-slavad-14.04>
References: <20150821052558.GB23571@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150821052558.GB23571@kmo-pixel>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, sviatoslavpestov@gmail.com, mrubin@google.com, zab@zabbo.net, bcrl@kvack.org, ric@redhat.com, Vyacheslav.Dubeyko@hgst.com, Cyril Guyot <cyril.guyot@hgst.com>, adam.manzanares@hgst.com, damien.lemoal@hgst.com
List-Id: linux-bcache@vger.kernel.org

Hi Kent,

On Thu, 2015-08-20 at 21:25 -0800, Kent Overstreet wrote:
> For those who haven't kept up with bcache, the bcache codebase has been
> evolving/metastasizing into a full blown, general purpose posix filesystem - a
> modern COW filesystem with checksumming, compression, multiple devices, caching,
> and eventually snapshots and all kinds of other nifty features.
> 
> "Yet another new filesystem? Why?"
> 
> Well, years ago (going back to when I was still at Google), I and the other
> people working on bcache realized that what we were working on was, almost by
> accident, a good chunk of the functionality of a full blown filesystem - and
> there was a really clean and elegant design to be had there if we took it and
> ran with it. And a fast one - the main goal of bcachefs to match ext4 and xfs on
> performance and reliability, but with the features of btrfs/zfs.
> 

<snip>

> 
> PLANNED FEATURES:
>  - snapshots (might start on this soon)
>  - erasure coding

What erasure coding scheme(s) do you like to use?

>  - native support for SMR drives, raw flash

How do you imagine SMR drives support? How do you feel about libzbc [1]
using for SMR drives support? I am not very familiar with bcachefs
architecture yet. But I suppose that maybe libzbc model can be useful
for SMR drives support on bcachefs side. Anyway, it makes sense to
discuss proper model.

How do you imagine raw flash support in bcachefs architecture? Frankly
speaking, I am implementing NAND flash oriented file system. But this
project is proprietary yet and I can't share any details. However,
currently, I've implemented NAND flash related approaches in my file
system only. So, maybe, it make sense to consider some joint variant of
bcachefs and implementation on my side for NAND flash support. I need to
be more familiar with bcachefs architecture for such decision. But,
unfortunately, I suspect that it can be not so easy to support raw flash
for bcachefs. Of course, I can be wrong.

[1] https://github.com/hgst/libzbc

Thanks,
Vyacheslav Dubeyko.
