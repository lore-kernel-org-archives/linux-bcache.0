From: Rui Hua <huarui.dev@gmail.com>
Subject: Re: [PATCH] bcache: recover data from backing device when read
 request hit clean
Date: Fri, 17 Nov 2017 15:26:03 +0800
Message-ID: <CAPGwLLPmUiz-6xjur5jPAn1QLvkJY23QcsPCNvK+4+BVubWYnw@mail.gmail.com>
References: <CAPGwLLNwG+kLT9_QaCL5PBLS0a6K-x-iog+ON2pArUQWr1rWTg@mail.gmail.com>
 <dc6f513b-cca3-a37d-3379-2e12df21e825@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <dc6f513b-cca3-a37d-3379-2e12df21e825@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: Coly Li <i@coly.li>, Michael Lyle <mlyle@lyle.org>, Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

Hi, Coly--
Thanks for your detailed review notes.

2017-11-17 14:01 GMT+08:00 Coly Li <colyli@suse.de>:

>> Without this patch, when we use writeback mode, we will never reread from
>> the backing device when cache read race happend, until the whole cache
>> device is clean, because the condition
>
> I assume this is a race condition, that means after the race window, the
> KEY associated to the reused bucket will be invalided too. So a second
> read will trigger a cache miss, and re-read the data back into cache
> device. So it won't be "never". The problem is, if upper layer code
> treats it as a failed I/O, and it happens to be metadata of upper layer
> code, then some negative result may happens. For example file system
> turns into read-only mode.

Yes, your example about metadata of upper layer code provides a good reference ,
Indeed, I met the xfs metadata error a few days ago when I use xfs on bcache,
under heavy load, I got the following xfs error:
localhost kernel: XFS (bcache0): metadata I/O error: block 0x3e3e2af0
("xfs_trans_read_buf_map") error 4 numblks 16
And I can confirm it was caused by the read race.

The word "never" I used in above is not suitable:-/, thanks for your point,
 what I want to say is we will not recover clean data UNTIL the whole cache
device become clean, or in writethrough mode.

>
> P.S could you please also take a look on btree internal node I/O failure
> ? Thanks in advance.
>
At least, for now, I find that when cache_lookup() traverse btree,
if bch_btree_node_get() return ERR_PTR(-EIO), it will not pass to upper layer,
cached_dev_bio_complete() will be called, just like there is no any IO error,
I think this is another bug. I'll deep into code and find more detail
when I have time.

Thanks,
