From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH 0/4] add crc64 calculation as kernel library
Date: Tue, 17 Jul 2018 22:20:07 +0800
Message-ID: <a2da98a9-65bb-e483-dbf3-410b5d682c11@suse.de>
References: <20180716165507.23100-1-colyli@suse.de>
 <8538b45b-bf30-926a-50fb-700b4bf1c636@suse.de>
 <608100d7-6e98-13ec-57ab-5c672131e332@suse.de>
 <b85806d5a6085f67fb430ca0808b286d0d4d737e.camel@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <b85806d5a6085f67fb430ca0808b286d0d4d737e.camel@linux.intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Hannes Reinecke <hare@suse.de>, linux-kernel@vger.kernel.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Luis R . Rodriguez" <mcgrof@suse.com>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Michael Lyle <mlyle@lyle.org>, Kent Overstreet <kent.overstreet@gmail.com>, Kate Stewart <kstewart@linuxfoundation.org>
List-Id: linux-bcache@vger.kernel.org

On 2018/7/17 4:37 PM, Andy Shevchenko wrote:
> On Tue, 2018-07-17 at 14:19 +0800, Coly Li wrote:
>> On 2018/7/17 1:46 PM, Hannes Reinecke wrote:
> 
>>> Actually, I would merge patch 1 & 2 together (pointless to introduce
>>> an
>>> option for which no code exists).
>>
> 
> I was just about to say the same.
> 
>> The patch 1 was originally from Andy Shevchenko, and I want to keep
>> his
>> contribute. If it seems not a good idea from me, I will merge them
>> into
>> 1 patch in v2 series.
> 
> We have Co-developed-by tag, for example, which you may use here (if you
> choose this way, leave my SoB as well).
> 
Thanks for the hint. I add a Co-developed-by tag for you :-)

Coly Li
