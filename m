From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: [PATCH 07/12] Propagate gfp_t when allocating pte entries from __vmalloc
Date: Mon, 10 Jun 2019 15:14:15 -0400
Message-ID: <20190610191420.27007-8-kent.overstreet@gmail.com>
References: <20190610191420.27007-1-kent.overstreet@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190610191420.27007-1-kent.overstreet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@gmail.com>
List-Id: linux-bcache@vger.kernel.org

This fixes a lockdep recursion when using __vmalloc from places that
aren't GFP_KERNEL safe.

Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
---
 arch/alpha/include/asm/pgalloc.h             | 11 ++---
 arch/arc/include/asm/pgalloc.h               |  9 +---
 arch/arm/include/asm/pgalloc.h               | 11 +++--
 arch/arm/mm/idmap.c                          |  2 +-
 arch/arm/mm/mmu.c                            |  5 +-
 arch/arm/mm/pgd.c                            |  8 +--
 arch/arm64/include/asm/pgalloc.h             | 17 ++++---
 arch/arm64/mm/hugetlbpage.c                  |  8 +--
 arch/csky/include/asm/pgalloc.h              |  4 +-
 arch/hexagon/include/asm/pgalloc.h           |  5 +-
 arch/ia64/include/asm/pgalloc.h              | 14 +++---
 arch/ia64/mm/hugetlbpage.c                   |  4 +-
 arch/ia64/mm/init.c                          |  6 +--
 arch/m68k/include/asm/mcf_pgalloc.h          | 12 ++---
 arch/m68k/include/asm/motorola_pgalloc.h     |  7 +--
 arch/m68k/include/asm/sun3_pgalloc.h         | 12 ++---
 arch/m68k/mm/kmap.c                          |  5 +-
 arch/m68k/sun3x/dvma.c                       |  6 ++-
 arch/microblaze/include/asm/pgalloc.h        |  6 +--
 arch/microblaze/mm/pgtable.c                 |  6 +--
 arch/mips/include/asm/pgalloc.h              | 14 +++---
 arch/mips/mm/hugetlbpage.c                   |  4 +-
 arch/mips/mm/ioremap.c                       |  6 +--
 arch/nds32/include/asm/pgalloc.h             | 14 ++----
 arch/nds32/kernel/dma.c                      |  4 +-
 arch/nios2/include/asm/pgalloc.h             |  8 +--
 arch/nios2/mm/ioremap.c                      |  6 +--
 arch/openrisc/include/asm/pgalloc.h          |  2 +-
 arch/openrisc/mm/ioremap.c                   |  4 +-
 arch/parisc/include/asm/pgalloc.h            | 16 +++---
 arch/parisc/kernel/pci-dma.c                 |  6 +--
 arch/parisc/mm/hugetlbpage.c                 |  4 +-
 arch/powerpc/include/asm/book3s/32/pgalloc.h |  4 +-
 arch/powerpc/include/asm/book3s/64/pgalloc.h | 20 ++++----
 arch/powerpc/include/asm/nohash/32/pgalloc.h |  6 +--
 arch/powerpc/include/asm/nohash/64/pgalloc.h | 14 +++---
 arch/powerpc/kvm/book3s_64_mmu_radix.c       |  2 +-
 arch/powerpc/mm/hugetlbpage.c                |  8 +--
 arch/powerpc/mm/pgtable-book3e.c             |  6 +--
 arch/powerpc/mm/pgtable-book3s64.c           | 14 +++---
 arch/powerpc/mm/pgtable-hash64.c             |  6 +--
 arch/powerpc/mm/pgtable-radix.c              | 12 ++---
 arch/powerpc/mm/pgtable_32.c                 |  6 +--
 arch/riscv/include/asm/pgalloc.h             | 11 ++---
 arch/s390/include/asm/pgalloc.h              | 25 +++++-----
 arch/s390/mm/hugetlbpage.c                   |  6 +--
 arch/s390/mm/pgalloc.c                       | 10 ++--
 arch/s390/mm/pgtable.c                       |  6 +--
 arch/s390/mm/vmem.c                          |  2 +-
 arch/sh/include/asm/pgalloc.h                |  7 +--
 arch/sh/mm/hugetlbpage.c                     |  4 +-
 arch/sh/mm/init.c                            |  4 +-
 arch/sh/mm/pgtable.c                         |  8 ++-
 arch/sparc/include/asm/pgalloc_32.h          |  6 +--
 arch/sparc/include/asm/pgalloc_64.h          | 12 +++--
 arch/sparc/mm/hugetlbpage.c                  |  4 +-
 arch/sparc/mm/init_64.c                      | 10 +---
 arch/sparc/mm/srmmu.c                        |  2 +-
 arch/um/include/asm/pgalloc.h                |  2 +-
 arch/um/include/asm/pgtable-3level.h         |  3 +-
 arch/um/kernel/mem.c                         | 17 ++-----
 arch/um/kernel/skas/mmu.c                    |  4 +-
 arch/unicore32/include/asm/pgalloc.h         |  8 ++-
 arch/unicore32/mm/pgd.c                      |  2 +-
 arch/x86/include/asm/pgalloc.h               | 30 ++++++------
 arch/x86/kernel/espfix_64.c                  |  2 +-
 arch/x86/kernel/tboot.c                      |  6 +--
 arch/x86/mm/pgtable.c                        |  4 +-
 arch/x86/platform/efi/efi_64.c               |  9 ++--
 arch/xtensa/include/asm/pgalloc.h            |  4 +-
 drivers/staging/media/ipu3/ipu3-dmamap.c     |  2 +-
 include/asm-generic/4level-fixup.h           |  6 +--
 include/asm-generic/5level-fixup.h           |  6 +--
 include/asm-generic/pgtable-nop4d-hack.h     |  2 +-
 include/asm-generic/pgtable-nop4d.h          |  2 +-
 include/asm-generic/pgtable-nopmd.h          |  2 +-
 include/asm-generic/pgtable-nopud.h          |  2 +-
 include/linux/mm.h                           | 40 ++++++++-------
 include/linux/vmalloc.h                      |  2 +-
 lib/ioremap.c                                |  8 +--
 mm/hugetlb.c                                 | 11 +++--
 mm/kasan/init.c                              |  8 +--
 mm/memory.c                                  | 51 +++++++++++---------
 mm/migrate.c                                 |  6 +--
 mm/mremap.c                                  |  6 +--
 mm/userfaultfd.c                             |  6 +--
 mm/vmalloc.c                                 | 49 +++++++++++--------
 mm/zsmalloc.c                                |  2 +-
 virt/kvm/arm/mmu.c                           |  6 +--
 89 files changed, 377 insertions(+), 392 deletions(-)

diff --git a/arch/alpha/include/asm/pgalloc.h b/arch/alpha/include/asm/pgalloc.h
index 02f9f91bb4..6b8336865e 100644
--- a/arch/alpha/include/asm/pgalloc.h
+++ b/arch/alpha/include/asm/pgalloc.h
@@ -39,9 +39,9 @@ pgd_free(struct mm_struct *mm, pgd_t *pgd)
 }
 
 static inline pmd_t *
-pmd_alloc_one(struct mm_struct *mm, unsigned long address)
+pmd_alloc_one(struct mm_struct *mm, unsigned long address, gfp_t gfp)
 {
-	pmd_t *ret = (pmd_t *)__get_free_page(GFP_KERNEL|__GFP_ZERO);
+	pmd_t *ret = (pmd_t *)get_zeroed_page(gfp);
 	return ret;
 }
 
@@ -52,10 +52,9 @@ pmd_free(struct mm_struct *mm, pmd_t *pmd)
 }
 
 static inline pte_t *
-pte_alloc_one_kernel(struct mm_struct *mm)
+pte_alloc_one_kernel(struct mm_struct *mm, gfp_t gfp)
 {
-	pte_t *pte = (pte_t *)__get_free_page(GFP_KERNEL|__GFP_ZERO);
-	return pte;
+	return (pte_t *)get_zeroed_page(gfp);
 }
 
 static inline void
@@ -67,7 +66,7 @@ pte_free_kernel(struct mm_struct *mm, pte_t *pte)
 static inline pgtable_t
 pte_alloc_one(struct mm_struct *mm)
 {
-	pte_t *pte = pte_alloc_one_kernel(mm);
+	pte_t *pte = pte_alloc_one_kernel(mm, GFP_KERNEL);
 	struct page *page;
 
 	if (!pte)
diff --git a/arch/arc/include/asm/pgalloc.h b/arch/arc/include/asm/pgalloc.h
index 9c9b5a5ebf..491535bb2b 100644
--- a/arch/arc/include/asm/pgalloc.h
+++ b/arch/arc/include/asm/pgalloc.h
@@ -90,14 +90,9 @@ static inline int __get_order_pte(void)
 	return get_order(PTRS_PER_PTE * sizeof(pte_t));
 }
 
-static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm)
+static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm, gfp_t gfp)
 {
-	pte_t *pte;
-
-	pte = (pte_t *) __get_free_pages(GFP_KERNEL | __GFP_ZERO,
-					 __get_order_pte());
-
-	return pte;
+	return (pte_t *) __get_free_pages(gfp|__GFP_ZERO, __get_order_pte());
 }
 
 static inline pgtable_t
diff --git a/arch/arm/include/asm/pgalloc.h b/arch/arm/include/asm/pgalloc.h
index 17ab72f0cc..f21ba862f6 100644
--- a/arch/arm/include/asm/pgalloc.h
+++ b/arch/arm/include/asm/pgalloc.h
@@ -27,9 +27,10 @@
 
 #ifdef CONFIG_ARM_LPAE
 
-static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
+static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr,
+				   gfp_t gfp)
 {
-	return (pmd_t *)get_zeroed_page(GFP_KERNEL);
+	return (pmd_t *)get_zeroed_page(gfp);
 }
 
 static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
@@ -48,7 +49,7 @@ static inline void pud_populate(struct mm_struct *mm, pud_t *pud, pmd_t *pmd)
 /*
  * Since we have only two-level page tables, these are trivial
  */
-#define pmd_alloc_one(mm,addr)		({ BUG(); ((pmd_t *)2); })
+#define pmd_alloc_one(mm,addr,gfp)	({ BUG(); ((pmd_t *)2); })
 #define pmd_free(mm, pmd)		do { } while (0)
 #define pud_populate(mm,pmd,pte)	BUG()
 
@@ -81,11 +82,11 @@ static inline void clean_pte_table(pte_t *pte)
  *  +------------+
  */
 static inline pte_t *
-pte_alloc_one_kernel(struct mm_struct *mm)
+pte_alloc_one_kernel(struct mm_struct *mm, gfp_t gfp)
 {
 	pte_t *pte;
 
-	pte = (pte_t *)__get_free_page(PGALLOC_GFP);
+	pte = (pte_t *)get_zeroed_page(gfp);
 	if (pte)
 		clean_pte_table(pte);
 
diff --git a/arch/arm/mm/idmap.c b/arch/arm/mm/idmap.c
index a033f6134a..b90d2deedc 100644
--- a/arch/arm/mm/idmap.c
+++ b/arch/arm/mm/idmap.c
@@ -28,7 +28,7 @@ static void idmap_add_pmd(pud_t *pud, unsigned long addr, unsigned long end,
 	unsigned long next;
 
 	if (pud_none_or_clear_bad(pud) || (pud_val(*pud) & L_PGD_SWAPPER)) {
-		pmd = pmd_alloc_one(&init_mm, addr);
+		pmd = pmd_alloc_one(&init_mm, addr, GFP_KERNEL);
 		if (!pmd) {
 			pr_warn("Failed to allocate identity pmd.\n");
 			return;
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index f3ce34113f..7cc18e5174 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -979,10 +979,11 @@ void __init create_mapping_late(struct mm_struct *mm, struct map_desc *md,
 				bool ng)
 {
 #ifdef CONFIG_ARM_LPAE
-	pud_t *pud = pud_alloc(mm, pgd_offset(mm, md->virtual), md->virtual);
+	pud_t *pud = pud_alloc(mm, pgd_offset(mm, md->virtual), md->virtual,
+			       GFP_KERNEL);
 	if (WARN_ON(!pud))
 		return;
-	pmd_alloc(mm, pud, 0);
+	pmd_alloc(mm, pud, 0, GFP_KERNEL);
 #endif
 	__create_mapping(mm, md, late_alloc, ng);
 }
diff --git a/arch/arm/mm/pgd.c b/arch/arm/mm/pgd.c
index a1606d9502..6c3a640672 100644
--- a/arch/arm/mm/pgd.c
+++ b/arch/arm/mm/pgd.c
@@ -57,11 +57,11 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 	 * Allocate PMD table for modules and pkmap mappings.
 	 */
 	new_pud = pud_alloc(mm, new_pgd + pgd_index(MODULES_VADDR),
-			    MODULES_VADDR);
+			    MODULES_VADDR, GFP_KERNEL);
 	if (!new_pud)
 		goto no_pud;
 
-	new_pmd = pmd_alloc(mm, new_pud, 0);
+	new_pmd = pmd_alloc(mm, new_pud, 0, GFP_KERNEL);
 	if (!new_pmd)
 		goto no_pmd;
 #endif
@@ -72,11 +72,11 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 		 * contains the machine vectors. The vectors are always high
 		 * with LPAE.
 		 */
-		new_pud = pud_alloc(mm, new_pgd, 0);
+		new_pud = pud_alloc(mm, new_pgd, 0, GFP_KERNEL);
 		if (!new_pud)
 			goto no_pud;
 
-		new_pmd = pmd_alloc(mm, new_pud, 0);
+		new_pmd = pmd_alloc(mm, new_pud, 0, GFP_KERNEL);
 		if (!new_pmd)
 			goto no_pmd;
 
diff --git a/arch/arm64/include/asm/pgalloc.h b/arch/arm64/include/asm/pgalloc.h
index 52fa47c73b..54199d52ea 100644
--- a/arch/arm64/include/asm/pgalloc.h
+++ b/arch/arm64/include/asm/pgalloc.h
@@ -26,14 +26,14 @@
 
 #define check_pgt_cache()		do { } while (0)
 
-#define PGALLOC_GFP	(GFP_KERNEL | __GFP_ZERO)
 #define PGD_SIZE	(PTRS_PER_PGD * sizeof(pgd_t))
 
 #if CONFIG_PGTABLE_LEVELS > 2
 
-static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
+static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr,
+				   gfp_t gfp)
 {
-	return (pmd_t *)__get_free_page(PGALLOC_GFP);
+	return (pmd_t *)get_zeroed_page(gfp);
 }
 
 static inline void pmd_free(struct mm_struct *mm, pmd_t *pmdp)
@@ -60,9 +60,10 @@ static inline void __pud_populate(pud_t *pudp, phys_addr_t pmdp, pudval_t prot)
 
 #if CONFIG_PGTABLE_LEVELS > 3
 
-static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long addr)
+static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long addr,
+				   gfp_t gfp)
 {
-	return (pud_t *)__get_free_page(PGALLOC_GFP);
+	return (pud_t *)get_zeroed_page(gfp);
 }
 
 static inline void pud_free(struct mm_struct *mm, pud_t *pudp)
@@ -91,9 +92,9 @@ extern pgd_t *pgd_alloc(struct mm_struct *mm);
 extern void pgd_free(struct mm_struct *mm, pgd_t *pgdp);
 
 static inline pte_t *
-pte_alloc_one_kernel(struct mm_struct *mm)
+pte_alloc_one_kernel(struct mm_struct *mm, gfp_t gfp)
 {
-	return (pte_t *)__get_free_page(PGALLOC_GFP);
+	return (pte_t *)get_zeroed_page(gfp);
 }
 
 static inline pgtable_t
