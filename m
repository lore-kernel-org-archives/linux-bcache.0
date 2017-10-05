From: Coly Li <i@coly.li>
Subject: Re: [PATCH 4/5] bcache: writeback: collapse contiguous IO better
Date: Fri, 6 Oct 2017 02:07:36 +0800
Message-ID: <3ba261da-060d-4f80-fe92-c6ef91b7dc43@coly.li>
References: <1506497553-12552-1-git-send-email-tang.junhui@zte.com.cn>
 <3dfc3f12-b616-debd-8913-6049f215f2f3@coly.li>
 <CAJ+L6qf_zG37s4nGhxTbNvsdvDr5fwbmYocwP5m4rkjMLQKjtg@mail.gmail.com>
 <CAJ+L6qe9XjPOw=6NpWzZhw-PLC5EXhstOrPaapbqvDcD0+_7QA@mail.gmail.com>
 <CAJ+L6qcU+Db5TP1Q2J-V8angdzeW9DFGwc7KQqc4di9CSxusLg@mail.gmail.com>
 <CAJ+L6qdu4OSRh7Qdkk-5XBgd4W_N29Y6-wVLf-jFAMKEhQrTbQ@mail.gmail.com>
 <CAJ+L6qcyq-E4MrWNfB9kGA8DMD_U1HMxJii-=-qPfv0LeRL45w@mail.gmail.com>
 <CAJ+L6qdc8YqO5B3Cv0h4QQ+4P06FbtsT10Jqt5=Fx8iRh1UGwQ@mail.gmail.com>
 <96f34768-2b02-7849-c034-e1bb83b0fa0d@coly.li>
 <CAJ+L6qdTB6DyhD8UwHaVtN-THXwanBXrQK3EvmvLhuoXgYyzrA@mail.gmail.com>
 <05c1aa86-5fc8-f330-5cd1-46f9ba7cd3e0@coly.li>
 <CAJ+L6qfTDkgrLEUSRX2Pv2qvB7Ns=Hb3nBVz0SDoDn_m9RC8hg@mail.gmail.com>
 <2c39cd9c-34bd-5982-9fd7-ceb61305c13d@coly.li>
 <CAJ+L6qe7C=FyPFya8y0HV8SCc7VSEEuUApcqEUnouVDUByfZ5w@mail.gmail.com>
 <6a2052da-6b52-9c06-b85e-e3ea29e3f8e8@coly.li>
 <CAJ+L6qdqQn4tpFdkPZ-zhxss9O8axBEarMBJA5X6f9i+K8SLGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CAJ+L6qdqQn4tpFdkPZ-zhxss9O8axBEarMBJA5X6f9i+K8SLGg@mail.gmail.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: Junhui Tang <tang.junhui@zte.com.cn>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>
List-Id: linux-bcache@vger.kernel.org

On 2017/10/6 上午1:53, Michael Lyle wrote:
> On Thu, Oct 5, 2017 at 10:38 AM, Coly Li <i@coly.li> wrote:
>> [snip]
>>   In this test, without bio reorder patches, writeback throughput is
>> much faster, you may see the write request number and request merge
>> number are also much faster then bio reorder patches. After around 10
>> minutes later, there is no obvious performance difference with/without
>> the bio reorder patches. Therefore in this test, with bio reorder
>> patches, I observe a worse writeback performance result.
>>
>> The above tests tell me, to get a better writeback performance with bio
>> reorder patches, a specific situation is required (many contiguous dirty
>> data on cache device), this situation can only happen in some specific
>> of work loads. In general writeback situations, reordering bios by
>> waiting does not have significant performance advantage, and even
>> performance regression is observed.
> 
> I mean, did you not notice that one of the changes is to limit the
> amount of write-issue-merge from the current behavior?  It's not
> exactly surprising that the initial/peak rate is a bit lower
> initially...
> 
> Your test methodology is flawed-- I tried telling you this from the
> beginning-- and I'm not convinced at all you understand the point of
> the patches.  But hey, there's not really any other reviewers on
> bcache stuff, so I guess my stuff is blocked forever. ;)

Patch 1,2,3 are in my for-next directory and continue for more testing.

The new PI controller is simpler and easier to understand with your
comprehensive commit log and code comments, and works as expected as a
flow controller. We should have it in 4.15, and I will try to make it.

Thank you for the great job :-)

-- 
Coly Li
