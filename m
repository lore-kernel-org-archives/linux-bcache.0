From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] bcache: avoid clang -Wunintialized warning
Date: Fri, 26 Apr 2019 10:43:01 +0800
Message-ID: <44474338-8031-13eb-1e95-376c1036b611@suse.de>
References: <20190322143507.1256436-1-arnd@arndb.de>
 <20190425180853.GA4507@archlinux-i9>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190425180853.GA4507@archlinux-i9>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>, Arnd Bergmann <arnd@arndb.de>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, clang-built-linux@googlegroups.com, Nick Desaulniers <ndesaulniers@google.com>, Jens Axboe <axboe@kernel.dk>, Shenghui Wang <shhuiw@foxmail.com>, Hannes Reinecke <hare@suse.com>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 2019/4/26 2:08 上午, Nathan Chancellor wrote:
> On Fri, Mar 22, 2019 at 03:35:00PM +0100, Arnd Bergmann wrote:
>> clang has identified a code path in which it thinks a
>> variable may be unused:
>>
>> drivers/md/bcache/alloc.c:333:4: error: variable 'bucket' is used uninitialized whenever 'if' condition is false
>>       [-Werror,-Wsometimes-uninitialized]
>>                         fifo_pop(&ca->free_inc, bucket);
>>                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/md/bcache/util.h:219:27: note: expanded from macro 'fifo_pop'
>>  #define fifo_pop(fifo, i)       fifo_pop_front(fifo, (i))
>>                                 ^~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/md/bcache/util.h:189:6: note: expanded from macro 'fifo_pop_front'
>>         if (_r) {                                                       \
>>             ^~
>> drivers/md/bcache/alloc.c:343:46: note: uninitialized use occurs here
>>                         allocator_wait(ca, bch_allocator_push(ca, bucket));
>>                                                                   ^~~~~~
>> drivers/md/bcache/alloc.c:287:7: note: expanded from macro 'allocator_wait'
>>                 if (cond)                                               \
>>                     ^~~~
>> drivers/md/bcache/alloc.c:333:4: note: remove the 'if' if its condition is always true
>>                         fifo_pop(&ca->free_inc, bucket);
>>                         ^
>> drivers/md/bcache/util.h:219:27: note: expanded from macro 'fifo_pop'
>>  #define fifo_pop(fifo, i)       fifo_pop_front(fifo, (i))
>>                                 ^
>> drivers/md/bcache/util.h:189:2: note: expanded from macro 'fifo_pop_front'
>>         if (_r) {                                                       \
>>         ^
>> drivers/md/bcache/alloc.c:331:15: note: initialize the variable 'bucket' to silence this warning
>>                         long bucket;
>>                                    ^
>>
>> This cannot happen in practice because we only enter the loop
>> if there is at least one element in the list.
>>
>> Slightly rearranging the code makes this clearer to both the
>> reader and the compiler, which avoids the warning.
>>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> ---
>>  drivers/md/bcache/alloc.c | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
>> index 5002838ea476..f8986effcb50 100644
>> --- a/drivers/md/bcache/alloc.c
>> +++ b/drivers/md/bcache/alloc.c
>> @@ -327,10 +327,11 @@ static int bch_allocator_thread(void *arg)
>>  		 * possibly issue discards to them, then we add the bucket to
>>  		 * the free list:
>>  		 */
>> -		while (!fifo_empty(&ca->free_inc)) {
>> +		while (1) {
>>  			long bucket;
>>  
>> -			fifo_pop(&ca->free_inc, bucket);
>> +			if (!fifo_pop(&ca->free_inc, bucket))
>> +				break;
>>  
>>  			if (ca->discard) {
>>  				mutex_unlock(&ca->set->bucket_lock);
>> -- 
>> 2.20.0
>>
> 
> Hi all,
> 
> Could someone please review/pick this up? This is one of two remaining
> -Wsometimes-uninitialized warnings among arm, arm64, and x86_64
> all{yes,mod}config and I'd like to get it turned on as soon as possible
> to catch more bugs.

Hi Nathan,

It is in Jens' block tree for-next branch already, for Linux v5.2 merge
window.

Thanks.

-- 

Coly Li
