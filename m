From: Kent Overstreet <koverstreet@google.com>
Subject: Re: bcache: order 7 allocation
Date: Mon, 24 Jun 2013 13:05:18 -0700
Message-ID: <20130624200518.GA2509@google.com>
References: <20130622114745.GB8075@amd.pavel.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130622114745.GB8075@amd.pavel.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-bcache@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On Sat, Jun 22, 2013 at 01:47:46PM +0200, Pavel Machek wrote:
> Hi!
> 
> I'm trying to play with bcache, but first surprise was oom in syslog:
> 
> Order 7 alocation is pretty big, no?

That's a btree node - and after it allocates the reserve at startup,
allocation failures don't matter.

I would just flip on CONFIG_COMPACTION - CONFIG_BCACHE used to select
that but someone complained (probably I just shouldn't have listened).
