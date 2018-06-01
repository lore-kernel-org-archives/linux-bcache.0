From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH v2 19/21] bcache: use match_string() helper
Date: Fri, 1 Jun 2018 13:04:52 +0800
Message-ID: <160f89c8-e14f-4c68-571c-71df7a5e445e@suse.de>
References: <1527765086-19873-1-git-send-email-xieyisheng1@huawei.com>
 <1527765086-19873-20-git-send-email-xieyisheng1@huawei.com>
 <f8dea584-a7b1-a894-d4b6-d573fdb4da3d@suse.de>
 <36b9f53d-66bd-076e-7c2e-045ca2fd4406@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <36b9f53d-66bd-076e-7c2e-045ca2fd4406@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Yisheng Xie <xieyisheng1@huawei.com>, linux-kernel@vger.kernel.org
Cc: andy.shevchenko@gmail.com, Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 2018/6/1 12:32 PM, Yisheng Xie wrote:
> Hi Coly,
> 
> On 2018/6/1 11:45, Coly Li wrote:
>> On 2018/5/31 7:11 PM, Yisheng Xie wrote:
>>> match_string() returns the index of an array for a matching string,
>>> which can be used instead of open coded variant.
>>>
>>> Cc: Kent Overstreet <kent.overstreet@gmail.com>
>>> Cc: linux-bcache@vger.kernel.org 
>>> Signed-off-by: Yisheng Xie <xieyisheng1@huawei.com>
>>
>> Hi Yishenng,
>>
>> Andy Shevchenko <andriy.shevchenko@linux.intel.com> submitted a patch to
>> replace the whole bch_read_string_list() with __sysfs_match_string().
>> And this patch is applied in Jens' block tree, will go into mainline
>> kernel in v4.18.
>>
>> If you search bcache mailing list, you may find a patch named with
>> "bcache: Replace bch_read_string_list() by __sysfs_match_string()".
>>
>> That means this patch will conflict with existing changes.
> 
> Get it, and thanks for this information.
> 
> Sorry Andy, for doing this once more.
> 
Hi Yisheng,

Thank you for the effort, hope to see more bcache patches from you :-)

Coly Li
