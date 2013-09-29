From: Joseph Yasi <joe.yasi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Data corruption with bcache in 3.11
Date: Sun, 29 Sep 2013 12:52:42 -0400
Message-ID: <CADzA9okLDMc6Pqm3a+dyZ+1YGfn4LDGKcs385isU4ssrw0z0jQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 09/20/2013 02:35 AM, Kent Overstreet wrote:
> If you were one of the users seeing data corruption in 3.11 but not any
> of the 3.10 stable kernel, I think I just fixed it. It's now clearer why
> it was only hitting some users, too...
>
> I want to get confirmation from someone who was seeing it that it fixes
> the issue, so please test the fix and let me know what happens. It's in
> my bcache-data-corruption-fix branch, and the patch is below:
>
> commit 97ad43a31a7ea3c23a4eb64b8e26aad3cf21ae8d

This patch seems to fix the corruption problem for me caching an md
RAID10 array.
