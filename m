From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH v4 3/3] lib/test_crc: Add test cases for crc calculation
Date: Wed, 25 Jul 2018 12:07:57 +0800
Message-ID: <fa19dc99-30de-98e5-eea2-804ad0466e34@suse.de>
References: <20180718165545.1622-1-colyli@suse.de>
 <20180718165545.1622-4-colyli@suse.de>
 <20180724044420.GB1944@sol.localdomain>
 <2feeece1-6d92-aa08-c9b6-1b0c646eed29@suse.de>
 <20180724173930.GA194165@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180724173930.GA194165@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Kate Stewart <kstewart@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, Randy Dunlap <rdunlap@infradead.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Noah Massey <noah.massey@gmail.com>
List-Id: linux-bcache@vger.kernel.org

On 2018/7/25 1:39 AM, Eric Biggers wrote:
> On Wed, Jul 25, 2018 at 12:28:15AM +0800, Coly Li wrote:
>> On 2018/7/24 12:44 PM, Eric Biggers wrote:
>>> On Thu, Jul 19, 2018 at 12:55:45AM +0800, Coly Li wrote:
>>>> This patch adds a kernel module to test the consistency of multiple crc
>>>> calculation in Linux kernel. It is enabled with CONFIG_TEST_CRC enabled.
>>>>
>>>> The test results are printed into kernel message, which look like,
>>>>
>>>> test_crc: crc64_be: FAILED (0x03d4d0d85685d9a1, expected 0x3d4d0d85685d9a1f)
>>>>
>>>> kernel 0day system has framework to check kernel message, then the above
>>>> result can be handled by 0day system. If crc calculation inconsistency
>>>> happens, it can be detected quite soon.
>>>>
>>>> lib/test_crc.c is a testing frame work for many crc consistency
>>>> testings. For now, there is only one test caes for crc64_be().
>>>
>>> Are you aware there's already a CRC-32 test module: CONFIG_CRC32_SELFTEST and
>>> lib/crc32test.c?  Confusingly, your patch uses a different naming convention for
>>> the new CRC-64 one, and puts the Kconfig option in a different place, and makes
>>> it sound like it's a generic test for all CRC implementations rather than just
>>> the CRC-64 one.  Please use the existing convention (i.e. add
>>> CONFIG_CRC64_SELFTEST and lib/crc64test.c) unless you have a strong argument for
>>> why it should be done differently.
>>>
>>> (And I don't think it makes sense to combine all CRC tests into one module,
>>> since you should be able to e.g. enable just CRC32 and CRC32_SELFTEST without
>>> also pulling in a dependency on all the other CRC variants.)
>>>
>>
>> Hi Eric,
>>
>> The purpose of test_crc is to provide a unified crc calculation
>> consistency testing for 0day. So far it is only crc64, and I will add
>> more test cases later. I see there is crc-32 test module, which does
>> more testing then consistency check, and no unified format for 0day
>> system to detect. This is why people suggested me to add this test
>> framework.
>>
> 
> Actually the code in crc32test is nearly the same as what you're adding for
> CRC-64.  The CRC-32 test is longer because it's testing two different
> polynomials "crc32" and "crc32c" as well as combining CRC's; neither of those is
> relevant for CRC-64 yet, as you've implemented just one polynomial and there is
> no function provided to combine CRC64's yet.  The CRC-32 test also tests
> performance, but if you don't believe CRC performance should be tested, then you
> should remove the performance test from the existing module rather than
> implementing a brand new test module just to remove the performance test...
> 
> I still don't understand why you decided to do things differently for CRC-64,
> when there were already CRC-32 tests that used a certain convention for the
> Kconfig option, filename, etc.  It's inconsistent and confusing.  Again, please
> use the existing convention unless you have a strong argument for why it should
> be done differently.  (And if you do want to do things differently, the existing
> test should be converted first.)

Hi Eric,

So far only crc32 has selftesting code, it is hardly to be a convention
IMHO. Anyway, considerate your comments and suggestion, I feel crc_test
can be a separate patch from this series.

Later I will post another series, which unify all crc test together into
test_crc, including other crc calculations which don't have their
testing code.

Thanks.

Coly Li
