From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v3 3/3] lib/test_crc: Add test cases for crc calculation
Date: Tue, 17 Jul 2018 09:57:28 -0700
Message-ID: <346998e5-8798-e8f0-ccaa-a9d4810b68f5@infradead.org>
References: <20180717145525.50852-1-colyli@suse.de>
 <20180717145525.50852-4-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180717145525.50852-4-colyli@suse.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, linux-kernel@vger.kernel.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Kate Stewart <kstewart@linuxfoundation.org>
List-Id: linux-bcache@vger.kernel.org

Hi,

On 07/17/2018 07:55 AM, Coly Li wrote:

> diff --git a/lib/test_crc.c b/lib/test_crc.c
> new file mode 100644
> index 000000000000..441bf835fbd3
> --- /dev/null
> +++ b/lib/test_crc.c
> @@ -0,0 +1,138 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * CRC test driver
> + *
> + * Copyright (C) 2018 Coly Li <colyli@suse.de>
> + *

> +
> +static int __init test_crc_init(void)
> +{
> +	int i;
> +	int v, err = 0;
> +
> +	pr_info("Kernel CRC consitency testing:\n");

	                    consistency

> +	for (i = 0; test_data[i].name; i++) {
> +		v = test_data[i].handler(&test_data[i]);
> +		if (v < 0)
> +			err++;
> +	}
> +
> +	if (err == 0)
> +		pr_info("test_crc: all %d tests passed\n", i);
> +	else
> +		pr_err("test_crc: %d cases tested, %d passed, %d failed\n",
> +		       i, i - err, err);
> +
> +	return (err == 0) ? 0 : -EINVAL;
> +}


-- 
~Randy
