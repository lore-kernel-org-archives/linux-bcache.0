From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 01/13] bcache: set writeback_rate_update_seconds in
 range [1, 60] seconds
Date: Tue, 16 Jan 2018 10:03:03 +0100
Message-ID: <da1324d5-de5b-7b67-6fe1-1827b5dea329@suse.de>
References: <20180114144236.28213-1-colyli@suse.de>
 <20180114144236.28213-2-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180114144236.28213-2-colyli@suse.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 01/14/2018 03:42 PM, Coly Li wrote:
> dc->writeback_rate_update_seconds can be set via sysfs and its value can
> be set to [1, ULONG_MAX].  It does not make sense to set such a large
> value, 60 seconds is long enough value considering the default 5 seconds
> works well for long time.
> 
> Because dc->writeback_rate_update is a special delayed work, it re-arms
> itself inside the delayed work routine update_writeback_rate(). When
> stopping it by cancel_delayed_work_sync(), there should be a timeout to
> wait and make sure the re-armed delayed work is stopped too. A small max
> value of dc->writeback_rate_update_seconds is also helpful to decide a
> reasonable small timeout.
> 
> This patch limits sysfs interface to set dc->writeback_rate_update_seconds
> in range of [1, 60] seconds, and replaces the hand-coded number by macros.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>  drivers/md/bcache/sysfs.c     | 3 +++
>  drivers/md/bcache/writeback.c | 2 +-
>  drivers/md/bcache/writeback.h | 3 +++
>  3 files changed, 7 insertions(+), 1 deletion(-)
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
