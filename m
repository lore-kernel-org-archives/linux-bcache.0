From: Coly Li <i@coly.li>
Subject: Re: [PATCHv3] bcache: only permit to recovery read error when cache
 device is clean
Date: Tue, 17 Oct 2017 02:07:25 +0800
Message-ID: <dcb97d02-c9cf-5de9-1821-cba6ab747949@coly.li>
References: <20170921195458.53890-1-colyli@suse.de>
 <CAJ+L6qdqn1i=UFJcaO+xQzgZj_o5RNm71XhnSznrtMqt0P5Tew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CAJ+L6qdqn1i=UFJcaO+xQzgZj_o5RNm71XhnSznrtMqt0P5Tew@mail.gmail.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 2017/10/17 上午1:39, Michael Lyle wrote:
> Hey Coly--
> 
> On Thu, Sep 21, 2017 at 12:54 PM, Coly Li <colyli@suse.de> wrote:
>> When bcache does read I/Os, for example in writeback or writethrough mode,
>> if a read request on cache device is failed, bcache will try to recovery
>> the request by reading from cached device. If the data on cached device is
>> not synced with cache device, then requester will get a stale data.
> [...]
>> +       if (s->recoverable &&
>> +           (dc && !atomic_read(&dc->has_dirty)) {
> 
> Looks like this is missing a parens.

Hi Mike,

Oops, I am blind ... Thanks for figure out this.

V4 patch is out, and I think you may change Acked-by to Reviewed-by,
because you reviewed the code and pointed out problem :-)

Thanks.

-- 
Coly Li
