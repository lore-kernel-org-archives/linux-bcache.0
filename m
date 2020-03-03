From: =?koi8-r?B?88/Sz8vJziDh0tTFzSDzxdLHxcXXyd4=?=
        <a.sorokin@bank-hlynov.ru>
Subject: Re: [PATCH 1/2] bcache: ignore pending signals in
 bcache_device_init()
Date: Tue, 3 Mar 2020 06:58:44 +0000
Message-ID: <6D00F9F9-D44F-4853-AC85-22AC1455B653@bank-hlynov.ru>
References: <20200302093450.48016-1-colyli@suse.de>
 <20200302093450.48016-2-colyli@suse.de>
 <20200302122748.GH4380@dhcp22.suse.cz>
 <29a1c9fa-46e2-af5f-9531-c25dbb0a3dca@suse.de>
 <20200302134048.GK4380@dhcp22.suse.cz>
 <cc759569-e79e-a1a0-3019-0e07dd6957cb@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx02.bank-hlynov.ru ([65.52.69.146]:50056 "EHLO
        mx02.bank-hlynov.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727407AbgCCHFP (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 3 Mar 2020 02:05:15 -0500
In-Reply-To: <cc759569-e79e-a1a0-3019-0e07dd6957cb@suse.de>
Content-Language: ru-RU
Content-ID: <4AFDBE0E17EAA045BB08823951FA2023@bank-hlynov.ru>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "hare@suse.de" <hare@suse.de>, "mkoutny@suse.com" <mkoutny@suse.com>, Oleg Nesterov <oleg@redhat.com>, Christoph Hellwig <hch@lst.de>

Hello Coly,

On 2 Mar 2020, at 20:06, Coly Li <colyli@suse.de> wrote:
> 
> I see your concern. But the udev timeout is global for all udev rules, I
> am not sure whether change it to a very long time is good ... (indeed I
> tried to add event_timeout=3600 but I can still see the signal received).
> 
> Ignore the pending signal in bcache registering code is the only method
> currently I know to avoid bcache auto-register failure in boot time. If
> there is other way I can achieve the same goal, I'd like to try.
> 
> BTW, by the mean time, I am still looking for the reason why
> event_timeout=3600 in /etc/udev/udev.conf does not take effect...

In my setup, i completely moved bcache registration from udev to systemd. As a result, there is no need to change udev timeout or worry about kill signals. But this approach breaks hot-plugging bcache devices and require to modify udev rules and probe-bcache from bcache-tools.

It also helps me to manage startup dependencies to ensure that ceph-osd will start only when bcache is ready.

I can elaborate on my approach if you are interested.

-- 
Artem Sorokin
