From: Larkin Lowrey <llowrey@nuclearwinter.com>
Subject: Re: Null pointer oops
Date: Wed, 13 Aug 2014 16:21:14 -0500
Message-ID: <53EBD6CA.2000404@nuclearwinter.com>
References: <53EAF170.90600@nuclearwinter.com>	<CALJ65z=25CrrO9uMc2vfYVAQWb=6eK+OhB5TGJJrCp=D4ALvrQ@mail.gmail.com>	<53EB9513.8010200@nuclearwinter.com>	<CACHGV4LDe6YUAUAFxvzfu8XvyJJ+yjuRefGvteuRA99B-Cn2YQ@mail.gmail.com>	<53EBAFEB.8000109@nuclearwinter.com> <CACHGV4LEGK=7tFAJAEFaO84D=c6GGDyVTg4eMWC2mz5w1Xt_2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from titan.nuclearwinter.com ([174.136.96.186]:57975 "EHLO
	mail.nuclearwinter.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752821AbaHMVVO (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 13 Aug 2014 17:21:14 -0400
In-Reply-To: <CACHGV4LEGK=7tFAJAEFaO84D=c6GGDyVTg4eMWC2mz5w1Xt_2A@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Slava Pestov <sp@datera.io>
Cc: Kent Overstreet <kmo@daterainc.com>, linux-bcache@vger.kernel.org

Here's the dissassembly of bch_btree_node_read_done. The offending line
is 207 and the instruction is at offset 76.

--Larkin

199     void bch_btree_node_read_done(struct btree *b)
200     {
   0x00000000000065b0 <+0>:     callq  0x65b5 <bch_btree_node_read_done+5>
   0x00000000000065b5 <+5>:     push   %rbp
   0x00000000000065b8 <+8>:     mov    %rsp,%rbp
   0x00000000000065bb <+11>:    push   %r15
   0x00000000000065bd <+13>:    push   %r14
   0x00000000000065bf <+15>:    push   %r13
   0x00000000000065c1 <+17>:    push   %r12
   0x00000000000065c3 <+19>:    mov    %rdi,%r12
   0x00000000000065c6 <+22>:    push   %rbx

201             const char *err = "bad btree header";
   0x0000000000006800 <+592>:   mov    $0x0,%rdx

202             struct bset *i = btree_bset_first(b);
203             struct btree_iter *iter;
204
205             iter = mempool_alloc(b->c->fill_iter, GFP_NOWAIT);
   0x00000000000065b6 <+6>:     xor    %esi,%esi
   0x00000000000065c7 <+23>:    mov    0x80(%rdi),%rax
   0x00000000000065d5 <+37>:    mov    0xcb58(%rax),%rdi
   0x00000000000065dc <+44>:    callq  0x65e1 <bch_btree_node_read_done+49>
   0x00000000000065e9 <+57>:    mov    %rax,%r13

206             iter->size = b->c->sb.bucket_size / b->c->sb.block_size;
   0x00000000000065e1 <+49>:    mov    0x80(%r12),%rsi
   0x00000000000065ec <+60>:    xor    %edx,%edx
   0x00000000000065ee <+62>:    movzwl 0x432(%rsi),%eax
   0x00000000000065f5 <+69>:    divw   0x430(%rsi)
   0x0000000000006604 <+84>:    movzwl %ax,%eax
   0x0000000000006607 <+87>:    mov    %rax,0x0(%r13)

207             iter->used = 0;
   0x00000000000065fc <+76>:    movq   $0x0,0x8(%r13)

208
209     #ifdef CONFIG_BCACHE_DEBUG
210             iter->b = &b->keys;
211     #endif
212
213             if (!i->seq)
   0x000000000000660b <+91>:    mov    0x10(%rbx),%rax
   0x000000000000660f <+95>:    test   %rax,%rax
   0x0000000000006612 <+98>:    je     0x6800 <bch_btree_node_read_done+592>

214                     goto err;
215
216             for (;
   0x000000000000664d <+157>:   cmp    %r9d,%ecx
   0x0000000000006650 <+160>:   jae    0x6882 <bch_btree_node_read_done+722>
   0x0000000000006744 <+404>:   cmp    %r9d,%r10d
   0x0000000000006747 <+407>:   jae    0x6898 <bch_btree_node_read_done+744>

217                  b->written < btree_blocks(b) && i->seq ==
b->keys.set[0].data->seq;
   0x0000000000006618 <+104>:   mov    0x80(%r12),%rsi
   0x0000000000006625 <+117>:   movzwl 0xc0(%r12),%edi
   0x000000000000662e <+126>:   mov    0x108(%r12),%r8
   0x0000000000006636 <+134>:   movzwl 0xde2(%rsi),%ecx
   0x0000000000006644 <+148>:   mov    %rdx,%r9
   0x0000000000006647 <+151>:   shr    %cl,%r9
   0x000000000000664a <+154>:   movzwl %di,%ecx
   0x0000000000006656 <+166>:   cmp    0x10(%r8),%rax
   0x000000000000665a <+170>:   jne    0x6882 <bch_btree_node_read_done+722>
   0x000000000000670f <+351>:   mov    %rdx,%r9
   0x000000000000672a <+378>:   movzwl 0xde2(%rsi),%ecx
   0x0000000000006738 <+392>:   shr    %cl,%r9
   0x000000000000674d <+413>:   mov    0x10(%r8),%rcx
   0x0000000000006751 <+417>:   cmp    %rcx,0x10(%rbx)
   0x0000000000006755 <+421>:   jne    0x6898 <bch_btree_node_read_done+744>
   0x0000000000006892 <+738>:   add    %r8,%rbx
   0x0000000000006895 <+741>:   nopl   (%rax)

218                  i = write_block(b)) {
219                     err = "unsupported bset version";
   0x00000000000069c0 <+1040>:  mov    $0x0,%rdx
   0x00000000000069c7 <+1047>:  jmpq   0x6807 <bch_btree_node_read_done+599>
   0x00000000000069cc <+1052>:  nopl   0x0(%rax)

220                     if (i->version > BCACHE_BSET_VERSION)
   0x0000000000006660 <+176>:   mov    0x18(%rbx),%r10d
   0x0000000000006664 <+180>:   cmp    $0x1,%r10d
   0x0000000000006668 <+184>:   ja     0x69c0
<bch_btree_node_read_done+1040>
   0x000000000000666e <+190>:   movzwl 0x430(%rsi),%r11d
   0x0000000000006676 <+198>:   jmpq   0x6769 <bch_btree_node_read_done+441>
   0x000000000000667b <+203>:   nopl   0x0(%rax,%rax,1)
   0x000000000000675b <+427>:   mov    0x18(%rbx),%r10d
   0x000000000000675f <+431>:   cmp    $0x1,%r10d
   0x0000000000006763 <+435>:   ja     0x69c0
<bch_btree_node_read_done+1040>

221                             goto err;
222
223                     err = "bad btree header";
224                     if (b->written + set_blocks(i, block_bytes(b->c)) >
   0x0000000000006769 <+441>:   mov    0x1c(%rbx),%eax
   0x000000000000676c <+444>:   mov    %r11,%rcx
   0x000000000000676f <+447>:   xor    %edx,%edx
   0x0000000000006771 <+449>:   shl    $0x9,%rcx
   0x0000000000006775 <+453>:   movzwl %di,%edi
   0x0000000000006778 <+456>:   mov    %r9d,%r9d
   0x000000000000677b <+459>:   and    $0x1fffe00,%ecx
   0x0000000000006781 <+465>:   lea    0x20(,%rax,8),%r8
   0x0000000000006789 <+473>:   lea    -0x1(%r8,%rcx,1),%rax
   0x000000000000678e <+478>:   div    %rcx
   0x0000000000006791 <+481>:   add    %rdi,%rax
   0x0000000000006794 <+484>:   cmp    %r9,%rax
   0x0000000000006797 <+487>:   ja     0x6800 <bch_btree_node_read_done+592>

225                         btree_blocks(b))
226                             goto err;
227
228                     err = "bad magic";
   0x00000000000069d0 <+1056>:  mov    $0x0,%rdx
   0x00000000000069d7 <+1063>:  jmpq   0x6807 <bch_btree_node_read_done+599>
   0x00000000000069dc <+1068>:  nopl   0x0(%rax)

229                     if (i->magic != bset_magic(&b->c->sb))
   0x00000000000067aa <+506>:   cmp    %rax,0x8(%rbx)
   0x00000000000067ae <+510>:   jne    0x69d0
<bch_btree_node_read_done+1056>

230                             goto err;
231
232                     err = "bad checksum";
   0x00000000000067df <+559>:   mov    $0x0,%rdx
   0x00000000000067e6 <+566>:   jmp    0x6807 <bch_btree_node_read_done+599>
   0x00000000000067e8 <+568>:   nopl   0x0(%rax,%rax,1)
   0x00000000000067f0 <+576>:   mov    0x1c(%rbx),%eax
   0x00000000000067f3 <+579>:   jmpq   0x66bf <bch_btree_node_read_done+271>
   0x00000000000067f8 <+584>:   nopl   0x0(%rax,%rax,1)

233                     switch (i->version) {
   0x00000000000067b4 <+516>:   cmp    $0x1,%r10d
   0x00000000000067bb <+523>:   je     0x6680 <bch_btree_node_read_done+208>

234                     case 0:
235                             if (i->csum != csum_set(i))
   0x00000000000067c1 <+529>:   lea    0x20(%rbx),%r14
   0x00000000000067c5 <+533>:   lea    0x8(%rbx),%rdi
   0x00000000000067ce <+542>:   sub    %rdi,%rsi
   0x00000000000067d1 <+545>:   callq  0x67d6 <bch_btree_node_read_done+550>
   0x00000000000067d6 <+550>:   cmp    %rax,%r15
   0x00000000000067d9 <+553>:   je     0x66a6 <bch_btree_node_read_done+246>
236                                     goto err;
237                             break;
238                     case BCACHE_BSET_VERSION:
239                             if (i->csum != btree_csum_set(b, i))
   0x000000000000669d <+237>:   cmp    %rax,%r15
   0x00000000000066a0 <+240>:   jne    0x67df <bch_btree_node_read_done+559>
   0x00000000000067b8 <+520>:   mov    (%rbx),%r15

240                                     goto err;
241                             break;
242                     }
243
244                     err = "empty set";
   0x00000000000069e0 <+1072>:  mov    $0x0,%rdx
   0x00000000000069e7 <+1079>:  jmpq   0x6807 <bch_btree_node_read_done+599>

245                     if (i != b->keys.set[0].data && !i->keys)
   0x00000000000066a6 <+246>:   cmp    %rbx,0x108(%r12)
   0x00000000000066ae <+254>:   je     0x67f0 <bch_btree_node_read_done+576>
   0x00000000000066b4 <+260>:   mov    0x1c(%rbx),%eax
   0x00000000000066b7 <+263>:   test   %eax,%eax
   0x00000000000066b9 <+265>:   je     0x69e0
<bch_btree_node_read_done+1072>

246                             goto err;
247
248                     bch_btree_iter_push(iter, i->start,
bset_bkey_last(i));
   0x00000000000066c3 <+275>:   mov    %r14,%rsi
   0x00000000000066c6 <+278>:   mov    %r13,%rdi
   0x00000000000066c9 <+281>:   callq  0x66ce <bch_btree_node_read_done+286>

249
250                     b->written += set_blocks(i, block_bytes(b->c));
   0x00000000000066ce <+286>:   mov    0x80(%r12),%rsi
   0x00000000000066d6 <+294>:   mov    0x1c(%rbx),%eax
   0x00000000000066d9 <+297>:   xor    %edx,%edx
   0x00000000000066e3 <+307>:   movzwl 0x430(%rsi),%ecx
   0x00000000000066ea <+314>:   shl    $0x9,%ecx
   0x00000000000066ed <+317>:   movslq %ecx,%rcx
   0x00000000000066f0 <+320>:   lea    0x1f(%rcx,%rax,8),%rax
   0x00000000000066f5 <+325>:   div    %rcx
   0x0000000000006704 <+340>:   mov    %eax,%edi
   0x0000000000006706 <+342>:   add    0xc0(%r12),%di
   0x0000000000006712 <+354>:   mov    %di,0xc0(%r12)

251             }
252
253             err = "corrupted btree";
   0x00000000000069b0 <+1024>:  mov    $0x0,%rdx
   0x00000000000069b7 <+1031>:  jmpq   0x6807 <bch_btree_node_read_done+599>
   0x00000000000069bc <+1036>:  nopl   0x0(%rax)

254             for (i = write_block(b);
   0x00000000000068a1 <+753>:   cmp    %rdx,%rcx
   0x00000000000068a4 <+756>:   jae    0x68e5 <bch_btree_node_read_done+821>
   0x00000000000068e0 <+816>:   cmp    %rdx,%rcx
   0x00000000000068e3 <+819>:   jb     0x68c8 <bch_btree_node_read_done+792>

255                  bset_sector_offset(&b->keys, i) < KEY_SIZE(&b->key);
256                  i = ((void *) i) + block_bytes(b->c))
   0x00000000000068d7 <+807>:   mov    %rcx,%rbx
   0x00000000000068da <+810>:   sub    %r8d,%ecx

257                     if (i->seq == b->keys.set[0].data->seq)
   0x00000000000068a6 <+758>:   mov    0x10(%r8),%rdi
   0x00000000000068aa <+762>:   cmp    %rdi,0x10(%rbx)
   0x00000000000068ae <+766>:   je     0x69b0
<bch_btree_node_read_done+1024>
   0x00000000000068b4 <+772>:   cltq
   0x00000000000068b6 <+774>:   mov    %rax,%r9
   0x00000000000068b9 <+777>:   lea    (%rbx,%rax,1),%rcx
   0x00000000000068bd <+781>:   neg    %r9
   0x00000000000068c0 <+784>:   jmp    0x68d7 <bch_btree_node_read_done+807>
   0x00000000000068c2 <+786>:   nopw   0x0(%rax,%rax,1)
   0x00000000000068c8 <+792>:   lea    (%rbx,%rax,1),%rcx
   0x00000000000068cc <+796>:   cmp    0x10(%rcx,%r9,1),%rdi
   0x00000000000068d1 <+801>:   je     0x69b0
<bch_btree_node_read_done+1024>

258                             goto err;
259
260             bch_btree_sort_and_fix_extents(&b->keys, iter, &b->c->sort);
   0x00000000000068e5 <+821>:   lea    0xc8(%r12),%r14
   0x00000000000068ed <+829>:   lea    0xcb60(%rsi),%rdx
   0x00000000000068f4 <+836>:   mov    %r13,%rsi
   0x00000000000068f7 <+839>:   mov    %r14,%rdi
   0x00000000000068fa <+842>:   callq  0x68ff <bch_btree_node_read_done+847>

261
262             i = b->keys.set[0].data;
   0x0000000000006907 <+855>:   mov    0x108(%r12),%rbx

263             err = "short btree key";
   0x00000000000069ec <+1084>:  mov    $0x0,%rdx
   0x00000000000069f3 <+1091>:  jmpq   0x6807 <bch_btree_node_read_done+599>

264             if (b->keys.set[0].size &&
   0x00000000000068ff <+847>:   mov    0xe0(%r12),%eax
   0x0000000000006914 <+868>:   test   %eax,%eax
   0x0000000000006916 <+870>:   je     0x694d <bch_btree_node_read_done+925>
   0x0000000000006944 <+916>:   test   %rax,%rax
   0x0000000000006947 <+919>:   js     0x69ec
<bch_btree_node_read_done+1084>

265                 bkey_cmp(&b->key, &b->keys.set[0].end) < 0)
266                     goto err;
267
268             if (b->written < btree_blocks(b))
   0x000000000000694d <+925>:   mov    0x80(%r12),%rax
   0x0000000000006955 <+933>:   movzwl 0xc0(%r12),%esi
   0x0000000000006965 <+949>:   movzwl 0xde2(%rax),%ecx
   0x000000000000696c <+956>:   shr    %cl,%rdx
   0x000000000000696f <+959>:   cmp    %edx,%esi
   0x0000000000006971 <+961>:   jae    0x6868 <bch_btree_node_read_done+696>

269                     bch_bset_init_next(&b->keys, write_block(b),
   0x000000000000698f <+991>:   mov    %r14,%rdi
   0x000000000000699e <+1006>:  callq  0x69a3
<bch_btree_node_read_done+1011>
   0x00000000000069a3 <+1011>:  mov    0x80(%r12),%rax
   0x00000000000069ab <+1019>:  jmpq   0x6868 <bch_btree_node_read_done+696>

270                                        bset_magic(&b->c->sb));
271     out:
272             mempool_free(iter, b->c->fill_iter);
   0x0000000000006868 <+696>:   mov    0xcb58(%rax),%rsi
   0x000000000000686f <+703>:   mov    %r13,%rdi
   0x0000000000006872 <+706>:   callq  0x6877 <bch_btree_node_read_done+711>

273             return;
274     err:
275             set_btree_node_io_error(b);
276             bch_cache_set_error(b->c, "%s at bucket %zu, block %u,
%u keys",
   0x0000000000006829 <+633>:   mov    0x1c(%rbx),%r9d
   0x000000000000684a <+666>:   mov    %esi,%ecx
   0x000000000000684c <+668>:   mov    $0x0,%rsi
   0x0000000000006853 <+675>:   shr    %cl,%r8d
   0x0000000000006856 <+678>:   mov    %rax,%rcx
   0x0000000000006859 <+681>:   xor    %eax,%eax
   0x000000000000685b <+683>:   callq  0x6860 <bch_btree_node_read_done+688>
   0x0000000000006860 <+688>:   mov    0x80(%r12),%rax

277                                 err, PTR_BUCKET_NR(b->c, &b->key, 0),
278                                 bset_block_offset(b, i), i->keys);
279             goto out;
280     }
   0x0000000000006877 <+711>:   pop    %rbx
   0x0000000000006878 <+712>:   pop    %r12
   0x000000000000687a <+714>:   pop    %r13
   0x000000000000687c <+716>:   pop    %r14
   0x000000000000687e <+718>:   pop    %r15
   0x0000000000006880 <+720>:   pop    %rbp
   0x0000000000006881 <+721>:   retq
   0x0000000000006882 <+722>:   movzwl 0x430(%rsi),%eax
   0x0000000000006889 <+729>:   shl    $0x9,%eax
   0x000000000000688c <+732>:   imul   %eax,%ecx
   0x000000000000688f <+735>:   movslq %ecx,%rbx


On 8/13/2014 1:45 PM, Slava Pestov wrote:
> Can you post the disassembly of the function?
>
> On Wed, Aug 13, 2014 at 11:35 AM, Larkin Lowrey
> <llowrey@nuclearwinter.com> wrote:
>> Thanks. Trying gdb helped me find the answer. I needed to install the
>> kernel-debuginfo-3.15.8-200.fc20.x86_64  package via yum.
>>
>> From addr2line:
>>> bch_btree_node_read_done+0x4c
>>> drivers/md/bcache/btree.c:207
>> Here'a a snippet from gdb:
>>
>>> (gdb) list *(bch_btree_node_read_done+0x4c)
>>> 0x65fc is in bch_btree_node_read_done (drivers/md/bcache/btree.c:207).
>>> 202             struct bset *i = btree_bset_first(b);
>>> 203             struct btree_iter *iter;
>>> 204
>>> 205             iter = mempool_alloc(b->c->fill_iter, GFP_NOWAIT);
>>> 206             iter->size = b->c->sb.bucket_size / b->c->sb.block_size;
>>> 207             iter->used = 0;
>>> 208
>>> 209     #ifdef CONFIG_BCACHE_DEBUG
>>> 210             iter->b = &b->keys;
>>> 211     #endif
>> This doesn't make any sense to me. If iter was null I would expect line
>> 206 to blow up first.
>>
>> --Larkin
>>
>> On 8/13/2014 12:41 PM, Slava Pestov wrote:
>>> You can try to use gdb:
>>>
>>> gdb /lib/modules/.../foo.ko
>>>
>>> list *(bch_btree_node_read_done+0x4c)
>>>
>>>
>>> On Wed, Aug 13, 2014 at 9:40 AM, Larkin Lowrey
>>> <llowrey@nuclearwinter.com> wrote:
>>>> This is making be feel very dumb. I've googled extensively but can't
>>>> figure out how to run addr2line for a module.
>>>>
>>>> I'm running Fedora 20 and the kernel did not have debugging symbols. I
>>>> downloaded the version with symbols but I don't know if the addresses
>>>> are going to be the same. Bcache is a module for me and that's where
>>>> things get tricky. Do you have any tips?
>>>>
>>>> --Larkin
>>>>
>>>> On 8/13/2014 12:04 AM, Kent Overstreet wrote:
>>>>> Any chance you could do an addr2line and get me the exact line where
>>>>> it happened?
>>>>>
>>>>> On Aug 12, 2014 10:02 PM, "Larkin Lowrey" <llowrey@nuclearwinter.com
>>>>> <mailto:llowrey@nuclearwinter.com>> wrote:
>>>>>
>>>>>     I got an oops while doing some heavy I/O. I have an md raid10 cache
>>>>>     device (4 SSDs) and 3 md raid5/6 backing devices. This setup has been
>>>>>     well behaved for about 6 months.
>>>>>
>>>>>     If this isn't a known issue is there anything I can do to provide more
>>>>>     useful information?
>>>>>
>>>>>     I'm running kernel 3.15.8-200.fc20.x86_64.
>>>>>
>>>>>     [210884.047249] BUG: unable to handle kernel NULL pointer
>>>>>     dereference at 0000000000000008
>>>>>     [210884.055605] IP: [<ffffffffa01625fc>]
>>>>>     bch_btree_node_read_done+0x4c/0x450 [bcache]
>>>>>     [210884.063723] PGD 0
>>>>>     [210884.066053] Oops: 0002 [#1] SMP
>>>>>     [210884.069610] Modules linked in: lp parport binfmt_misc
>>>>>     ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat xt_CHECKSUM
>>>>>     iptable_mangle tun bridge stp llc xt_multiport ebtable_nat
>>>>>     ebtables hwmon_vid ip6t_REJECT nf_conntrack_ipv6 nf_conntrack_ipv4
>>>>>     nf_defrag_ipv6 nf_defrag_ipv4 ip6table_filter xt_conntrack
>>>>>     ip6_tables nf_conntrack keyspan ezusb kvm_amd kvm crct10dif_pclmul
>>>>>     crc32_pclmul crc32c_intel ghash_clmulni_intel microcode serio_raw
>>>>>     amd64_edac_mod edac_core fam15h_power k10temp edac_mce_amd
>>>>>     sp5100_tco i2c_piix4 igb ptp pps_core dca shpchp acpi_cpufreq
>>>>>     btrfs bcache raid456 async_raid6_recov async_memcpy async_pq
>>>>>     async_xor async_tx xor raid6_pq raid10 i2c_algo_bit drm_kms_helper
>>>>>     ttm drm i2c_core mpt2sas mvsas libsas raid_class
>>>>>     scsi_transport_sas cpufreq_stats
>>>>>     [210884.140704] CPU: 5 PID: 11188 Comm: kworker/5:1 Not tainted
>>>>>     3.15.8-200.fc20.x86_64 #1
>>>>>     [210884.149069] Hardware name:  /H8DG6/H8DGi, BIOS 3.0a       07/2
>>>>>     [210884.155280] Workqueue: bcache cache_lookup [bcache]
>>>>>     [210884.160531] task: ffff880218633160 ti: ffff8800217b8000
>>>>>     task.ti: ffff8800217b8000
>>>>>     [210884.168502] RIP: 0010:[<ffffffffa01625fc>]
>>>>>      [<ffffffffa01625fc>] bch_btree_node_read_done+0x4c/0x450 [bcache]
>>>>>     [210884.179105] RSP: 0000:ffff8800217bbbe8  EFLAGS: 00010212
>>>>>     [210884.184806] RAX: 0000000000000400 RBX: ffff880245ec0000 RCX:
>>>>>     0000000000000000
>>>>>     [210884.192480] RDX: 0000000000000000 RSI: ffff880418380000 RDI:
>>>>>     0000000000000246
>>>>>     [210884.200075] RBP: ffff8800217bbc10 R08: 0000000000000000 R09:
>>>>>     0000000000000f6b
>>>>>     [210884.207738] R10: 0000000000000000 R11: 0000000000000400 R12:
>>>>>     ffff880413d06c00
>>>>>     [210884.215391] R13: 0000000000000000 R14: ffff8800217bbc20 R15:
>>>>>     ffff880413d06c00
>>>>>     [210884.222961] FS:  00007f73bacd6880(0000)
>>>>>     GS:ffff88021fd40000(0000) knlGS:0000000000000000
>>>>>     [210884.231516] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>>>>>     [210884.237557] CR2: 0000000000000008 CR3: 0000000001c11000 CR4:
>>>>>     00000000000407e0
>>>>>     [210884.245131] Stack:
>>>>>     [210884.247395]  ffff880274f4d020 ffff880413d06c00
>>>>>     0000bfcc44a463f8 ffff8800217bbc20
>>>>>     [210884.255337]  ffff880413d06c00 ffff8800217bbc78
>>>>>     ffffffffa0162b68 0000000000000000
>>>>>     [210884.263256]  ffff880218633160 0000000000000000
>>>>>     0000000000000000 0000000000000000
>>>>>     [210884.271234] Call Trace:
>>>>>     [210884.273985]  [<ffffffffa0162b68>]
>>>>>     bch_btree_node_read+0x168/0x190 [bcache]
>>>>>     [210884.281258]  [<ffffffffa0163f69>]
>>>>>     bch_btree_node_get+0x169/0x290 [bcache]
>>>>>     [210884.288377]  [<ffffffffa01642f5>]
>>>>>     bch_btree_map_keys_recurse+0xd5/0x1d0 [bcache]
>>>>>     [210884.296311]  [<ffffffffa016dcb0>] ?
>>>>>     cached_dev_congested+0x180/0x180 [bcache]
>>>>>     [210884.303953]  [<ffffffff8135b204>] ?
>>>>>     call_rwsem_down_read_failed+0x14/0x30
>>>>>     [210884.311158]  [<ffffffffa01673f7>]
>>>>>     bch_btree_map_keys+0x127/0x150 [bcache]
>>>>>     [210884.318273]  [<ffffffffa016dcb0>] ?
>>>>>     cached_dev_congested+0x180/0x180 [bcache]
>>>>>     [210884.325826]  [<ffffffffa016e7f5>] cache_lookup+0xf5/0x1f0 [bcache]
>>>>>     [210884.332325]  [<ffffffff810a4af6>] process_one_work+0x176/0x430
>>>>>     [210884.338427]  [<ffffffff810a578b>] worker_thread+0x11b/0x3a0
>>>>>     [210884.344282]  [<ffffffff810a5670>] ? rescuer_thread+0x3b0/0x3b0
>>>>>     [210884.350447]  [<ffffffff810ac528>] kthread+0xd8/0xf0
>>>>>     [210884.355615]  [<ffffffff810ac450>] ? insert_kthread_work+0x40/0x40
>>>>>     [210884.362017]  [<ffffffff816ff93c>] ret_from_fork+0x7c/0xb0
>>>>>     [210884.367756]  [<ffffffff810ac450>] ? insert_kthread_work+0x40/0x40
>>>>>     [210884.374234] Code: 08 01 00 00 48 8b b8 58 cb 00 00 e8 bf 25 01
>>>>>     e1 49 8b b4 24 80 00 00 00 49 89 c5 31 d2 0f b7 86 32 04 00 00 66
>>>>>     f7 b6 30 04 00 00 <49> c7 45 08 00 00 00 00 0f b7 c0 49 89 45 00
>>>>>     48 8b 43 10 48 85
>>>>>     [210884.395405] RIP  [<ffffffffa01625fc>]
>>>>>     bch_btree_node_read_done+0x4c/0x450 [bcache]
>>>>>     [210884.403389]  RSP <ffff8800217bbbe8>
>>>>>     [210884.407171] CR2: 0000000000000008
>>>>>     [210884.411233] ---[ end trace 0064e6abfd068c85 ]---
>>>>>     [210884.416352] BUG: unable to handle kernel paging request at
>>>>>     ffffffffffffffd8
>>>>>     [210884.423871] IP: [<ffffffff810acb10>] kthread_data+0x10/0x20
>>>>>     [210884.429915] PGD 1c14067 PUD 1c16067 PMD 0
>>>>>
>>>>>     --Larkin
>>>>>
>>>>>     --
>>>>>     To unsubscribe from this list: send the line "unsubscribe
>>>>>     linux-bcache" in
>>>>>     the body of a message to majordomo@vger.kernel.org
>>>>>     <mailto:majordomo@vger.kernel.org>
>>>>>     More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
