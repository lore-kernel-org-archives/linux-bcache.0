From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH] bcache: check ca->alloc_thread initialized before wake up it
Date: Sat, 7 Oct 2017 14:46:50 -0700
Message-ID: <CAJ+L6qdpS8ncKTB+5HS1yuHijd6gK_KfdqvDNEgPypYOnfatgA@mail.gmail.com>
References: <20170919221111.18549-1-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170919221111.18549-1-colyli@suse.de>
Sender: stable-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On Tue, Sep 19, 2017 at 3:11 PM, Coly Li <colyli@suse.de> wrote:
> In bcache code, sysfs entries are created before all resources get
> allocated, e.g. allocation thread of a cache set.
>
> There is posibility for NULL pointer deference if a resource is accessed
> but which is not initialized yet. Indeed Jorg Bornschein catches one on
> cache set allocation thread and gets a kernel oops.
> Signed-off-by: Coly Li <colyli@suse.de>
> Reported-by: Jorg Bornschein <jb@capsec.org>
> Cc: Kent Overstreet <kent.overstreet@gmail.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Michael Lyle <mlyle@lyle.org>
