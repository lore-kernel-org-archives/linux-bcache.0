From: Slava Pestov <sp@datera.io>
Subject: Re: [PATCH] bcache: amend writeback_rate documentation
Date: Wed, 25 Jun 2014 10:38:04 -0700
Message-ID: <CACHGV4+31Se0k6y6VDnN19H+LGDBa-BVAd79zW=+o=3NXPoabw@mail.gmail.com>
References: <1403086412-18310-1-git-send-email-Arne.Wiebalck@cern.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:33869 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757574AbaFYRiG (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 25 Jun 2014 13:38:06 -0400
Received: by mail-we0-f171.google.com with SMTP id q58so2408614wes.2
        for <linux-bcache@vger.kernel.org>; Wed, 25 Jun 2014 10:38:05 -0700 (PDT)
In-Reply-To: <1403086412-18310-1-git-send-email-Arne.Wiebalck@cern.ch>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi Arne,

I looked at the latest code and the problem does not happen in our
development branch. For release kernels, a better fix might be to
actually change sysfs.c to read and write writeback_rate in units of
bytes. This way it is simpler to document. What do you think?

On Wed, Jun 18, 2014 at 3:13 AM, Arne Wiebalck <Arne.Wiebalck@cern.ch> wrote:
> From: Arne Wiebalck <Arne.Wiebalck@cern.ch>
>
> The writeback_rate is displayed in bytes per sec, but needs to
> be set in sectors per sec. This patch amends the documentation
> accordingly.
> ---
>  Documentation/bcache.txt | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/bcache.txt b/Documentation/bcache.txt
> index 32b6c31..5643751 100644
> --- a/Documentation/bcache.txt
> +++ b/Documentation/bcache.txt
> @@ -268,9 +268,9 @@ writeback_percent
>    the rate.
>
>  writeback_rate
> -  Rate in sectors per second - if writeback_percent is nonzero, background
> +  Rate in bytes per second - if writeback_percent is nonzero, background
>    writeback is throttled to this rate. Continuously adjusted by bcache but may
> -  also be set by the user.
> +  also be set by the user (in sectors per second).
>
>  writeback_running
>    If off, writeback of dirty data will not take place at all. Dirty data will
> --
> 1.8.3.2.634.g7a3187e
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
