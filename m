From: Brad Campbell <brad-+nnirC7rrGZibQn6LdNjmg@public.gmane.org>
Subject: Issue with bcache on top of RAID10
Date: Sun, 22 Apr 2012 19:07:01 +0800
Message-ID: <4F93E655.4080002@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

I've just fired up my test server with the latest git code, and I'm seeing this in the logs

Apr 22 18:54:29 test kernel: [  169.015498] md/raid10:md10: make_request bug: can't convert block 
across chunks or bigger than 512k 260098047 4
Apr 22 18:54:30 test kernel: [  170.015440] md/raid10:md10: make_request bug: can't convert block 
across chunks or bigger than 512k 260098047 4
Apr 22 18:54:31 test kernel: [  171.015455] md/raid10:md10: make_request bug: can't convert block 
across chunks or bigger than 512k 260098047 4
Apr 22 18:54:32 test kernel: [  172.015486] md/raid10:md10: make_request bug: can't convert block 
across chunks or bigger than 512k 260098047 4

It's triggering this code in /device/md/raid10.c in make_request()

                 /* Sanity check -- queue functions should prevent this happening */
                 if (bio->bi_vcnt != 1 ||
                     bio->bi_idx != 0)
                         goto bad_map;

As I didn't see this with plain ext4 on the md device, but I do see it with ext4 on bcache0 on the 
md device I can only assume something funky is happening in bcache.

Happy to do anything to help.

Regards,
Brad
