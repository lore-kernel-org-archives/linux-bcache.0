From: Brian Cottingham <spiffytech@gmail.com>
Subject: Move + resize backing partition?
Date: Wed, 16 Apr 2014 13:37:05 -0400
Message-ID: <CAJEMKXPXJcE2LG1M+-BWCQX0LM00r_iEt3ujhjGH6oCNMzcd3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:61179 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbaDPRhq (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 16 Apr 2014 13:37:46 -0400
Received: by mail-ie0-f174.google.com with SMTP id rp18so10809084iec.19
        for <linux-bcache@vger.kernel.org>; Wed, 16 Apr 2014 10:37:45 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

I need to nondestructively move and grow a partition that backs
bcache. How should I do this? Is it dangerous to use GParted with the
bcache superblock on the partition? Is it possible/advisable to
convert my backing device back to a standard ext4 filesystem for the
move/resize, then convert back to bcache again afterwards? Or is there
a better way?
