From: Nix <nix@esperi.org.uk>
Subject: Re: make-bcache bug?
Date: Mon, 15 May 2017 13:52:09 +0100
Message-ID: <8737c6th8m.fsf@esperi.org.uk>
References: <20170514175840.s3l6p4zjxnf2brm6@merlins.org>
        <20170514220055.2d06210e@jupiter.sol.kaishome.de>
        <20170514201940.76bu7rz764jeplnd@merlins.org>
        <20170514232816.79c2530e@jupiter.sol.kaishome.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from icebox.esperi.org.uk ([81.187.191.129]:49868 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751253AbdEOMwM (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 15 May 2017 08:52:12 -0400
In-Reply-To: <20170514232816.79c2530e@jupiter.sol.kaishome.de> (Kai Krakow's
        message of "Sun, 14 May 2017 23:28:16 +0200")
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kai Krakow <hurikhan77@gmail.com>
Cc: linux-bcache@vger.kernel.org

On 14 May 2017, Kai Krakow said:
> I had done this previously, too, and had no such message. But I had to
> use wipefs anyway because otherwise udev came and triggered the device
> for reasons I couldn't really follow.

udev does a blkid to see how the block device needs to be activated:
this relies on precisely the information wipefs removes. Avoiding this
problem is why wipefs *exists*. :)

-- 
NULL && (void)
