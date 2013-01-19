From: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Bcache upstreaming
Date: Sat, 19 Jan 2013 02:35:15 -0800
Message-ID: <CAC7rs0v=zA-6Lf9kH5jmXxySci6GTLMu_Tq1pZFhHDpYcj0APQ@mail.gmail.com>
References: <50FA5C38.60301@crc.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50FA5C38.60301-tY1ak9Q0PTWHXe+LvDLADg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steven Haigh <netwiz-tY1ak9Q0PTWHXe+LvDLADg@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Yeah, the bcache master branch is currently against 3.7.

On Sat, Jan 19, 2013 at 12:41 AM, Steven Haigh <netwiz-tY1ak9Q0PTWHXe+LvDLADg@public.gmane.org> wrote:
>> From: Kent Overstreet <koverstreet@...
>> <http://gmane.org/get-address.php?address=koverstreet%2dhpIqsD4AKlfQT0dZR%2bAlfA%40public.gmane.org>>
>> Subject:Bcache upstreaming
>> <http://news.gmane.org/find-root.php?message_id=%3c20130104235040.GA26407%40google.com%3e>
>> Newsgroups:gmane.linux.kernel.bcache.devel
>> <http://news.gmane.org/gmane.linux.kernel.bcache.devel>
>> Date: 2013-01-04 23:50:40 GMT (2 weeks, 8 hours and 47 minutes ago)
>>
>> I've (finally!) got a bcache branch hacked up that ought to be suitable
>> to go upstream, possibly in staging initially.
>>
>> It's currently closer to the dev branch than the stable branch, plus
>> some additional minor changes to make it all more self contained. The
>> code has seen a decent amount of testing and I think it's in good shape,
>> but I'd like it if it could see a bit more testing before I see about
>> pushing it upstream.
>>
>> If anyone wants to try it out, checkout the bcache-for-staging branch.
>> It's against Linux 3.7.
>
>
> Hi Kent,
>
> Just wondering if you maintain a patch for this vs kernel 3.7.x?
>
> I build EL6 RPMs for use as a Xen Dom0 and I'd like to include bcache in
> them for testing....
>
> --
> Steven Haigh
>
> Email: netwiz-tY1ak9Q0PTWHXe+LvDLADg@public.gmane.org
> Web: http://www.crc.id.au
> Phone: (03) 9001 6090 - 0412 935 897
> Fax: (03) 8338 0299
>
>
