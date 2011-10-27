From: Brad Campbell <lists2009-+nnirC7rrGZibQn6LdNjmg@public.gmane.org>
Subject: Re: "Benchmarks"
Date: Thu, 27 Oct 2011 11:54:47 +0800
Message-ID: <4EA8D607.4060203@fnarfbargle.com>
References: <4EA20E4E.8050402@fnarfbargle.com> <CAC7rs0s3qCDYGnkbMv3NmxFR740mo48vV0mZa54TKbomFB7kjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAC7rs0s3qCDYGnkbMv3NmxFR740mo48vV0mZa54TKbomFB7kjg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 25/10/11 01:10, Kent Overstreet wrote:
> Cool!
>
> The thing I'd be really curious about is what the benchmarks would
> look like if you were using only the SSD, no bcache.

I'll see what I can do when I next fire up the staging server.

> How happy are you with it?

Well, it does what it says on the tin for quick and dirty benchmarks, 
but I really can't even contemplate it on a production machine until it 
is compatible with md, and preferably has dirty write mirroring.

Now I have a permanent staging server, I'll keep playing with it as the 
code evolves though.
