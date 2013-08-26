From: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Subject: Re: bcache-tools: changes to make the udev rules work
Date: Tue, 27 Aug 2013 00:20:06 +0200
Message-ID: <521BD496.5060207@rolffokkens.nl>
References: <521B1E94.8090802@rolffokkens.nl> <kvfs5h$j12$1@ger.gmane.org> <521BC237.9000802@rolffokkens.nl> <521BC829.9080303@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <521BC829.9080303-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 08/26/2013 11:27 PM, Gabriel de Perthuis wrote:
> Possibly /dev/sdc1 or /dev/sdd1 has a stray non-bcache superblock.
You're right, see below. That was an ugly one.

Do you think having blkid identify bcache itself would have helped, or 
is there always a chance of contradictive signatures which may confuse  
blkid?
>
> You can check with wipefs, and remove it with wipefs -a.
The evidence:

[root@localhost ~]# wipefs /dev/sda3
[root@localhost ~]# wipefs /dev/sdb1
offset               type
----------------------------------------------------------------
0x218                LVM2_member   [raid]
                      UUID:  ZSSjZv-FU0H-Zeaa-92GU-37Zs-KyLS-JMF03Y

[root@localhost ~]# wipefs /dev/sdc1
[root@localhost ~]# wipefs /dev/sdd1
[root@localhost ~]# blkid /dev/sdb1
/dev/sdb1: UUID="ZSSjZv-FU0H-Zeaa-92GU-37Zs-KyLS-JMF03Y" TYPE="LVM2_member"
[root@localhost ~]#
