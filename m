From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH] bcache: Fix building error on MIPS
Date: Wed, 15 Nov 2017 20:43:21 -0800
Message-ID: <91433707-3b0d-a656-b9cc-d695836c7355@lyle.org>
References: <1510801573-17878-1-git-send-email-chenhc@lemote.com>
 <b28f4962-f418-d6bf-ad7b-7c1a8089bbe8@suse.de>
 <tencent_18C70D36191568EA3FDA967B@qq.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <tencent_18C70D36191568EA3FDA967B@qq.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: =?UTF-8?B?6ZmI5Y2O5omN?= <chenhc@lemote.com>, Coly Li <colyli@suse.de>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache <linux-bcache@vger.kernel.org>, stable <stable@vger.kernel.org>
List-Id: linux-bcache@vger.kernel.org

Huacai--

Thanks for your patch.

On 11/15/2017 08:29 PM, 陈华才 wrote:
> I think #undef is not very good, because it depends on the sequence of #include.
> 
> Huacai

Yes-- I can live with this-- we don't have many uses of the PTR() macro
and it doesn't hurt clarity.

Reviewed-by: Michael Lyle <mlyle@lyle.org>

I will carry this in my tree of things to possibly submit later in 4.15.

Mike
