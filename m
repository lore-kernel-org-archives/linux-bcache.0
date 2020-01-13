From: Coly Li <colyli@suse.de>
Subject: Re: undo make-bcache (was: Re: Can't mount an encrypted backing
 device)
Date: Mon, 13 Jan 2020 22:18:14 +0800
Message-ID: <0c6c3fea-5580-3a71-264c-b383b5b4fe66@suse.de>
References: <CA+Z73LFJLiP7Z2_cDUsO4Om_8pdD6w1jTSGQB0jY5sL-+nw1Wg@mail.gmail.com>
 <CA+Z73LGvXa_V8t=KYPkrmeJ-xmEXmz1uAnaT=Yj5AReZgLeqhg@mail.gmail.com>
 <65c05b80-679b-2ccb-1bd1-a9a6887c9c51@suse.de>
 <20200113124415.Horde.G9hpYwu_fqvg2w0msexL3ri@webmail.nde.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38698 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726946AbgAMOSb (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 13 Jan 2020 09:18:31 -0500
In-Reply-To: <20200113124415.Horde.G9hpYwu_fqvg2w0msexL3ri@webmail.nde.ag>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Cc: linux-bcache@vger.kernel.org

On 2020/1/13 8:44 下午, Jens-U. Mozdzen wrote:
> Hi Coly,
> 
> jumping in here, because I was looking for a way to revert from bcache
> to plain device:
> 
> Zitat von Coly Li <colyli@suse.de>:
>> The super block location of the backing disk is occupied by bcache. You
>> cannot mount the file system directly from the backing disk which is
>> formated as bcache backing device [...] (bcache offset all I/Os on
>> bcache device 4KB behind the requesting
>> LBA on backing disk).
> 
> Assuming that no caching device is associated with a backing device (so
> the backing device is "clean" as in "containing all data blocks with the
> current content"), could one convert the content of a backing device to
> a "non-bcached device" by removing the first 4096 octets of the backing
> device content?
> 
> Something like "dd if=backingdev of=newdev skip_bytes=4096 ..."?

Hi Jens-U,

you may try dmsetup to setup a linear device mapper target, and the map
table just skipping the first 4KB (bcache superblock area). If you are
lucky, I mean the real file system is not corrupted, the created device
mapper target can be mounted directly.


-- 

Coly Li
