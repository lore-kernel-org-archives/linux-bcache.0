From: Pony Cheng <ponycheng0@gmail.com>
Subject: Re: how to understand bcache
Date: Thu, 25 Jan 2018 09:54:37 +0800
Message-ID: <CAATtUKngr+iTUk4daERvbr0A5ryh3dgArhc7TGWJyBwbephBhg@mail.gmail.com>
References: <1516786455-29038-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1516786455-29038-1-git-send-email-tang.junhui@zte.com.cn>
Sender: linux-block-owner@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: colyli@suse.de, Michael Lyle <mlyle@lyle.org>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

OK, Thank you very much.

2018-01-24 17:34 GMT+08:00  <tang.junhui@zte.com.cn>:
> From: Tang Junhui <tang.junhui@zte.com.cn>
>
>> On 24/01/2018 10:34 AM, Pony Cheng wrote:
>> > Hi all,
>> >
>> > I'm beginner of kernel module, and I'm reading bcache codebase now.
>> > But I'm very confused about many details, such as b+tree and io path.
>> >
>> > So, what should I do now, do you have some advices?
>>
>> Hi Pony,
>>
>> Read the code, through out your questions. If the question is
>> easy/simple, you may have response.
>>
>> Coly Li
>
> It sounds interesting, hahahaha~~
>
> you'd better to known how the data organized in disk,
> and what is bkey, bset, btree node, and what erver else,
> and think about deeply: If I am the author, how would I write
> the code, and read the currently code, to find wether it written
> as your thought, judge about is it your wrong or the author, Then
> you understood bcache, and bcache also understood you.
>
> you also can ask our dear maintainer Mike, who knows all about bcache,
> but sometiomes he is very busy, It is normally you would hear nothing
> from him for one weeks or two, sometimes maybe three, but never five,
> since the merge window comes.
>
> Thanks,
> Tang Junhui
>
