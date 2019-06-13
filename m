From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [PATCH 10/12] bcache: move closures to lib/
Date: Thu, 13 Jun 2019 07:04:47 -0400
Message-ID: <20190613110447.GA15110@kmo-pixel>
References: <20190610191420.27007-1-kent.overstreet@gmail.com>
 <20190610191420.27007-11-kent.overstreet@gmail.com>
 <20190613072841.GA7996@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190613072841.GA7996@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On Thu, Jun 13, 2019 at 12:28:41AM -0700, Christoph Hellwig wrote:
> On Mon, Jun 10, 2019 at 03:14:18PM -0400, Kent Overstreet wrote:
> > Prep work for bcachefs - being a fork of bcache it also uses closures
> 
> NAK.  This obsfucation needs to go away from bcache and not actually be
> spread further, especially not as an API with multiple users which will
> make it even harder to get rid of it.

Christoph, you've made it plenty clear how much you dislike closures in the past
but "I don't like it" is not remotely the kind of objection that is appropriate
or useful for technical discussions, and that's pretty much all you've ever
given.

If you really think that code should be gotten rid of, then maybe you should
actually _look at what they do that's not covered by other kernel
infrastructure_ and figure out something better. Otherwise... no one else seems
to care all that much about closures, and you're not actually giving any
technical feedback, so I'm not sure what you expect.
