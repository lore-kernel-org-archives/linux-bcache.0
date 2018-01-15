From: Clemens Eisserer <linuxhippy@gmail.com>
Subject: Re: Enabling discard rendered caching device unuseable
Date: Mon, 15 Jan 2018 10:31:44 +0100
Message-ID: <CAFvQSYQ3Y+2BQJGdjZ40N8xn0B=vY+tT=2TVG14xVF3=JH4DGQ@mail.gmail.com>
References: <CAFvQSYTrzA=i6Xww3vGRs+Wu3sHg_hjXMY1JmEdfNb8hD2Phxw@mail.gmail.com>
 <CAJ+L6qeOVY_KofXsZKihHrbHaYzQTKYAh0Shm7Givj+f8=PiBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pl0-f46.google.com ([209.85.160.46]:37640 "EHLO
        mail-pl0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754291AbeAOJbq (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 15 Jan 2018 04:31:46 -0500
Received: by mail-pl0-f46.google.com with SMTP id s3so3282912plp.4
        for <linux-bcache@vger.kernel.org>; Mon, 15 Jan 2018 01:31:46 -0800 (PST)
In-Reply-To: <CAJ+L6qeOVY_KofXsZKihHrbHaYzQTKYAh0Shm7Givj+f8=PiBg@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi Michael,

> I'm sorry for this experience; I've added discard to my list of things
> to review.
>
> I suggest avoiding discard for bcache; since the cache device grows
> until it is nearly full and is kept in that state, there is little
> benefit from it.

Good to know, thanks for the advice.

Best regards, Clemens
