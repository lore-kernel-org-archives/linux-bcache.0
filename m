From: Eddie Chapman <eddie@ehuk.net>
Subject: Re: [PATCH] bcache: recover data from backing device when read
 request hit clean
Date: Fri, 17 Nov 2017 13:43:33 +0000
Message-ID: <6b1f4824-cefb-480e-dc85-9058bce25db9@ehuk.net>
References: <CAPGwLLNwG+kLT9_QaCL5PBLS0a6K-x-iog+ON2pArUQWr1rWTg@mail.gmail.com>
 <dc6f513b-cca3-a37d-3379-2e12df21e825@suse.de>
 <CAPGwLLPmUiz-6xjur5jPAn1QLvkJY23QcsPCNvK+4+BVubWYnw@mail.gmail.com>
 <D393CD04-8C7A-4A8C-B23A-6C68D5544E34@profihost.ag>
 <CAPGwLLNTwZ1WrRVqwaLK5h8Ovj5SN5-Y-2qja843hwx2kJCAUQ@mail.gmail.com>
 <54dbc609-b448-68f6-bd9a-676fd5d21151@ehuk.net>
 <dc4a100c-e1c0-ff9b-4a13-a90faf8a9d06@suse.de>
Reply-To: Eddie Chapman <eddie@ehuk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <dc4a100c-e1c0-ff9b-4a13-a90faf8a9d06@suse.de>
Content-Language: en-GB
Sender: linux-block-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: Rui Hua <huarui.dev@gmail.com>, Stefan Priebe - Profihost AG <s.priebe@profihost.ag>, Coly Li <i@coly.li>, Michael Lyle <mlyle@lyle.org>, Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 17/11/17 13:22, Coly Li wrote:
> On 17/11/2017 8:57 PM, Eddie Chapman wrote:
>> On 17/11/17 10:20, Rui Hua wrote:
>>> Hi, Stefan
>>>
>>> 2017-11-17 16:28 GMT+08:00 Stefan Priebe - Profihost AG
>>> <s.priebe@profihost.ag>:
>>>> I‘m getting the same xfs error message under high load. Does this
>>>> patch fix
>>>> it?
>>>>
>>> Did you applied the patch "bcache: only permit to recovery read error
>>> when cache device is clean" ?
>>> If you did, maybe this patch can fix it. And you'd better check
>>> /sys/fs/bcache/XXX/internal/cache_read_races in your environment,
>>> meanwhile, it should not be zero when you get that err message.
>>
>> Hi all,
>>
>> I have 3 servers running a very recent 4.9 stable release, with several
>> recent bcache patches cherry picked, including V4 of "bcache: only
>> permit to recovery read error when cache device is clean".
>>
>> In the 3 weeks since using these cherry picks I've experienced a very
>> small number of isolated read errors in the layer above bcache, on all 3
>> servers.
>>
>> On one of the servers, 2 out of the 6 bcache resources have a value of 1
>> in /sys/fs/bcache/XXX/internal/cache_read_races, and it is on these same
>> 2 bcache resources where one read error has occurred on the upper layer.
>> The other 4 bcache resources have 0 in cache_read_races and I haven't
>> had any read errors on the layers above them.
>>
>> On another server, I have 1 bcache resource out of 10 with a value of 5
>> in /sys/fs/bcache/XXX/internal/cache_read_races, and it is on that
>> bcache resource where a read error occurred on one occasion. The other 9
>> bcache resources have 0 in cache_read_races, and no read errors have
>> occurred on the layers above any of them.
>>
>> On the 3rd server where some read errors occurred, I cannot verify if
>> there were positive values in cache_read_races as I moved the data from
>> there onto other storage, and shut down the bcache resources where the
>> errors occurred.
>>
>> If I can provide any other info which might help with this issue, please
>> let me know.
> 
> Hi Eddie,
> 
> This is very informative, thank you so much :-)
> 
> Coly Li

Hi Coly,

You are most welcome. Another interesting info, but maybe it is 
unrelated/coincidence: the bcache resources where the errors occurred, 
the underlying backing device was a raid adapter that is quite a lot 
slower than the (different) underlying physical storage on the other 
bcache resources that do not have read races. Up to now I had suspected 
a driver issue with this raid adapter as causing the read errors, so I 
started the process of gradually retiring the adapter on these servers 
in the last 3 weeks. Anyway, in light of this issue coming up here I'm 
wondering if this is significant in suggesting possibly that the read 
races are more likely to occur if the backing storage is quite slow. Or 
maybe not.

Eddie
