From: Michael Lyle <mlyle@lyle.org>
Subject: Re: Can't register existing backing devices anymore
Date: Fri, 27 Oct 2017 12:41:43 -0700
Message-ID: <CAJ+L6qcb+ypDfHZQaFc-viT7r8SoMWQvugnVmkPYTU3=e6ogbg@mail.gmail.com>
References: <a3c0c8b9df96dc16c6bc682359c2893c@889215b17b02>
 <5eb849fa-8f0b-776a-b635-e3f5af122d75@coly.li> <alpine.LRH.2.11.1710271937260.24585@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qt0-f173.google.com ([209.85.216.173]:54506 "EHLO
        mail-qt0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932135AbdJ0Tlo (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 Oct 2017 15:41:44 -0400
Received: by mail-qt0-f173.google.com with SMTP id z19so9758921qtg.11
        for <linux-bcache@vger.kernel.org>; Fri, 27 Oct 2017 12:41:44 -0700 (PDT)
In-Reply-To: <alpine.LRH.2.11.1710271937260.24585@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: Coly Li <i@coly.li>, Jorg Bornschein <jb@capsec.org>, linux-bcache@vger.kernel.org

On Fri, Oct 27, 2017 at 12:38 PM, Eric Wheeler
<bcache@lists.ewheeler.net> wrote:
> Has this been fixed elsewhere?  The suggested quick-fix doesn't appear in
> 4.14-rc6 so maybe it was solved some other way?

It's in next for probable inclusion in 4.15, but I am not sure it
fixes anything and there are other related races.  It should not get
rushed into 4.14.

Mike
