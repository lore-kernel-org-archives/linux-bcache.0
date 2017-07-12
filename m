From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] bcache: only recovery I/O error for writethrough mode
Date: Wed, 12 Jul 2017 11:20:23 +0800
Message-ID: <be0287d1-9af2-659c-0d40-5fb774e3b178@suse.de>
References: <20170710111828.97918-1-colyli@suse.de>
 <OFCB2AA6A0.E15FCC3D-ON4825815B.0001EEF5-4825815B.00033093@zte.com.cn>
 <eb85fc2b-91d9-0344-829c-972803572ac1@suse.de>
 <OFAAA836F5.65C1F846-ON4825815B.00093270-4825815B.0009741B@zte.com.cn>
 <45926957-5990-6520-7bd7-6de8c2bae7b8@suse.de>
 <OF7159B9D9.1C66A3AE-ON4825815B.000AD084-4825815B.000B252E@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <OF7159B9D9.1C66A3AE-ON4825815B.000AD084-4825815B.000B252E@zte.com.cn>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: linux-bcache@vger.kernel.org, linux-bcache-owner@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 2017/7/12 上午10:01, tang.junhui@zte.com.cn wrote:
>>I meant "it is very necessary for data base applications which always
>>use *writeback* mode and not switch to other mode during all their
>>online time."  ^_^
> 
> I know, it is necessary, but not enough. who can promise they will not
> switch during online time? This patch is logical imperfectly.

Yes, I agree with you. Since Eric mentions dirty data map, an improved
fix shows up in my head,

When cache device disconnected from system,
0) If in non mode, do nothing.
1) If in writeback/writethough/writearound mode, and dirty map is clean,
   - switch to non mode
   - continue to handle I/O without cache device
2) If in writeback mode, and dirty map is not clean,
   - return -EIO immediately for WRITE request
   - return -EIO immediately for READ request (*)
3) If not in writeback mode, and dirty map is not clean. It means the
cache mode is switched from writeback mode with dirty data lost, then
   - returns -EIO immediately for WRITE request
   - returns -EIO immediately for READ request (*)

(*) NOTE:
A sysfs entry "recovery_io_error" can be add here, which is disabled as
default. If it is enabled, if a READ request does not hit dirty map,
bcache will provide it from backing device.

By the above method, if no dirty data lost and cache device
disconnected, bcache steps back to non mode. If we have dirty data lost,
always returns -EIO to notify application to handle the failure as soon
as possible. And there will be a little more failure tolerance if
"recovery_io_error" is enabled.

Eric, Junhui,

How do you think about the above idea ? Thanks in advance for your comments.

Coly
