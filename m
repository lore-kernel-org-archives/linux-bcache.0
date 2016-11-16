From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: __bch_btree_iter_unlock+0x6a/0xb0 or OpenAFS bug?
Date: Wed, 16 Nov 2016 06:16:18 -0900
Message-ID: <20161116151618.a5sajjqjn6nadxan@kmo-pixel>
References: <2bb548a4-cce9-e854-e6e8-4cb3fe86af58@posteo.de>
 <20161116144056.uiqyfplos6ab7ju6@kmo-pixel>
 <62855f9f-c1c7-859a-65b8-a378c25212f4@posteo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pg0-f46.google.com ([74.125.83.46]:33732 "EHLO
        mail-pg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752263AbcKPPWS (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 16 Nov 2016 10:22:18 -0500
Received: by mail-pg0-f46.google.com with SMTP id 3so80288836pgd.0
        for <linux-bcache@vger.kernel.org>; Wed, 16 Nov 2016 07:22:18 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <62855f9f-c1c7-859a-65b8-a378c25212f4@posteo.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Karl-Philipp Richter <krichter@posteo.de>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

On Wed, Nov 16, 2016 at 04:09:56PM +0100, Karl-Philipp Richter wrote:
> 
> 
> Am 16.11.2016 um 15:40 schrieb Kent Overstreet:
> >> A bcachefs or an OpenAFS bug? I only experience this with the OpenAFS
> >> > cache on a one-partition bcachefs mount.
> > Where are you getting __bch_btree_iter_unlock() from?
> From the right backtrace

Ah ok. That's OpenAFS, not bcachefs - the backtrace code isn't reliable, it just
finds anything on the stack that looks like a return address.