@@ -101,7 +102,7 @@ pte_alloc_one(struct mm_struct *mm)
 {
 	struct page *pte;
 
-	pte = alloc_pages(PGALLOC_GFP, 0);
+	pte = alloc_pages(GFP_KERNEL|__GFP_ZERO, 0);
 	if (!pte)
 		return NULL;
 	if (!pgtable_page_ctor(pte)) {
diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
index 6b4a47b3ad..0a17776894 100644
--- a/arch/arm64/mm/hugetlbpage.c
+++ b/arch/arm64/mm/hugetlbpage.c
@@ -230,14 +230,14 @@ pte_t *huge_pte_alloc(struct mm_struct *mm,
 	pte_t *ptep = NULL;
 
 	pgdp = pgd_offset(mm, addr);
-	pudp = pud_alloc(mm, pgdp, addr);
+	pudp = pud_alloc(mm, pgdp, addr, GFP_KERNEL);
 	if (!pudp)
 		return NULL;
 
 	if (sz == PUD_SIZE) {
 		ptep = (pte_t *)pudp;
 	} else if (sz == (PAGE_SIZE * CONT_PTES)) {
-		pmdp = pmd_alloc(mm, pudp, addr);
+		pmdp = pmd_alloc(mm, pudp, addr, GFP_KERNEL);
 
 		WARN_ON(addr & (sz - 1));
 		/*
@@ -253,9 +253,9 @@ pte_t *huge_pte_alloc(struct mm_struct *mm,
 		    pud_none(READ_ONCE(*pudp)))
 			ptep = huge_pmd_share(mm, addr, pudp);
 		else
-			ptep = (pte_t *)pmd_alloc(mm, pudp, addr);
+			ptep = (pte_t *)pmd_alloc(mm, pudp, addr, GFP_KERNEL);
 	} else if (sz == (PMD_SIZE * CONT_PMDS)) {
-		pmdp = pmd_alloc(mm, pudp, addr);
+		pmdp = pmd_alloc(mm, pudp, addr, GFP_KERNEL);
 		WARN_ON(addr & (sz - 1));
 		return (pte_t *)pmdp;
 	}
diff --git a/arch/csky/include/asm/pgalloc.h b/arch/csky/include/asm/pgalloc.h
index d213bb47b7..1611a84be5 100644
--- a/arch/csky/include/asm/pgalloc.h
+++ b/arch/csky/include/asm/pgalloc.h
@@ -24,12 +24,12 @@ static inline void pmd_populate(struct mm_struct *mm, pmd_t *pmd,
 
 extern void pgd_init(unsigned long *p);
 
-static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm)
+static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm, gfp_t gfp)
 {
 	pte_t *pte;
 	unsigned long i;
 
-	pte = (pte_t *) __get_free_page(GFP_KERNEL);
+	pte = (pte_t *) __get_free_page(gfp);
 	if (!pte)
 		return NULL;
 
diff --git a/arch/hexagon/include/asm/pgalloc.h b/arch/hexagon/include/asm/pgalloc.h
index d36183887b..2c42f912f4 100644
--- a/arch/hexagon/include/asm/pgalloc.h
+++ b/arch/hexagon/include/asm/pgalloc.h
@@ -74,10 +74,9 @@ static inline struct page *pte_alloc_one(struct mm_struct *mm)
 }
 
 /* _kernel variant gets to use a different allocator */
-static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm)
+static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm, gfp_t gfp)
 {
-	gfp_t flags =  GFP_KERNEL | __GFP_ZERO;
-	return (pte_t *) __get_free_page(flags);
+	return (pte_t *) get_zeroed_page(gfp);
 }
 
 static inline void pte_free(struct mm_struct *mm, struct page *pte)
diff --git a/arch/ia64/include/asm/pgalloc.h b/arch/ia64/include/asm/pgalloc.h
index c9e481023c..dd99d58a89 100644
--- a/arch/ia64/include/asm/pgalloc.h
+++ b/arch/ia64/include/asm/pgalloc.h
@@ -40,9 +40,10 @@ pgd_populate(struct mm_struct *mm, pgd_t * pgd_entry, pud_t * pud)
 	pgd_val(*pgd_entry) = __pa(pud);
 }
 
-static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long addr)
+static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long addr,
+				   gfp_t gfp)
 {
-	return quicklist_alloc(0, GFP_KERNEL, NULL);
+	return quicklist_alloc(0, gfp, NULL);
 }
 
 static inline void pud_free(struct mm_struct *mm, pud_t *pud)
@@ -58,9 +59,10 @@ pud_populate(struct mm_struct *mm, pud_t * pud_entry, pmd_t * pmd)
 	pud_val(*pud_entry) = __pa(pmd);
 }
 
-static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
+static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr,
+				   gfp_t gfp)
 {
-	return quicklist_alloc(0, GFP_KERNEL, NULL);
+	return quicklist_alloc(0, gfp, NULL);
 }
 
 static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
@@ -99,9 +101,9 @@ static inline pgtable_t pte_alloc_one(struct mm_struct *mm)
 	return page;
 }
 
-static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm)
+static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm, gfp_t gfp)
 {
-	return quicklist_alloc(0, GFP_KERNEL, NULL);
+	return quicklist_alloc(0, gfp, NULL);
 }
 
 static inline void pte_free(struct mm_struct *mm, pgtable_t pte)
diff --git a/arch/ia64/mm/hugetlbpage.c b/arch/ia64/mm/hugetlbpage.c
index d16e419fd7..01e08edc9d 100644
--- a/arch/ia64/mm/hugetlbpage.c
+++ b/arch/ia64/mm/hugetlbpage.c
@@ -35,9 +35,9 @@ huge_pte_alloc(struct mm_struct *mm, unsigned long addr, unsigned long sz)
 	pte_t *pte = NULL;
 
 	pgd = pgd_offset(mm, taddr);
-	pud = pud_alloc(mm, pgd, taddr);
+	pud = pud_alloc(mm, pgd, taddr, GFP_KERNEL);
 	if (pud) {
-		pmd = pmd_alloc(mm, pud, taddr);
+		pmd = pmd_alloc(mm, pud, taddr, GFP_KERNEL);
 		if (pmd)
 			pte = pte_alloc_map(mm, pmd, taddr);
 	}
diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
index e49200e317..a420c0d04f 100644
--- a/arch/ia64/mm/init.c
+++ b/arch/ia64/mm/init.c
@@ -216,13 +216,13 @@ put_kernel_page (struct page *page, unsigned long address, pgprot_t pgprot)
 	pgd = pgd_offset_k(address);		/* note: this is NOT pgd_offset()! */
 
 	{
-		pud = pud_alloc(&init_mm, pgd, address);
+		pud = pud_alloc(&init_mm, pgd, address, GFP_KERNEL);
 		if (!pud)
 			goto out;
-		pmd = pmd_alloc(&init_mm, pud, address);
+		pmd = pmd_alloc(&init_mm, pud, address, GFP_KERNEL);
 		if (!pmd)
 			goto out;
-		pte = pte_alloc_kernel(pmd, address);
+		pte = pte_alloc_kernel(pmd, address, GFP_KERNEL);
 		if (!pte)
 			goto out;
 		if (!pte_none(*pte))
diff --git a/arch/m68k/include/asm/mcf_pgalloc.h b/arch/m68k/include/asm/mcf_pgalloc.h
index 4399d712f6..95384360cf 100644
--- a/arch/m68k/include/asm/mcf_pgalloc.h
+++ b/arch/m68k/include/asm/mcf_pgalloc.h
@@ -12,15 +12,9 @@ extern inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
 
 extern const char bad_pmd_string[];
 
-extern inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm)
+extern inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm, gfp_t gfp)
 {
-	unsigned long page = __get_free_page(GFP_DMA);
-
-	if (!page)
-		return NULL;
-
-	memset((void *)page, 0, PAGE_SIZE);
-	return (pte_t *) (page);
+	return (pte_t *) get_zeroed_page(gfp|GFP_DMA);
 }
 
 extern inline pmd_t *pmd_alloc_kernel(pgd_t *pgd, unsigned long address)
@@ -29,7 +23,7 @@ extern inline pmd_t *pmd_alloc_kernel(pgd_t *pgd, unsigned long address)
 }
 
 #define pmd_alloc_one_fast(mm, address) ({ BUG(); ((pmd_t *)1); })
-#define pmd_alloc_one(mm, address)      ({ BUG(); ((pmd_t *)2); })
+#define pmd_alloc_one(mm, address, gfp) ({ BUG(); ((pmd_t *)2); })
 
 #define pmd_populate(mm, pmd, page) (pmd_val(*pmd) = \
 	(unsigned long)(page_address(page)))
diff --git a/arch/m68k/include/asm/motorola_pgalloc.h b/arch/m68k/include/asm/motorola_pgalloc.h
index d04d9ba9b9..e9b598f96b 100644
--- a/arch/m68k/include/asm/motorola_pgalloc.h
+++ b/arch/m68k/include/asm/motorola_pgalloc.h
@@ -8,11 +8,11 @@
 extern pmd_t *get_pointer_table(void);
 extern int free_pointer_table(pmd_t *);
 
-static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm)
+static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm, gfp_t gfp)
 {
 	pte_t *pte;
 
-	pte = (pte_t *)__get_free_page(GFP_KERNEL|__GFP_ZERO);
+	pte = (pte_t *)get_zeroed_page(gfp);
 	if (pte) {
 		__flush_page_to_ram(pte);
 		flush_tlb_kernel_page(pte);
@@ -67,7 +67,8 @@ static inline void __pte_free_tlb(struct mmu_gather *tlb, pgtable_t page,
 }
 
 
-static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
+static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address,
+				   gfp_t gfp)
 {
 	return get_pointer_table();
 }
diff --git a/arch/m68k/include/asm/sun3_pgalloc.h b/arch/m68k/include/asm/sun3_pgalloc.h
index 1456c5eecb..18324d4a33 100644
--- a/arch/m68k/include/asm/sun3_pgalloc.h
+++ b/arch/m68k/include/asm/sun3_pgalloc.h
@@ -15,7 +15,7 @@
 
 extern const char bad_pmd_string[];
 
-#define pmd_alloc_one(mm,address)       ({ BUG(); ((pmd_t *)2); })
+#define pmd_alloc_one(mm,address,gfp)       ({ BUG(); ((pmd_t *)2); })
 
 
 static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
@@ -35,15 +35,9 @@ do {							\
 	tlb_remove_page((tlb), pte);			\
 } while (0)
 
-static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm)
+static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm, gfp_t gfp)
 {
-	unsigned long page = __get_free_page(GFP_KERNEL);
-
-	if (!page)
-		return NULL;
-
-	memset((void *)page, 0, PAGE_SIZE);
-	return (pte_t *) (page);
+	return (pte_t *) get_zeroed_page(gfp);
 }
 
 static inline pgtable_t pte_alloc_one(struct mm_struct *mm)
