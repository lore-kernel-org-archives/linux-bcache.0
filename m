From: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [GIT PULL] Bcache fixes for 3.10
Date: Wed, 1 May 2013 14:19:43 -0700
Message-ID: <CAC7rs0s7_EBcvLGtbFKcjOofhZC3U=PXoPqR3C7Doo8dKJTFXQ@mail.gmail.com>
References: <20130430195214.GH9931@google.com>
	<20130501072616.GH7800@kernel.dk>
	<20130501185450.GA4057@moria.home.lan>
	<20130501190553.GC7800@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130501190553.GC7800-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Wed, May 1, 2013 at 12:05 PM, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org> wrote:
> Nope, in fact your series was on top of the last commit I got from you,
> cef52797. Only non-bcache in between. Just wondering how that 215
> insertions and 118 deletions becames 213/112 for that case.

Oh, that. That was a last minute bugfix, just backed out part of a
change. Sorry :P
