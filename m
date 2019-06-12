From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 01/12] Compiler Attributes: add __flatten
Date: Wed, 12 Jun 2019 19:16:28 +0200
Message-ID: <20190612171628.GA7518@kroah.com>
References: <20190610191420.27007-1-kent.overstreet@gmail.com>
 <20190610191420.27007-2-kent.overstreet@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190610191420.27007-2-kent.overstreet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On Mon, Jun 10, 2019 at 03:14:09PM -0400, Kent Overstreet wrote:
> Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
> ---
>  include/linux/compiler_attributes.h | 5 +++++
>  1 file changed, 5 insertions(+)

I know I reject patches with no changelog text at all.  You shouldn't
rely on other maintainers being more lax.

You need to describe why you are doing this at the very least, as I sure
do not know...

thanks,

greg k-h
