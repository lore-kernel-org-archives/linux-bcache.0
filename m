From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [RFC] bcache: fix a circular dead locking with dc->writeback_lock
 and bch_register_lock
Date: Sun, 19 Nov 2017 11:59:29 -0800
Message-ID: <1c0eeb2d-7c7a-466f-370c-89f8ae5c3c92@lyle.org>
References: <20171118081415.49669-1-colyli@suse.de>
 <a64160cc-f008-3732-4c95-818368614cbb@lyle.org>
 <136f0ccd-0bdb-c4a2-9b42-d76c6361ac26@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <136f0ccd-0bdb-c4a2-9b42-d76c6361ac26@suse.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 11/18/2017 09:32 AM, Coly Li wrote:
> On 19/11/2017 1:01 AM, Michael Lyle wrote:
>> Coly--
>>
>> It's a real circular lock dep between registration (a very rare
>> operation) and writeback rate calculation (a fairly rare operation).
>> While it's definitely a real issue, it's a very unlikely one to be
>> actually encountered.
>>
>> (Encountering it requires the every-5-second periodic task of
>> calculating writeback to be running, between writeback lock and register
>> lock [a pretty short window], and then for the user to register a new
>> cached volume)
>>
> 
> Hi Mike,
> 
> Thanks for response. It seems I can almost 100% reproduce this lockdep
> warning on my simple test environment. Just compiling mainline kernel
> with locking debug enabled, then attach a backing device to a cache
> device, and use fio to write around 30G 4KB blocksize data on bcache
> device. This is why this warning grabs my eyes.
> 
> From the lockdep warning it seems this should be very rare to happen,
> but I don't know why it happens almost every time in my testing...

Coly--

Do you get an actual deadlock here, or just a lockdep warning?  The
lockdep warning just lets you know that locks were acquired in different
orders and that an issue is possible.  I'd expect a lockdep warning
every time, but almost never an actual deadlock.

> [snip] 
> Another warning is the nested locking in btree levels, so far I don't
> have no idea what happens here yet ....

I am guessing there is a missing free of a lock-- which only creates
problems with lockdep on but we should fix it.

Mike
