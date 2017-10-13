From: Michael Lyle <mlyle@lyle.org>
Subject: Re: bcache failure hangs something in kernel
Date: Fri, 13 Oct 2017 02:13:49 -0700
Message-ID: <d49c21f3-354b-675a-60d4-702a40e3c3c8@lyle.org>
References: <efb67a88-3f4c-d268-3d2a-59c00824b5e7@xenlab.one>
 <b574aee6-1f6f-8eb3-d78a-ee3fd8f9bfb3@lyle.org>
 <b4cf93d3-7e15-9f20-941b-7f11269c510b@xenlab.one>
 <024c8d28-9ddb-09fe-c2b0-8a7d0aed493d@lyle.org>
 <f9afc17d-de8b-1d5e-bb34-260051aa2de1@xenlab.one>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:50908 "EHLO
        mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751033AbdJMJNw (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 13 Oct 2017 05:13:52 -0400
Received: by mail-pf0-f179.google.com with SMTP id b6so848601pfh.7
        for <linux-bcache@vger.kernel.org>; Fri, 13 Oct 2017 02:13:51 -0700 (PDT)
In-Reply-To: <f9afc17d-de8b-1d5e-bb34-260051aa2de1@xenlab.one>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Alexandr Kuznetsov <progmachine@xenlab.one>, linux-bcache@vger.kernel.org

On 10/13/2017 02:10 AM, Alexandr Kuznetsov wrote:
[snip]
> I was not manipulating directly with backing devices or lvm pv's. I was
> not doing something illegal from lvm or bcache points of view, otherwise
> i would not write here, because then i would know that file system was
> killed by myself.
> There was only lvcreate and lvremove commands that creates and removes
> logical volumes inside lvm, nothing more, there wasn't any direct access
> outside of /dev/bcache* devices. Thats why i wrote "This means that some
> necessary io buffer range checks are missing inside bcache". So how
> bcache allowed to damage data outside of bcache* devices if any access
> to them went through bcache, not directly? I'm sure thats a bug. Why
> bcache freezes when he meets corrupted data instead of reporting errors?
> I'm sure thats a bug.

I'm sorry you've lost data.  I've run bcache and lvm a lot at scale and
haven't seen anything like this, nor are there any other reports as far
as I'm aware.  I am new as bcache maintainer but have a pretty high
degree of confidence it doesn't overwrite its own superblocks randomly.

If you come up with a repro I'll be glad to look at it.

Mike
