From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/4] Export blk_fill_rwbs()
Date: Fri, 1 Feb 2013 11:57:30 +0800
Message-ID: <510B3D2A.3040007@huawei.com>
References: <1358285142-10576-1-git-send-email-koverstreet@google.com>  <1358285142-10576-3-git-send-email-koverstreet@google.com> <1359690521.5642.10.camel@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1359690521.5642.10.camel-f9ZlEuEWxVcJvu8Pb33WZ0EMvNT87kid@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

on 2013/2/1 11:48, Steven Rostedt wrote:
> Li,
> 
> Can you give an Ack or Nack for this.
> 

I think this patch shouldn't go into upstream without bcache code. We don't
export symbols for out of tree code.

> Thanks,
> 
> -- Steve
> 
> 
> On Tue, 2013-01-15 at 13:25 -0800, Kent Overstreet wrote:
>> Exported so it can be used by bcache's tracepoints
>>
>> Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> CC: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
>> CC: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> CC: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>  kernel/trace/blktrace.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
>> index c0bd030..dbe1667 100644
>> --- a/kernel/trace/blktrace.c
>> +++ b/kernel/trace/blktrace.c
>> @@ -1806,6 +1806,7 @@ void blk_fill_rwbs(char *rwbs, u32 rw, int bytes)
>>  
>>  	rwbs[i] = '\0';
>>  }
>> +EXPORT_SYMBOL_GPL(blk_fill_rwbs);
>>  
>>  #endif /* CONFIG_EVENT_TRACING */
>>  
> 
> 
> 
