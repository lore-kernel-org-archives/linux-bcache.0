From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH] bcache: safeguard a dangerous addressing in closure_queue
Date: Thu, 12 Oct 2017 10:44:47 -0700
Message-ID: <0b4be514-0ce8-efd9-4e17-8772729ac336@lyle.org>
References: <20171012143737.24577-1-liangchen.linux@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:55514 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750729AbdJLRoz (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 12 Oct 2017 13:44:55 -0400
Received: by mail-pf0-f194.google.com with SMTP id 17so5863963pfn.12
        for <linux-bcache@vger.kernel.org>; Thu, 12 Oct 2017 10:44:55 -0700 (PDT)
In-Reply-To: <20171012143737.24577-1-liangchen.linux@gmail.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Liang Chen <liangchen.linux@gmail.com>, linux-bcache@vger.kernel.org
Cc: i@coly.li, kent.overstreet@gmail.com, linux-kernel@vger.kernel.org

On 10/12/2017 07:37 AM, Liang Chen wrote:
> The use of the union reduces the size of closure struct by taking advantage
> of the current size of its members. The offset of func in work_struct equals
> the size of the first three members, so that work.work_func will just
> reference the forth member - fn.
> 
> This is smart but dangerous. It can be broken if work_struct or the other
> structs get changed, and can be a bit difficult to debug.
> 
> Signed-off-by: Liang Chen <liangchen.linux@gmail.com>

So the objective here is to make sure that struct work_struct and the
anonymous struct remain identical?  I agree that's a potential problem
for future maintenance.

Could we use BUILD_BUG_ON with offsets and sizes to do the same, to get
compile-time checking and avoid doing anything at runtime (I know the
compiler can usually omit the BUG but better to be safe)?  Otherwise a
kernel that triggered this problem would compile, and it'd only be if
someone actually used bcache that it would trigger.

Mike
