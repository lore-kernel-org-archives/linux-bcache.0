From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: bcache-tools [branch: dev] throws Assertion `!(bcache_init())'
 failed.
Date: Thu, 2 Feb 2017 12:58:53 -0900
Message-ID: <20170202215853.dno7uphjdw6lbdtc@moria.home.lan>
References: <b5d03d84-47c6-8f05-6851-2c6ac8eed035@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:33779 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751446AbdBBV65 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 2 Feb 2017 16:58:57 -0500
Received: by mail-pg0-f67.google.com with SMTP id 194so96485pgd.0
        for <linux-bcache@vger.kernel.org>; Thu, 02 Feb 2017 13:58:56 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <b5d03d84-47c6-8f05-6851-2c6ac8eed035@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "marcin@mejor.pl" <marcin@mejor.pl>
Cc: linux-bcache@vger.kernel.org

On Wed, Feb 01, 2017 at 03:06:01PM +0100, marcin@mejor.pl wrote:
> Hi,
> bcachefs-tools at b33fc829 throws assertion:
> # bcache
> bcache: libbcache/super.c:2503: __call_bcache_init: Assertion
> `!(bcache_init())' failed.

Found it - it was an initialization order thing. Fix is pushed.
