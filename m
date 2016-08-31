From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: clang doesn't like bcache-tools: libbcache.c:79:39: error:
 function definition is not allowed here
Date: Tue, 30 Aug 2016 16:32:03 -0800
Message-ID: <20160831003203.amfuaozybcvewuuv@kmo-pixel>
References: <b8e1ee15-da4a-a5d3-3717-96b9286d9571@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35070 "EHLO
        mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751301AbcHaAjI (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 30 Aug 2016 20:39:08 -0400
Received: by mail-pa0-f46.google.com with SMTP id hb8so12438792pac.2
        for <linux-bcache@vger.kernel.org>; Tue, 30 Aug 2016 17:39:07 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <b8e1ee15-da4a-a5d3-3717-96b9286d9571@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marcin =?utf-8?B?TWlyb3PFgmF3?= <marcin@mejor.pl>
Cc: linux-bcache@vger.kernel.org

On Tue, Aug 30, 2016 at 10:42:29AM +0200, Marcin Mirosław wrote:
> Hi!
> Compilation of bcache-tools (branch: dev) fails due to:

oh yeah, clang doesn't like nested functions. fixed.
