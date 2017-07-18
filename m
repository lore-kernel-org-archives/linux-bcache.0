From: Eddie Chapman <eddie@ehuk.net>
Subject: Re: [PULL] bcache updates based on git.kernel.dk/linux-block:for-next
Date: Tue, 18 Jul 2017 21:36:56 +0100
Message-ID: <42e13a8a-c892-4e1a-5829-5b903f4f3c52@ehuk.net>
References: <alpine.LRH.2.11.1705251853530.19359@mail.ewheeler.net>
 <23b4ace1-60b7-1ce6-23d7-29433ec8582c@ehuk.net>
 <7040453d-2272-d376-710b-6ed07527a98e@coly.li>
 <d94db8ff-ff2c-0c3c-5638-97cd3c769c1c@ehuk.net>
 <OF92BA0158.87BDF9E3-ON4825815E.000736BF-4825815E.000833F7@zte.com.cn>
 <f09f9db6-c8ec-3e38-84af-40195b0fc13b@ehuk.net>
 <d490f93b-b43a-cb08-cf2e-304b3dbf1d96@ehuk.net>
 <20170718200615.GE3694@kroah.com>
Reply-To: Eddie Chapman <eddie@ehuk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170718200615.GE3694@kroah.com>
Content-Language: en-GB
Sender: stable-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: tang.junhui@zte.com.cn, Eric Wheeler <bcache@lists.ewheeler.net>, Coly Li <i@coly.li>, linux-bcache@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

Hi Greg,

On 18/07/17 21:06, Greg KH wrote:
> On Tue, Jul 18, 2017 at 07:31:35PM +0100, Eddie Chapman wrote:
>> As per previous mail, below are the 4 patches discussed, generated with 
>> diff -up, from kernel.org 4.4.77, so with correct context for 4.4. Just 
>> in case they are useful for anyone.
> 
> <formletter>
> 
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.
> 
> </formletter>

I know, I certainly did not want to submit these patches for inclusion in the stable kernel yet! As I said, I only sent them to Tang and others in case they were useful. I'm just trying to help with testing.

> Note, I can't do anything with patches until they are in Linus's tree.
> Please work to get them accepted there, then we can worry about
> backporting them to older kernels if they are needed.

Hold your fire! :-) I know, I said exactly the same myself earlier in this thread, that they must be in Linus' tree first.

Sorry if I gave the wrong idea. Maybe I should have removed stable@ from CC? But I thought that would not be good in case someone found the thread in future and wanted to know.

Eddie

> 
> thanks,
> 
> greg k-h