diff --git a/arch/m68k/mm/kmap.c b/arch/m68k/mm/kmap.c
index 40a3b327da..8de716049a 100644
--- a/arch/m68k/mm/kmap.c
+++ b/arch/m68k/mm/kmap.c
@@ -196,7 +196,7 @@ void __iomem *__ioremap(unsigned long physaddr, unsigned long size, int cachefla
 			printk ("\npa=%#lx va=%#lx ", physaddr, virtaddr);
 #endif
 		pgd_dir = pgd_offset_k(virtaddr);
-		pmd_dir = pmd_alloc(&init_mm, pgd_dir, virtaddr);
+		pmd_dir = pmd_alloc(&init_mm, pgd_dir, virtaddr, GFP_KERNEL);
 		if (!pmd_dir) {
 			printk("ioremap: no mem for pmd_dir\n");
 			return NULL;
@@ -208,7 +208,8 @@ void __iomem *__ioremap(unsigned long physaddr, unsigned long size, int cachefla
 			virtaddr += PTRTREESIZE;
 			size -= PTRTREESIZE;
 		} else {
-			pte_dir = pte_alloc_kernel(pmd_dir, virtaddr);
+			pte_dir = pte_alloc_kernel(pmd_dir, virtaddr,
+						   GFP_KERNEL);
 			if (!pte_dir) {
 				printk("ioremap: no mem for pte_dir\n");
 				return NULL;
diff --git a/arch/m68k/sun3x/dvma.c b/arch/m68k/sun3x/dvma.c
index 89e630e665..86ffbe2785 100644
--- a/arch/m68k/sun3x/dvma.c
+++ b/arch/m68k/sun3x/dvma.c
@@ -95,7 +95,8 @@ inline int dvma_map_cpu(unsigned long kaddr,
 		pmd_t *pmd;
 		unsigned long end2;
 
-		if((pmd = pmd_alloc(&init_mm, pgd, vaddr)) == NULL) {
+		pmd = pmd_alloc(&init_mm, pgd, vaddr, GFP_KERNEL);
+		if (!pmd) {
 			ret = -ENOMEM;
 			goto out;
 		}
@@ -109,7 +110,8 @@ inline int dvma_map_cpu(unsigned long kaddr,
 			pte_t *pte;
 			unsigned long end3;
 
-			if((pte = pte_alloc_kernel(pmd, vaddr)) == NULL) {
+			pte = pte_alloc_kernel(pmd, vaddr, GFP_KERNEL);
+			if (!pte) {
 				ret = -ENOMEM;
 				goto out;
 			}
diff --git a/arch/microblaze/include/asm/pgalloc.h b/arch/microblaze/include/asm/pgalloc.h
index f4cc9ffc44..240e0bcd14 100644
--- a/arch/microblaze/include/asm/pgalloc.h
+++ b/arch/microblaze/include/asm/pgalloc.h
@@ -106,9 +106,9 @@ static inline void free_pgd_slow(pgd_t *pgd)
  * the pgd will always be present..
  */
 #define pmd_alloc_one_fast(mm, address)	({ BUG(); ((pmd_t *)1); })
-#define pmd_alloc_one(mm, address)	({ BUG(); ((pmd_t *)2); })
+#define pmd_alloc_one(mm, address, gfp)	({ BUG(); ((pmd_t *)2); })
 
-extern pte_t *pte_alloc_one_kernel(struct mm_struct *mm);
+extern pte_t *pte_alloc_one_kernel(struct mm_struct *mm, gfp_t gfp);
 
 static inline struct page *pte_alloc_one(struct mm_struct *mm)
 {
@@ -166,7 +166,7 @@ static inline void pte_free(struct mm_struct *mm, struct page *ptepage)
  * We don't have any real pmd's, and this code never triggers because
  * the pgd will always be present..
  */
-#define pmd_alloc_one(mm, address)	({ BUG(); ((pmd_t *)2); })
+#define pmd_alloc_one(mm, address, gfp)	({ BUG(); ((pmd_t *)2); })
 #define pmd_free(mm, x)			do { } while (0)
 #define __pmd_free_tlb(tlb, x, addr)	pmd_free((tlb)->mm, x)
 #define pgd_populate(mm, pmd, pte)	BUG()
diff --git a/arch/microblaze/mm/pgtable.c b/arch/microblaze/mm/pgtable.c
index c2ce1e42b8..796c422af7 100644
--- a/arch/microblaze/mm/pgtable.c
+++ b/arch/microblaze/mm/pgtable.c
@@ -144,7 +144,7 @@ int map_page(unsigned long va, phys_addr_t pa, int flags)
 	/* Use upper 10 bits of VA to index the first level map */
 	pd = pmd_offset(pgd_offset_k(va), va);
 	/* Use middle 10 bits of VA to index the second-level map */
-	pg = pte_alloc_kernel(pd, va); /* from powerpc - pgtable.c */
+	pg = pte_alloc_kernel(pd, va, GFP_KERNEL); /* from powerpc - pgtable.c */
 	/* pg = pte_alloc_kernel(&init_mm, pd, va); */
 
 	if (pg != NULL) {
@@ -235,11 +235,11 @@ unsigned long iopa(unsigned long addr)
 	return pa;
 }
 
-__ref pte_t *pte_alloc_one_kernel(struct mm_struct *mm)
+__ref pte_t *pte_alloc_one_kernel(struct mm_struct *mm, gfp_t gfp)
 {
 	pte_t *pte;
 	if (mem_init_done) {
-		pte = (pte_t *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
+		pte = (pte_t *)get_zeroed_page(gfp);
 	} else {
 		pte = (pte_t *)early_get_page();
 		if (pte)
diff --git a/arch/mips/include/asm/pgalloc.h b/arch/mips/include/asm/pgalloc.h
index 27808d9461..7e832f978a 100644
--- a/arch/mips/include/asm/pgalloc.h
+++ b/arch/mips/include/asm/pgalloc.h
@@ -50,9 +50,9 @@ static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 	free_pages((unsigned long)pgd, PGD_ORDER);
 }
 
-static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm)
+static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm, gfp_t gfp)
 {
-	return (pte_t *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, PTE_ORDER);
+	return (pte_t *)__get_free_pages(gfp | __GFP_ZERO, PTE_ORDER);
 }
 
 static inline struct page *pte_alloc_one(struct mm_struct *mm)
@@ -89,11 +89,12 @@ do {							\
 
 #ifndef __PAGETABLE_PMD_FOLDED
 
-static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
+static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address,
+				   gfp_t gfp)
 {
 	pmd_t *pmd;
 
-	pmd = (pmd_t *) __get_free_pages(GFP_KERNEL, PMD_ORDER);
+	pmd = (pmd_t *) __get_free_pages(gfp, PMD_ORDER);
 	if (pmd)
 		pmd_init((unsigned long)pmd, (unsigned long)invalid_pte_table);
 	return pmd;
@@ -110,11 +111,12 @@ static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
 
 #ifndef __PAGETABLE_PUD_FOLDED
 
-static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long address)
+static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long address,
+				   gfp_t gfp)
 {
 	pud_t *pud;
 
-	pud = (pud_t *) __get_free_pages(GFP_KERNEL, PUD_ORDER);
+	pud = (pud_t *) __get_free_pages(gfp, PUD_ORDER);
 	if (pud)
 		pud_init((unsigned long)pud, (unsigned long)invalid_pmd_table);
 	return pud;
diff --git a/arch/mips/mm/hugetlbpage.c b/arch/mips/mm/hugetlbpage.c
index cef1522343..27843e10f6 100644
--- a/arch/mips/mm/hugetlbpage.c
+++ b/arch/mips/mm/hugetlbpage.c
@@ -29,9 +29,9 @@ pte_t *huge_pte_alloc(struct mm_struct *mm, unsigned long addr,
 	pte_t *pte = NULL;
 
 	pgd = pgd_offset(mm, addr);
-	pud = pud_alloc(mm, pgd, addr);
+	pud = pud_alloc(mm, pgd, addr, GFP_KERNEL);
 	if (pud)
-		pte = (pte_t *)pmd_alloc(mm, pud, addr);
+		pte = (pte_t *)pmd_alloc(mm, pud, addr, GFP_KERNEL);
 
 	return pte;
 }
diff --git a/arch/mips/mm/ioremap.c b/arch/mips/mm/ioremap.c
index 1601d90b08..40da8f0ba7 100644
--- a/arch/mips/mm/ioremap.c
+++ b/arch/mips/mm/ioremap.c
@@ -56,7 +56,7 @@ static inline int remap_area_pmd(pmd_t * pmd, unsigned long address,
 	phys_addr -= address;
 	BUG_ON(address >= end);
 	do {
-		pte_t * pte = pte_alloc_kernel(pmd, address);
+		pte_t *pte = pte_alloc_kernel(pmd, address, GFP_KERNEL);
 		if (!pte)
 			return -ENOMEM;
 		remap_area_pte(pte, address, end - address, address + phys_addr, flags);
@@ -82,10 +82,10 @@ static int remap_area_pages(unsigned long address, phys_addr_t phys_addr,
 		pmd_t *pmd;
 
 		error = -ENOMEM;
-		pud = pud_alloc(&init_mm, dir, address);
+		pud = pud_alloc(&init_mm, dir, address, GFP_KERNEL);
 		if (!pud)
 			break;
-		pmd = pmd_alloc(&init_mm, pud, address);
+		pmd = pmd_alloc(&init_mm, pud, address, GFP_KERNEL);
 		if (!pmd)
 			break;
 		if (remap_area_pmd(pmd, address, end - address,
diff --git a/arch/nds32/include/asm/pgalloc.h b/arch/nds32/include/asm/pgalloc.h
index 3c5fee5b57..b187a2f127 100644
--- a/arch/nds32/include/asm/pgalloc.h
+++ b/arch/nds32/include/asm/pgalloc.h
@@ -12,8 +12,8 @@
 /*
  * Since we have only two-level page tables, these are trivial
  */
-#define pmd_alloc_one(mm, addr)		({ BUG(); ((pmd_t *)2); })
-#define pmd_free(mm, pmd)			do { } while (0)
+#define pmd_alloc_one(mm, addr, gfp)	({ BUG(); ((pmd_t *)2); })
+#define pmd_free(mm, pmd)		do { } while (0)
 #define pgd_populate(mm, pmd, pte)	BUG()
 #define pmd_pgtable(pmd) pmd_page(pmd)
 
@@ -22,15 +22,9 @@ extern void pgd_free(struct mm_struct *mm, pgd_t * pgd);
 
 #define check_pgt_cache()		do { } while (0)
 
-static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm)
+static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm, gfp_t gfp)
 {
-	pte_t *pte;
-
-	pte =
-	    (pte_t *) __get_free_page(GFP_KERNEL | __GFP_RETRY_MAYFAIL |
-				      __GFP_ZERO);
-
-	return pte;
+	return (pte_t *) get_zeroed_page(gfp | __GFP_RETRY_MAYFAIL);
 }
 
 static inline pgtable_t pte_alloc_one(struct mm_struct *mm)
diff --git a/arch/nds32/kernel/dma.c b/arch/nds32/kernel/dma.c
index d0dbd4fe96..920a003762 100644
--- a/arch/nds32/kernel/dma.c
+++ b/arch/nds32/kernel/dma.c
@@ -300,7 +300,7 @@ static int __init consistent_init(void)
 
 	do {
 		pgd = pgd_offset(&init_mm, CONSISTENT_BASE);
-		pmd = pmd_alloc(&init_mm, pgd, CONSISTENT_BASE);
+		pmd = pmd_alloc(&init_mm, pgd, CONSISTENT_BASE, GFP_KERNEL);
 		if (!pmd) {
 			pr_err("%s: no pmd tables\n", __func__);
 			ret = -ENOMEM;
@@ -310,7 +310,7 @@ static int __init consistent_init(void)
 		 * It's not necessary to warn here. */
 		/* WARN_ON(!pmd_none(*pmd)); */
 
-		pte = pte_alloc_kernel(pmd, CONSISTENT_BASE);
+		pte = pte_alloc_kernel(pmd, CONSISTENT_BASE, GFP_KERNEL);
 		if (!pte) {
 			ret = -ENOMEM;
 			break;
diff --git a/arch/nios2/include/asm/pgalloc.h b/arch/nios2/include/asm/pgalloc.h
index 3a149ead12..2ce9bd5399 100644
--- a/arch/nios2/include/asm/pgalloc.h
+++ b/arch/nios2/include/asm/pgalloc.h
@@ -37,13 +37,9 @@ static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 	free_pages((unsigned long)pgd, PGD_ORDER);
 }
 
-static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm)
+static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm, gf_t gfp)
 {
-	pte_t *pte;
-
-	pte = (pte_t *) __get_free_pages(GFP_KERNEL|__GFP_ZERO, PTE_ORDER);
-
-	return pte;
+	return (pte_t *)__get_free_pages(gfp|__GFP_ZERO, PTE_ORDER);
 }
 
 static inline pgtable_t pte_alloc_one(struct mm_struct *mm)
diff --git a/arch/nios2/mm/ioremap.c b/arch/nios2/mm/ioremap.c
index 3a28177a01..50c38da029 100644
--- a/arch/nios2/mm/ioremap.c
+++ b/arch/nios2/mm/ioremap.c
@@ -61,7 +61,7 @@ static inline int remap_area_pmd(pmd_t *pmd, unsigned long address,
 	if (address >= end)
 		BUG();
 	do {
-		pte_t *pte = pte_alloc_kernel(pmd, address);
+		pte_t *pte = pte_alloc_kernel(pmd, address, GFP_KERNEL);
 
 		if (!pte)
 			return -ENOMEM;
@@ -90,10 +90,10 @@ static int remap_area_pages(unsigned long address, unsigned long phys_addr,
 		pmd_t *pmd;
 
 		error = -ENOMEM;
-		pud = pud_alloc(&init_mm, dir, address);
+		pud = pud_alloc(&init_mm, dir, address, GFP_KERNEL);
 		if (!pud)
 			break;
-		pmd = pmd_alloc(&init_mm, pud, address);
+		pmd = pmd_alloc(&init_mm, pud, address, GFP_KERNEL);
 		if (!pmd)
 			break;
 		if (remap_area_pmd(pmd, address, end - address,
diff --git a/arch/openrisc/include/asm/pgalloc.h b/arch/openrisc/include/asm/pgalloc.h
index 149c82ee4b..f33f2a4504 100644
--- a/arch/openrisc/include/asm/pgalloc.h
+++ b/arch/openrisc/include/asm/pgalloc.h
@@ -70,7 +70,7 @@ static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 	free_page((unsigned long)pgd);
 }
 
-extern pte_t *pte_alloc_one_kernel(struct mm_struct *mm);
+extern pte_t *pte_alloc_one_kernel(struct mm_struct *mm, gfp_t gfp);
 
 static inline struct page *pte_alloc_one(struct mm_struct *mm)
 {
diff --git a/arch/openrisc/mm/ioremap.c b/arch/openrisc/mm/ioremap.c
index a8509950db..93d295d26a 100644
--- a/arch/openrisc/mm/ioremap.c
+++ b/arch/openrisc/mm/ioremap.c
@@ -118,12 +118,12 @@ EXPORT_SYMBOL(iounmap);
  * the memblock infrastructure.
  */
 
-pte_t __ref *pte_alloc_one_kernel(struct mm_struct *mm)
+pte_t __ref *pte_alloc_one_kernel(struct mm_struct *mm, gfp_t gfp)
 {
 	pte_t *pte;
 
 	if (likely(mem_init_done)) {
-		pte = (pte_t *)get_zeroed_page(GFP_KERNEL);
+		pte = (pte_t *)get_zeroed_page(gfp);
 	} else {
 		pte = memblock_alloc(PAGE_SIZE, PAGE_SIZE);
 		if (!pte)
diff --git a/arch/parisc/include/asm/pgalloc.h b/arch/parisc/include/asm/pgalloc.h
index d05c678c77..705f5fffbd 100644
--- a/arch/parisc/include/asm/pgalloc.h
+++ b/arch/parisc/include/asm/pgalloc.h
@@ -62,12 +62,10 @@ static inline void pgd_populate(struct mm_struct *mm, pgd_t *pgd, pmd_t *pmd)
 		        (__u32)(__pa((unsigned long)pmd) >> PxD_VALUE_SHIFT));
 }
 
-static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
+static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address,
+				   gfp_t gfp)
 {
-	pmd_t *pmd = (pmd_t *)__get_free_pages(GFP_KERNEL, PMD_ORDER);
-	if (pmd)
-		memset(pmd, 0, PAGE_SIZE<<PMD_ORDER);
-	return pmd;
+	return (pmd_t *)__get_free_pages(gfp|__GFP_ZERO, PMD_ORDER);
 }
 
 static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
@@ -94,7 +92,7 @@ static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
  * inside the pgd, so has no extra memory associated with it.
  */
 
-#define pmd_alloc_one(mm, addr)		({ BUG(); ((pmd_t *)2); })
+#define pmd_alloc_one(mm, addr, gfp)	({ BUG(); ((pmd_t *)2); })
 #define pmd_free(mm, x)			do { } while (0)
 #define pgd_populate(mm, pmd, pte)	BUG()
 
@@ -134,11 +132,9 @@ pte_alloc_one(struct mm_struct *mm)
 	return page;
 }
 
-static inline pte_t *
-pte_alloc_one_kernel(struct mm_struct *mm)
+static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm, gfp_t gfp)
 {
-	pte_t *pte = (pte_t *)__get_free_page(GFP_KERNEL|__GFP_ZERO);
-	return pte;
+	return (pte_t *)get_zeroed_page(gfp);
 }
 
 static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
diff --git a/arch/parisc/kernel/pci-dma.c b/arch/parisc/kernel/pci-dma.c
index 239162355b..285688e735 100644
--- a/arch/parisc/kernel/pci-dma.c
+++ b/arch/parisc/kernel/pci-dma.c
@@ -113,7 +113,7 @@ static inline int map_pmd_uncached(pmd_t * pmd, unsigned long vaddr,
 	if (end > PGDIR_SIZE)
 		end = PGDIR_SIZE;
 	do {
-		pte_t * pte = pte_alloc_kernel(pmd, vaddr);
+		pte_t *pte = pte_alloc_kernel(pmd, vaddr, GFP_KERNEL);
 		if (!pte)
 			return -ENOMEM;
 		if (map_pte_uncached(pte, orig_vaddr, end - vaddr, paddr_ptr))
@@ -134,8 +134,8 @@ static inline int map_uncached_pages(unsigned long vaddr, unsigned long size,
 	dir = pgd_offset_k(vaddr);
 	do {
 		pmd_t *pmd;
-		
-		pmd = pmd_alloc(NULL, dir, vaddr);
+
+		pmd = pmd_alloc(NULL, dir, vaddr, GFP_KERNEL);
 		if (!pmd)
 			return -ENOMEM;
 		if (map_pmd_uncached(pmd, vaddr, end - vaddr, &paddr))
diff --git a/arch/parisc/mm/hugetlbpage.c b/arch/parisc/mm/hugetlbpage.c
index d77479ae3a..6351549539 100644
--- a/arch/parisc/mm/hugetlbpage.c
+++ b/arch/parisc/mm/hugetlbpage.c
@@ -61,9 +61,9 @@ pte_t *huge_pte_alloc(struct mm_struct *mm,
 	addr &= HPAGE_MASK;
 
 	pgd = pgd_offset(mm, addr);
-	pud = pud_alloc(mm, pgd, addr);
+	pud = pud_alloc(mm, pgd, addr, GFP_KERNEL);
 	if (pud) {
-		pmd = pmd_alloc(mm, pud, addr);
+		pmd = pmd_alloc(mm, pud, addr, GFP_KERNEL);
 		if (pmd)
 			pte = pte_alloc_map(mm, pmd, addr);
 	}
diff --git a/arch/powerpc/include/asm/book3s/32/pgalloc.h b/arch/powerpc/include/asm/book3s/32/pgalloc.h
index 3633502e10..9032660c0e 100644
--- a/arch/powerpc/include/asm/book3s/32/pgalloc.h
+++ b/arch/powerpc/include/asm/book3s/32/pgalloc.h
@@ -42,7 +42,7 @@ static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
  * We don't have any real pmd's, and this code never triggers because
  * the pgd will always be present..
  */
-/* #define pmd_alloc_one(mm,address)       ({ BUG(); ((pmd_t *)2); }) */
+/* #define pmd_alloc_one(mm,address,gfp) ({ BUG(); ((pmd_t *)2); }) */
 #define pmd_free(mm, x) 		do { } while (0)
 #define __pmd_free_tlb(tlb,x,a)		do { } while (0)
 /* #define pgd_populate(mm, pmd, pte)      BUG() */
@@ -61,7 +61,7 @@ static inline void pmd_populate(struct mm_struct *mm, pmd_t *pmdp,
 
 #define pmd_pgtable(pmd) ((pgtable_t)pmd_page_vaddr(pmd))
 
-extern pte_t *pte_alloc_one_kernel(struct mm_struct *mm);
+extern pte_t *pte_alloc_one_kernel(struct mm_struct *mm, gfp_t gfp);
 extern pgtable_t pte_alloc_one(struct mm_struct *mm);
 void pte_frag_destroy(void *pte_frag);
 pte_t *pte_fragment_alloc(struct mm_struct *mm, int kernel);
diff --git a/arch/powerpc/include/asm/book3s/64/pgalloc.h b/arch/powerpc/include/asm/book3s/64/pgalloc.h
index 138bc2ecc0..c2199361cf 100644
--- a/arch/powerpc/include/asm/book3s/64/pgalloc.h
+++ b/arch/powerpc/include/asm/book3s/64/pgalloc.h
@@ -39,8 +39,8 @@ extern struct vmemmap_backing *vmemmap_list;
 extern struct kmem_cache *pgtable_cache[];
 #define PGT_CACHE(shift) pgtable_cache[shift]
 
-extern pte_t *pte_fragment_alloc(struct mm_struct *, int);
-extern pmd_t *pmd_fragment_alloc(struct mm_struct *, unsigned long);
+extern pte_t *pte_fragment_alloc(struct mm_struct *, int, gfp_t);
+extern pmd_t *pmd_fragment_alloc(struct mm_struct *, unsigned long, gfp_t);
 extern void pte_fragment_free(unsigned long *, int);
 extern void pmd_fragment_free(unsigned long *);
 extern void pgtable_free_tlb(struct mmu_gather *tlb, void *table, int shift);
@@ -114,12 +114,13 @@ static inline void pgd_populate(struct mm_struct *mm, pgd_t *pgd, pud_t *pud)
 	*pgd =  __pgd(__pgtable_ptr_val(pud) | PGD_VAL_BITS);
 }
 
-static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long addr)
+static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long addr,
+				   gfp_t gfp)
 {
 	pud_t *pud;
 
 	pud = kmem_cache_alloc(PGT_CACHE(PUD_CACHE_INDEX),
-			       pgtable_gfp_flags(mm, GFP_KERNEL));
+			       pgtable_gfp_flags(mm, gfp));
 	/*
 	 * Tell kmemleak to ignore the PUD, that means don't scan it for
 	 * pointers and don't consider it a leak. PUDs are typically only
@@ -152,9 +153,10 @@ static inline void __pud_free_tlb(struct mmu_gather *tlb, pud_t *pud,
 	pgtable_free_tlb(tlb, pud, PUD_INDEX);
 }
 
-static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
+static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr,
+				   gfp_t gfp)
 {
-	return pmd_fragment_alloc(mm, addr);
+	return pmd_fragment_alloc(mm, addr, gfp);
 }
 
 static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
@@ -190,14 +192,14 @@ static inline pgtable_t pmd_pgtable(pmd_t pmd)
 	return (pgtable_t)pmd_page_vaddr(pmd);
 }
 
-static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm)
+static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm, gfp_t gfp)
 {
-	return (pte_t *)pte_fragment_alloc(mm, 1);
+	return (pte_t *)pte_fragment_alloc(mm, 1, gfp);
 }
 
 static inline pgtable_t pte_alloc_one(struct mm_struct *mm)
 {
-	return (pgtable_t)pte_fragment_alloc(mm, 0);
+	return (pgtable_t)pte_fragment_alloc(mm, 0, GFP_KERNEL);
 }
 
 static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
diff --git a/arch/powerpc/include/asm/nohash/32/pgalloc.h b/arch/powerpc/include/asm/nohash/32/pgalloc.h
index bd186e85b4..8a5a944251 100644
--- a/arch/powerpc/include/asm/nohash/32/pgalloc.h
+++ b/arch/powerpc/include/asm/nohash/32/pgalloc.h
@@ -42,8 +42,8 @@ static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
  * We don't have any real pmd's, and this code never triggers because
  * the pgd will always be present..
  */
-/* #define pmd_alloc_one(mm,address)       ({ BUG(); ((pmd_t *)2); }) */
-#define pmd_free(mm, x) 		do { } while (0)
+/* #define pmd_alloc_one(mm,address,gfp) ({ BUG(); ((pmd_t *)2); }) */
+#define pmd_free(mm, x)			do { } while (0)
 #define __pmd_free_tlb(tlb,x,a)		do { } while (0)
 /* #define pgd_populate(mm, pmd, pte)      BUG() */
 
@@ -79,7 +79,7 @@ static inline void pmd_populate(struct mm_struct *mm, pmd_t *pmdp,
 #define pmd_pgtable(pmd) ((pgtable_t)pmd_page_vaddr(pmd))
 #endif
 
-extern pte_t *pte_alloc_one_kernel(struct mm_struct *mm);
+extern pte_t *pte_alloc_one_kernel(struct mm_struct *mm, gfp_t gfp);
 extern pgtable_t pte_alloc_one(struct mm_struct *mm);
 void pte_frag_destroy(void *pte_frag);
 pte_t *pte_fragment_alloc(struct mm_struct *mm, int kernel);
diff --git a/arch/powerpc/include/asm/nohash/64/pgalloc.h b/arch/powerpc/include/asm/nohash/64/pgalloc.h
index 66d086f85b..e30f21916a 100644
--- a/arch/powerpc/include/asm/nohash/64/pgalloc.h
+++ b/arch/powerpc/include/asm/nohash/64/pgalloc.h
@@ -51,10 +51,11 @@ static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 
 #define pgd_populate(MM, PGD, PUD)	pgd_set(PGD, (unsigned long)PUD)
 
-static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long addr)
+static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long addr,
+				   gfp_t gfp)
 {
 	return kmem_cache_alloc(PGT_CACHE(PUD_INDEX_SIZE),
-			pgtable_gfp_flags(mm, GFP_KERNEL));
+			pgtable_gfp_flags(mm, gfp));
 }
 
 static inline void pud_free(struct mm_struct *mm, pud_t *pud)
@@ -81,10 +82,11 @@ static inline void pmd_populate(struct mm_struct *mm, pmd_t *pmd,
 
 #define pmd_pgtable(pmd) pmd_page(pmd)
 
-static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
+static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr,
+				   gfp_t gfp)
 {
 	return kmem_cache_alloc(PGT_CACHE(PMD_CACHE_INDEX),
-			pgtable_gfp_flags(mm, GFP_KERNEL));
+			pgtable_gfp_flags(mm, gfp));
 }
 
 static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
@@ -93,9 +95,9 @@ static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
 }
 
 
-static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm)
+static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm, gfp_t gfp)
 {
-	return (pte_t *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
+	return (pte_t *)get_zeroed_page(gfp);
 }
 
 static inline pgtable_t pte_alloc_one(struct mm_struct *mm)
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index f55ef07188..d9a9856029 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -585,7 +585,7 @@ int kvmppc_create_pte(struct kvm *kvm, pgd_t *pgtable, pte_t pte,
 	if (pgd_present(*pgd))
 		pud = pud_offset(pgd, gpa);
 	else
-		new_pud = pud_alloc_one(kvm->mm, gpa);
+		new_pud = pud_alloc_one(kvm->mm, gpa, GFP_KERNEL);
 
 	pmd = NULL;
 	if (pud && pud_present(*pud) && !pud_huge(*pud))
diff --git a/arch/powerpc/mm/hugetlbpage.c b/arch/powerpc/mm/hugetlbpage.c
index 9e732bb2c8..f66c42c933 100644
--- a/arch/powerpc/mm/hugetlbpage.c
+++ b/arch/powerpc/mm/hugetlbpage.c
@@ -153,7 +153,7 @@ pte_t *huge_pte_alloc(struct mm_struct *mm, unsigned long addr, unsigned long sz
 		hpdp = (hugepd_t *)pg;
 	} else {
 		pdshift = PUD_SHIFT;
-		pu = pud_alloc(mm, pg, addr);
+		pu = pud_alloc(mm, pg, addr, GFP_KERNEL);
 		if (pshift == PUD_SHIFT)
 			return (pte_t *)pu;
 		else if (pshift > PMD_SHIFT) {
@@ -161,7 +161,7 @@ pte_t *huge_pte_alloc(struct mm_struct *mm, unsigned long addr, unsigned long sz
 			hpdp = (hugepd_t *)pu;
 		} else {
 			pdshift = PMD_SHIFT;
-			pm = pmd_alloc(mm, pu, addr);
+			pm = pmd_alloc(mm, pu, addr, GFP_KERNEL);
 			if (pshift == PMD_SHIFT)
 				/* 16MB hugepage */
 				return (pte_t *)pm;
@@ -177,13 +177,13 @@ pte_t *huge_pte_alloc(struct mm_struct *mm, unsigned long addr, unsigned long sz
 		hpdp = (hugepd_t *)pg;
 	} else {
 		pdshift = PUD_SHIFT;
-		pu = pud_alloc(mm, pg, addr);
+		pu = pud_alloc(mm, pg, addr, GFP_KERNEL);
 		if (pshift >= PUD_SHIFT) {
 			ptl = pud_lockptr(mm, pu);
 			hpdp = (hugepd_t *)pu;
 		} else {
 			pdshift = PMD_SHIFT;
-			pm = pmd_alloc(mm, pu, addr);
+			pm = pmd_alloc(mm, pu, addr, GFP_KERNEL);
 			ptl = pmd_lockptr(mm, pm);
 			hpdp = (hugepd_t *)pm;
 		}
diff --git a/arch/powerpc/mm/pgtable-book3e.c b/arch/powerpc/mm/pgtable-book3e.c
index 1032ef7aaf..43bcc3bc8a 100644
--- a/arch/powerpc/mm/pgtable-book3e.c
+++ b/arch/powerpc/mm/pgtable-book3e.c
@@ -84,13 +84,13 @@ int map_kernel_page(unsigned long ea, unsigned long pa, pgprot_t prot)
 	BUILD_BUG_ON(TASK_SIZE_USER64 > PGTABLE_RANGE);
 	if (slab_is_available()) {
 		pgdp = pgd_offset_k(ea);
-		pudp = pud_alloc(&init_mm, pgdp, ea);
+		pudp = pud_alloc(&init_mm, pgdp, ea, GFP_KERNEL);
 		if (!pudp)
 			return -ENOMEM;
-		pmdp = pmd_alloc(&init_mm, pudp, ea);
+		pmdp = pmd_alloc(&init_mm, pudp, ea, GFP_KERNEL);
 		if (!pmdp)
 			return -ENOMEM;
-		ptep = pte_alloc_kernel(pmdp, ea);
+		ptep = pte_alloc_kernel(pmdp, ea, GFP_KERNEL);
 		if (!ptep)
 			return -ENOMEM;
 	} else {
diff --git a/arch/powerpc/mm/pgtable-book3s64.c b/arch/powerpc/mm/pgtable-book3s64.c
index a4341aba0a..cfb417ce6a 100644
--- a/arch/powerpc/mm/pgtable-book3s64.c
+++ b/arch/powerpc/mm/pgtable-book3s64.c
@@ -262,15 +262,14 @@ static pmd_t *get_pmd_from_cache(struct mm_struct *mm)
 	return (pmd_t *)ret;
 }
 
-static pmd_t *__alloc_for_pmdcache(struct mm_struct *mm)
+static pmd_t *__alloc_for_pmdcache(struct mm_struct *mm, gfp_t gfp)
 {
 	void *ret = NULL;
 	struct page *page;
-	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO;
 
-	if (mm == &init_mm)
-		gfp &= ~__GFP_ACCOUNT;
-	page = alloc_page(gfp);
+	if (mm != &init_mm)
+		gfp |= __GFP_ACCOUNT;
+	page = alloc_page(gfp|__GFP_ZERO);
 	if (!page)
 		return NULL;
 	if (!pgtable_pmd_page_ctor(page)) {
@@ -303,7 +302,8 @@ static pmd_t *__alloc_for_pmdcache(struct mm_struct *mm)
 	return (pmd_t *)ret;
 }
 
-pmd_t *pmd_fragment_alloc(struct mm_struct *mm, unsigned long vmaddr)
+pmd_t *pmd_fragment_alloc(struct mm_struct *mm, unsigned long vmaddr,
+			  gfp_t gfp)
 {
 	pmd_t *pmd;
 
@@ -311,7 +311,7 @@ pmd_t *pmd_fragment_alloc(struct mm_struct *mm, unsigned long vmaddr)
 	if (pmd)
 		return pmd;
 
-	return __alloc_for_pmdcache(mm);
+	return __alloc_for_pmdcache(mm, gfp);
 }
 
 void pmd_fragment_free(unsigned long *pmd)
diff --git a/arch/powerpc/mm/pgtable-hash64.c b/arch/powerpc/mm/pgtable-hash64.c
index c08d49046a..d90deb67d8 100644
--- a/arch/powerpc/mm/pgtable-hash64.c
+++ b/arch/powerpc/mm/pgtable-hash64.c
@@ -152,13 +152,13 @@ int hash__map_kernel_page(unsigned long ea, unsigned long pa, pgprot_t prot)
 	BUILD_BUG_ON(TASK_SIZE_USER64 > H_PGTABLE_RANGE);
 	if (slab_is_available()) {
 		pgdp = pgd_offset_k(ea);
-		pudp = pud_alloc(&init_mm, pgdp, ea);
+		pudp = pud_alloc(&init_mm, pgdp, ea, GFP_KERNEL);
 		if (!pudp)
 			return -ENOMEM;
-		pmdp = pmd_alloc(&init_mm, pudp, ea);
+		pmdp = pmd_alloc(&init_mm, pudp, ea, GFP_KERNEL);
 		if (!pmdp)
 			return -ENOMEM;
-		ptep = pte_alloc_kernel(pmdp, ea);
+		ptep = pte_alloc_kernel(pmdp, ea, GFP_KERNEL);
 		if (!ptep)
 			return -ENOMEM;
 		set_pte_at(&init_mm, ea, ptep, pfn_pte(pa >> PAGE_SHIFT, prot));
diff --git a/arch/powerpc/mm/pgtable-radix.c b/arch/powerpc/mm/pgtable-radix.c
index 154472a28c..0fbc67a090 100644
--- a/arch/powerpc/mm/pgtable-radix.c
+++ b/arch/powerpc/mm/pgtable-radix.c
@@ -145,21 +145,21 @@ static int __map_kernel_page(unsigned long ea, unsigned long pa,
 	 * boot.
 	 */
 	pgdp = pgd_offset_k(ea);
-	pudp = pud_alloc(&init_mm, pgdp, ea);
+	pudp = pud_alloc(&init_mm, pgdp, ea, GFP_KERNEL);
 	if (!pudp)
 		return -ENOMEM;
 	if (map_page_size == PUD_SIZE) {
 		ptep = (pte_t *)pudp;
 		goto set_the_pte;
 	}
-	pmdp = pmd_alloc(&init_mm, pudp, ea);
+	pmdp = pmd_alloc(&init_mm, pudp, ea, GFP_KERNEL);
 	if (!pmdp)
 		return -ENOMEM;
 	if (map_page_size == PMD_SIZE) {
 		ptep = pmdp_ptep(pmdp);
 		goto set_the_pte;
 	}
-	ptep = pte_alloc_kernel(pmdp, ea);
+	ptep = pte_alloc_kernel(pmdp, ea, GFP_KERNEL);
 	if (!ptep)
 		return -ENOMEM;
 
@@ -194,21 +194,21 @@ void radix__change_memory_range(unsigned long start, unsigned long end,
 
 	for (idx = start; idx < end; idx += PAGE_SIZE) {
 		pgdp = pgd_offset_k(idx);
-		pudp = pud_alloc(&init_mm, pgdp, idx);
+		pudp = pud_alloc(&init_mm, pgdp, idx, GFP_KERNEL);
 		if (!pudp)
 			continue;
 		if (pud_huge(*pudp)) {
 			ptep = (pte_t *)pudp;
 			goto update_the_pte;
 		}
-		pmdp = pmd_alloc(&init_mm, pudp, idx);
+		pmdp = pmd_alloc(&init_mm, pudp, idx, GFP_KERNEL);
 		if (!pmdp)
 			continue;
 		if (pmd_huge(*pmdp)) {
 			ptep = pmdp_ptep(pmdp);
 			goto update_the_pte;
 		}
-		ptep = pte_alloc_kernel(pmdp, idx);
+		ptep = pte_alloc_kernel(pmdp, idx, GFP_KERNEL);
 		if (!ptep)
 			continue;
 update_the_pte:
diff --git a/arch/powerpc/mm/pgtable_32.c b/arch/powerpc/mm/pgtable_32.c
index 6e56a6240b..eb474a99f0 100644
--- a/arch/powerpc/mm/pgtable_32.c
+++ b/arch/powerpc/mm/pgtable_32.c
@@ -43,12 +43,12 @@ EXPORT_SYMBOL(ioremap_bot);	/* aka VMALLOC_END */
 
 extern char etext[], _stext[], _sinittext[], _einittext[];
 
-__ref pte_t *pte_alloc_one_kernel(struct mm_struct *mm)
+__ref pte_t *pte_alloc_one_kernel(struct mm_struct *mm, gfp_t gfp)
 {
 	if (!slab_is_available())
 		return memblock_alloc(PTE_FRAG_SIZE, PTE_FRAG_SIZE);
 
-	return (pte_t *)pte_fragment_alloc(mm, 1);
+	return (pte_t *)pte_fragment_alloc(mm, 1, gfp);
 }
 
 pgtable_t pte_alloc_one(struct mm_struct *mm)
@@ -214,7 +214,7 @@ int map_kernel_page(unsigned long va, phys_addr_t pa, pgprot_t prot)
 	/* Use upper 10 bits of VA to index the first level map */
 	pd = pmd_offset(pud_offset(pgd_offset_k(va), va), va);
 	/* Use middle 10 bits of VA to index the second-level map */
-	pg = pte_alloc_kernel(pd, va);
+	pg = pte_alloc_kernel(pd, va, GFP_KERNEL);
 	if (pg != 0) {
 		err = 0;
 		/* The PTE should never be already set nor present in the
diff --git a/arch/riscv/include/asm/pgalloc.h b/arch/riscv/include/asm/pgalloc.h
index 94043cf83c..991c8d268e 100644
--- a/arch/riscv/include/asm/pgalloc.h
+++ b/arch/riscv/include/asm/pgalloc.h
@@ -67,10 +67,10 @@ static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 
 #ifndef __PAGETABLE_PMD_FOLDED
 
-static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
+static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr,
+				   gfp_t gfp)
 {
-	return (pmd_t *)__get_free_page(
-		GFP_KERNEL | __GFP_RETRY_MAYFAIL | __GFP_ZERO);
+	return (pmd_t *)get_zeroed_page(gfp|__GFP_RETRY_MAYFAIL);
 }
 
 static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
@@ -82,10 +82,9 @@ static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
 
 #endif /* __PAGETABLE_PMD_FOLDED */
 
-static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm)
+static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm, gfp_t gfp)
 {
-	return (pte_t *)__get_free_page(
-		GFP_KERNEL | __GFP_RETRY_MAYFAIL | __GFP_ZERO);
+	return (pte_t *)get_zeroed_page(gfp | __GFP_RETRY_MAYFAIL);
 }
 
 static inline struct page *pte_alloc_one(struct mm_struct *mm)
diff --git a/arch/s390/include/asm/pgalloc.h b/arch/s390/include/asm/pgalloc.h
index bccb8f4a63..49fb025627 100644
--- a/arch/s390/include/asm/pgalloc.h
+++ b/arch/s390/include/asm/pgalloc.h
@@ -19,10 +19,10 @@
 
 #define CRST_ALLOC_ORDER 2
 
-unsigned long *crst_table_alloc(struct mm_struct *);
+unsigned long *crst_table_alloc(struct mm_struct *, gfp_t);
 void crst_table_free(struct mm_struct *, unsigned long *);
 
-unsigned long *page_table_alloc(struct mm_struct *);
+unsigned long *page_table_alloc(struct mm_struct *, gfp_t);
 struct page *page_table_alloc_pgste(struct mm_struct *mm);
 void page_table_free(struct mm_struct *, unsigned long *);
 void page_table_free_rcu(struct mmu_gather *, unsigned long *, unsigned long);
@@ -48,9 +48,10 @@ static inline unsigned long pgd_entry_type(struct mm_struct *mm)
 int crst_table_upgrade(struct mm_struct *mm, unsigned long limit);
 void crst_table_downgrade(struct mm_struct *);
 
-static inline p4d_t *p4d_alloc_one(struct mm_struct *mm, unsigned long address)
+static inline p4d_t *p4d_alloc_one(struct mm_struct *mm, unsigned long address,
+				   gfp_t gfp)
 {
-	unsigned long *table = crst_table_alloc(mm);
+	unsigned long *table = crst_table_alloc(mm, gfp);
 
 	if (table)
 		crst_table_init(table, _REGION2_ENTRY_EMPTY);
@@ -58,18 +59,20 @@ static inline p4d_t *p4d_alloc_one(struct mm_struct *mm, unsigned long address)
 }
 #define p4d_free(mm, p4d) crst_table_free(mm, (unsigned long *) p4d)
 
-static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long address)
+static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long address,
+				   gfp_t gfp)
 {
-	unsigned long *table = crst_table_alloc(mm);
+	unsigned long *table = crst_table_alloc(mm, gfp);
 	if (table)
 		crst_table_init(table, _REGION3_ENTRY_EMPTY);
 	return (pud_t *) table;
 }
 #define pud_free(mm, pud) crst_table_free(mm, (unsigned long *) pud)
 
-static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long vmaddr)
+static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long vmaddr,
+				   gfp_t gfp)
 {
-	unsigned long *table = crst_table_alloc(mm);
+	unsigned long *table = crst_table_alloc(mm, gfp);
 
 	if (!table)
 		return NULL;
@@ -104,7 +107,7 @@ static inline void pud_populate(struct mm_struct *mm, pud_t *pud, pmd_t *pmd)
 
 static inline pgd_t *pgd_alloc(struct mm_struct *mm)
 {
-	unsigned long *table = crst_table_alloc(mm);
+	unsigned long *table = crst_table_alloc(mm, GFP_KERNEL);
 
 	if (!table)
 		return NULL;
@@ -139,8 +142,8 @@ static inline void pmd_populate(struct mm_struct *mm,
 /*
  * page table entry allocation/free routines.
  */
-#define pte_alloc_one_kernel(mm) ((pte_t *)page_table_alloc(mm))
-#define pte_alloc_one(mm) ((pte_t *)page_table_alloc(mm))
+#define pte_alloc_one_kernel(mm, gfp) ((pte_t *)page_table_alloc(mm, gfp))
+#define pte_alloc_one(mm) ((pte_t *)page_table_alloc(mm, GFP_KERNEL))
 
 #define pte_free_kernel(mm, pte) page_table_free(mm, (unsigned long *) pte)
 #define pte_free(mm, pte) page_table_free(mm, (unsigned long *) pte)
diff --git a/arch/s390/mm/hugetlbpage.c b/arch/s390/mm/hugetlbpage.c
index b0246c705a..eeb1468369 100644
--- a/arch/s390/mm/hugetlbpage.c
+++ b/arch/s390/mm/hugetlbpage.c
@@ -192,14 +192,14 @@ pte_t *huge_pte_alloc(struct mm_struct *mm,
 	pmd_t *pmdp = NULL;
 
 	pgdp = pgd_offset(mm, addr);
-	p4dp = p4d_alloc(mm, pgdp, addr);
+	p4dp = p4d_alloc(mm, pgdp, addr, GFP_KERNEL);
 	if (p4dp) {
-		pudp = pud_alloc(mm, p4dp, addr);
+		pudp = pud_alloc(mm, p4dp, addr, GFP_KERNEL);
 		if (pudp) {
 			if (sz == PUD_SIZE)
 				return (pte_t *) pudp;
 			else if (sz == PMD_SIZE)
-				pmdp = pmd_alloc(mm, pudp, addr);
+				pmdp = pmd_alloc(mm, pudp, addr, GFP_KERNEL);
 		}
 	}
 	return (pte_t *) pmdp;
diff --git a/arch/s390/mm/pgalloc.c b/arch/s390/mm/pgalloc.c
index db6bb2f97a..b8c309de98 100644
--- a/arch/s390/mm/pgalloc.c
+++ b/arch/s390/mm/pgalloc.c
@@ -53,9 +53,9 @@ __initcall(page_table_register_sysctl);
 
 #endif /* CONFIG_PGSTE */
 
-unsigned long *crst_table_alloc(struct mm_struct *mm)
+unsigned long *crst_table_alloc(struct mm_struct *mm, gfp_t gfp)
 {
-	struct page *page = alloc_pages(GFP_KERNEL, 2);
+	struct page *page = alloc_pages(gfp, 2);
 
 	if (!page)
 		return NULL;
@@ -87,7 +87,7 @@ int crst_table_upgrade(struct mm_struct *mm, unsigned long end)
 	rc = 0;
 	notify = 0;
 	while (mm->context.asce_limit < end) {
-		table = crst_table_alloc(mm);
+		table = crst_table_alloc(mm, GFP_KERNEL);
 		if (!table) {
 			rc = -ENOMEM;
 			break;
@@ -179,7 +179,7 @@ void page_table_free_pgste(struct page *page)
 /*
  * page table entry allocation/free routines.
  */
-unsigned long *page_table_alloc(struct mm_struct *mm)
+unsigned long *page_table_alloc(struct mm_struct *mm, gfp_t gfp)
 {
 	unsigned long *table;
 	struct page *page;
@@ -209,7 +209,7 @@ unsigned long *page_table_alloc(struct mm_struct *mm)
 			return table;
 	}
 	/* Allocate a fresh page */
-	page = alloc_page(GFP_KERNEL);
+	page = alloc_page(gfp);
 	if (!page)
 		return NULL;
 	if (!pgtable_page_ctor(page)) {
diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index 8485d6dc27..0bc3249927 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -418,13 +418,13 @@ static pmd_t *pmd_alloc_map(struct mm_struct *mm, unsigned long addr)
 	pmd_t *pmd;
 
 	pgd = pgd_offset(mm, addr);
-	p4d = p4d_alloc(mm, pgd, addr);
+	p4d = p4d_alloc(mm, pgd, addr, GFP_KERNEL);
 	if (!p4d)
 		return NULL;
-	pud = pud_alloc(mm, p4d, addr);
+	pud = pud_alloc(mm, p4d, addr, GFP_KERNEL);
 	if (!pud)
 		return NULL;
-	pmd = pmd_alloc(mm, pud, addr);
+	pmd = pmd_alloc(mm, pud, addr, GFP_KERNEL);
 	return pmd;
 }
 
diff --git a/arch/s390/mm/vmem.c b/arch/s390/mm/vmem.c
index 0472e27feb..47ffefab75 100644
--- a/arch/s390/mm/vmem.c
+++ b/arch/s390/mm/vmem.c
@@ -54,7 +54,7 @@ pte_t __ref *vmem_pte_alloc(void)
 	pte_t *pte;
 
 	if (slab_is_available())
-		pte = (pte_t *) page_table_alloc(&init_mm);
+		pte = (pte_t *) page_table_alloc(&init_mm, GFP_KERNEL);
 	else
 		pte = (pte_t *) memblock_phys_alloc(size, size);
 	if (!pte)
diff --git a/arch/sh/include/asm/pgalloc.h b/arch/sh/include/asm/pgalloc.h
index 8ad73cb311..bd51502e8b 100644
--- a/arch/sh/include/asm/pgalloc.h
+++ b/arch/sh/include/asm/pgalloc.h
@@ -12,7 +12,8 @@ extern void pgd_free(struct mm_struct *mm, pgd_t *pgd);
 
 #if PAGETABLE_LEVELS > 2
 extern void pud_populate(struct mm_struct *mm, pud_t *pudp, pmd_t *pmd);
-extern pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address);
+extern pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address,
+			    gfp_t gfp);
 extern void pmd_free(struct mm_struct *mm, pmd_t *pmd);
 #endif
 
@@ -32,9 +33,9 @@ static inline void pmd_populate(struct mm_struct *mm, pmd_t *pmd,
 /*
  * Allocate and free page tables.
  */
-static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm)
+static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm, gfp_t gfp)
 {
-	return quicklist_alloc(QUICK_PT, GFP_KERNEL, NULL);
+	return quicklist_alloc(QUICK_PT, gfp, NULL);
 }
 
 static inline pgtable_t pte_alloc_one(struct mm_struct *mm)
diff --git a/arch/sh/mm/hugetlbpage.c b/arch/sh/mm/hugetlbpage.c
index 960deb1f24..1eb4932cdb 100644
--- a/arch/sh/mm/hugetlbpage.c
+++ b/arch/sh/mm/hugetlbpage.c
@@ -32,9 +32,9 @@ pte_t *huge_pte_alloc(struct mm_struct *mm,
 
 	pgd = pgd_offset(mm, addr);
 	if (pgd) {
-		pud = pud_alloc(mm, pgd, addr);
+		pud = pud_alloc(mm, pgd, addr, GFP_KERNEL);
 		if (pud) {
-			pmd = pmd_alloc(mm, pud, addr);
+			pmd = pmd_alloc(mm, pud, addr, GFP_KERNEL);
 			if (pmd)
 				pte = pte_alloc_map(mm, pmd, addr);
 		}
diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
index 70621324db..4bd118c32e 100644
--- a/arch/sh/mm/init.c
+++ b/arch/sh/mm/init.c
@@ -53,13 +53,13 @@ static pte_t *__get_pte_phys(unsigned long addr)
 		return NULL;
 	}
 
-	pud = pud_alloc(NULL, pgd, addr);
+	pud = pud_alloc(NULL, pgd, addr, GFP_KERNEL);
 	if (unlikely(!pud)) {
 		pud_ERROR(*pud);
 		return NULL;
 	}
 
-	pmd = pmd_alloc(NULL, pud, addr);
+	pmd = pmd_alloc(NULL, pud, addr, GFP_KERNEL);
 	if (unlikely(!pmd)) {
 		pmd_ERROR(*pmd);
 		return NULL;
diff --git a/arch/sh/mm/pgtable.c b/arch/sh/mm/pgtable.c
index 5c8f9247c3..972f54fa09 100644
--- a/arch/sh/mm/pgtable.c
+++ b/arch/sh/mm/pgtable.c
@@ -2,8 +2,6 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 
-#define PGALLOC_GFP GFP_KERNEL | __GFP_ZERO
-
 static struct kmem_cache *pgd_cachep;
 #if PAGETABLE_LEVELS > 2
 static struct kmem_cache *pmd_cachep;
@@ -32,7 +30,7 @@ void pgtable_cache_init(void)
 
 pgd_t *pgd_alloc(struct mm_struct *mm)
 {
-	return kmem_cache_alloc(pgd_cachep, PGALLOC_GFP);
+	return kmem_cache_alloc(pgd_cachep, GFP_KERNEL|__GFP_ZERO);
 }
 
 void pgd_free(struct mm_struct *mm, pgd_t *pgd)
@@ -46,9 +44,9 @@ void pud_populate(struct mm_struct *mm, pud_t *pud, pmd_t *pmd)
 	set_pud(pud, __pud((unsigned long)pmd));
 }
 
-pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
+pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address, gfp_t gfp)
 {
-	return kmem_cache_alloc(pmd_cachep, PGALLOC_GFP);
+	return kmem_cache_alloc(pmd_cachep, gfp|__GFP_ZERO);
 }
 
 void pmd_free(struct mm_struct *mm, pmd_t *pmd)
diff --git a/arch/sparc/include/asm/pgalloc_32.h b/arch/sparc/include/asm/pgalloc_32.h
index 282be50a4a..51dea1c004 100644
--- a/arch/sparc/include/asm/pgalloc_32.h
+++ b/arch/sparc/include/asm/pgalloc_32.h
@@ -38,7 +38,8 @@ static inline void pgd_set(pgd_t * pgdp, pmd_t * pmdp)
 #define pgd_populate(MM, PGD, PMD)      pgd_set(PGD, PMD)
 
 static inline pmd_t *pmd_alloc_one(struct mm_struct *mm,
-				   unsigned long address)
+				   unsigned long address,
+				   gfp_t gfp)
 {
 	return srmmu_get_nocache(SRMMU_PMD_TABLE_SIZE,
 				 SRMMU_PMD_TABLE_SIZE);
@@ -60,12 +61,11 @@ void pmd_set(pmd_t *pmdp, pte_t *ptep);
 
 pgtable_t pte_alloc_one(struct mm_struct *mm);
 
-static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm)
+static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm, gfp_t gfp)
 {
 	return srmmu_get_nocache(PTE_SIZE, PTE_SIZE);
 }
 
-
 static inline void free_pte_fast(pte_t *pte)
 {
 	srmmu_free_nocache(pte, PTE_SIZE);
diff --git a/arch/sparc/include/asm/pgalloc_64.h b/arch/sparc/include/asm/pgalloc_64.h
index 48abccba49..e772ee60ee 100644
--- a/arch/sparc/include/asm/pgalloc_64.h
+++ b/arch/sparc/include/asm/pgalloc_64.h
@@ -40,9 +40,10 @@ static inline void __pud_populate(pud_t *pud, pmd_t *pmd)
 
 #define pud_populate(MM, PUD, PMD)	__pud_populate(PUD, PMD)
 
-static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long addr)
+static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long addr,
+				   gfp_t gfp)
 {
-	return kmem_cache_alloc(pgtable_cache, GFP_KERNEL);
+	return kmem_cache_alloc(pgtable_cache, gfp);
 }
 
 static inline void pud_free(struct mm_struct *mm, pud_t *pud)
@@ -50,9 +51,10 @@ static inline void pud_free(struct mm_struct *mm, pud_t *pud)
 	kmem_cache_free(pgtable_cache, pud);
 }
 
-static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
+static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr,
+				   gfp_t gfp)
 {
-	return kmem_cache_alloc(pgtable_cache, GFP_KERNEL);
+	return kmem_cache_alloc(pgtable_cache, gfp);
 }
 
 static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
@@ -60,7 +62,7 @@ static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
 	kmem_cache_free(pgtable_cache, pmd);
 }
 
-pte_t *pte_alloc_one_kernel(struct mm_struct *mm);
+pte_t *pte_alloc_one_kernel(struct mm_struct *mm, gfp_t gfp);
 pgtable_t pte_alloc_one(struct mm_struct *mm);
 void pte_free_kernel(struct mm_struct *mm, pte_t *pte);
 void pte_free(struct mm_struct *mm, pgtable_t ptepage);
diff --git a/arch/sparc/mm/hugetlbpage.c b/arch/sparc/mm/hugetlbpage.c
index f78793a06b..aeacfb0aab 100644
--- a/arch/sparc/mm/hugetlbpage.c
+++ b/arch/sparc/mm/hugetlbpage.c
@@ -281,12 +281,12 @@ pte_t *huge_pte_alloc(struct mm_struct *mm,
 	pmd_t *pmd;
 
 	pgd = pgd_offset(mm, addr);
-	pud = pud_alloc(mm, pgd, addr);
+	pud = pud_alloc(mm, pgd, addr, GFP_KERNEL);
 	if (!pud)
 		return NULL;
 	if (sz >= PUD_SIZE)
 		return (pte_t *)pud;
-	pmd = pmd_alloc(mm, pud, addr);
+	pmd = pmd_alloc(mm, pud, addr, GFP_KERNEL);
 	if (!pmd)
 		return NULL;
 	if (sz >= PMD_SIZE)
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index f2d70ff7a2..bd81b148f4 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -2933,15 +2933,9 @@ void __flush_tlb_all(void)
 			     : : "r" (pstate));
 }
 
-pte_t *pte_alloc_one_kernel(struct mm_struct *mm)
+pte_t *pte_alloc_one_kernel(struct mm_struct *mm, gfp_t gfp)
 {
-	struct page *page = alloc_page(GFP_KERNEL | __GFP_ZERO);
-	pte_t *pte = NULL;
-
-	if (page)
-		pte = (pte_t *) page_address(page);
-
-	return pte;
+	return (pte_t *) get_zeroed_page(gfp);
 }
 
 pgtable_t pte_alloc_one(struct mm_struct *mm)
diff --git a/arch/sparc/mm/srmmu.c b/arch/sparc/mm/srmmu.c
index aaebbc00d2..143a5bc7ce 100644
--- a/arch/sparc/mm/srmmu.c
+++ b/arch/sparc/mm/srmmu.c
@@ -375,7 +375,7 @@ pgtable_t pte_alloc_one(struct mm_struct *mm)
 	unsigned long pte;
 	struct page *page;
 
-	if ((pte = (unsigned long)pte_alloc_one_kernel(mm)) == 0)
+	if ((pte = (unsigned long)pte_alloc_one_kernel(mm, GFP_KERNEL)) == 0)
 		return NULL;
 	page = pfn_to_page(__nocache_pa(pte) >> PAGE_SHIFT);
 	if (!pgtable_page_ctor(page)) {
diff --git a/arch/um/include/asm/pgalloc.h b/arch/um/include/asm/pgalloc.h
index 99eb568279..71090e43d0 100644
--- a/arch/um/include/asm/pgalloc.h
+++ b/arch/um/include/asm/pgalloc.h
@@ -25,7 +25,7 @@
 extern pgd_t *pgd_alloc(struct mm_struct *);
 extern void pgd_free(struct mm_struct *mm, pgd_t *pgd);
 
-extern pte_t *pte_alloc_one_kernel(struct mm_struct *);
+extern pte_t *pte_alloc_one_kernel(struct mm_struct *, gfp_t);
 extern pgtable_t pte_alloc_one(struct mm_struct *);
 
 static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
diff --git a/arch/um/include/asm/pgtable-3level.h b/arch/um/include/asm/pgtable-3level.h
index c4d876dfb9..7f5fd79234 100644
--- a/arch/um/include/asm/pgtable-3level.h
+++ b/arch/um/include/asm/pgtable-3level.h
@@ -80,7 +80,8 @@ static inline void pgd_mkuptodate(pgd_t pgd) { pgd_val(pgd) &= ~_PAGE_NEWPAGE; }
 #endif
 
 struct mm_struct;
-extern pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address);
+extern pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address,
+			    gfp_t gfp);
 
 static inline void pud_clear (pud_t *pud)
 {
diff --git a/arch/um/kernel/mem.c b/arch/um/kernel/mem.c
index 99aa11bf53..3e0ce9f645 100644
--- a/arch/um/kernel/mem.c
+++ b/arch/um/kernel/mem.c
@@ -215,12 +215,9 @@ void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 	free_page((unsigned long) pgd);
 }
 
-pte_t *pte_alloc_one_kernel(struct mm_struct *mm)
+pte_t *pte_alloc_one_kernel(struct mm_struct *mm, gfp_t gfp)
 {
-	pte_t *pte;
-
-	pte = (pte_t *)__get_free_page(GFP_KERNEL|__GFP_ZERO);
-	return pte;
+	return (pte_t *)get_zeroed_page(gfp);
 }
 
 pgtable_t pte_alloc_one(struct mm_struct *mm)
@@ -238,14 +235,10 @@ pgtable_t pte_alloc_one(struct mm_struct *mm)
 }
 
 #ifdef CONFIG_3_LEVEL_PGTABLES
-pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
+pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address,
+		     gfp_t gfp)
 {
-	pmd_t *pmd = (pmd_t *) __get_free_page(GFP_KERNEL);
-
-	if (pmd)
-		memset(pmd, 0, PAGE_SIZE);
-
-	return pmd;
+	return (pmd_t *) get_zeroed_page(gfp);
 }
 #endif
 
diff --git a/arch/um/kernel/skas/mmu.c b/arch/um/kernel/skas/mmu.c
index 7a1f2a936f..b677b615d6 100644
--- a/arch/um/kernel/skas/mmu.c
+++ b/arch/um/kernel/skas/mmu.c
@@ -24,11 +24,11 @@ static int init_stub_pte(struct mm_struct *mm, unsigned long proc,
 	pte_t *pte;
 
 	pgd = pgd_offset(mm, proc);
-	pud = pud_alloc(mm, pgd, proc);
+	pud = pud_alloc(mm, pgd, proc, GFP_KERNEL);
 	if (!pud)
 		goto out;
 
-	pmd = pmd_alloc(mm, pud, proc);
+	pmd = pmd_alloc(mm, pud, proc, GFP_KERNEL);
 	if (!pmd)
 		goto out_pmd;
 
diff --git a/arch/unicore32/include/asm/pgalloc.h b/arch/unicore32/include/asm/pgalloc.h
index 7cceabecf4..e5f6c1ae64 100644
--- a/arch/unicore32/include/asm/pgalloc.h
+++ b/arch/unicore32/include/asm/pgalloc.h
@@ -28,17 +28,15 @@ extern void free_pgd_slow(struct mm_struct *mm, pgd_t *pgd);
 #define pgd_alloc(mm)			get_pgd_slow(mm)
 #define pgd_free(mm, pgd)		free_pgd_slow(mm, pgd)
 
-#define PGALLOC_GFP	(GFP_KERNEL | __GFP_ZERO)
-
 /*
  * Allocate one PTE table.
  */
 static inline pte_t *
-pte_alloc_one_kernel(struct mm_struct *mm)
+pte_alloc_one_kernel(struct mm_struct *mm, gfp_t gfp)
 {
 	pte_t *pte;
 
-	pte = (pte_t *)__get_free_page(PGALLOC_GFP);
+	pte = (pte_t *)get_zeroed_page(gfp);
 	if (pte)
 		clean_dcache_area(pte, PTRS_PER_PTE * sizeof(pte_t));
 
@@ -50,7 +48,7 @@ pte_alloc_one(struct mm_struct *mm)
 {
 	struct page *pte;
 
-	pte = alloc_pages(PGALLOC_GFP, 0);
+	pte = alloc_pages(GFP_KERNEL|__GFP_ZERO, 0);
 	if (!pte)
 		return NULL;
 	if (!PageHighMem(pte)) {
diff --git a/arch/unicore32/mm/pgd.c b/arch/unicore32/mm/pgd.c
index a830a300aa..b9c628a55f 100644
--- a/arch/unicore32/mm/pgd.c
+++ b/arch/unicore32/mm/pgd.c
@@ -50,7 +50,7 @@ pgd_t *get_pgd_slow(struct mm_struct *mm)
 		 * On UniCore, first page must always be allocated since it
 		 * contains the machine vectors.
 		 */
-		new_pmd = pmd_alloc(mm, (pud_t *)new_pgd, 0);
+		new_pmd = pmd_alloc(mm, (pud_t *)new_pgd, 0, GFP_KERNEL);
 		if (!new_pmd)
 			goto no_pmd;
 
diff --git a/arch/x86/include/asm/pgalloc.h b/arch/x86/include/asm/pgalloc.h
index a281e61ec6..1909a8dfaf 100644
--- a/arch/x86/include/asm/pgalloc.h
+++ b/arch/x86/include/asm/pgalloc.h
@@ -47,7 +47,7 @@ extern gfp_t __userpte_alloc_gfp;
 extern pgd_t *pgd_alloc(struct mm_struct *);
 extern void pgd_free(struct mm_struct *mm, pgd_t *pgd);
 
-extern pte_t *pte_alloc_one_kernel(struct mm_struct *);
+extern pte_t *pte_alloc_one_kernel(struct mm_struct *, gfp_t);
 extern pgtable_t pte_alloc_one(struct mm_struct *);
 
 /* Should really implement gc for free page table pages. This could be
@@ -99,14 +99,14 @@ static inline void pmd_populate(struct mm_struct *mm, pmd_t *pmd,
 #define pmd_pgtable(pmd) pmd_page(pmd)
 
 #if CONFIG_PGTABLE_LEVELS > 2
-static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
+static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr,
+				   gfp_t gfp)
 {
 	struct page *page;
-	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO;
 
-	if (mm == &init_mm)
-		gfp &= ~__GFP_ACCOUNT;
-	page = alloc_pages(gfp, 0);
+	if (mm != &init_mm)
+		gfp |= __GFP_ACCOUNT;
+	page = alloc_pages(gfp|__GFP_ZERO, 0);
 	if (!page)
 		return NULL;
 	if (!pgtable_pmd_page_ctor(page)) {
@@ -160,12 +160,11 @@ static inline void p4d_populate_safe(struct mm_struct *mm, p4d_t *p4d, pud_t *pu
 	set_p4d_safe(p4d, __p4d(_PAGE_TABLE | __pa(pud)));
 }
 
-static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long addr)
+static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long addr,
+				   gfp_t gfp)
 {
-	gfp_t gfp = GFP_KERNEL_ACCOUNT;
-
-	if (mm == &init_mm)
-		gfp &= ~__GFP_ACCOUNT;
+	if (mm != &init_mm)
+		gfp |= __GFP_ACCOUNT;
 	return (pud_t *)get_zeroed_page(gfp);
 }
 
@@ -200,12 +199,11 @@ static inline void pgd_populate_safe(struct mm_struct *mm, pgd_t *pgd, p4d_t *p4
 	set_pgd_safe(pgd, __pgd(_PAGE_TABLE | __pa(p4d)));
 }
 
-static inline p4d_t *p4d_alloc_one(struct mm_struct *mm, unsigned long addr)
+static inline p4d_t *p4d_alloc_one(struct mm_struct *mm, unsigned long addr,
+				   gfp_t gfp)
 {
-	gfp_t gfp = GFP_KERNEL_ACCOUNT;
-
-	if (mm == &init_mm)
-		gfp &= ~__GFP_ACCOUNT;
+	if (mm != &init_mm)
+		gfp |= __GFP_ACCOUNT;
 	return (p4d_t *)get_zeroed_page(gfp);
 }
 
diff --git a/arch/x86/kernel/espfix_64.c b/arch/x86/kernel/espfix_64.c
index aebd0d5bc0..46df9bb51f 100644
--- a/arch/x86/kernel/espfix_64.c
+++ b/arch/x86/kernel/espfix_64.c
@@ -126,7 +126,7 @@ void __init init_espfix_bsp(void)
 
 	/* Install the espfix pud into the kernel page directory */
 	pgd = &init_top_pgt[pgd_index(ESPFIX_BASE_ADDR)];
-	p4d = p4d_alloc(&init_mm, pgd, ESPFIX_BASE_ADDR);
+	p4d = p4d_alloc(&init_mm, pgd, ESPFIX_BASE_ADDR, GFP_KERNEL);
 	p4d_populate(&init_mm, p4d, espfix_pud_page);
 
 	/* Randomize the locations */
diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
index 6e5ef8fb8a..9a4f0fa6d6 100644
--- a/arch/x86/kernel/tboot.c
+++ b/arch/x86/kernel/tboot.c
@@ -124,13 +124,13 @@ static int map_tboot_page(unsigned long vaddr, unsigned long pfn,
 	pte_t *pte;
 
 	pgd = pgd_offset(&tboot_mm, vaddr);
-	p4d = p4d_alloc(&tboot_mm, pgd, vaddr);
+	p4d = p4d_alloc(&tboot_mm, pgd, vaddr, GFP_KERNEL);
 	if (!p4d)
 		return -1;
-	pud = pud_alloc(&tboot_mm, p4d, vaddr);
+	pud = pud_alloc(&tboot_mm, p4d, vaddr, GFP_KERNEL);
 	if (!pud)
 		return -1;
-	pmd = pmd_alloc(&tboot_mm, pud, vaddr);
+	pmd = pmd_alloc(&tboot_mm, pud, vaddr, GFP_KERNEL);
 	if (!pmd)
 		return -1;
 	pte = pte_alloc_map(&tboot_mm, pmd, vaddr);
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 7bd01709a0..04cb5aec7b 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -23,9 +23,9 @@ EXPORT_SYMBOL(physical_mask);
 
 gfp_t __userpte_alloc_gfp = PGALLOC_GFP | PGALLOC_USER_GFP;
 
-pte_t *pte_alloc_one_kernel(struct mm_struct *mm)
+pte_t *pte_alloc_one_kernel(struct mm_struct *mm, gfp_t gfp)
 {
-	return (pte_t *)__get_free_page(PGALLOC_GFP & ~__GFP_ACCOUNT);
+	return (pte_t *) get_zeroed_page(gfp);
 }
 
 pgtable_t pte_alloc_one(struct mm_struct *mm)
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index cf0347f61b..9cb455ba28 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -106,7 +106,7 @@ pgd_t * __init efi_call_phys_prolog(void)
 		pgd_efi = pgd_offset_k(addr_pgd);
 		save_pgd[pgd] = *pgd_efi;
 
-		p4d = p4d_alloc(&init_mm, pgd_efi, addr_pgd);
+		p4d = p4d_alloc(&init_mm, pgd_efi, addr_pgd, GFP_KERNEL);
 		if (!p4d) {
 			pr_err("Failed to allocate p4d table!\n");
 			goto out;
@@ -116,7 +116,8 @@ pgd_t * __init efi_call_phys_prolog(void)
 			addr_p4d = addr_pgd + i * P4D_SIZE;
 			p4d_efi = p4d + p4d_index(addr_p4d);
 
-			pud = pud_alloc(&init_mm, p4d_efi, addr_p4d);
+			pud = pud_alloc(&init_mm, p4d_efi, addr_p4d,
+					GFP_KERNEL);
 			if (!pud) {
 				pr_err("Failed to allocate pud table!\n");
 				goto out;
@@ -217,13 +218,13 @@ int __init efi_alloc_page_tables(void)
 		return -ENOMEM;
 
 	pgd = efi_pgd + pgd_index(EFI_VA_END);
-	p4d = p4d_alloc(&init_mm, pgd, EFI_VA_END);
+	p4d = p4d_alloc(&init_mm, pgd, EFI_VA_END, GFP_KERNEL);
 	if (!p4d) {
 		free_page((unsigned long)efi_pgd);
 		return -ENOMEM;
 	}
 
-	pud = pud_alloc(&init_mm, p4d, EFI_VA_END);
+	pud = pud_alloc(&init_mm, p4d, EFI_VA_END, GFP_KERNEL);
 	if (!pud) {
 		if (pgtable_l5_enabled())
 			free_page((unsigned long) pgd_page_vaddr(*pgd));
diff --git a/arch/xtensa/include/asm/pgalloc.h b/arch/xtensa/include/asm/pgalloc.h
index b3b388ff2f..cc7ec6dd09 100644
--- a/arch/xtensa/include/asm/pgalloc.h
+++ b/arch/xtensa/include/asm/pgalloc.h
@@ -38,12 +38,12 @@ static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 	free_page((unsigned long)pgd);
 }
 
-static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm)
+static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm, gfp_t gfp)
 {
 	pte_t *ptep;
 	int i;
 
-	ptep = (pte_t *)__get_free_page(GFP_KERNEL);
+	ptep = (pte_t *)__get_free_page(gfp);
 	if (!ptep)
 		return NULL;
 	for (i = 0; i < 1024; i++)
diff --git a/drivers/staging/media/ipu3/ipu3-dmamap.c b/drivers/staging/media/ipu3/ipu3-dmamap.c
index d978a00e1e..f74221ab2b 100644
--- a/drivers/staging/media/ipu3/ipu3-dmamap.c
+++ b/drivers/staging/media/ipu3/ipu3-dmamap.c
@@ -137,7 +137,7 @@ void *imgu_dmamap_alloc(struct imgu_device *imgu, struct imgu_css_map *map,
 
 	map->vma->pages = pages;
 	/* And map it in KVA */
-	if (map_vm_area(map->vma, PAGE_KERNEL, pages))
+	if (map_vm_area(map->vma, GFP_KERNEL, PAGE_KERNEL, pages))
 		goto out_vunmap;
 
 	map->size = size;
diff --git a/include/asm-generic/4level-fixup.h b/include/asm-generic/4level-fixup.h
index e3667c9a33..652b68f475 100644
--- a/include/asm-generic/4level-fixup.h
+++ b/include/asm-generic/4level-fixup.h
@@ -12,9 +12,9 @@
 
 #define pud_t				pgd_t
 
-#define pmd_alloc(mm, pud, address) \
-	((unlikely(pgd_none(*(pud))) && __pmd_alloc(mm, pud, address))? \
- 		NULL: pmd_offset(pud, address))
+#define pmd_alloc(mm, pud, address, gfp) \
+	((unlikely(pgd_none(*(pud))) && __pmd_alloc(mm, pud, address, gfp)) \
+		? NULL : pmd_offset(pud, address))
 
 #define pud_offset(pgd, start)		(pgd)
 #define pud_none(pud)			0
diff --git a/include/asm-generic/5level-fixup.h b/include/asm-generic/5level-fixup.h
index bb6cb34701..c6f68f6a9f 100644
--- a/include/asm-generic/5level-fixup.h
+++ b/include/asm-generic/5level-fixup.h
@@ -13,11 +13,11 @@
 
 #define p4d_t				pgd_t
 
-#define pud_alloc(mm, p4d, address) \
-	((unlikely(pgd_none(*(p4d))) && __pud_alloc(mm, p4d, address)) ? \
+#define pud_alloc(mm, p4d, address, gfp) \
+	((unlikely(pgd_none(*(p4d))) && __pud_alloc(mm, p4d, address, gfp)) ? \
 		NULL : pud_offset(p4d, address))
 
-#define p4d_alloc(mm, pgd, address)	(pgd)
+#define p4d_alloc(mm, pgd, address, gfp) (pgd)
 #define p4d_offset(pgd, start)		(pgd)
 #define p4d_none(p4d)			0
 #define p4d_bad(p4d)			0
diff --git a/include/asm-generic/pgtable-nop4d-hack.h b/include/asm-generic/pgtable-nop4d-hack.h
index 829bdb0d63..3ba3c7e4b9 100644
--- a/include/asm-generic/pgtable-nop4d-hack.h
+++ b/include/asm-generic/pgtable-nop4d-hack.h
@@ -53,7 +53,7 @@ static inline pud_t *pud_offset(pgd_t *pgd, unsigned long address)
  * allocating and freeing a pud is trivial: the 1-entry pud is
  * inside the pgd, so has no extra memory associated with it.
  */
-#define pud_alloc_one(mm, address)		NULL
+#define pud_alloc_one(mm, address, gfp)		NULL
 #define pud_free(mm, x)				do { } while (0)
 #define __pud_free_tlb(tlb, x, a)		do { } while (0)
 
diff --git a/include/asm-generic/pgtable-nop4d.h b/include/asm-generic/pgtable-nop4d.h
index aebab905e6..7c9e00e44d 100644
--- a/include/asm-generic/pgtable-nop4d.h
+++ b/include/asm-generic/pgtable-nop4d.h
@@ -48,7 +48,7 @@ static inline p4d_t *p4d_offset(pgd_t *pgd, unsigned long address)
  * allocating and freeing a p4d is trivial: the 1-entry p4d is
  * inside the pgd, so has no extra memory associated with it.
  */
-#define p4d_alloc_one(mm, address)		NULL
+#define p4d_alloc_one(mm, address, gfp)		NULL
 #define p4d_free(mm, x)				do { } while (0)
 #define __p4d_free_tlb(tlb, x, a)		do { } while (0)
 
diff --git a/include/asm-generic/pgtable-nopmd.h b/include/asm-generic/pgtable-nopmd.h
index b85b8271a7..e4a51cbdef 100644
--- a/include/asm-generic/pgtable-nopmd.h
+++ b/include/asm-generic/pgtable-nopmd.h
@@ -56,7 +56,7 @@ static inline pmd_t * pmd_offset(pud_t * pud, unsigned long address)
  * allocating and freeing a pmd is trivial: the 1-entry pmd is
  * inside the pud, so has no extra memory associated with it.
  */
-#define pmd_alloc_one(mm, address)		NULL
+#define pmd_alloc_one(mm, address, gfp)		NULL
 static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
 {
 }
diff --git a/include/asm-generic/pgtable-nopud.h b/include/asm-generic/pgtable-nopud.h
index c77a1d3011..e7aacf134c 100644
--- a/include/asm-generic/pgtable-nopud.h
+++ b/include/asm-generic/pgtable-nopud.h
@@ -57,7 +57,7 @@ static inline pud_t *pud_offset(p4d_t *p4d, unsigned long address)
  * allocating and freeing a pud is trivial: the 1-entry pud is
  * inside the p4d, so has no extra memory associated with it.
  */
-#define pud_alloc_one(mm, address)		NULL
+#define pud_alloc_one(mm, address, gfp)		NULL
 #define pud_free(mm, x)				do { } while (0)
 #define __pud_free_tlb(tlb, x, a)		do { } while (0)
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6b10c21630..d6f315e106 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1749,17 +1749,18 @@ static inline pte_t *get_locked_pte(struct mm_struct *mm, unsigned long addr,
 
 #ifdef __PAGETABLE_P4D_FOLDED
 static inline int __p4d_alloc(struct mm_struct *mm, pgd_t *pgd,
-						unsigned long address)
+			      unsigned long address, gfp_t gfp)
 {
 	return 0;
 }
 #else
-int __p4d_alloc(struct mm_struct *mm, pgd_t *pgd, unsigned long address);
+int __p4d_alloc(struct mm_struct *mm, pgd_t *pgd,
+		unsigned long address, gfp_t gfp);
 #endif
 
 #if defined(__PAGETABLE_PUD_FOLDED) || !defined(CONFIG_MMU)
 static inline int __pud_alloc(struct mm_struct *mm, p4d_t *p4d,
-						unsigned long address)
+			      unsigned long address, gfp_t gfp)
 {
 	return 0;
 }
@@ -1767,7 +1768,8 @@ static inline void mm_inc_nr_puds(struct mm_struct *mm) {}
 static inline void mm_dec_nr_puds(struct mm_struct *mm) {}
 
 #else
-int __pud_alloc(struct mm_struct *mm, p4d_t *p4d, unsigned long address);
+int __pud_alloc(struct mm_struct *mm, p4d_t *p4d,
+		unsigned long address, gfp_t gfp);
 
 static inline void mm_inc_nr_puds(struct mm_struct *mm)
 {
@@ -1786,7 +1788,7 @@ static inline void mm_dec_nr_puds(struct mm_struct *mm)
 
 #if defined(__PAGETABLE_PMD_FOLDED) || !defined(CONFIG_MMU)
 static inline int __pmd_alloc(struct mm_struct *mm, pud_t *pud,
-						unsigned long address)
+			      unsigned long address, gfp_t gfp)
 {
 	return 0;
 }
@@ -1795,7 +1797,8 @@ static inline void mm_inc_nr_pmds(struct mm_struct *mm) {}
 static inline void mm_dec_nr_pmds(struct mm_struct *mm) {}
 
 #else
-int __pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long address);
+int __pmd_alloc(struct mm_struct *mm, pud_t *pud,
+		unsigned long address, gfp_t gfp);
 
 static inline void mm_inc_nr_pmds(struct mm_struct *mm)
 {
@@ -1845,7 +1848,7 @@ static inline void mm_dec_nr_ptes(struct mm_struct *mm) {}
 #endif
 
 int __pte_alloc(struct mm_struct *mm, pmd_t *pmd);
-int __pte_alloc_kernel(pmd_t *pmd);
+int __pte_alloc_kernel(pmd_t *pmd, gfp_t gfp);
 
 /*
  * The following ifdef needed to get the 4level-fixup.h header to work.
@@ -1855,24 +1858,25 @@ int __pte_alloc_kernel(pmd_t *pmd);
 
 #ifndef __ARCH_HAS_5LEVEL_HACK
 static inline p4d_t *p4d_alloc(struct mm_struct *mm, pgd_t *pgd,
-		unsigned long address)
+		unsigned long address, gfp_t gfp)
 {
-	return (unlikely(pgd_none(*pgd)) && __p4d_alloc(mm, pgd, address)) ?
-		NULL : p4d_offset(pgd, address);
+	return (unlikely(pgd_none(*pgd)) && __p4d_alloc(mm, pgd, address, gfp))
+	    ? NULL : p4d_offset(pgd, address);
 }
 
 static inline pud_t *pud_alloc(struct mm_struct *mm, p4d_t *p4d,
-		unsigned long address)
+		unsigned long address, gfp_t gfp)
 {
-	return (unlikely(p4d_none(*p4d)) && __pud_alloc(mm, p4d, address)) ?
-		NULL : pud_offset(p4d, address);
+	return (unlikely(p4d_none(*p4d)) && __pud_alloc(mm, p4d, address, gfp))
+	    ? NULL : pud_offset(p4d, address);
 }
 #endif /* !__ARCH_HAS_5LEVEL_HACK */
 
-static inline pmd_t *pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long address)
+static inline pmd_t *pmd_alloc(struct mm_struct *mm, pud_t *pud,
+		unsigned long address, gfp_t gfp)
 {
-	return (unlikely(pud_none(*pud)) && __pmd_alloc(mm, pud, address))?
-		NULL: pmd_offset(pud, address);
+	return (unlikely(pud_none(*pud)) && __pmd_alloc(mm, pud, address, gfp))
+	    ? NULL : pmd_offset(pud, address);
 }
 #endif /* CONFIG_MMU && !__ARCH_HAS_4LEVEL_HACK */
 
@@ -1985,8 +1989,8 @@ static inline void pgtable_page_dtor(struct page *page)
 	(pte_alloc(mm, pmd) ?			\
 		 NULL : pte_offset_map_lock(mm, pmd, address, ptlp))
 
-#define pte_alloc_kernel(pmd, address)			\
-	((unlikely(pmd_none(*(pmd))) && __pte_alloc_kernel(pmd))? \
+#define pte_alloc_kernel(pmd, address, gfp)			\
+	((unlikely(pmd_none(*(pmd))) && __pte_alloc_kernel(pmd, gfp))? \
 		NULL: pte_offset_kernel(pmd, address))
 
 #if USE_SPLIT_PMD_PTLOCKS
diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 398e9c95cd..11788d5ba3 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -135,7 +135,7 @@ extern struct vm_struct *__get_vm_area_caller(unsigned long size,
 extern struct vm_struct *remove_vm_area(const void *addr);
 extern struct vm_struct *find_vm_area(const void *addr);
 
-extern int map_vm_area(struct vm_struct *area, pgprot_t prot,
+extern int map_vm_area(struct vm_struct *area, gfp_t gfp, pgprot_t prot,
 			struct page **pages);
 #ifdef CONFIG_MMU
 extern int map_kernel_range_noflush(unsigned long start, unsigned long size,
diff --git a/lib/ioremap.c b/lib/ioremap.c
index 0632136855..a4e21ef50c 100644
--- a/lib/ioremap.c
+++ b/lib/ioremap.c
@@ -65,7 +65,7 @@ static int ioremap_pte_range(pmd_t *pmd, unsigned long addr,
 	u64 pfn;
 
 	pfn = phys_addr >> PAGE_SHIFT;
-	pte = pte_alloc_kernel(pmd, addr);
+	pte = pte_alloc_kernel(pmd, addr, GFP_KERNEL);
 	if (!pte)
 		return -ENOMEM;
 	do {
@@ -101,7 +101,7 @@ static inline int ioremap_pmd_range(pud_t *pud, unsigned long addr,
 	pmd_t *pmd;
 	unsigned long next;
 
-	pmd = pmd_alloc(&init_mm, pud, addr);
+	pmd = pmd_alloc(&init_mm, pud, addr, GFP_KERNEL);
 	if (!pmd)
 		return -ENOMEM;
 	do {
@@ -141,7 +141,7 @@ static inline int ioremap_pud_range(p4d_t *p4d, unsigned long addr,
 	pud_t *pud;
 	unsigned long next;
 
-	pud = pud_alloc(&init_mm, p4d, addr);
+	pud = pud_alloc(&init_mm, p4d, addr, GFP_KERNEL);
 	if (!pud)
 		return -ENOMEM;
 	do {
@@ -181,7 +181,7 @@ static inline int ioremap_p4d_range(pgd_t *pgd, unsigned long addr,
 	p4d_t *p4d;
 	unsigned long next;
 
-	p4d = p4d_alloc(&init_mm, pgd, addr);
+	p4d = p4d_alloc(&init_mm, pgd, addr, GFP_KERNEL);
 	if (!p4d)
 		return -ENOMEM;
 	do {
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 6cdc7b2d91..245d4a2585 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4683,7 +4683,7 @@ pte_t *huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud)
 	spinlock_t *ptl;
 
 	if (!vma_shareable(vma, addr))
-		return (pte_t *)pmd_alloc(mm, pud, addr);
+		return (pte_t *)pmd_alloc(mm, pud, addr, GFP_KERNEL);
 
 	i_mmap_lock_write(mapping);
 	vma_interval_tree_foreach(svma, &mapping->i_mmap, idx, idx) {
@@ -4714,7 +4714,7 @@ pte_t *huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud)
 	}
 	spin_unlock(ptl);
 out:
-	pte = (pte_t *)pmd_alloc(mm, pud, addr);
+	pte = (pte_t *)pmd_alloc(mm, pud, addr, GFP_KERNEL);
 	i_mmap_unlock_write(mapping);
 	return pte;
 }
@@ -4776,10 +4776,10 @@ pte_t *huge_pte_alloc(struct mm_struct *mm,
 	pte_t *pte = NULL;
 
 	pgd = pgd_offset(mm, addr);
-	p4d = p4d_alloc(mm, pgd, addr);
+	p4d = p4d_alloc(mm, pgd, addr, GFP_KERNEL);
 	if (!p4d)
 		return NULL;
-	pud = pud_alloc(mm, p4d, addr);
+	pud = pud_alloc(mm, p4d, addr, GFP_KERNEL);
 	if (pud) {
 		if (sz == PUD_SIZE) {
 			pte = (pte_t *)pud;
@@ -4788,7 +4788,8 @@ pte_t *huge_pte_alloc(struct mm_struct *mm,
 			if (want_pmd_share() && pud_none(*pud))
 				pte = huge_pmd_share(mm, addr, pud);
 			else
-				pte = (pte_t *)pmd_alloc(mm, pud, addr);
+				pte = (pte_t *)pmd_alloc(mm, pud, addr,
+							 GFP_KERNEL);
 		}
 	}
 	BUG_ON(pte && pte_present(*pte) && !pte_huge(*pte));
diff --git a/mm/kasan/init.c b/mm/kasan/init.c
index ce45c491eb..3ed63dcb7a 100644
--- a/mm/kasan/init.c
+++ b/mm/kasan/init.c
@@ -129,7 +129,7 @@ static int __ref zero_pmd_populate(pud_t *pud, unsigned long addr,
 			pte_t *p;
 
 			if (slab_is_available())
-				p = pte_alloc_one_kernel(&init_mm);
+				p = pte_alloc_one_kernel(&init_mm, GFP_KERNEL);
 			else
 				p = early_alloc(PAGE_SIZE, NUMA_NO_NODE);
 			if (!p)
@@ -166,7 +166,7 @@ static int __ref zero_pud_populate(p4d_t *p4d, unsigned long addr,
 			pmd_t *p;
 
 			if (slab_is_available()) {
-				p = pmd_alloc(&init_mm, pud, addr);
+				p = pmd_alloc(&init_mm, pud, addr, GFP_KERNEL);
 				if (!p)
 					return -ENOMEM;
 			} else {
@@ -207,7 +207,7 @@ static int __ref zero_p4d_populate(pgd_t *pgd, unsigned long addr,
 			pud_t *p;
 
 			if (slab_is_available()) {
-				p = pud_alloc(&init_mm, p4d, addr);
+				p = pud_alloc(&init_mm, p4d, addr, GFP_KERNEL);
 				if (!p)
 					return -ENOMEM;
 			} else {
@@ -280,7 +280,7 @@ int __ref kasan_populate_early_shadow(const void *shadow_start,
 			p4d_t *p;
 
 			if (slab_is_available()) {
-				p = p4d_alloc(&init_mm, pgd, addr);
+				p = p4d_alloc(&init_mm, pgd, addr, GFP_KERNEL);
 				if (!p)
 					return -ENOMEM;
 			} else {
diff --git a/mm/memory.c b/mm/memory.c
index ab650c21bc..f599cdd1bc 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -435,9 +435,9 @@ int __pte_alloc(struct mm_struct *mm, pmd_t *pmd)
 	return 0;
 }
 
-int __pte_alloc_kernel(pmd_t *pmd)
+int __pte_alloc_kernel(pmd_t *pmd, gfp_t gfp)
 {
-	pte_t *new = pte_alloc_one_kernel(&init_mm);
+	pte_t *new = pte_alloc_one_kernel(&init_mm, gfp);
 	if (!new)
 		return -ENOMEM;
 
@@ -884,7 +884,7 @@ static inline int copy_pmd_range(struct mm_struct *dst_mm, struct mm_struct *src
 	pmd_t *src_pmd, *dst_pmd;
 	unsigned long next;
 
-	dst_pmd = pmd_alloc(dst_mm, dst_pud, addr);
+	dst_pmd = pmd_alloc(dst_mm, dst_pud, addr, GFP_KERNEL);
 	if (!dst_pmd)
 		return -ENOMEM;
 	src_pmd = pmd_offset(src_pud, addr);
@@ -918,7 +918,7 @@ static inline int copy_pud_range(struct mm_struct *dst_mm, struct mm_struct *src
 	pud_t *src_pud, *dst_pud;
 	unsigned long next;
 
-	dst_pud = pud_alloc(dst_mm, dst_p4d, addr);
+	dst_pud = pud_alloc(dst_mm, dst_p4d, addr, GFP_KERNEL);
 	if (!dst_pud)
 		return -ENOMEM;
 	src_pud = pud_offset(src_p4d, addr);
@@ -952,7 +952,7 @@ static inline int copy_p4d_range(struct mm_struct *dst_mm, struct mm_struct *src
 	p4d_t *src_p4d, *dst_p4d;
 	unsigned long next;
 
-	dst_p4d = p4d_alloc(dst_mm, dst_pgd, addr);
+	dst_p4d = p4d_alloc(dst_mm, dst_pgd, addr, GFP_KERNEL);
 	if (!dst_p4d)
 		return -ENOMEM;
 	src_p4d = p4d_offset(src_pgd, addr);
@@ -1422,13 +1422,13 @@ pte_t *__get_locked_pte(struct mm_struct *mm, unsigned long addr,
 	pmd_t *pmd;
 
 	pgd = pgd_offset(mm, addr);
-	p4d = p4d_alloc(mm, pgd, addr);
+	p4d = p4d_alloc(mm, pgd, addr, GFP_KERNEL);
 	if (!p4d)
 		return NULL;
-	pud = pud_alloc(mm, p4d, addr);
+	pud = pud_alloc(mm, p4d, addr, GFP_KERNEL);
 	if (!pud)
 		return NULL;
-	pmd = pmd_alloc(mm, pud, addr);
+	pmd = pmd_alloc(mm, pud, addr, GFP_KERNEL);
 	if (!pmd)
 		return NULL;
 
@@ -1768,7 +1768,7 @@ static inline int remap_pmd_range(struct mm_struct *mm, pud_t *pud,
 	int err;
 
 	pfn -= addr >> PAGE_SHIFT;
-	pmd = pmd_alloc(mm, pud, addr);
+	pmd = pmd_alloc(mm, pud, addr, GFP_KERNEL);
 	if (!pmd)
 		return -ENOMEM;
 	VM_BUG_ON(pmd_trans_huge(*pmd));
@@ -1791,7 +1791,7 @@ static inline int remap_pud_range(struct mm_struct *mm, p4d_t *p4d,
 	int err;
 
 	pfn -= addr >> PAGE_SHIFT;
-	pud = pud_alloc(mm, p4d, addr);
+	pud = pud_alloc(mm, p4d, addr, GFP_KERNEL);
 	if (!pud)
 		return -ENOMEM;
 	do {
@@ -1813,7 +1813,7 @@ static inline int remap_p4d_range(struct mm_struct *mm, pgd_t *pgd,
 	int err;
 
 	pfn -= addr >> PAGE_SHIFT;
-	p4d = p4d_alloc(mm, pgd, addr);
+	p4d = p4d_alloc(mm, pgd, addr, GFP_KERNEL);
 	if (!p4d)
 		return -ENOMEM;
 	do {
@@ -1956,7 +1956,7 @@ static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
 	spinlock_t *uninitialized_var(ptl);
 
 	pte = (mm == &init_mm) ?
-		pte_alloc_kernel(pmd, addr) :
+		pte_alloc_kernel(pmd, addr, GFP_KERNEL) :
 		pte_alloc_map_lock(mm, pmd, addr, &ptl);
 	if (!pte)
 		return -ENOMEM;
@@ -1990,7 +1990,7 @@ static int apply_to_pmd_range(struct mm_struct *mm, pud_t *pud,
 
 	BUG_ON(pud_huge(*pud));
 
-	pmd = pmd_alloc(mm, pud, addr);
+	pmd = pmd_alloc(mm, pud, addr, GFP_KERNEL);
 	if (!pmd)
 		return -ENOMEM;
 	do {
@@ -2010,7 +2010,7 @@ static int apply_to_pud_range(struct mm_struct *mm, p4d_t *p4d,
 	unsigned long next;
 	int err;
 
-	pud = pud_alloc(mm, p4d, addr);
+	pud = pud_alloc(mm, p4d, addr, GFP_KERNEL);
 	if (!pud)
 		return -ENOMEM;
 	do {
@@ -2030,7 +2030,7 @@ static int apply_to_p4d_range(struct mm_struct *mm, pgd_t *pgd,
 	unsigned long next;
 	int err;
 
-	p4d = p4d_alloc(mm, pgd, addr);
+	p4d = p4d_alloc(mm, pgd, addr, GFP_KERNEL);
 	if (!p4d)
 		return -ENOMEM;
 	do {
@@ -3868,11 +3868,11 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 	vm_fault_t ret;
 
 	pgd = pgd_offset(mm, address);
-	p4d = p4d_alloc(mm, pgd, address);
+	p4d = p4d_alloc(mm, pgd, address, GFP_KERNEL);
 	if (!p4d)
 		return VM_FAULT_OOM;
 
-	vmf.pud = pud_alloc(mm, p4d, address);
+	vmf.pud = pud_alloc(mm, p4d, address, GFP_KERNEL);
 	if (!vmf.pud)
 		return VM_FAULT_OOM;
 	if (pud_none(*vmf.pud) && __transparent_hugepage_enabled(vma)) {
@@ -3898,7 +3898,7 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 		}
 	}
 
-	vmf.pmd = pmd_alloc(mm, vmf.pud, address);
+	vmf.pmd = pmd_alloc(mm, vmf.pud, address, GFP_KERNEL);
 	if (!vmf.pmd)
 		return VM_FAULT_OOM;
 	if (pmd_none(*vmf.pmd) && __transparent_hugepage_enabled(vma)) {
@@ -3991,9 +3991,10 @@ EXPORT_SYMBOL_GPL(handle_mm_fault);
  * Allocate p4d page table.
  * We've already handled the fast-path in-line.
  */
-int __p4d_alloc(struct mm_struct *mm, pgd_t *pgd, unsigned long address)
+int __p4d_alloc(struct mm_struct *mm, pgd_t *pgd, unsigned long address,
+		gfp_t gfp)
 {
-	p4d_t *new = p4d_alloc_one(mm, address);
+	p4d_t *new = p4d_alloc_one(mm, address, gfp);
 	if (!new)
 		return -ENOMEM;
 
@@ -4014,9 +4015,10 @@ int __p4d_alloc(struct mm_struct *mm, pgd_t *pgd, unsigned long address)
  * Allocate page upper directory.
  * We've already handled the fast-path in-line.
  */
-int __pud_alloc(struct mm_struct *mm, p4d_t *p4d, unsigned long address)
+int __pud_alloc(struct mm_struct *mm, p4d_t *p4d, unsigned long address,
+		gfp_t gfp)
 {
-	pud_t *new = pud_alloc_one(mm, address);
+	pud_t *new = pud_alloc_one(mm, address, gfp);
 	if (!new)
 		return -ENOMEM;
 
@@ -4046,10 +4048,11 @@ int __pud_alloc(struct mm_struct *mm, p4d_t *p4d, unsigned long address)
  * Allocate page middle directory.
  * We've already handled the fast-path in-line.
  */
-int __pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long address)
+int __pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long address,
+		gfp_t gfp)
 {
 	spinlock_t *ptl;
-	pmd_t *new = pmd_alloc_one(mm, address);
+	pmd_t *new = pmd_alloc_one(mm, address, gfp);
 	if (!new)
 		return -ENOMEM;
 
diff --git a/mm/migrate.c b/mm/migrate.c
index 663a544936..917ff0b3f7 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2616,13 +2616,13 @@ static void migrate_vma_insert_page(struct migrate_vma *migrate,
 		goto abort;
 
 	pgdp = pgd_offset(mm, addr);
-	p4dp = p4d_alloc(mm, pgdp, addr);
+	p4dp = p4d_alloc(mm, pgdp, addr, GFP_KERNEL);
 	if (!p4dp)
 		goto abort;
-	pudp = pud_alloc(mm, p4dp, addr);
+	pudp = pud_alloc(mm, p4dp, addr, GFP_KERNEL);
 	if (!pudp)
 		goto abort;
-	pmdp = pmd_alloc(mm, pudp, addr);
+	pmdp = pmd_alloc(mm, pudp, addr, GFP_KERNEL);
 	if (!pmdp)
 		goto abort;
 
diff --git a/mm/mremap.c b/mm/mremap.c
index e3edef6b7a..b1f9605fad 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -65,14 +65,14 @@ static pmd_t *alloc_new_pmd(struct mm_struct *mm, struct vm_area_struct *vma,
 	pmd_t *pmd;
 
 	pgd = pgd_offset(mm, addr);
-	p4d = p4d_alloc(mm, pgd, addr);
+	p4d = p4d_alloc(mm, pgd, addr, GFP_KERNEL);
 	if (!p4d)
 		return NULL;
-	pud = pud_alloc(mm, p4d, addr);
+	pud = pud_alloc(mm, p4d, addr, GFP_KERNEL);
 	if (!pud)
 		return NULL;
 
-	pmd = pmd_alloc(mm, pud, addr);
+	pmd = pmd_alloc(mm, pud, addr, GFP_KERNEL);
 	if (!pmd)
 		return NULL;
 
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index d59b5a73df..9bb9d44834 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -153,10 +153,10 @@ static pmd_t *mm_alloc_pmd(struct mm_struct *mm, unsigned long address)
 	pud_t *pud;
 
 	pgd = pgd_offset(mm, address);
-	p4d = p4d_alloc(mm, pgd, address);
+	p4d = p4d_alloc(mm, pgd, address, GFP_KERNEL);
 	if (!p4d)
 		return NULL;
-	pud = pud_alloc(mm, p4d, address);
+	pud = pud_alloc(mm, p4d, address, GFP_KERNEL);
 	if (!pud)
 		return NULL;
 	/*
@@ -164,7 +164,7 @@ static pmd_t *mm_alloc_pmd(struct mm_struct *mm, unsigned long address)
 	 * missing, the *pmd may be already established and in
 	 * turn it may also be a trans_huge_pmd.
 	 */
-	return pmd_alloc(mm, pud, address);
+	return pmd_alloc(mm, pud, address, GFP_KERNEL);
 }
 
 #ifdef CONFIG_HUGETLB_PAGE
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index e86ba6e74b..288d078ab6 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -132,7 +132,8 @@ static void vunmap_page_range(unsigned long addr, unsigned long end)
 }
 
 static int vmap_pte_range(pmd_t *pmd, unsigned long addr,
-		unsigned long end, pgprot_t prot, struct page **pages, int *nr)
+		unsigned long end, gfp_t gfp, pgprot_t prot,
+		struct page **pages, int *nr)
 {
 	pte_t *pte;
 
@@ -141,7 +142,7 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr,
 	 * callers keep track of where we're up to.
 	 */
 
-	pte = pte_alloc_kernel(pmd, addr);
+	pte = pte_alloc_kernel(pmd, addr, gfp);
 	if (!pte)
 		return -ENOMEM;
 	do {
@@ -158,51 +159,54 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr,
 }
 
 static int vmap_pmd_range(pud_t *pud, unsigned long addr,
-		unsigned long end, pgprot_t prot, struct page **pages, int *nr)
+		unsigned long end, gfp_t gfp, pgprot_t prot,
+		struct page **pages, int *nr)
 {
 	pmd_t *pmd;
 	unsigned long next;
 
-	pmd = pmd_alloc(&init_mm, pud, addr);
+	pmd = pmd_alloc(&init_mm, pud, addr, gfp);
 	if (!pmd)
 		return -ENOMEM;
 	do {
 		next = pmd_addr_end(addr, end);
-		if (vmap_pte_range(pmd, addr, next, prot, pages, nr))
+		if (vmap_pte_range(pmd, addr, next, gfp, prot, pages, nr))
 			return -ENOMEM;
 	} while (pmd++, addr = next, addr != end);
 	return 0;
 }
 
 static int vmap_pud_range(p4d_t *p4d, unsigned long addr,
-		unsigned long end, pgprot_t prot, struct page **pages, int *nr)
+		unsigned long end, gfp_t gfp, pgprot_t prot,
+		struct page **pages, int *nr)
 {
 	pud_t *pud;
 	unsigned long next;
 
-	pud = pud_alloc(&init_mm, p4d, addr);
+	pud = pud_alloc(&init_mm, p4d, addr, gfp);
 	if (!pud)
 		return -ENOMEM;
 	do {
 		next = pud_addr_end(addr, end);
-		if (vmap_pmd_range(pud, addr, next, prot, pages, nr))
+		if (vmap_pmd_range(pud, addr, next, gfp, prot, pages, nr))
 			return -ENOMEM;
 	} while (pud++, addr = next, addr != end);
 	return 0;
 }
 
 static int vmap_p4d_range(pgd_t *pgd, unsigned long addr,
-		unsigned long end, pgprot_t prot, struct page **pages, int *nr)
+		unsigned long end, gfp_t gfp, pgprot_t prot,
+		struct page **pages, int *nr)
 {
 	p4d_t *p4d;
 	unsigned long next;
 
-	p4d = p4d_alloc(&init_mm, pgd, addr);
+	p4d = p4d_alloc(&init_mm, pgd, addr, gfp);
 	if (!p4d)
 		return -ENOMEM;
 	do {
 		next = p4d_addr_end(addr, end);
-		if (vmap_pud_range(p4d, addr, next, prot, pages, nr))
+		if (vmap_pud_range(p4d, addr, next, gfp, prot, pages, nr))
 			return -ENOMEM;
 	} while (p4d++, addr = next, addr != end);
 	return 0;
@@ -215,7 +219,8 @@ static int vmap_p4d_range(pgd_t *pgd, unsigned long addr,
  * Ie. pte at addr+N*PAGE_SIZE shall point to pfn corresponding to pages[N]
  */
 static int vmap_page_range_noflush(unsigned long start, unsigned long end,
-				   pgprot_t prot, struct page **pages)
+				   gfp_t gfp, pgprot_t prot,
+				   struct page **pages)
 {
 	pgd_t *pgd;
 	unsigned long next;
@@ -227,7 +232,7 @@ static int vmap_page_range_noflush(unsigned long start, unsigned long end,
 	pgd = pgd_offset_k(addr);
 	do {
 		next = pgd_addr_end(addr, end);
-		err = vmap_p4d_range(pgd, addr, next, prot, pages, &nr);
+		err = vmap_p4d_range(pgd, addr, next, gfp, prot, pages, &nr);
 		if (err)
 			return err;
 	} while (pgd++, addr = next, addr != end);
@@ -236,11 +241,11 @@ static int vmap_page_range_noflush(unsigned long start, unsigned long end,
 }
 
 static int vmap_page_range(unsigned long start, unsigned long end,
-			   pgprot_t prot, struct page **pages)
+			   gfp_t gfp, pgprot_t prot, struct page **pages)
 {
 	int ret;
 
-	ret = vmap_page_range_noflush(start, end, prot, pages);
+	ret = vmap_page_range_noflush(start, end, gfp, prot, pages);
 	flush_cache_vmap(start, end);
 	return ret;
 }
@@ -1182,7 +1187,7 @@ void *vm_map_ram(struct page **pages, unsigned int count, int node, pgprot_t pro
 		addr = va->va_start;
 		mem = (void *)addr;
 	}
-	if (vmap_page_range(addr, addr + size, prot, pages) < 0) {
+	if (vmap_page_range(addr, addr + size, GFP_KERNEL, prot, pages) < 0) {
 		vm_unmap_ram(mem, count);
 		return NULL;
 	}
@@ -1298,7 +1303,8 @@ void __init vmalloc_init(void)
 int map_kernel_range_noflush(unsigned long addr, unsigned long size,
 			     pgprot_t prot, struct page **pages)
 {
-	return vmap_page_range_noflush(addr, addr + size, prot, pages);
+	return vmap_page_range_noflush(addr, addr + size, GFP_KERNEL, prot,
+				       pages);
 }
 
 /**
@@ -1339,13 +1345,14 @@ void unmap_kernel_range(unsigned long addr, unsigned long size)
 }
 EXPORT_SYMBOL_GPL(unmap_kernel_range);
 
-int map_vm_area(struct vm_struct *area, pgprot_t prot, struct page **pages)
+int map_vm_area(struct vm_struct *area, gfp_t gfp,
+		pgprot_t prot, struct page **pages)
 {
 	unsigned long addr = (unsigned long)area->addr;
 	unsigned long end = addr + get_vm_area_size(area);
 	int err;
 
-	err = vmap_page_range(addr, end, prot, pages);
+	err = vmap_page_range(addr, end, gfp, prot, pages);
 
 	return err > 0 ? 0 : err;
 }
@@ -1661,7 +1668,7 @@ void *vmap(struct page **pages, unsigned int count,
 	if (!area)
 		return NULL;
 
-	if (map_vm_area(area, prot, pages)) {
+	if (map_vm_area(area, GFP_KERNEL, prot, pages)) {
 		vunmap(area->addr);
 		return NULL;
 	}
@@ -1720,7 +1727,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 			cond_resched();
 	}
 
-	if (map_vm_area(area, prot, pages))
+	if (map_vm_area(area, gfp_mask, prot, pages))
 		goto fail;
 	return area->addr;
 
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 0787d33b80..d369e5bf27 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1151,7 +1151,7 @@ static inline void __zs_cpu_down(struct mapping_area *area)
 static inline void *__zs_map_object(struct mapping_area *area,
 				struct page *pages[2], int off, int size)
 {
-	BUG_ON(map_vm_area(area->vm, PAGE_KERNEL, pages));
+	BUG_ON(map_vm_area(area->vm, GFP_KERNEL, PAGE_KERNEL, pages));
 	area->vm_addr = area->vm->addr;
 	return area->vm_addr + off;
 }
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index a39dcfdbcc..0829eefb61 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -645,7 +645,7 @@ static int create_hyp_pmd_mappings(pud_t *pud, unsigned long start,
 		BUG_ON(pmd_sect(*pmd));
 
 		if (pmd_none(*pmd)) {
-			pte = pte_alloc_one_kernel(NULL);
+			pte = pte_alloc_one_kernel(NULL, GFP_KERNEL);
 			if (!pte) {
 				kvm_err("Cannot allocate Hyp pte\n");
 				return -ENOMEM;
@@ -677,7 +677,7 @@ static int create_hyp_pud_mappings(pgd_t *pgd, unsigned long start,
 		pud = pud_offset(pgd, addr);
 
 		if (pud_none_or_clear_bad(pud)) {
-			pmd = pmd_alloc_one(NULL, addr);
+			pmd = pmd_alloc_one(NULL, addr, GFP_KERNEL);
 			if (!pmd) {
 				kvm_err("Cannot allocate Hyp pmd\n");
 				return -ENOMEM;
@@ -712,7 +712,7 @@ static int __create_hyp_mappings(pgd_t *pgdp, unsigned long ptrs_per_pgd,
 		pgd = pgdp + kvm_pgd_index(addr, ptrs_per_pgd);
 
 		if (pgd_none(*pgd)) {
-			pud = pud_alloc_one(NULL, addr);
+			pud = pud_alloc_one(NULL, addr, GFP_KERNEL);
 			if (!pud) {
 				kvm_err("Cannot allocate Hyp pud\n");
 				err = -ENOMEM;
-- 
2.20.1
