From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH v4 1/3] lib: add crc64 calculation routines
Date: Thu, 26 Jul 2018 11:28:45 +0800
Message-ID: <ad442c01-8fd7-12ac-3b8d-bfab738c7bde@suse.de>
References: <20180718165545.1622-1-colyli@suse.de>
 <20180718165545.1622-2-colyli@suse.de>
 <20180724042637.GA1944@sol.localdomain>
 <dd95ab25-562e-1318-19e9-c8163969252f@suse.de>
 <399c1cc851f983370a0308c76c68a97ff41a5d4f.camel@linux.intel.com>
 <01f8e352-a49f-2f41-6264-bb6395bb0bf2@suse.de>
 <20180725142246.23e354fcc21ef041bb3f87e6@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180725142246.23e354fcc21ef041bb3f87e6@linux-foundation.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Eric Biggers <ebiggers3@gmail.com>, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Michael Lyle <mlyle@lyle.org>, Kent Overstreet <kent.overstreet@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Kate Stewart <kstewart@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>
List-Id: linux-bcache@vger.kernel.org

On 2018/7/26 5:22 AM, Andrew Morton wrote:
> On Wed, 25 Jul 2018 10:37:23 +0800 Coly Li <colyli@suse.de> wrote:
> 
>>> IIUC this series in Andrew's quilt. So, it's still possible to replace
>>> it with better one, I suppose. Ask Andrew (at least I remember recent
>>> case where he just replaced series by fixed one).
>>
>> Hi Andrew,
>>
>> It seems there should be some fix/update for this series. I see current
>> series is in linux-next for now. If I want to add the fix, should I post
>> a new version of the series, or the incremental patches to fix current
>> series ?
> 
> mm...  it sounds like the changes will be large, so probably a new
> series would be better at this early stage.  If the changes are small
> then little fixup patches would be nicer to the people who have already
> reviewed v1.
> 

Yes, it is large (patch 3/3 will be removed). So I will post a new
series to replace current series.

Thanks for the hint.

Coly Li
