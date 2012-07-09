From: Jason Warr <jason-/cow75dQlsI@public.gmane.org>
Subject: Re: bcache & kernel branch that will build together
Date: Mon, 09 Jul 2012 16:48:43 -0500
Message-ID: <4FFB51BB.7050905@warr.net>
References: <CAOzFzEh8pO37dVWoMoD+hFoUGrBoubSdktdu7SQS0UcXLcC66w@mail.gmail.com> <20120709155734.GA23774@google.com> <CAOzFzEjovYu4eE9E_asOBVyBhqFuvhgzJ7UFyESLY0XycAfkuA@mail.gmail.com> <20120709170742.GA26798@google.com> <4FFB1DD4.7030304@warr.net> <20120709184149.GA3234@google.com> <CAC7rs0vkasCKYwBTrvhWg8pzvHuix1ZaBJxTLBW+5AVG_31hEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAC7rs0vkasCKYwBTrvhWg8pzvHuix1ZaBJxTLBW+5AVG_31hEQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Excellent.  That builds fine for me against 3.5rc6.

Much appreciated.

Now to see if I can get the Fedora "patched" source to build and boot.

On 07/09/2012 03:16 PM, Kent Overstreet wrote:
> Ok, I think I got them all fixed - the code that's up now should build for you.
>
> On Mon, Jul 9, 2012 at 11:41 AM, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>> On Mon, Jul 09, 2012 at 01:07:16PM -0500, Jason Warr wrote:
>>> Dumb question coming from someone who is more of an admin than a
>>> developer.  Although I did build and run a dev lab at Sun in the
>>> early days of Solaris Nevada.
>>>
>>> What kernel source version or branch will your current git tree patch to and compile with?
>>>
>>> I have tried everything from 3.5rc1 to Linus's current git tree.  It
>>> breaks DRBD.  Once I disable DRBD in the config it fails at
>>> target_core_iblock.c.  So I never get a full build.
>>>
>>> So either I am doing something obviously wrong or ???
>>
>> Bah, sounds like I didn't test my code when I rebased to 3.5. Lazy me.
>>
>> For the moment, if you're not actually using drbd or iscsi you could
>> just disable both of those in the config. Assuming I didn't break dm and
>> md too. heh.
>>
>>>
>>> I'd love to test this out and help with debugging.  I have plenty of
>>> hardware and interest in it working well.  I can even provide you
>>> access to debug when I hit an issue.
>>
>> Cool!
>>
>>> What error output can I provide and can you point me to good trees?
>>
>> You could send me your .config in case it turns out to be something
>> specific to your specific config. Ought to be something simple, though.
>>
>>> I appreciate it and I am glad to see that someone is finally making
>>> the effort to get a real, working block cache object into the
>>> kernel.  I will help in any way I can.
>>
>> Thanks :)
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
