From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: Question =?utf-8?Q?about=C2=A0sequenti?=
 =?utf-8?B?YWzCoGxhcmdlwqB3cml0ZcKgSU8=?= bypass
Date: Mon, 24 Apr 2017 20:55:00 -0800
Message-ID: <20170425045500.wn2wrzo5glypk3d5@moria.home.lan>
References: <201704251238542040646@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:35552 "EHLO
        mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758615AbdDYEzH (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 25 Apr 2017 00:55:07 -0400
Received: by mail-io0-f181.google.com with SMTP id r16so202323577ioi.2
        for <linux-bcache@vger.kernel.org>; Mon, 24 Apr 2017 21:55:07 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <201704251238542040646@zte.com.cn>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: linux-bcache@vger.kernel.org

On Tue, Apr 25, 2017 at 12:38:54PM +0800, tang.junhui@zte.com.cn wrote:
> Hello all, 
> 
> 
> 
> 
> We test sequential write IO with bs=1M by FIO,
> 
> and the bcache cache_mode is writeback,
> 
> we expect these IOs to be bypassed cache,
> 
> but actually they not.
> 
> We debug the code, and find in check_should_bypass():
> 
>     if (!congested &&
> 
>         mode == CACHE_MODE_WRITEBACK &&
> 
>         op_is_write(bio_op(bio)) &&
> 
>         (bio-＞bi_opf & REQ_SYNC))
> 
>         goto rescale
> 
> that means, If in writeback mode, a write IO with REQ_SYNC flag
> 
> will not be bypassed though it is a sequential large IO.
> 
>  
> 
> So, my question is: why do not we bypass these IOs ?
> 
> We planned to remove these codes. Does the modification do any harm?

You can remove that check, it won't break anything.
