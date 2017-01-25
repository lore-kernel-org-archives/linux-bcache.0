From: =?UTF-8?Q?Marcin_Miros=c5=82aw?= <marcin@mejor.pl>
Subject: bcachefs-tools: file bcache.h is symlink to local file
Date: Wed, 25 Jan 2017 16:00:24 +0100
Message-ID: <4fe1eab0-2539-c7dc-129a-0fea91e8a4a8@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:19080 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750722AbdAYPBW (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 25 Jan 2017 10:01:22 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi!
File 
https://evilpiepirate.org/git/bcache-tools.git/tree/include/trace/events/bcache.h?h=dev
is symlink on local computer. My compilator don't have access to Kent's 
box, this make gcc upset:)
Marcin
