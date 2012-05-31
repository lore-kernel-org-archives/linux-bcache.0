From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 0/3] Generic rb tree code
Date: Thu, 31 May 2012 23:03:35 +0200
Message-ID: <20120531210335.GC16338@quack.suse.cz>
References: <1337979461-19654-1-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1337979461-19654-1-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org, Daniel Santos <danielfsantos-fOdFMYwuEsI@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On Fri 25-05-12 13:57:38, Kent Overstreet wrote:
> Right now, users of the rb tree code have to open code their own search and
> insert functions. This provides generic versions that you pass a comparison
> function to.
> 
> I highly doubt the extra function calls are going to have a measurable
> performance impact in practice - the pointer chasing is going to dominate. I
> did provide inline versions just in case, though - it's modelled after the
> spinlock code.
> 
> The inline version of rb_search() is important for another reason, though - you
> have to pass rb_search a pointer to your struct for it to compare against,
> which has to be allocated on the stack. For most users I think that'll be fine,
> but for the elevator code struct rb_node is embedded in struct request, which
> is rather large. By using the inline version that stack allocation goes away.
> 
> (I looked at the generated assembly of elv_rb_find() before and after, and if
> I'm reading it right it's not using any extra stack. Code is a bit worse, but
> IMO removing code duplication is worth it).
> 
> Kent Overstreet (3):
>   rbtree: Add rb_insert(), rb_search(), etc.
>   timerqueue: convert to generic rb tree code
>   block: convert elevator to generic rb tree code
  Hum, are you aware of another generic rb-tree attempt -
 https://lkml.org/lkml/2012/4/30/132 ?

								Honza
-- 
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, CR
