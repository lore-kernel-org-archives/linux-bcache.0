From: Alain Spineux <aspineux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: howto unregister disks and unload bcache module
Date: Thu, 12 Jul 2012 18:37:41 +0200
Message-ID: <CACgTii_nd5uHPy4dfej=GxZ7WBkYO9AgXPKkayFN-86eQmr3WA@mail.gmail.com>
References: <CACgTii9ZvM=jxJzhaQOZHuca3666KArQPf2AhkKUepg5N5Fb9w@mail.gmail.com>
	<20120708004240.GA12542@moria.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120708004240.GA12542-jC9Py7bek1znysI04z7BkA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Sun, Jul 8, 2012 at 2:42 AM, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> On Wed, Jul 04, 2012 at 11:15:32AM +0200, Alain Spineux wrote:
>> Hi
>>
>> I'm trying to unregister disks to unload the bcache module and reuse
>> the disk for other tests.
>>
>> Can someone tell me how to unload module bcache after having run these command ?
>
> You'd use either unregister or stop (in the various bcache directories,
> depending on whether you just wanted to stop/unregister a backing device
> or cache set) and then you ought to be able to rmmod it.
>
> I should test that though, I wouldn't be surprised if something isn't
> completely working.

YES !  stop is working !

Thanks Kent

Here is a kind of getting started

first load the bcache module
# modprobe bcache

I created a cache device on /dev/sdb1
# ./make-bcache -C -b512k -w4k --writeback /dev/sdb1

# and a backing device on /dev/sdz1
./make-bcache -B /dev/sdz1

# ./probe-bcache /dev/sdb1
5f42bdd1-4342-4ab6-8dda-855989a09604: UUID="" TYPE="bcache"

# ./probe-bcache /dev/sdz1
6bbac9a4-afbd-4d40-9562-cdd290622c5d: UUID="" TYPE="bcache"

I register the backed device
# echo /dev/sdb1 >/sys/fs/bcache/register

This create /dev/bcache0 thap map /dev/sdz1
except for the first blocks to avoid to use sdz1 instead of bcache0
ATTN bcache0 is not yet attached to any cache device !

I create a "cache set"
# echo /dev/sdz1  >/sys/fs/bcache/register

# ls /sys/fs/bcache/
887d3bb6-0161-4e54-b9d8-801de9f7df83  register  register_quiet

"887d3bb6-0161-4e54-b9d8-801de9f7df83"
is the uuid of the "cache set" composed by the caching device /dev/sdb1


now I attach /dev/sdz1 to this cache set
# echo "887d3bb6-0161-4e54-b9d8-801de9f7df83" >
/sys/block/sdz/sdz1/bcache/attach

I want to activate writeback
# echo writeback > /sys/block/bcache0/bcache/cache_mode

and ask bcache to bypasse the cache when I write more than
64k of sequential data. Default is 4M
# echo 64k > /sys/block/sdz/sdz1/bcache/sequential_cutoff

to stop bcache0
# echo 1 >  /sys/block/sdz/sdz1/bcache/stop

to stop the cache set
# echo 1 > /sys/fs/bcache/887d3bb6-0161-4e54-b9d8-801de9f7df83/stop

An finally unload the module
# modprobe -r bcache


>
>>
>> Thanks.
>>
>> #first load module
>> # modprobe bcache
>>
>> I created a cache device on /dev/sdb1
>> # ./make-bcache -C -b512k -w4k --writeback /dev/sdb1
>>
>> and a backing device on /dev/sdz.
>> # ./make-bcache -B /dev/sdz
>>
>> # ./probe-bcache /dev/sdb1
>> 5f42bdd1-4342-4ab6-8dda-855989a09604: UUID="" TYPE="bcache"
>>
>> # ./probe-bcache /dev/sdz
>> 6bbac9a4-afbd-4d40-9562-cdd290622c5d: UUID="" TYPE="bcache"
>>
>>
>> I then registered them by:
>> # echo /dev/sdb1 >/sys/fs/bcache/register
>> # echo /dev/sdz  >/sys/fs/bcache/register
>>
>> I have /dev/bcache0.
>> /dev/bcache0 maps /dev/sdz except the first blocks
>> /dev/bcache0 is not yet cached by anything
>>
>> # ls /sys/fs/bcache/
>> 887d3bb6-0161-4e54-b9d8-801de9f7df83  register  register_quiet
>>
>> "887d3bb6-0161-4e54-b9d8-801de9f7df83"
>> is the id of the bcache "pool" composed by the only caching device /dev/sdb1
>>
>> # now I attach /dev/sdz to this pool
>> echo "887d3bb6-0161-4e54-b9d8-801de9f7df83" > /sys/block/sdz/bcache/attach
>>
>>
>>
>> --
>> Alain Spineux                   |  aspineux gmail com
>> Monitor your iT & Backups |  http://www.magikmon.com
>> Free Backup front-end       | http://www.magikmon.com/mksbackup
>> Your email 100% available |  http://www.emailgency.com
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Alain Spineux                   |  aspineux gmail com
Monitor your iT & Backups |  http://www.magikmon.com
Free Backup front-end       | http://www.magikmon.com/mksbackup
Your email 100% available |  http://www.emailgency.com
