From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH v4 06/13] bcache: set error_limit correctly
Date: Thu, 1 Feb 2018 13:49:09 -0800
Message-ID: <a809420e-c55c-d722-682a-9c8c38da45ee@lyle.org>
References: <20180127142406.89741-1-colyli@suse.de>
 <20180127142406.89741-7-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pl0-f49.google.com ([209.85.160.49]:39757 "EHLO
        mail-pl0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752005AbeBAVtL (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 1 Feb 2018 16:49:11 -0500
Received: by mail-pl0-f49.google.com with SMTP id o13so4558440pli.6
        for <linux-bcache@vger.kernel.org>; Thu, 01 Feb 2018 13:49:11 -0800 (PST)
In-Reply-To: <20180127142406.89741-7-colyli@suse.de>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, Junhui Tang <tang.junhui@zte.com.cn>

On 01/27/2018 06:23 AM, Coly Li wrote:
> Struct cache uses io_errors for two purposes,
> - Error decay: when cache set error_decay is set, io_errors is used to
>   generate a small piece of delay when I/O error happens.
> - I/O errors counter: in order to generate big enough value for error
>   decay, I/O errors counter value is stored by left shifting 20 bits (a.k.a
>   IO_ERROR_SHIFT).

This LGTM

Reviewed-by: Michael Lyle <mlyle@lyle.org>
