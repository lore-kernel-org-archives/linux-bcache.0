From: Denis Bychkov <manover@gmail.com>
Subject: Re: use bcache with /dev/zram as caching device
Date: Wed, 16 Sep 2015 18:30:37 -0400
Message-ID: <CAO2mnoy7Lx55Hi=mHW4APiRUgVOWUnJoWQdZcM+AkeMS+D7s-A@mail.gmail.com>
References: <CAEMVdVwOqXeL38fMghAHJ1OBMq3CDZv7FxfPvrN2DM1gv++fdw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:34324 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbbIPWai (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 16 Sep 2015 18:30:38 -0400
Received: by lbbmp1 with SMTP id mp1so259321lbb.1
        for <linux-bcache@vger.kernel.org>; Wed, 16 Sep 2015 15:30:37 -0700 (PDT)
In-Reply-To: <CAEMVdVwOqXeL38fMghAHJ1OBMq3CDZv7FxfPvrN2DM1gv++fdw@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Ansgar Jazdzewski <a.jazdzewski@googlemail.com>
Cc: linux-bcache@vger.kernel.org

Do you mean you don't care about the state of the file system after a
reboot? Do you rebuild it from scratch each time on restart? Even so,
bcache was designed around SSD media behavior, there are some notions
non-applicable to zram drives, like buckets. They might introduce some
inefficiencies, but should not affect the semantics. Could show the
errors you receive.
Also, could it be zram-related? Did you try RAM block devices instead?
What IO scheduler do you use on zram? Could you try noop and see what
happens?

On Fri, Aug 28, 2015 at 1:47 AM, Ansgar Jazdzewski
<a.jazdzewski@googlemail.com> wrote:
> hi,
>
> we like to use bcache with a ramdrive as cache but during the
> configuration i received some errors possibly be timing related.
>
> some one of you tryed to have a ram device as chache? before you ask:
> we like to try to speed up a elasticsearch cluster so a server fail is
> not an issue.
>
> Best,
> Ansgar
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 

Denis
