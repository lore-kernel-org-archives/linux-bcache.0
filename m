From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] bcache: avoid a dangerous addressing in closure_queue
Date: Wed, 5 Jul 2017 12:31:43 -0700
Message-ID: <20170705193143.GA1050@infradead.org>
References: <1499259199-15161-1-git-send-email-liangchen.linux@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1499259199-15161-1-git-send-email-liangchen.linux@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Liang Chen <liangchen.linux@gmail.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, colyli@suse.de, bcache@linux.ewheeler.net
List-Id: linux-bcache@vger.kernel.org

On Wed, Jul 05, 2017 at 08:53:19PM +0800, Liang Chen wrote:
> The use of the union reduces the size of closure struct by taking advantage
> of the current size of its members. The offset of func in work_struct equals
> the size of the first three members, so that work.work_func will just
> reference the forth member - the pointer to closure_fn.
> 
> This is smart but dangerous. It can be broken if work_struct or the other
> ones get changed, and can be a bit difficult to debug.

Please, don't ever cast function pointers, as that's extremely
dangerous.
