From: Jonathan Tripathy <jonnyt-Nf8S+5hNwl710XsdtD+oqA@public.gmane.org>
Subject: Re: Block Size for Windows
Date: Thu, 30 Aug 2012 03:10:22 +0100
Message-ID: <503ECB8E.1080909@abpni.co.uk>
References: <503BC71A.6050207@abpni.co.uk> <CAH+dOxJ1GPQgmgDv4T3On-QovazSshU89GdVp=EHFmpaAzAGnQ@mail.gmail.com> <503BC82F.1030107@abpni.co.uk> <CAH+dOxJZEH9=ZEsB4RsS-8MdH-AGRh3jvo31bMUwXsMdirLMMQ@mail.gmail.com> <503BC897.3020606@abpni.co.uk> <CAH+dOxKx=kaW4duTyhRYrFH-5mYDUT6CGgY7WX9vqsMD_CpJaQ@mail.gmail.com> <503BCDC6.9010807@abpni.co.uk> <503BD1E8.7060402@abpni.co.uk> <503BD37C.9010403@abpni.co.uk> <503BD55D.2060408@abpni.co.uk> <CAOzFzEi6AzHFJVUGGc+J2p7QYe2f2i_XKrpad8wHDXo2xO=buA@mail.gmail.com> <503BEE7F.4020202@abpni.co.uk> <CAOzFzEg7v6U6sTYjTsGDzPE_yGRp-WULzngAn-1TCygp2jo76w@mail.gmail.com> <CAH+dOxLnh34vQ+56JUfKtA2PyA1cyeDZvfBdWvSUhZC_pV2YMQ@mail.gmail.com> <CAH+dOxJYNE=UiKX-GaCUmhWOgoHqkGrBnF=sOc7mXDUoFKu36Q@mail.gmail.com> <a3453cb279f786534858d1d410d880f5@abpni.co.uk> <503E4FD6.
 20106@abpni.co.uk> <503EC946.3050500@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <503EC946.3050500-+nnirC7rrGZibQn6LdNjmg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Brad Campbell <brad-+nnirC7rrGZibQn6LdNjmg@public.gmane.org>
Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 30/08/2012 03:00, Brad Campbell wrote:
> On 30/08/12 01:22, Jonathan Tripathy wrote:
>> On 29/08/2012 13:12, Jonathan Tripathy wrote:
>>>
>>> On 29.08.2012 08:03, Kent Overstreet wrote:
>>>> I just went ahead and backed out the problematic change. Haven't even
>>>> tried building the code yet - but if you feel lucky, it's up. I bet it
>>>> fixes it.
>>>
>>> Hi Kent,
>>>
>>> I pull down your latest code and did a build. I'm pleased to say that
>>> Windows has now installed. I will do some further testing/benchmarking
>>> to make sure that the install is stable.
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
>
> Looks like the same problem I reported in April.
>
Hi There,

I've built the latest head from the bcache-3.2 branch and now all seems 
fine. I currently have an IOMeter test that has been running for about 
90 minutes with an IO depth of 256 with 30 workers (a very heavy load) 
and so far not a single error in netconsole....

Cheers
