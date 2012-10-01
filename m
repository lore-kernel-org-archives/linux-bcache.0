From: Brad Walker <bwalker-WlSugiYO8JFBDgjK7y7TUQ@public.gmane.org>
Subject: Re: problem w/ read caching..
Date: Mon, 1 Oct 2012 22:26:43 +0000 (UTC)
Message-ID: <loom.20121002T001556-394@post.gmane.org>
References: <CAPKZHbV3n7O+VRVNS-C2oDVSpO_VdirMDUOuwwWKaA5ZOUEG_g@mail.gmail.com> <CAH+dOxLKJKRLU2+0hD0LVmTC68SnFpFrTE63+QegaGPs5BOSMg@mail.gmail.com> <loom.20120928T010314-562@post.gmane.org> <20120928185949.GA7062@google.com> <loom.20121001T211315-779@post.gmane.org> <20121001193806.GA26488@google.com> <loom.20121001T220412-225@post.gmane.org> <20121001203706.GB26488@google.com> <loom.20121001T223817-249@post.gmane.org> <20121001211458.GC26488@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Kent Overstreet <koverstreet@...> writes:


> I was just browsing around the code, and I bet I know what it is -
> btree_insert_check_key() is failing because the btree node is full.
> 
> But, we should confirm this really is what's going on...  Can you apply
> this patch and rerun to test my theory? See if the number of times the
> printk fires lines up with the number of cache misses.
> 


I applied this change and I see a LOT of the messages.

And the rate seems to be increasing.

-brad w.
