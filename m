From: Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: register cache device hangs on bcache branch (3.6.0-rc3)
Date: Mon, 08 Oct 2012 11:11:03 -0700
Message-ID: <50731737.8090409@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

It looks like the bcache branch (3.6.0-rc3) hangs when registering a
cache device. I don't have that issue with the 3.2 branch.

[root@test0 ~]# echo /dev/sdb1 >
/sys/fs/bcache/register                       
[  143.221306] bcache: invalidating existing
data                              
[  203.136484] INFO: rcu_sched self-detected stall on CPU { 0}  (t=60000
jiffies
)                                                                              

[  203.144151] Pid: 83, comm: kworker/0:1 Not tainted 3.6.0-rc3+
#7            
[  203.150254] Call
Trace:                                                     
[  203.152807]  <IRQ>  [<ffffffff810d8b34>]
rcu_check_callbacks+0x184/0x700    
[  203.159753]  [<ffffffff81060928>]
update_process_times+0x48/0x90            
[  203.165861]  [<ffffffff8109bfc3>]
tick_sched_timer+0x63/0x170               
[  203.171710]  [<ffffffff81078063>]
__run_hrtimer+0x73/0x200                  
[  203.177298]  [<ffffffff8109bf60>] ?
tick_init_highres+0x20/0x20             
[  203.183318]  [<ffffffff8109597c>] ?
ktime_get_update_offsets+0x4c/0xd0      
[  203.189947]  [<ffffffff81057c62>] ?
__do_softirq+0x122/0x270                
[  203.195709]  [<ffffffff810787e7>]
hrtimer_interrupt+0x117/0x260             
[  203.201732]  [<ffffffff8158f4bc>] ?
call_softirq+0x1c/0x30                  
[  203.207321]  [<ffffffff8143a1f0>] ?
bch_bucket_add_unused+0xe0/0xe0         
[  203.213690]  [<ffffffff8158fdf9>]
smp_apic_timer_interrupt+0x69/0x99        
[  203.220145]  [<ffffffff8158edca>]
apic_timer_interrupt+0x6a/0x70            
[  203.226246]  <EOI>  [<ffffffff81439c31>] ?
can_invalidate_bucket+0x31/0x40  
[  203.233361]  [<ffffffff8143a6a4>] ?
bch_allocator_thread+0x4b4/0xef0        
[  203.239815]  [<ffffffff81074480>] ?
add_wait_queue+0x60/0x60                
[  203.245574]  [<ffffffff8143a1f0>] ?
bch_bucket_add_unused+0xe0/0xe0         
[  203.251941]  [<ffffffff8106d00a>]
process_one_work+0x13a/0x590              
[  203.257872]  [<ffffffff8106e6f1>]
worker_thread+0x191/0x500                 
[  203.263543]  [<ffffffff8106e560>] ?
manage_workers+0x2d0/0x2d0              
[  203.269476]  [<ffffffff81073b13>]
kthread+0x93/0xa0                         
[  203.274454]  [<ffffffff8158f3c4>]
kernel_thread_helper+0x4/0x10             
[  203.280472]  [<ffffffff81073a80>] ?
flush_kthread_worker+0xb0/0xb0          
[  203.286753]  [<ffffffff8158f3c0>] ? gs_change+0x13/0x13
