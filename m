From: "marcin@mejor.pl" <marcin@mejor.pl>
Subject: Re: bcache-tools [branch: dev] throws Assertion `!(bcache_init())'
 failed.
Date: Fri, 3 Feb 2017 10:28:34 +0100
Message-ID: <c9cc6d85-bab3-e0ef-5aaf-fd64d7da2e45@mejor.pl>
References: <b5d03d84-47c6-8f05-6851-2c6ac8eed035@mejor.pl>
 <20170202215853.dno7uphjdw6lbdtc@moria.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:7368 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751878AbdBCJ24 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 3 Feb 2017 04:28:56 -0500
In-Reply-To: <20170202215853.dno7uphjdw6lbdtc@moria.home.lan>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

W dniu 02.02.2017 o 22:58, Kent Overstreet pisze:
> On Wed, Feb 01, 2017 at 03:06:01PM +0100, marcin@mejor.pl wrote:
>> Hi,
>> bcachefs-tools at b33fc829 throws assertion:
>> # bcache
>> bcache: libbcache/super.c:2503: __call_bcache_init: Assertion
>> `!(bcache_init())' failed.
> 
> Found it - it was an initialization order thing. Fix is pushed.

It's ok now, thank you.
Marcin
