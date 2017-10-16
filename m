From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCHv3] bcache: only permit to recovery read error when cache
 device is clean
Date: Mon, 16 Oct 2017 10:39:25 -0700
Message-ID: <CAJ+L6qdqn1i=UFJcaO+xQzgZj_o5RNm71XhnSznrtMqt0P5Tew@mail.gmail.com>
References: <20170921195458.53890-1-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170921195458.53890-1-colyli@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>, Nix <nix@esperi.org.uk>, Kai Krakow <hurikhan77@gmail.com>, Eric Wheeler <bcache@lists.ewheeler.net>, Junhui Tang <tang.junhui@zte.com.cn>, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

Hey Coly--

On Thu, Sep 21, 2017 at 12:54 PM, Coly Li <colyli@suse.de> wrote:
> When bcache does read I/Os, for example in writeback or writethrough mode,
> if a read request on cache device is failed, bcache will try to recovery
> the request by reading from cached device. If the data on cached device is
> not synced with cache device, then requester will get a stale data.
[...]
> +       if (s->recoverable &&
> +           (dc && !atomic_read(&dc->has_dirty)) {

Looks like this is missing a parens.

Thx,

Mike
