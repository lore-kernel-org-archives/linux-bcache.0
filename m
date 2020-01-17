From: Coly Li <colyli@suse.de>
Subject: Re: undo make-bcache (was: Re: Can't mount an encrypted backing
 device)
Date: Fri, 17 Jan 2020 08:58:52 +0800
Message-ID: <32fb3244-cb9e-460d-3156-99e418dda44f@suse.de>
References: <CA+Z73LFJLiP7Z2_cDUsO4Om_8pdD6w1jTSGQB0jY5sL-+nw1Wg@mail.gmail.com>
 <CA+Z73LGvXa_V8t=KYPkrmeJ-xmEXmz1uAnaT=Yj5AReZgLeqhg@mail.gmail.com>
 <65c05b80-679b-2ccb-1bd1-a9a6887c9c51@suse.de>
 <20200113124415.Horde.G9hpYwu_fqvg2w0msexL3ri@webmail.nde.ag>
 <0c6c3fea-5580-3a71-264c-b383b5b4fe66@suse.de>
 <CA+Z73LGG1pBtT=0WN5vEyqEvzxEnqMRZ26S_2x4Gd5JPSmuXmQ@mail.gmail.com>
 <CA+Z73LFNxP8kDMSq74DBKDbCXpbtMA9svpc1KddkUmrk-cfnOA@mail.gmail.com>
 <CA+Z73LGXJOwYEb+GmPuuDi3TcJbGG=NLv-5vCRcEvB+kgr4a+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43762 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730151AbgAQA7C (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 16 Jan 2020 19:59:02 -0500
In-Reply-To: <CA+Z73LGXJOwYEb+GmPuuDi3TcJbGG=NLv-5vCRcEvB+kgr4a+A@mail.gmail.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: clodoaldo.pinto.neto@gmail.com
Cc: "Jens-U. Mozdzen" <jmozdzen@nde.ag>, linux-bcache@vger.kernel.org

On 2020/1/17 5:52 上午, Clodoaldo Neto wrote:
> 
> Em seg, 13 de jan de 2020 11:19, Coly Li <colyli@suse.de
> <mailto:colyli@suse.de>> escreveu:
>>
>> On 2020/1/13 8:44 下午, Jens-U. Mozdzen wrote:
>> > Hi Coly,
>> >
>> > jumping in here, because I was looking for a way to revert from bcache
>> > to plain device:
>> >
>> > Zitat von Coly Li <colyli@suse.de <mailto:colyli@suse.de>>:
>> >> The super block location of the backing disk is occupied by bcache. You
>> >> cannot mount the file system directly from the backing disk which is
>> >> formated as bcache backing device [...] (bcache offset all I/Os on
>> >> bcache device 4KB behind the requesting
>> >> LBA on backing disk).
>> >
>> > Assuming that no caching device is associated with a backing device (so
>> > the backing device is "clean" as in "containing all data blocks with the
>> > current content"), could one convert the content of a backing device to
>> > a "non-bcached device" by removing the first 4096 octets of the backing
>> > device content?
>> >
>> > Something like "dd if=backingdev of=newdev skip_bytes=4096 ..."?
>>
>> Hi Jens-U,
>>
>> you may try dmsetup to setup a linear device mapper target, and the map
>> table just skipping the first 4KB (bcache superblock area). If you are
>> lucky, I mean the real file system is not corrupted, the created device
>> mapper target can be mounted directly.
> 
> 
> I'm trying dmsetup but it does not accept anything other than 0 and 0
> at the beginning and end of the table:
> 
> # echo '0 3774578672 linear /dev/mapper/backing-device 8' | dmsetup
> create dmb
> device-mapper: reload ioctl on dmb  failed: Invalid argument
> Command failed.

The above line should work, if 3774578672 is a correct size number in
sectors.

> 
> # echo '8 3774578664 linear /dev/mapper/backing-device 0' | dmsetup
> create dmb
> device-mapper: reload ioctl on dmb  failed: Invalid argument
> Command failed.
> 
> I'm not sure about how it works. Is it not 8 sectors for 4k bytes?
> 

It works on my side, my kernel is Linux v5.5-rc2, lvm2 version is
2.02.180, dmsetup version is 1.02.149. The difference is the device
size, my disk size is much less.

-- 

Coly Li
