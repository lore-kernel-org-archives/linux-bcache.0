From: Zachary Palmer <zep_bcache-J5qI5MFTcs8@public.gmane.org>
Subject: Re: Suspend and Hibernation Bugs
Date: Sun, 01 Sep 2013 19:13:08 -0400
Message-ID: <5223CA04.4010607@bahj.com>
References: <52238303.6040509@bahj.com> <5223999F.2050508@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5223999F.2050508-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Interesting; it does indeed have a stale header of some kind:

     zpalmer@thirtyseven:~$ sudo blkid /dev/sda7
     /dev/sda7: UUID="b56e8430-2594-436a-9fba-b91617cdaa5e" 
TYPE="crypto_LUKS"
     zpalmer@thirtyseven:~$ sudo /sbin/wipefs /dev/sda7
     offset               type
----------------------------------------------------------------
     0x0                  crypto_LUKS   [crypto]
                         UUID: b56e8430-2594-436a-9fba-b91617cdaa5e

But /dev/sda7 is a bcache backing volume.

     zpalmer@thirtyseven:~$ sudo probe-bcache /dev/sda7
     4b6ead1d-3341-407c-9e16-dd9e639268e4: UUID="" TYPE="bcache"

Doesn't bcache put its superblock in the first part of the block 
device?  How is it possible that the device looks like a bcache backing 
volume and a LUKS encrypted volume at the same time?  (For the record, I 
know that the LUKS volume identified above is the stale one; when I used 
LVM to move everything around, I created a fresh LUKS encrypted volume 
which has a different UUID than the old one shown above.)

Thanks,

Zach

p.s.: Regarding the hibernation issue, I believe that a related bug has 
already been reported to the Debian crew, who have sent at least some of 
the information upstream to kernel development (see 
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=715019).  I've added my 
own information to that bug report, of course.  If I can provide any 
information that would be of assistance, please let me know.
>> Hello there. I'm not sure if this is the appropriate venue, so please
>> let me know if this information should be somewhere else. I have
>> configured a Debian 7.0 installation on a Dell Inspiron 17R SE laptop
>> to use a bcache root device. The previous known working configuration
>> for the laptop was:
>>
>>      /dev/sda (1TB HDD)
>>          ...
>>          /dev/sda7 (used as LUKS encrypted volume)
>>              /dev/mapper/sda7_crypt (used as LVM PV)
>>                  /dev/vg0/home
>>                  /dev/vg0/root
>>                  ...
>>          /dev/sda8 (used as ext3 /boot)
>>
>> The new configuration is
>>
>>      /dev/sda (1TB HDD)
>>          ...
>>          /dev/sda7 (used as bcache backing device)
>>              /dev/bcache0 (used as LUKS encrypted volume)
>>                  /dev/mapper/bcache_crypt (used as LVM PV)
>>                      /dev/vg0/home
>>                      /dev/vg0/root
>>                      ...
>>          /dev/sda8 (used as ext3 /boot)
>>      /dev/sdb (32GB SSD)
>>          ...
>>          /dev/sdb3 (used as bcache caching device)
>>
>> In order to get things booting, I also:
>>
>>      * Installed a Linux 3.10 kernel from wheezy-backports (3.10-0.bpo.2-686-pae)
>>      * Obtained a copy of the bcache-tools source from the git repo and compiled it
>>      * Constructed a Debian package for bcache-tools using checkinstall
>>      * Because udev recognition wasn't enough at boot time, added a script
>>        /etc/initramfs-tools/scripts/init-premount/z-bcache which looks like this:
> Just addressing the udev part; could you check with wipefs (nondestructive with no flags)
> that /dev/sda7 doesn't have an old non-bcache superblock?
>
> There's been a transitional period when udev rules were stricter than what make-bcache
> created, which will be fixed with the patch at https://github.com/g2p/bcache-tools/commits.
>
