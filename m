From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/4] bcache: bch_writeback_thread() is not freezable
Date: Tue, 24 May 2016 09:01:09 -0600
Message-ID: <57446CB5.6080203@kernel.dk>
References: <alpine.LNX.2.00.1605241634270.31937@cbobk.fhfr.pm>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1605241634270.31937@cbobk.fhfr.pm>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Kosina <jikos@kernel.org>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, Eric Wheeler <bcache@lists.ewheeler.net>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 05/24/2016 08:38 AM, Jiri Kosina wrote:
> From: Jiri Kosina <jkosina@suse.cz>
>
> bch_writeback_thread() is calling try_to_freeze(), but that's just an
> expensive no-op given the fact that the thread is not marked freezable.
>
> I/O helper kthreads, exactly such as the bcache writeback thread, actually
> shouldn't be freezable, because they are potentially necessary for
> finalizing the image write-out.

Applied 1-4, thanks Jiri.

-- 
Jens Axboe
