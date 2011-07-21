From: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Git Repo lacks memory ?
Date: Thu, 21 Jul 2011 13:04:03 -0700
Message-ID: <4E288633.3040602@gmail.com>
References: <loom.20110721T165958-17@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <loom.20110721T165958-17-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: i- <itooo-xVucS5mfmt0AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 07/21/11 08:07, i- wrote:
> Hi,
>
> Trying to clone the repository fails with the following error :
>
> root@VM# git clone git://evilpiepirate.org/~kent/linux-bcache.git
> Initialized empty Git repository in /root/bcache/linux-bcache/.git/
> remote: fatal: Out of memory, realloc failed
> remote: aborting due to possible repository corruption on the remote side.
> fatal: early EOF
> fatal: index-pack failed
>
> Can you take a look ?

Damn, thought I fixed that. Give me a day or so, I'm in the middle of 
some on disk format changes and once I finish that I need to rebase and 
upload a bunch of new stuff.
