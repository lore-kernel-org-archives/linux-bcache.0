From: Christoph Hellwig <hch@lst.de>
Subject: simplify queue allocation
Date: Fri, 27 Mar 2020 09:30:07 +0100
Message-ID: <20200327083012.1618778-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

Hi Jens,

this series ensures all allocated queues have a valid ->make_request_fn
and also nicely consolidates the code for allocating queues.
