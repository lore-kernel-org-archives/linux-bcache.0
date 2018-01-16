From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 10/13] bcache: fix inaccurate io state for detached
 bcache devices
Date: Tue, 16 Jan 2018 10:27:48 +0100
Message-ID: <96cc45cb-be6b-c90f-ccfb-7c0a28a358e9@suse.de>
References: <20180114144236.28213-1-colyli@suse.de>
 <20180114144236.28213-11-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52755 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750821AbeAPJ1v (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 16 Jan 2018 04:27:51 -0500
In-Reply-To: <20180114144236.28213-11-colyli@suse.de>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, Tang Junhui <tang.junhui@zte.com.cn>

On 01/14/2018 03:42 PM, Coly Li wrote:
> From: Tang Junhui <tang.junhui@zte.com.cn>
> 
> When we run IO in a detached device,  and run iostat to shows IO status,
> normally it will show like bellow (Omitted some fields):
> Device: ... avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
> sdd        ... 15.89     0.53    1.82    0.20    2.23   1.81  52.30
> bcache0    ... 15.89   115.42    0.00    0.00    0.00   2.40  69.60
> but after IO stopped, there are still very big avgqu-sz and %util
> values as bellow:
> Device: ... avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
> bcache0   ...      0   5326.32    0.00    0.00    0.00   0.00 100.10
> 
> The reason for this issue is that, only generic_start_io_acct() called
> and no generic_end_io_acct() called for detached device in
> cached_dev_make_request(). See the code:
> //start generic_start_io_acct()
> generic_start_io_acct(q, rw, bio_sectors(bio), &d->disk->part0);
> if (cached_dev_get(dc)) {
> 	//will callback generic_end_io_acct()
> }
> else {
> 	//will not call generic_end_io_acct()
> }
> 
> This patch calls generic_end_io_acct() in the end of IO for detached
> devices, so we can show IO state correctly.
> 
> (Modified to use GFP_NOIO in kzalloc() by Coly Li)
> 
> Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
> Reviewed-by: Coly Li <colyli@suse.de>
> ---
>  drivers/md/bcache/request.c | 58 +++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 51 insertions(+), 7 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
