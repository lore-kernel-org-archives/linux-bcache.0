From: Coly Li <i@coly.li>
Subject: Re: zhujing@ecloutech.com.cn; qinxq@ecloutech.com.cn;
 qiulg@ecloutech.com.cn
Date: Sat, 30 Sep 2017 20:18:37 +0800
Message-ID: <8f618e23-47b1-5242-1337-85d677bbf466@coly.li>
References: <tencent_6B3B92236BCF98600CB74BF7@qq.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:44980 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752706AbdI3MSm (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 30 Sep 2017 08:18:42 -0400
In-Reply-To: <tencent_6B3B92236BCF98600CB74BF7@qq.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: qiulg <qiulg@ecloudtech.com.cn>
Cc: linux-bcache <linux-bcache@vger.kernel.org>

On 2017/9/30 下午6:50, qiulg wrote:
> Hi,
>  
> Our environment is Redhat Enterprise 6.8, upgrade to kernal 4.4.89. We use sdj(480G) as as backing devices and sdk1(20G) as cache device. To test maintenance step when hard disk fail, we plug out the backing device sdj.
> Here are the results during test:
>  
> # lsscsi
> -- the sdj device is gone.
>  
> # ls -l /dev/bcache4
> brw-rw---- 1 root root 251, 4 Sep 30 18:00 /dev/bcache4
> -- the bcache4 device is still there
>  
> # dd if=/dev/bcache4 of=/dev/null bs=1M count=100
> dd: reading `/dev/bcache4': Input/output error
> 0+0 records in
> 0+0 records out
> 0 bytes (0 B) copied, 0.00201728 s, 0.0 kB/s
> -- this is resonable
>  
> # fdisk -l /dev/bcache4
> -- fdisk has no result. This is resonable
>  
> # dd if=/dev/zero of=/dev/bcache4 bs=1M count=100
> 100+0 records in
> 100+0 records out
> 104857600 bytes (105 MB) copied, 0.230408 s, 455 MB/s
> -- bcache4 can still be written. If the backing device is really destroyed, then application don't know that, and thought data is saved. It's not acceptable. The application should get I/O error.
>  
> # dd if=/dev/bcache4 of=/dev/null bs=1M count=100
> dd: reading `/dev/bcache4': Input/output error
> 46+1 records in
> 46+1 records out
> 48238592 bytes (48 MB) copied, 0.120517 s, 400 MB/s
> -- now read still shows error but 48MB data read out.
>  
> # fdisk -l /dev/bcache4
> Note: sector size is 4096 (not 512)
> Disk /dev/bcache4: 480.1 GB, 480103972864 bytes
> 255 heads, 63 sectors/track, 7296 cylinders
> Units = cylinders of 16065 * 4096 = 65802240 bytes
> Sector size (logical/physical): 4096 bytes / 4096 bytes
> I/O size (minimum/optimal): 4096 bytes / 4096 bytes
> Disk identifier: 0x00000000
> -- fdisk got answer. Strange. 480GB is the backing device size.
>  
> # dd if=/dev/zero of=/dev/bcache4 bs=1M
> dd: writing `/dev/bcache4': No space left on device
> 457863+0 records in
> 457862+0 records out
> 480103972864 bytes (480 GB) copied, 620.993 s, 773 MB/s
> -- keep writing to bcache4, after 480GB, it says "no space left". But the backing device is 480G, cache device is only 20G, where did the data go?
> -- during dd, the /var/log/message shows error
> ...
> Sep 30 17:52:35 s103 kernel: Buffer I/O error on dev bcache4, logical block 2224259, lost async page write
> Sep 30 17:52:35 s103 kernel: Buffer I/O error on dev bcache4, logical block 2224260, lost async page write
> Sep 30 17:52:35 s103 kernel: Buffer I/O error on dev bcache4, logical block 2224261, lost async page write
> Sep 30 17:52:40 s103 kernel: buffer_io_error: 1093169 callbacks suppressed
> Sep 30 17:52:40 s103 kernel: Buffer I/O error on dev bcache4, logical block 3317548, lost async page write
> ...
>  
> I think correct behaviour should be, if backing device lost, "dd" (the application) should know rightaway, got I/O error.
>  
> Appreciated for any help.
>  
Hi,

Could you please try oflag=direct and observe what is the difference ?

Buffered I/O is asynchronized, application is not able to get an
immediate -EIO.


-- 
Coly Li
