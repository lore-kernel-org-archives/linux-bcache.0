From: Jonathan Tripathy <jonnyt-Nf8S+5hNwl710XsdtD+oqA@public.gmane.org>
Subject: Re: Block Size for Windows
Date: Wed, 29 Aug 2012 18:42:43 +0100
Message-ID: <503E5493.5090903@abpni.co.uk>
References: <503BD1E8.7060402@abpni.co.uk> <503BD37C.9010403@abpni.co.uk> <503BD55D.2060408@abpni.co.uk> <CAOzFzEi6AzHFJVUGGc+J2p7QYe2f2i_XKrpad8wHDXo2xO=buA@mail.gmail.com> <503BEE7F.4020202@abpni.co.uk> <CAOzFzEg7v6U6sTYjTsGDzPE_yGRp-WULzngAn-1TCygp2jo76w@mail.gmail.com> <CAH+dOxLnh34vQ+56JUfKtA2PyA1cyeDZvfBdWvSUhZC_pV2YMQ@mail.gmail.com> <CAH+dOxJYNE=UiKX-GaCUmhWOgoHqkGrBnF=sOc7mXDUoFKu36Q@mail.gmail.com> <a3453cb279f786534858d1d410d880f5@abpni.co.uk> <503E4FD6.20106@abpni.co.uk> <20120829173459.GB3893@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120829173459.GB3893-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 29/08/2012 18:34, Kent Overstreet wrote:
> On Wed, Aug 29, 2012 at 06:22:30PM +0100, Jonathan Tripathy wrote:
>> On 29/08/2012 13:12, Jonathan Tripathy wrote:
>>> On 29.08.2012 08:03, Kent Overstreet wrote:
>>>> I just went ahead and backed out the problematic change. Haven't even
>>>> tried building the code yet - but if you feel lucky, it's up. I bet it
>>>> fixes it.
>>> Hi Kent,
>>>
>>> I pull down your latest code and did a build. I'm pleased to say
>>> that Windows has now installed. I will do some further
>>> testing/benchmarking to make sure that the install is stable.
>>>
>>> Many thanks for your quick help
>> Hi Kent,
>>
>> A little bad news. With this new build, the spindles are getting
>> thrashed and this is constantly (never stopping) spewing out on my
>> netconsole:
>>
>> [23198.979215] md/raid10:md7: make_request bug: can't convert block
>> across chunks or bigger than 512k 67230714 4
>> [23198.979304] md/raid10:md7: make_request bug: can't convert block
>> across chunks or bigger than 512k 67234814 4
>> [23198.979393] md/raid10:md7: make_request bug: can't convert block
>> across chunks or bigger than 512k 67235834 4
>> [23198.979595] md/raid10:md7: make_request bug: can't convert block
>> across chunks or bigger than 512k 67276796 3
>> [23198.979696] md/raid10:md7: make_request bug: can't convert block
>> across chunks or bigger than 512k 67297276 4
>> [23198.979791] md/raid10:md7: make_request bug: can't convert block
>> across chunks or bigger than 512k 67248126 4
>> [23198.979886] md/raid10:md7: make_request bug: can't convert block
>> across chunks or bigger than 512k 67284987 3
>> [23198.979966] md/raid10:md7: make_request bug: can't convert block
>> across chunks or bigger than 512k 67305471 4
>> [23198.980215] md/raid10:md7: make_request bug: can't convert block
>> across chunks or bigger than 512k 67329017 4
>> [23198.980337] md/raid10:md7: make_request bug: can't convert block
>> across chunks or bigger than 512k 67323899 4
>> [23198.980542] md/raid10:md7: make_request bug: can't convert block
>> across chunks or bigger than 512k 67330047 2
>> [23198.981707] md/raid10:md7: make_request bug: can't convert block
>> across chunks or bigger than 512k 67335164 3
>> [23198.982164] md/raid10:md7: make_request bug: can't convert block
>> across chunks or bigger than 512k 67346429 4
>>
>> Any ideas?
> Oh hell, I see the problem. That one is not going to be such an easy
> fix. I'm going to have to think about it.
>
> Amusing part is it looks like blocksize = 4k was working around the
> problem... :/
Ah, ok :)

Please keep me posted when this is fixed, I'm very keen to see bcache 
deployed in our cloud infrastructure :)

If there is anything I can do to help from a testing standpoint, please 
let me know.

Cheers
