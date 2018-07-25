From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH v4 1/3] lib: add crc64 calculation routines
Date: Wed, 25 Jul 2018 10:37:23 +0800
Message-ID: <01f8e352-a49f-2f41-6264-bb6395bb0bf2@suse.de>
References: <20180718165545.1622-1-colyli@suse.de>
 <20180718165545.1622-2-colyli@suse.de>
 <20180724042637.GA1944@sol.localdomain>
 <dd95ab25-562e-1318-19e9-c8163969252f@suse.de>
 <399c1cc851f983370a0308c76c68a97ff41a5d4f.camel@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <399c1cc851f983370a0308c76c68a97ff41a5d4f.camel@linux.intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Eric Biggers <ebiggers3@gmail.com>, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Michael Lyle <mlyle@lyle.org>, Kent Overstreet <kent.overstreet@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Kate Stewart <kstewart@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>
List-Id: linux-bcache@vger.kernel.org

On 2018/7/25 1:06 AM, Andy Shevchenko wrote:
> On Wed, 2018-07-25 at 00:29 +0800, Coly Li wrote:
>> On 2018/7/24 12:26 PM, Eric Biggers wrote:
>>> On Thu, Jul 19, 2018 at 12:55:43AM +0800, Coly Li wrote:
>>>> This patch adds the re-write crc64 calculation routines for Linux
>>>> kernel.
>>>> The CRC64 polynomical arithmetic follows ECMA-182 specification,
>>>> inspired
>>>
>>> "polynomical" => "polynomial".  Same everywhere else in the patches.
>>>
>>
>> Hi Eric,
>>
>> Thanks for your careful review. I will post a fixing patch to fix all
>> these issues.
> 
> IIUC this series in Andrew's quilt. So, it's still possible to replace
> it with better one, I suppose. Ask Andrew (at least I remember recent
> case where he just replaced series by fixed one).

Hi Andrew,

It seems there should be some fix/update for this series. I see current
series is in linux-next for now. If I want to add the fix, should I post
a new version of the series, or the incremental patches to fix current
series ?

Thanks in advance for your advice.

Coly Li
