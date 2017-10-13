From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH v2] bcache: safeguard a dangerous addressing in
 closure_queue
Date: Thu, 12 Oct 2017 22:48:51 -0700
Message-ID: <95ddfc9f-b01e-3346-4ebf-d15d73644d35@lyle.org>
References: <20171013053049.11875-1-liangchen.linux@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:53215 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751353AbdJMFsy (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 13 Oct 2017 01:48:54 -0400
Received: by mail-pf0-f193.google.com with SMTP id e64so8469172pfk.9
        for <linux-bcache@vger.kernel.org>; Thu, 12 Oct 2017 22:48:54 -0700 (PDT)
In-Reply-To: <20171013053049.11875-1-liangchen.linux@gmail.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Liang Chen <liangchen.linux@gmail.com>, linux-bcache@vger.kernel.org
Cc: i@coly.li, kent.overstreet@gmail.com, linux-kernel@vger.kernel.org

Hi Liang--

Thanks for the quick turnaround.  I've added this to bcache-for-next.

On 10/12/2017 10:30 PM, Liang Chen wrote:
> The use of the union reduces the size of closure struct by taking advantage
> of the current size of its members. The offset of func in work_struct equals
> the size of the first three members, so that work.work_func will just
> reference the forth member - fn.
> 
> This is smart but dangerous. It can be broken if work_struct or the other
> structs get changed, and can be a bit difficult to debug.
> 
> Signed-off-by: Liang Chen <liangchen.linux@gmail.com>

Reviewed-by: Michael Lyle <mlyle@lyle.org>

-Mike
