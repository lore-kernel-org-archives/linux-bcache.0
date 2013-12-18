From: Kent Overstreet <kmo@daterainc.com>
Subject: Re: Adding net cache device to existing bcache
Date: Wed, 18 Dec 2013 10:23:28 -0800
Message-ID: <CALJ65znXOa80Yp4Ah69DvkyyiQ0fkVAmi4L_3A+cMeQ0xzzjcw@mail.gmail.com>
References: <52B1E6B8.3080103@net.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:63380 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659Ab3LRSX3 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 18 Dec 2013 13:23:29 -0500
Received: by mail-ob0-f171.google.com with SMTP id wp18so23494obc.2
        for <linux-bcache@vger.kernel.org>; Wed, 18 Dec 2013 10:23:28 -0800 (PST)
In-Reply-To: <52B1E6B8.3080103@net.home>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Vlad <vovan@vovan.nl>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

Can you list the commands you were using?

On Wed, Dec 18, 2013 at 10:17 AM, Vlad <vovan@vovan.nl> wrote:
> Hello,
>
> I'm trying to add new cache device to an existing bcache, but
> unsuccessfully... I thought it should as simple as formating the new
> cache device (make-bcache) and then attaching it to an existing bcache
> device. However, this procedure won't work.
> Is there any useful howto or another info about this subject.
>
> Regards,
> Vlad.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
