From: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: pre-emptive caching
Date: Wed, 21 Nov 2012 10:28:38 -0800
Message-ID: <CAC7rs0vau4JsRgtC1m+nHZzrUMg=Da-ZbrVna3kCE2sO3NK7Wg@mail.gmail.com>
References: <CAOiFb5+sobkRnrThO9uo3p674pF8B3PpUC6nBS44nb-UBGxyJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOiFb5+sobkRnrThO9uo3p674pF8B3PpUC6nBS44nb-UBGxyJQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joshua Laferriere <laferrierejc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Install time is a bit different because all those small files will
probably end up looking like sequential writes to bcache, so they may
end up bypassing the cache.

In general though, small random writes will be added to the cache in
both writethrough and writeback mode.

On Sat, Nov 17, 2012 at 7:15 AM, Joshua Laferriere
<laferrierejc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> does it cache small files written during write-back caching?
>
> for example, new install, installing a bunch of files, first written
> files... never been read, just written
>
> does it cache the small files (not to overwrite current cache that has
> higher priority) just in case that file is re-read later so as not to have
> seek time penalties?
>
> On Thu, Nov 15, 2012 at 2:24 AM, Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> wrote:
>>
>> Yes - bcache does block level caching with small (sector) granularity
>> - it'll do what you want
>>
>> On Thu, Nov 15, 2012 at 2:22 AM, Joshua Laferriere
>> <laferrierejc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> > synapse
>> >
>> > On Nov 15, 2012 2:22 AM, "Joshua Laferriere" <laferrierejc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> > wrote:
>> >>
>> >> i was thinking how synaoss maintains a low random access time of
>> >> .78ms...
>> >> and wondered if its because it caches the first 128kb of large files it
>> >> wishes to read.
>> >>
>> >> On Nov 14, 2012 10:23 PM, "Joshua Laferriere" <laferrierejc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> >> wrote:
>> >>>
>> >>> how dkes it do read caching? just store prior read data? which i guess
>> >>> is
>> >>> fine. i did a symbolic link setup in windows that would break after
>> >>> about
>> >>> 10-100k links with smaller than 129k sized files on my ssd and all
>> >>> else in
>> >>> hdd
>
>
