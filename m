From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [bcachefs][tier] INFO: task bch_tier_read:21414 blocked for more
 than 120 seconds.
Date: Mon, 17 Oct 2016 16:30:31 -0800
Message-ID: <20161018003031.ny2dodab32mhmv3p@kmo-pixel>
References: <ebd2b9da9ab215488fd59797d8d1d67d@mejor.pl>
 <20161012012600.s2cq5ac37hwwrp3e@kmo-pixel>
 <b96021dc-9eaa-ea03-291f-1612d73f49c4@mejor.pl>
 <20161012121105.ym3sed4tgc2vx3dh@kmo-pixel>
 <8312944b83a28b36f054c7a44d0fcbd8@mejor.pl>
 <CAC7rs0vU1KTsf1KmbCJg3GWLrsKd4aA=j=vCezyBPTuVFxOHQg@mail.gmail.com>
 <856aa94d33dfbd22dbb377b5de22b0cc@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34236 "EHLO
        mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932779AbcJRAaf (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 17 Oct 2016 20:30:35 -0400
Received: by mail-pa0-f46.google.com with SMTP id rz1so66339946pab.1
        for <linux-bcache@vger.kernel.org>; Mon, 17 Oct 2016 17:30:35 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <856aa94d33dfbd22dbb377b5de22b0cc@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marcin <marcin@mejor.pl>
Cc: linux-bcache@vger.kernel.org

On Wed, Oct 12, 2016 at 09:51:17PM +0200, Marcin wrote:
> W dniu 2016-10-12 21:19, Kent Overstreet napisał(a):
> > It needs to return true, not false.
> 
> It's not a bash, ok:)
> 
> With:
> --- a/drivers/md/bcache/journal.h
> +++ b/drivers/md/bcache/journal.h
> @@ -184,7 +184,8 @@ static inline unsigned jset_u64s(unsigned u64s)
> 
>  static inline bool journal_flushes_device(struct cache *ca)
>  {
> -       return ca->mi.tier == 0;
> +       /** return ca->mi.tier == 0; **/
> +       return true;

Chris retested with the latest bcache-dev and it seems to be working for him
now - can you retest with bcache-dev too?
