From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/12] bcache: move closures to lib/
Date: Thu, 13 Jun 2019 00:28:41 -0700
Message-ID: <20190613072841.GA7996@infradead.org>
References: <20190610191420.27007-1-kent.overstreet@gmail.com>
 <20190610191420.27007-11-kent.overstreet@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190610191420.27007-11-kent.overstreet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On Mon, Jun 10, 2019 at 03:14:18PM -0400, Kent Overstreet wrote:
> Prep work for bcachefs - being a fork of bcache it also uses closures

NAK.  This obsfucation needs to go away from bcache and not actually be
spread further, especially not as an API with multiple users which will
make it even harder to get rid of it.
