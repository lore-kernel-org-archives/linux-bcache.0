From: "Matthew Patton" <pattonme@yahoo.com>
Subject: Re: Another bcache hang
Date: Fri, 22 Nov 2013 19:38:16 -0500
Message-ID: <op.w6y712vgf3gqgg@desktop.patton.net>
References: <20131121135604.GA26424@professorx.home.zettazebra.com>
 <14da01cee71f$28d233f0$7a769bd0$@acm.org>
 <20131122034919.GA25040@professorx.home.zettazebra.com>
 <528F6BAD.7080703@warr.net> <156301cee7bc$3b7fc420$b27f4c60$@acm.org>
 <528FBFCE.7020104@warr.net> <001b01cee7dd$e82f5d90$b88e18b0$@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from nm19-vm4.bullet.mail.ne1.yahoo.com ([98.138.91.179]:21804 "HELO
	nm19-vm4.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755248Ab3KWAiY (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 22 Nov 2013 19:38:24 -0500
In-Reply-To: <001b01cee7dd$e82f5d90$b88e18b0$@acm.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

On Fri, 22 Nov 2013 18:52:27 -0500, Paul B. Henson <henson@acm.org> wrote:

> Ah, that's true; using raid at the lvm layer allows you to selectively
> choose redundancy as opposed to dropping the entire pv on top of an  
> mdraid.

Not sure I understood that passage...

But in any event I'm working on a script I'm calling "md-3par" which will  
create a number of chunklets (aka LV) from a set of PV (contained  
naturally in a single VG) onto which to assemble a MD array of chosen  
geometry and redundancy level. Of course one can then additionally layer  
LVM, bcache, or (b)tier as desired. LVM is just a replacement for the  
archaic and inflexible partition table, IMO. Granted snapshots and  
thin-provisioning are nice to have.

I am disappointed that LVM is trying to expand into MD's territory. It's  
bad enough they had the LVM 'mirror' (IMO a sad effort, pitifully slow,  
and given it's unability to handle missing mirror members very much not  
useful) and an interleaved 'striping'. Simple concat/extension of course  
makes sense but the One True Faith of *nix is one simple tool to do one  
job and ONLY that job to the best possible. If they want to pretend to be  
ZFS-lite then just do ZFS already but keep it out of LVM. </rant>

-- 
NSA - subscribe to our Timeline and you'll know even before they've hit  
'ENTER'

Decency, Security and Liberty alike demand that government officials shall  
be subjected to the same rules of conduct that are commands to the  
citizen. In a government of laws, existence of the governmnet will be  
imperilled if it fails to observe the law scrupulously.
  -- Justice Louis D. Brandeis (Olmstead et. al. v. United States)
