From: Campbell Steven <casteven@gmail.com>
Subject: Re: [PATCH] bio: ensure __bio_clone_fast copies bi_partno
Date: Sat, 18 Nov 2017 09:25:12 +1300
Message-ID: <CAPerZE-AzNo9ZuusJYv5Ox7cJ1N5eCc2ce3tOar_pqtfNomJQA@mail.gmail.com>
References: <20171117074725.22536-1-mlyle@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171117074725.22536-1-mlyle@lyle.org>
Sender: linux-block-owner@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 17 November 2017 at 20:47, Michael Lyle <mlyle@lyle.org> wrote:
> A new field was introduced in 74d46992e0d9dee7f1f376de0d56d31614c8a17a,
> bi_partno, instead of using bdev->bd_contains and encoding the partition
> information in the bi_bdev field.  __bio_clone_fast was changed to copy
> the disk information, but not the partition information.  At minimum,
> this regressed bcache and caused data corruption.

Thanks alot for this Michael, I will run it up on our test servers today.

Campbell
