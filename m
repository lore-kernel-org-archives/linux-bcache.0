From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [bcachefs] bcache (dm-10): IO error on dm-10 for checksum error
 (due to change of str_hash?)
Date: Fri, 16 Sep 2016 00:38:53 -0800
Message-ID: <20160916083853.5syjxgpb4f73bmtt@kmo-pixel>
References: <b84591f6-c35e-0286-e6f2-16c7fdf5daaf@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35706 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751180AbcIPIi5 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 16 Sep 2016 04:38:57 -0400
Received: by mail-pf0-f193.google.com with SMTP id 6so402108pfl.2
        for <linux-bcache@vger.kernel.org>; Fri, 16 Sep 2016 01:38:57 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <b84591f6-c35e-0286-e6f2-16c7fdf5daaf@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marcin =?utf-8?B?TWlyb3PFgmF3?= <marcin@mejor.pl>
Cc: linux-bcache@vger.kernel.org

On Fri, Sep 16, 2016 at 10:07:30AM +0200, Marcin Mirosław wrote:
> Hi Kent, hi all,
> when I tried to mount fs that has troubles yesterday I've got:
> [  494.296818] bcache (dm-10): dm-10: journal checksum bad (got
> 18446744072224191025 expect 2809606705), sector 2048u
> [  494.309973] bcache (dm-10): dm-10: journal checksum bad (got
> 18446744073320597786 expect 3906013466), sector 2304u
> [  494.311597] bcache (dm-10): dm-10: journal checksum bad (got
> 18446744070980686285 expect 1566101965), sector 2560u
> [  494.313038] bcache (dm-10): dm-10: journal checksum bad (got
> 18446744073177643543 expect 3763059223), sector 2816u
> [  494.324082] bcache (dm-10): dm-10: journal checksum bad (got
> 18446744070081456445 expect 666872125), sector 3072u
> [... many similar lines...]
> [  495.000229] bcache (dm-10): dm-10: journal checksum bad (got
> 18446744071270315299 expect 1855730979), sector 90368u
> [  495.001373] bcache (dm-10): dm-10: journal checksum bad (got
> 18446744070901133954 expect 1486549634), sector 90624u
> [  495.002696] bcache (dm-10): dm-10: journal checksum bad (got
> 18446744071373615633 expect 1959031313), sector 90880u
> [  496.618084] bcache (dm-10): journal replay error: -28
> [  496.618124] bcache: bch_open_as_blockdevs() register_cache_set err
> journal replay failed
> [  496.796085] bcache (dm-10): stopped

Damn, metadata checksums were getting truncated too... Those checksum errors are
a result of the patch fixing that and not truncating the checksum anymore.

Well, if you want you could try testing with a5e2d9aaea to see what the error
was in fs gc, but regardless you're going to have to end reformatting (you said
nothing important was on this filesystem, right?)

> What str_hash does?

It selects the hash function used for indexing strings - dirents and xattrs are
indexed by hash.

> Today I formated block device and again I play with changing
> "compression, data_checksum, metadata_checksum, str_hash". I was
> changing options while intensive writing to fs. Two times I had hard
> lockup of kernel. No chance for getting dmesg. After first lockup I
> caouldn't mount fs again due to:
> kernel: [  260.141942] bcache: bch_open_as_blockdevs()
> register_cache_set err bad btree root
> 
> So -> format -> testing - hard lockup. On the second time I could mount
> again fs:
> kernel: [  234.920846] bcache (dm-11): journal replay done, 29 keys in 1
> entries, seq 3447
> 
> I'm thinking about using netconsole but I'm not sure I would have a time
> for this before tuesday.

I haven't yet tried randomly flipping the compression type at runtime, I'll try
that now...
