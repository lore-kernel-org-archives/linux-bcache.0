From: Marcin <marcin@mejor.pl>
Subject: Re: [bcachefs] problem with `bcache fsck`
Date: Fri, 17 Mar 2017 09:57:32 +0100
Message-ID: <4662ab7db9e440f044e98c0aea6b63c0@mejor.pl>
References: <6aaaad468dd77840265bcd9f31f1878a@mejor.pl>
 <20170316203455.jgl6ovsrve55fnxi@moria.home.lan>
 <f7e0b5acca043eff08a55f424470221d@mejor.pl>
 <20170316235651.oehere2zxhewbbdh@moria.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:37458 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751021AbdCQI6f (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 17 Mar 2017 04:58:35 -0400
In-Reply-To: <20170316235651.oehere2zxhewbbdh@moria.home.lan>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

W dniu 2017-03-17 00:57, Kent Overstreet napisał(a):
> On Thu, Mar 16, 2017 at 11:07:20PM +0100, Marcin wrote:
>> If I add bcachefs to fstab openrc expects userland fsck to works this 
>> is why
>> I tried it to use.
> 
> Fsck should be fixed now

Thanks, but when I pass only one device from two used in tiered fs 
`bcache fsck` becomes upset:
# bcache fsck /dev/sdd1
bcache: libbcache/buckets.h:87: gen_after: Assertion `!(r > 128U)' 
failed.

Also it happened I got segfault while using fsck. I don't have coredump, 
I'll try to catch it.

Marcin
