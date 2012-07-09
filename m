From: Jason Warr <jason-/cow75dQlsI@public.gmane.org>
Subject: bcache & kernel branch that will build together
Date: Mon, 09 Jul 2012 13:07:16 -0500
Message-ID: <4FFB1DD4.7030304@warr.net>
References: <CAOzFzEh8pO37dVWoMoD+hFoUGrBoubSdktdu7SQS0UcXLcC66w@mail.gmail.com> <20120709155734.GA23774@google.com> <CAOzFzEjovYu4eE9E_asOBVyBhqFuvhgzJ7UFyESLY0XycAfkuA@mail.gmail.com> <20120709170742.GA26798@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120709170742.GA26798-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Dumb question coming from someone who is more of an admin than a developer.  Although I did build and run a dev lab at 
Sun in the early days of Solaris Nevada.

What kernel source version or branch will your current git tree patch to and compile with?

I have tried everything from 3.5rc1 to Linus's current git tree.  It breaks DRBD.  Once I disable DRBD in the config it 
fails at target_core_iblock.c.  So I never get a full build.

So either I am doing something obviously wrong or ???

I'd love to test this out and help with debugging.  I have plenty of hardware and interest in it working well.  I can 
even provide you access to debug when I hit an issue.

What error output can I provide and can you point me to good trees?

I appreciate it and I am glad to see that someone is finally making the effort to get a real, working block cache object 
into the kernel.  I will help in any way I can.

Jason
