From: Brad Campbell <lists2009-+nnirC7rrGZibQn6LdNjmg@public.gmane.org>
Subject: Re: Bcache explodes when trying to attach
Date: Sun, 16 Oct 2011 13:15:18 +0800
Message-ID: <4E9A6866.70803@fnarfbargle.com>
References: <4E991D90.1040008@fnarfbargle.com>	<4E9983B1.9060803@fnarfbargle.com> <CAC7rs0sm5BgEawAZYjJjnrqAgyK+D96vmpn=1NEQuTJGk+BgAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAC7rs0sm5BgEawAZYjJjnrqAgyK+D96vmpn=1NEQuTJGk+BgAg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 16/10/11 13:08, Kent Overstreet wrote:
> Doh, I just keep breaking stuff.
>
> There are unfortunately known issues with running on top of dm/md -
> they are high on my list but I've had a lot on my plate lately =/
>
> Worst part of the md/dm issues are that passthrough mode is affected.
> Apologies for having to find out the hard way.
>
> Thanks for the heads up about the cgroup issue. I'm gonna post a new
> version on lkml just as soon as I have time to finish the md/dm stuff
> and thoroughly test it myself.
>
Not a hassle. I actually procured a "staging" machine to track down a long standing and annoying bug 
in netfilter, so as a consequence I have a machine sitting there with loads of hardware to allow me 
to beat on this stuff without having any consequences to crashes or corruption.

Happy to run some tests here under different conditions if you need wider coverage.
