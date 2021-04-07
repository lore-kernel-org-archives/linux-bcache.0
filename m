Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82B56C433B4
	for <linux-bcache@archiver.kernel.org>; Wed,  7 Apr 2021 12:59:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48F0A6120E
	for <linux-bcache@archiver.kernel.org>; Wed,  7 Apr 2021 12:59:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235427AbhDGM70 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Wed, 7 Apr 2021 08:59:26 -0400
Received: from vostok.pvgoran.name ([71.19.149.48]:48783 "EHLO
        vostok.pvgoran.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231892AbhDGM7Z (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 7 Apr 2021 08:59:25 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Apr 2021 08:59:25 EDT
Received: from [10.0.10.127] (l37-193-246-51.novotelecom.ru [::ffff:37.193.246.51])
  (AUTH: CRAM-MD5 main-collector@pvgoran.name, )
  by vostok.pvgoran.name with ESMTPSA
  id 000000000000D1D4.00000000606DAB74.0000055E; Wed, 07 Apr 2021 12:54:11 +0000
Date:   Wed, 7 Apr 2021 19:54:09 +0700
From:   Pavel Goran <via-bcache@pvgoran.name>
X-Mailer: The Bat! (v3.85.03) Professional
Reply-To: Pavel Goran <via-bcache@pvgoran.name>
X-Priority: 3 (Normal)
Message-ID: <807301067.20210407195409@pvgoran.name>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
CC:     colyli@suse.de, kent.overstreet@gmail.com,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH -next v3] bcache: use DEFINE_MUTEX() for mutex lock
In-Reply-To: <20210407125000.858219-1-zhengyongjun3@huawei.com>
References: <20210407125000.858219-1-zhengyongjun3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello Zheng,

The third paragraph of the commit description still mentions the .bss
segment.

Wednesday, April 7, 2021, 7:50:00 PM, you wrote:

> mutex lock can be initialized automatically with DEFINE_MUTEX() rather
> than explicitly calling mutex_init().

> this patch will reduce the size of bcache.ko about 16 bytes, the reason
> as follows:

> though this patch will increase the size of .data segment about 32 bytes,
> it will also reduce the size of .init.text and .rodata.str1.1(at x86_64),
> .rodata_str1.8(at arm64) and .bss segment total about 48 bytes which reduce
>  the size more than .data segment;

> here is the statistics:
> Sections: (arm64 platform)
> Idx name                size
> -.init.text             00000240
> +.init.text             00000228

> -.rodata.str1.8	000012cd
> +.rodata.str1.8	000012b5

> -.data                  00000c60
> +.data                  00000c80

> Sections: (x86 platform)
> Idx name                size
> -.init.text             000001d9
> +.init.text             000001bf

> -.rodata.str1.1	00000c80
> +.rodata.str1.1	00000c6d

> -.data                  00000cc0
> +.data                  00000ce0

> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---

> v3:
> - change commit log, delete statistic about .bss segment.
> v2:
> - add commit log about the reason why bcache.ko size reduced.

>  drivers/md/bcache/super.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 03e1fe4de53d..3635f454309e 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -40,7 +40,7 @@ static const char invalid_uuid[] = {
>  };
>  
>  static struct kobject *bcache_kobj;
> -struct mutex bch_register_lock;
> +DEFINE_MUTEX(bch_register_lock);
>  bool bcache_is_reboot;
>  LIST_HEAD(bch_cache_sets);
>  static LIST_HEAD(uncached_devices);
> @@ -2869,7 +2869,6 @@ static int __init bcache_init(void)
>  
>         check_module_parameters();
>  
> -       mutex_init(&bch_register_lock);
>         init_waitqueue_head(&unregister_wait);
>         register_reboot_notifier(&reboot);
>  



Pavel Goran
  

