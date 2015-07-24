From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [ANNOUNCE] bcachefs!
Date: Fri, 24 Jul 2015 12:25:04 -0700
Message-ID: <20150724192504.GB1928@kmo-pixel>
References: <20150714005825.GA24027@kmo-pixel>
 <CACaajQtwx45r8GcRmchrQwDts1GH-V8g0x1FwGfDvnfm02bq+Q@mail.gmail.com>
 <20150714081105.GA18569@kmo-pixel>
 <CAO2mnowOYReY07-YT23J7jx51wTcjd9VG9-Zy5e2+qCK6Epa+Q@mail.gmail.com>
 <CAC7rs0uWSt85F443PRw1zvybccg+EfebaSyH9EhUwHjhTGryRA@mail.gmail.com>
 <CAC7rs0upqkuH1CPd-OAmrpQ=8PmaDpzHYY1MaBDpAL6TS_iKyw@mail.gmail.com>
 <CAO2mnowmtws19urvHpUOk_6vT7NMOJ_Xge1N1fMy_-vSyXTVoA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:34704 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217AbbGXTZJ (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 24 Jul 2015 15:25:09 -0400
Received: by pdbbh15 with SMTP id bh15so17815021pdb.1
        for <linux-bcache@vger.kernel.org>; Fri, 24 Jul 2015 12:25:08 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAO2mnowmtws19urvHpUOk_6vT7NMOJ_Xge1N1fMy_-vSyXTVoA@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Denis Bychkov <manover@gmail.com>
Cc: Adam Berkan <adam.berkan@gmail.com>, linux-bcache@vger.kernel.org, Vasiliy Tolstov <v.tolstov@selfip.ru>, Michael Rubin <mrubin@google.com>, Slava Pestov <sviatoslavpestov@gmail.com>, zab@zabbo.net, Ricky Benitez <rickyb@google.com>

On Sun, Jul 19, 2015 at 10:52:09PM -0400, Denis Bychkov wrote:
> I don't think I found anything in the design description or anywhere
> else explaining how tiering works and what data, when and why ends up
> on the next tier. And how to control this. The old bcache has a pretty
> advanced set of knobs allowing you to fine-tune this behavior
> (read-ahead limit, sequential cutoff, congestion thresholds, etc.) If
> I overlooked, please point me to the right direction.

All those additional knobs don't exist yet in bcachefs/tiering land - I want to
rethink all of that, and also wait until there's actual users/use cases that
need that stuff so we have some idea of what we're trying to accomplish.

The way it works right now is:
 - Foreground writes always go to tier 0

   If tier 0 is full, they wait - there's code to slowly throttle foreground
   writes if tier 0 is getting close to full and give tiering/copygc a chance to
   catch up, so they hopefully don't get stuck waiting nearly forever when tier
   0 gets completely full

 - Tiering scans the extents btree looking for data that is present on tier 0
   but not tier 1, and then writes an additional copy of that data on tier 1

 - Extra replicas are considered cached, so the copy on tier 0 will no longer be
   considered dirty and can be reclaimed

 - On the read side, if we read from tier 1 the cache_promote() path tries to
   write another copy to tier 0

No fancy knobs yet. In the future (a ways off), if we want to readd fancy
knobs/behaviour we should try and rethink this stuff in the context of a
filesystem - like we could potentially have persistent inode flags for "this
file should always live on the slow tier", and also if we want to send
particular IOs to the slow tier possibly try and do that from the code that
interacts with the pagecache, where we've got more information about how much
data we're going to be reading/writing.
