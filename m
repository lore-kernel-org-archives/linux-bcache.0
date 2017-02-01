From: "marcin@mejor.pl" <marcin@mejor.pl>
Subject: Re: bcachefs-tools: file bcache.h is symlink to local file
Date: Wed, 1 Feb 2017 14:38:20 +0100
Message-ID: <0c4e0880-5cbb-5103-c952-d75e22b5ed70@mejor.pl>
References: <4fe1eab0-2539-c7dc-129a-0fea91e8a4a8@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:55466 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750737AbdBANix (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 1 Feb 2017 08:38:53 -0500
In-Reply-To: <4fe1eab0-2539-c7dc-129a-0fea91e8a4a8@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

W dniu 25.01.2017 o 16:00, Marcin Miros³aw pisze:
> Hi!
> File
> https://evilpiepirate.org/git/bcache-tools.git/tree/include/trace/events/bcache.h?h=dev
> 
> is symlink on local computer. My compilator don't have access to Kent's
> box, this make gcc upset:)
> Marcin

Hi!
I see that it's fixed, thank you.
Marcin
