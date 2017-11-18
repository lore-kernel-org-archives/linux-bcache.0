From: Rui Hua <huarui.dev@gmail.com>
Subject: Re: [PATCH] bcache: recover data from backing device when read
 request hit clean
Date: Sun, 19 Nov 2017 01:00:41 +0800
Message-ID: <CAPGwLLPggTUZ6OtnvTQ+tHnGCRcP-4mN11MG1fpAX0JFQXakuA@mail.gmail.com>
References: <CAPGwLLNwG+kLT9_QaCL5PBLS0a6K-x-iog+ON2pArUQWr1rWTg@mail.gmail.com>
 <1c715cc2-b656-36a8-4017-55052937df82@lyle.org> <CAPGwLLNyjjxKOXA3RCFGSi4p-ZWZ5T9ADWP6EAqrfL3oUvMbFQ@mail.gmail.com>
 <CAJ+L6qen=5AVFr_q_r_F6jU8BTQ=t+7p94ucFW9HXEDD6AGEKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CAJ+L6qen=5AVFr_q_r_F6jU8BTQ=t+7p94ucFW9HXEDD6AGEKg@mail.gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: Coly Li <i@coly.li>, Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache <linux-bcache@vger.kernel.org>, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

Hi, Michael

> Thanks for the clarification.  You're correct, it doesn't get called,
> and it goes to read_complete.  However, read_error should probably get
> called.  How would you suggest handling this-- should we initially set
> read_dirty_data true and clear it if it is all clean?  (and change the
> condition to properly go into the error path).  As it is, the patch
> makes things no worse but the error path is very unsafe.

Yes, init read_dirty_data to true is an option, but I think it is not
so easy to judge whether it is all clean, because a read request may
cover several keys(just as Coly mentioned in previous reply), probably
some of them are dirty, others are clean, and cache_lookup_fn() was
called on each of these keys when read request search them on btree,
which means we should count and mark them in some place?

Maybe we can set s->iop.status when metadata I/O error, and clear
s->recoverable at the same time (add the code in cache_lookup(), after
bch_btree_map_keys() returns), then it can goto the read_error path,
and will not goto the recovery code.  This option is just a idea,
certainly, we should consider other exception cases.

Thanks,
