From: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: software raid and bcache
Date: Wed, 3 Jul 2013 18:03:27 +0000 (UTC)
Message-ID: <kr1p1f$v4m$3@ger.gmane.org>
References: <CACaajQuSFAu9i-EzNfEnfDpCwzAf4OHR8vxk5ZtjaaRS75Tz7g@mail.gmail.com>
	<kr1k7a$v4m$1@ger.gmane.org>
	<CACaajQv2A8XkOpmwYU47qCwPVXKsTR+T=ETA5AA701bOr=767w@mail.gmail.com>
	<51D45919.40400@warr.net>
	<CACaajQsSL6kdjgWhr+v9QxAKdPK=UvUd6NUn7YDESjYYJ_tiDQ@mail.gmail.com>
	<51D4621A.505@warr.net>
	<CACaajQv-pEdgj8PdEWkHbrL7XT=ZbCTODzc7B8M_9fKqQ9CcFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Wed, 03 Jul 2013 21:57:54 +0400, Vasiliy Tolstov wrote:
> 2013/7/3 Jason Warr <jason-/cow75dQlsI@public.gmane.org>:
>> In a mirror your raid device can only be as big as the smallest device.
>> So if you put in a secondary device that is larger than the first you
>> still cannot go beyond the size of the first unless you then replace it
>> after syncing the second.
> 
> Yes i'm understand this. But normally i want to work with one device
> in raid1 =). Thanks all for help!

LVM would give you more flexibility for the use case of
moving data around, you could use any number of disks
regardless of their sizes.  Though I suppose you're
sticking with what you know.
