From: Coly Li <i@coly.li>
Subject: Re: ont out of 6 bcache devices does not register automatically
Date: Wed, 22 Nov 2017 20:16:56 +0800
Message-ID: <22a61b57-1fbf-5ec4-383c-13b2cb8eaaf2@coly.li>
References: <3ebfa7f8-cef6-ca8f-a56f-14a6bafd5bc6@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:56568 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752358AbdKVMRB (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 22 Nov 2017 07:17:01 -0500
In-Reply-To: <3ebfa7f8-cef6-ca8f-a56f-14a6bafd5bc6@profihost.ag>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

On 22/11/2017 7:23 PM, Stefan Priebe - Profihost AG wrote:
> Hello,
> 
> i've 6 bcache blk devices attached to 3 caching ssds (2 each). One fails
> to register automatically at boot time.
> 
> After reboot i always need to execute:
> echo /dev/sdf1 >/sys/fs/bcache/register
> 
> to bring up the bcache device.
> 
> Any idea?

Hi Stefan,

Is there any clue from kernel message ?

Thanks.

Coly Li

> Register happens through the following udev file:
> # register bcache devices as they come up
> # man 7 udev for syntax
> 
> SUBSYSTEM!="block", GOTO="bcache_end"
> ACTION=="remove", GOTO="bcache_end"
> 
> # blkid was run by the standard udev rules
> # It recognised bcache (util-linux 2.24+)
> ENV{ID_FS_TYPE}=="bcache", GOTO="bcache_backing_found"
> # It recognised something else; bail
> ENV{ID_FS_TYPE}=="?*", GOTO="bcache_backing_end"
> 
> # Backing devices: scan, symlink, register
> IMPORT{program}="probe-bcache -o udev $tempnode"
> ENV{ID_FS_TYPE}!="bcache", GOTO="bcache_backing_end"
> ENV{ID_FS_UUID_ENC}=="?*", SYMLINK+="disk/by-uuid/$env{ID_FS_UUID_ENC}"
> 
> LABEL="bcache_backing_found"
> RUN+="bcache-register $tempnode"
> LABEL="bcache_backing_end"
> 
> # Cached devices: symlink
> DRIVER=="bcache", ENV{CACHED_UUID}=="?*", \
>         SYMLINK+="bcache/by-uuid/$env{CACHED_UUID}"
> DRIVER=="bcache", ENV{CACHED_LABEL}=="?*", \
>         SYMLINK+="bcache/by-label/$env{CACHED_LABEL}"
> 
> LABEL="bcache_end"
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Coly Li
