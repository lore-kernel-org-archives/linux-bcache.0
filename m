From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: How to create bcachefs?
Date: Tue, 23 Aug 2016 22:52:12 -0800
Message-ID: <20160824065212.fzs2nk3rg7z7iudb@kmo-pixel>
References: <e6d5ceae4a7dd53daf2667e25b76539b@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:35679 "EHLO
        mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753705AbcHXGwR (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 24 Aug 2016 02:52:17 -0400
Received: by mail-pa0-f53.google.com with SMTP id hb8so3569587pac.2
        for <linux-bcache@vger.kernel.org>; Tue, 23 Aug 2016 23:52:17 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <e6d5ceae4a7dd53daf2667e25b76539b@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: marcin@mejor.pl
Cc: linux-bcache@vger.kernel.org

On Fri, Aug 19, 2016 at 08:07:31PM +0200, marcin@mejor.pl wrote:
> Hi!
> I'm spamming here with simple questions because it looks that documentation
> doesn't follow current state of bcachefs.
> 
> I've upgraded bcache-tools to b0f08fc1e30daafb274181234dae3408fb2eb69b and
> linux-bcache to 9c79c00b0d02f0da5e01ad5cd1bf4ae2ce421d5d.
> And now...
> 
> 1. How to create simple bcachefs on one disk, without any cache?
> # ./bcache format --meta_replicas=2 /dev/sdd1
> Please supply a device
> 
> Help displays:
>  # ./bcache format --help
> Usage: bcache format [OPTION]... <list of devices>
> Create a new bcache volume from one or more devices
> 
> Options:
>   -C, --cache=dev             Format a cache device
>   -w, --block=size            block size
>   -n, --btree_node=size       Btree node size, default 256k
>       --metadata_csum_type=(none|crc32c|crc64)
>                               Checksum type
>       --data_csum_type=(none|crc32c|crc64)
>                               Checksum type
>       --compression_type=(none|gzip)
>                               Compression type
>       --encrypted             enable encryption
>       --meta_replicas=#       number of metadata replicas
>       --data_replicas=#       number of data replicas
>       --error_action=(continue|readonly|panic)
>                               Action to take on filesystem error
>   -l, --label=label           label
>       --uuid=uuid             filesystem UUID
>       --fs_size=size          Size of filesystem on device
>   -b, --bucket=size           bucket size
>   -t, --tier=#                tier of subsequent devices
>       --discard               Enable discards
>   -q, --quiet                 reduce output to errors only
>   -v, --verbose               increase output to include informational
> messages
>       --help                  display this help and exit
>       --version               output version information and exit
> 
> Report bugs to <linux-bcache@vger.kernel.org>
> 
> I don't know what is correct syntax to format block device.
> 
> 2. How to create and mount bcachefs witch cache device?
> # ./bcache format --compression_type=lz4  --meta_replicas=2 /dev/sdd1  -C
> /dev/sde1

Hey, sorry for the long delay, been sick past several days. The way arguments
were passed to bcache format was a holdover from old style make-bcache, and
didn't make much sense for bcachefs - -C was used for all devices, and --tier
specifies fast devices and slow devices.

I finally got around to redoing the option parsing so we don't need the -C
argument today - update your bcache tools, and the command you want is now:

bcache format --tier 0 /dev/sde1 --tier 1 /dev/sdd1

(assuming sde1 is your fast device and sdd1 is your slow device).

Replication is not yet supported (it's around 90% implemented, but I haven't
worked on it in ages and the tests haven't been covering it so you'll likely hit
bugs if you try it).

Compression still isn't _quite_ done, I reverted the accounting until I fix an
issue with copygc. You can enable it and nothing will break, but it won't
actually let you store more data in your fs than if it was uncompressed.
