From: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Subject: undo make-bcache (was: Re: Can't mount an encrypted backing device)
Date: Mon, 13 Jan 2020 12:44:15 +0000
Message-ID: <20200113124415.Horde.G9hpYwu_fqvg2w0msexL3ri@webmail.nde.ag>
References: <CA+Z73LFJLiP7Z2_cDUsO4Om_8pdD6w1jTSGQB0jY5sL-+nw1Wg@mail.gmail.com>
 <CA+Z73LGvXa_V8t=KYPkrmeJ-xmEXmz1uAnaT=Yj5AReZgLeqhg@mail.gmail.com>
 <65c05b80-679b-2ccb-1bd1-a9a6887c9c51@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from gw-hh2.hh.nde.ag ([85.183.17.20]:58126 "EHLO mail.nde.ag"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726074AbgAMM4w (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 13 Jan 2020 07:56:52 -0500
In-Reply-To: <65c05b80-679b-2ccb-1bd1-a9a6887c9c51@suse.de>
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-bcache@vger.kernel.org

Hi Coly,

jumping in here, because I was looking for a way to revert from bcache  
to plain device:

Zitat von Coly Li <colyli@suse.de>:
> The super block location of the backing disk is occupied by bcache. You
> cannot mount the file system directly from the backing disk which is
> formated as bcache backing device [...] (bcache offset all I/Os on  
> bcache device 4KB behind the requesting
> LBA on backing disk).

Assuming that no caching device is associated with a backing device  
(so the backing device is "clean" as in "containing all data blocks  
with the current content"), could one convert the content of a backing  
device to a "non-bcached device" by removing the first 4096 octets of  
the backing device content?

Something like "dd if=backingdev of=newdev skip_bytes=4096 ..."?

Regards,
J
