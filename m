From: Pierre Beck <debian-bugs-MZZvbRqs/9F0RdzJJlgK+g@public.gmane.org>
Subject: Re: Loosing transactions
Date: Tue, 29 Jan 2013 21:16:02 +0100
Message-ID: <51082E02.7000908@pierre-beck.de>
References: <51004490.704@pierre-beck.de> <20130124233559.GO26407@google.com> <51068F01.9060000@pierre-beck.de> <20130129190133.GL26407@google.com> <20130129190942.GM26407@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130129190942.GM26407-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Am 29.01.2013 20:09, schrieb Kent Overstreet:
> I lied, that idea turned out to be wrong.
>
> Though - data=journal isn't that commonly used, an ext4 bug is an
> outside possibility (if it was assuming the pre 2.6.38 semantics of
> barriers that could cause this). Could you test with data=ordered and
> tell me what happens?
>

Sorry I didn't state that clearly. The ext4 data=journal test was for 
comparison only. All bcache tests were done with defaults, which is 
data=ordered.

# mkfs.ext4 -K -b 4096
# mount -o noatime

Disabling all hardware caches with hdparm AND putting bcache in 
writethrough mode made it pass the test, btw., with severe performance 
loss of course. What's really alarming is that bcache in writeback with 
hw caches deactivated still loses transactions. This points to the 
journal logic. Maybe the last element of the journal is simply not iterated?

Greetings,

Pierre Beck
