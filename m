From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH 4/5] bcache: writeback: collapse contiguous IO better
Date: Fri, 6 Oct 2017 11:36:36 -0700
Message-ID: <CAJ+L6qdnzocZRvcExwFBJPmVJnHWNJXY8j3NioUaekAp06QzXg@mail.gmail.com>
References: <1506497553-12552-1-git-send-email-tang.junhui@zte.com.cn>
 <CAJ+L6qfTDkgrLEUSRX2Pv2qvB7Ns=Hb3nBVz0SDoDn_m9RC8hg@mail.gmail.com>
 <2c39cd9c-34bd-5982-9fd7-ceb61305c13d@coly.li> <CAJ+L6qe7C=FyPFya8y0HV8SCc7VSEEuUApcqEUnouVDUByfZ5w@mail.gmail.com>
 <6a2052da-6b52-9c06-b85e-e3ea29e3f8e8@coly.li> <CAJ+L6qdqQn4tpFdkPZ-zhxss9O8axBEarMBJA5X6f9i+K8SLGg@mail.gmail.com>
 <CAJ+L6qe8rwbtO6tR-QNQBUApbeGQ9NGD=P9t5gtN9j0kzacJEQ@mail.gmail.com>
 <cb6db7c0-eaf7-f4a8-5584-8ce512575d74@coly.li> <CAJ+L6qdG70ExM7cnwYFLmCDBXY8SBErLhnMNeFVscXYemb_1SQ@mail.gmail.com>
 <18f2271b-87c2-530d-12da-dc2b4a5af1fd@coly.li> <CAJ+L6qcLc-=bbDJuaToDFPUWG=c4JKhKBQkivaw3tYWdjERmZw@mail.gmail.com>
 <b654ae09-b9f1-295f-b45a-6688c7fa4e0d@suse.de> <CAJ+L6qf7NtkqKFbKsEjr8noqG94nPQnj1z3doMh10DYH-vMniw@mail.gmail.com>
 <CAJ+L6qdQG27JpDTPxPrgYgeVC8qq-hYHq85U1zHQJDUneT8trA@mail.gmail.com>
 <dca3c016-bb3f-7d8c-1509-f042628d7fd6@coly.li> <CAJ+L6qcY=_vTaqZDLvif_3pqwujo24NUZhGG9ebp6z5+uWqwQQ@mail.gmail.com>
 <33e52793-251d-ed58-fb59-5432946efb56@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qt0-f173.google.com ([209.85.216.173]:45305 "EHLO
        mail-qt0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751491AbdJFSgi (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 6 Oct 2017 14:36:38 -0400
Received: by mail-qt0-f173.google.com with SMTP id k1so22121855qti.2
        for <linux-bcache@vger.kernel.org>; Fri, 06 Oct 2017 11:36:37 -0700 (PDT)
In-Reply-To: <33e52793-251d-ed58-fb59-5432946efb56@coly.li>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <i@coly.li>
Cc: Hannes Reinecke <hare@suse.de>, Junhui Tang <tang.junhui@zte.com.cn>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>

Sorry I missed this question:

> Is it the time from writeback starts to dirty reaches dirty target, or
> the time from writeback starts to dirty reaches 0 ?

Not quite either.  I monitor the machine with zabbix; it's the time to
when the backing disk reaches its background rate of activity / when
writeback hits its minimum rate (writeback with the PI controller
writes a little past the target because of the integral term).

Viewed one way: 5/80 is just a few percent of difference (6%).  But:
I'm hopeful that further improvement can be made along this patch
series, and in any event it's 5 minutes earlier that I/O will have an
unencumbered response time after a pulse of load.

Mike
