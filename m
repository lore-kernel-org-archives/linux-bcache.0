From: Liang Chen <liangchen.linux@gmail.com>
Subject: Re: [PATCH 06/19] bcache: explicitly destory mutex while exiting
Date: Wed, 5 Jul 2017 19:58:53 +0800
Message-ID: <CAKhg4tLAiRdujjhh+xUmCzaR9+bTpMgbwtht6TD_bs0zE_61rQ@mail.gmail.com>
References: <20170629134510.GA32385@infradead.org> <1498855388-16990-1-git-send-email-bcache@lists.ewheeler.net>
 <1498855388-16990-6-git-send-email-bcache@lists.ewheeler.net> <841d6190-61a6-7601-2a00-2404cf0c5a69@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <841d6190-61a6-7601-2a00-2404cf0c5a69@coly.li>
Sender: stable-owner@vger.kernel.org
To: Coly Li <i@coly.li>
Cc: bcache@lists.ewheeler.net, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, hch@infradead.org, axboe@kernel.dk, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

Hi Coly,
Thanks for reviewing the patch! You raised a good point about the race. I a=
lso
think it should be addressed. Even though the time window is small, it will
still happen sooner or later.

I would like to keep this "destory mutex" patch unchanged, and send another
patch to fix the issue based on your approach. Please take a look. Thanks!

Thanks,
Liang

On Sun, Jul 2, 2017 at 2:43 AM, Coly Li <i@coly.li> wrote:
> On 2017/7/1 =E4=B8=8A=E5=8D=884:42, bcache@lists.ewheeler.net wrote:
>> From: Liang Chen <liangchen.linux@gmail.com>
>>
>> mutex_destroy does nothing most of time, but it's better to call
>> it to make the code future proof and it also has some meaning
>> for like mutex debug.
>>
>> Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
>> Reviewed-by: Eric Wheeler <bcache@linux.ewheeler.net>
>> Cc: stable@vger.kernel.org
>> ---
>>  drivers/md/bcache/super.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
>> index 48b8c20..1f84791 100644
>> --- a/drivers/md/bcache/super.c
>> +++ b/drivers/md/bcache/super.c
>> @@ -2089,6 +2089,7 @@ static void bcache_exit(void)
>>       if (bcache_major)
>>               unregister_blkdev(bcache_major, "bcache");
>>       unregister_reboot_notifier(&reboot);
>> +     mutex_destroy(&bch_register_lock>  }
>>
>>  static int __init bcache_init(void)
>> @@ -2106,6 +2107,7 @@ static int __init bcache_init(void)
>>
>>       bcache_major =3D register_blkdev(0, "bcache");
>>       if (bcache_major < 0) {
>> +             mutex_destroy(&bch_register_lock);
>>               unregister_reboot_notifier(&reboot);
>>               return bcache_major;
>>       }
>>
>
> Hi Liang,
>
> Current code might have a potential race in a very corner case, see,
> 2084 static int __init bcache_init(void)
> 2085 {
> 2086         static const struct attribute *files[] =3D {
> 2087                 &ksysfs_register.attr,
> 2088                 &ksysfs_register_quiet.attr,
> 2089                 NULL
> 2090         };
> 2091
> 2092         mutex_init(&bch_register_lock);
> 2093         init_waitqueue_head(&unregister_wait);
> 2094         register_reboot_notifier(&reboot);
> 2095         closure_debug_init();
> 2096
> 2097         bcache_major =3D register_blkdev(0, "bcache");
> 2098         if (bcache_major < 0) {
> 2099                 unregister_reboot_notifier(&reboot);
> 2100                 return bcache_major;
> 2101         }
> 2102
> 2103         if (!(bcache_wq =3D alloc_workqueue("bcache", WQ_MEM_RECLAIM=
,
> 0)) ||
> 2104             !(bcache_kobj =3D kobject_create_and_add("bcache",
> fs_kobj)) ||
> 2105             sysfs_create_files(bcache_kobj, files) ||
> 2106             bch_request_init() ||
> 2107             bch_debug_init(bcache_kobj))
> 2108                 goto err;
> 2109
> 2110         return 0;
> 2111 err:
> 2112         bcache_exit();
> 2113         return -ENOMEM;
> 2114 }
>
> At line 2107, most of bache stuffs are ready to work, only a debugfs
> entry not created yet. If in the time gap between line 2106 and line
> 2017, another user space tool just registers cache and backing devices.
> Then bch_debug_init() failed, and bcache_exit() gets called. In this
> case, I doubt bcache_exit() can handle all the references correctly.
>
> The race is very rare, and almost won't happen in real life. So, if you
> don't care about it, the patch can be simpler like this,
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index e57353e39168..fb5453a46a03 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -2070,6 +2070,7 @@ static struct notifier_block reboot =3D {
>
>  static void bcache_exit(void)
>  {
> +       mutex_destroy(&bch_register_lock);
>         bch_debug_exit();
>         bch_request_exit();
>         if (bcache_kobj)
> @@ -2089,7 +2090,6 @@ static int __init bcache_init(void)
>                 NULL
>         };
>
> -       mutex_init(&bch_register_lock);
>         init_waitqueue_head(&unregister_wait);
>         register_reboot_notifier(&reboot);
>         closure_debug_init();
> @@ -2107,6 +2107,7 @@ static int __init bcache_init(void)
>             bch_debug_init(bcache_kobj))
>                 goto err;
>
> +       mutex_init(&bch_register_lock);
>         return 0;
>  err:
>         bcache_exit();
> ---
> And if you do care about the race, maybe you should do something like thi=
s,
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index e57353e39168..ca1d8b7a7815 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -2079,6 +2079,7 @@ static void bcache_exit(void)
>         if (bcache_major)
>                 unregister_blkdev(bcache_major, "bcache");
>         unregister_reboot_notifier(&reboot);
> +       mutex_unlock(&bch_register_lock);
>  }
>
>  static int __init bcache_init(void)
> @@ -2090,6 +2091,7 @@ static int __init bcache_init(void)
>         };
>
>         mutex_init(&bch_register_lock);
> +       mutex_lock(&bch_register_lock);
>         init_waitqueue_head(&unregister_wait);
>         register_reboot_notifier(&reboot);
>         closure_debug_init();
> @@ -2097,6 +2099,8 @@ static int __init bcache_init(void)
>         bcache_major =3D register_blkdev(0, "bcache");
>         if (bcache_major < 0) {
>                 unregister_reboot_notifier(&reboot);
> +               mutex_unlock(&bch_register_lock);
> +               mutex_destroy(&bch_register_lock);
>                 return bcache_major;
>         }
>
> @@ -2104,9 +2108,12 @@ static int __init bcache_init(void)
>             !(bcache_kobj =3D kobject_create_and_add("bcache", fs_kobj)) =
||
>             sysfs_create_files(bcache_kobj, files) ||
>             bch_request_init() ||
> -           bch_debug_init(bcache_kobj))
> +           bch_debug_init(bcache_kobj)) {
> +               mutex_unlock(&bch_register_lock);
>                 goto err;
> +       }
>
> +       mutex_unlock(&bch_register_lock);
>         return 0;
>  err:
>         bcache_exit();
> ---
>
> Personally I think the first approach with only one new line code added,
> your original version will add two new lines of code.
>
> Just FYI. Thanks.
>
> --
> Coly Li
