From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 11/13] bcache: add backing_request_endio() for
 bi_end_io of attached backing device I/O
Date: Tue, 16 Jan 2018 10:28:48 +0100
Message-ID: <de288b3a-5c95-dc79-133b-d5ce1f538e67@suse.de>
References: <20180114144236.28213-1-colyli@suse.de>
 <20180114144236.28213-12-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180114144236.28213-12-colyli@suse.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, Junhui Tang <tang.junhui@zte.com.cn>, Michael Lyle <mlyle@lyle.org>
List-Id: linux-bcache@vger.kernel.org

On 01/14/2018 03:42 PM, Coly Li wrote:
> In order to catch I/O error of backing device, a separate bi_end_io
> call back is required. Then a per backing device counter can record I/O
> errors number and retire the backing device if the counter reaches a
> per backing device I/O error limit.
> 
> This patch adds backing_request_endio() to bcache backing device I/O code
> path, this is a preparation for further complicated backing device failure
> handling. So far there is no real code logic change, I make this change a
> separate patch to make sure it is stable and reliable for further work.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> Cc: Junhui Tang <tang.junhui@zte.com.cn>
> Cc: Michael Lyle <mlyle@lyle.org>
> ---
>  drivers/md/bcache/request.c   | 95 +++++++++++++++++++++++++++++++++++--------
>  drivers/md/bcache/super.c     |  1 +
>  drivers/md/bcache/writeback.c |  1 +
>  3 files changed, 81 insertions(+), 16 deletions(-)
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
