From: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Subject: Re: Add Bcache to an existing Filesystem
Date: Tue, 27 Jun 2017 10:46:54 +0000
Message-ID: <20170627104654.Horde.qG1pMDnsa0LUeSdzxkMOzCc@webmail.nde.ag>
References: <46fc48b2-55db-471f-8318-5e60555e228e@upx.com>
 <CAPmG0jZyiA-3xbjoQFRP4X9Xkra6aOsbojK8HJqAALdycPkajQ@mail.gmail.com>
 <864cf409-86ca-dbe1-c6bc-89667a978f44@upx.com>
 <CAPmG0jZ2ye9z-n8efF9zd7CbBDVFoykrszceq10WpepaGrhx5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.181]:23449 "EHLO
        mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751922AbdF0KxY (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 27 Jun 2017 06:53:24 -0400
In-Reply-To: <CAPmG0jZ2ye9z-n8efF9zd7CbBDVFoykrszceq10WpepaGrhx5Q@mail.gmail.com>
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Henk Slager <eye1tm@gmail.com>
Cc: FERNANDO FREDIANI <fernando.frediani@upx.com>, linux-bcache@vger.kernel.org

Hi *,

Zitat von Henk Slager <eye1tm@gmail.com>:
> [...] There
> is someone on the list who uses bcache on top of MD RAID5 AFAIR.

that would probably be me: backing device was an MD-RAID6 (we've  
switched to RAID1 in the meantime because the data fits on a single  
disk (netto) and we needed the HDD slots) and caching device is an  
MD-RAID1 consisting of two SSDs.

On top of that bcache device, I decided to add an LVM layer (making  
/dev/bcache* a PV), which is really helpful i.e. with the base problem  
of this thread: You can create additional bcache devices and pvmove  
your data to the new PV, without interrupting production.

> I
> think I would choose to add bcache to each of the four harddisks,

If you'd do that with a single caching device, you're in for  
contention. My gut feeling tells me that running a single bcache  
backing device/caching device combo on top of MD-RAID is less  
straining than running MD-RAID across a bunch of bcache devices with a  
common caching device: The MD advantage of spreading the load across  
multiple "disks" is countered by accessing a common SSD.

Regards
J.
