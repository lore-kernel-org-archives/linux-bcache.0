From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [GIT PULL] bcache fixes for 3.13
Date: Tue, 17 Dec 2013 12:53:24 -0700
Message-ID: <20131217195324.GD24924@kernel.dk>
References: <20131216222409.GD4054@kmo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:54696 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab3LQTx0 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 17 Dec 2013 14:53:26 -0500
Content-Disposition: inline
In-Reply-To: <20131216222409.GD4054@kmo>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kmo@daterainc.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org

On Mon, Dec 16 2013, Kent Overstreet wrote:
> Jens - small pile of bcache fixes. I've been slacking on the writeback fixes but
> those definitely need to get into 3.13:
> 
> The following changes since commit c86949486d41d9e7d7681fc72923555114fd702f:
> 
>   bcache: defensively handle format strings (2013-11-10 21:56:43 -0800)
> 
> are available in the git repository at:
> 
>   git://evilpiepirate.org/~kent/linux-bcache.git bcache-for-3.13
> 
> for you to fetch changes up to 16749c23c00c686ed168471963e3ddb0f3fcd855:
> 
>   bcache: New writeback PD controller (2013-12-16 14:22:59 -0800)

Thanks Kent, pulled.

-- 
Jens Axboe
