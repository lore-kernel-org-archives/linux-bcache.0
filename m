From: Coly Li <colyli@suse.de>
Subject: Request For Suggestion: how to handle udevd timeout for bcache
 registration
Date: Thu, 23 Apr 2020 19:23:00 +0800
Message-ID: <7c92cd67-8e62-7d55-c520-345c30513bfa@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Cc: linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

Hi folk,

I want to listen to your suggestion on how to handle the udevd timeout
for bcache registration.

First of all let me introduce the background of this timeout problem.

Now the bcache registration is synchronized, the registering process
will be blocked until the whole registration done. In boot up time, such
registration can be initiated from a bcache udev rule. Normally it won't
be problem, but for very large cached data size there might be a large
internal btree on the cache device. During the registration checking all
the btree nodes may take 50+ minutes as a udev task, it exceeds 180
seconds timeout and udevd will kill it. The killing signal will make
kthread_create() fail during bcache initialization, then the automatic
bcache registration in boot up time will fail.

The above text describes the problem I need to solve: make boot up time
automatic bache registration always success no mater how long it will take.

I know there are several solutions to solve such problem, I do
appreciate if you may share the solution so that I may learn good ideas
from them.

Thank you in advance for the information sharing of my request of
suggestion.


Coly Li
