Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FCF3358BC;
	Fri,  6 Mar 2026 09:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772791158; cv=fail; b=IGv/zQtYYPP9GyQCegYzwiCm+i8wxfFjxi2VdFT+RGKUXPtM1Ej+UWVCQyI7no9EcnjTe4ROn+FzfHPikcWpqqnCT8JnhUD9PKhgo26NQG9ZNJGlIeCGhxtq3SknMII5yqnYHZy5OYDLNQ4VUblENLdACOY27j3Bx9ispMrstzc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772791158; c=relaxed/simple;
	bh=f+z6ql9M5JhawzkmfcJJBxApS2D5ls0dv54BOWw8ja8=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PlAJqQfDKMMKkpouslMuPLxxLBb9TRofPAUrthYXVO/eIPjlQQVyUG56fsElPRcTBQGufKU5euN2vT/qji2k38NiiDoN43Mrp8blJzyxFcLhdWnbrOssBx/bKz8mxkQDA2S+w3xQyDwjL5imgV6i6HRtUkQ+yQPf+jqS1SqdcXc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=VjiOIzNj; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=KqUlsHoC; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="VjiOIzNj";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="KqUlsHoC"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1772791156; x=1804327156;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=f+z6ql9M5JhawzkmfcJJBxApS2D5ls0dv54BOWw8ja8=;
  b=VjiOIzNj+57SmkpmbJbevWp+9BJBEhO62zYAZ1GO9b3sJTyuYco0w+9J
   qrsh5DhG9kaut19XfcfYNKlfIQvlyCpzi513Z2SWRdttN48P+MPbQVGqj
   nqQrDdVmwbxWxpvt2ZaMAUEjmb+XUXBNvm3Ma8eDXOp5fzIlmk+j8EtG5
   XbSG/IQW3sVLxwqp8tQumsvkh+PN3c8fDc4tw9xPTcqjeS9OOcmxf+p5Y
   9yRfJ4ogLYFsrUPLPsGvSsXrU0Hp2SOybz51xqMFGmPqAd2D0H/M3/WBA
   uoNOKoYLujeCz4iwb5ul3V6NXo2LoNlO9W8j5lsNHn3cwG1p2Ullf40dW
   A==;
X-CSE-ConnectionGUID: W+QF6INuSYCEM84qkJ97Ng==
X-CSE-MsgGUID: A3NckSbpQ2+fP/K+40/CUA==
X-IronPort-AV: E=Sophos;i="6.23,104,1770566400"; 
   d="scan'208";a="143160444"
Received: from mail-eastus2azon11010006.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([52.101.56.6])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Mar 2026 17:59:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zNDswWcjkIJhn4Q/mf/AeOEFRgwoLLVskACwIbyalPXcFEYWBqgyFxPtt/fm1GuoVWZaFW4RTGPTobxPzDDv8RDyYtmtQ77OOCWxCUSvyN4pfGbNwTdMCr7csU4U2bQLVYXacot5FC2rcVaJcTYpjgclwzJhT87f0qiAxsfTFS1O3vitJSr6Q3yxvrq3SnGGV8hNoncsCuwm1UvOQLJCwDc7oafFQ/Io0f59KtWjCltbfHed5s9D2Kj0IOxD5Vzq6ym1caxUxRNnoApmEilLS0o+oQ1GU1lnjjSbAvb5SB7VSM7uHbU++WYvbSql/k6qZPyidxTE69Tij/FXnTyNug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f+z6ql9M5JhawzkmfcJJBxApS2D5ls0dv54BOWw8ja8=;
 b=Bp8nQ4hCAVkWeDJzECkv3/mhSU3uwor9aJJR5J6ODcP1EEqOxiyw0BdZ9PAz+Vi7L+BeJQJUW3HXnjyq4eJMenFC4L8M2AizpbzRqqTKp+LDqmfdNfClN+fPvJq9G4yC/MMKBVRsjrVvntXWu2ayLMGT2lwJG7NbmT+iaiXmISXqYxvTLI0EzNGAHg43m7QpyOEWfl7GZB8H1nOJemT0qQqVjNjoA9TD7pOmb4ecOBVDtOqKDNENWzfmTNAetWnIaekDHBoA8l7Ztrv5YT/0E59AR6HSaXwaMYFc4ngOHp7EGZ1sF5KWqxKJDFGF3NU3YS+MEWD7DcoiwNHRQ7duZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f+z6ql9M5JhawzkmfcJJBxApS2D5ls0dv54BOWw8ja8=;
 b=KqUlsHoCELVQK8ndOIaI+YfH8tfnwTCSXheybVpDsLCV7b1j/zCJOnLOfWsM+O1wXE/V7Jb21Oqmfc8UeTS58wmNrofFgDp6AgZWwVigICxAnORQ96ybRncg5Tf2J4Y9Zd5VgD5tXiuMSAyWmN+fs74Kmj+JRe+zuCzMNEIIgKI=
Received: from LV8PR04MB8984.namprd04.prod.outlook.com (2603:10b6:408:18b::13)
 by LV3PR04MB8989.namprd04.prod.outlook.com (2603:10b6:408:195::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.19; Fri, 6 Mar
 2026 09:59:08 +0000
Received: from LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::14a1:5b7a:6cf4:31a3]) by LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::14a1:5b7a:6cf4:31a3%3]) with mapi id 15.20.9678.017; Fri, 6 Mar 2026
 09:59:08 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Daniel Wagner <dwagner@suse.de>, "hch@infradead.org" <hch@infradead.org>,
	Stephen Zhang <starzhangzsd@gmail.com>, Kent Overstreet
	<kent.overstreet@linux.dev>, Coly Li <colyli@fnnas.com>, Shinichiro Kawasaki
	<shinichiro.kawasaki@wdc.com>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-bcache@vger.kernel.org"
	<linux-bcache@vger.kernel.org>
Subject: Re: [PATCH blktests v5 2/3] bcache: add bcache/002
Thread-Topic: [PATCH blktests v5 2/3] bcache: add bcache/002
Thread-Index: AQHcrLEPIg8DA5bM1USnz59kKuQTebWhRluA
Date: Fri, 6 Mar 2026 09:59:07 +0000
Message-ID: <ad17d94c-2951-4a00-9f15-066f993288a3@wdc.com>
References: <20260305-bcache-v5-0-04cd4c9080d7@suse.de>
 <20260305-bcache-v5-2-04cd4c9080d7@suse.de>
In-Reply-To: <20260305-bcache-v5-2-04cd4c9080d7@suse.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR04MB8984:EE_|LV3PR04MB8989:EE_
x-ms-office365-filtering-correlation-id: 93482ce3-25e7-4291-7d6f-08de7b670232
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|19092799006|376014|10070799003|1800799024|366016|38070700021;
x-microsoft-antispam-message-info:
 HjwAN4P2LzMb2GkO9BpLsDYtl+8OByYL8HvI9eev4Zyte17VUrhjNL2hB+i7SDEPIr6hHP/z4ux9QCu1jNKjJ9iAGyqD7Mp4TYOvD2FUeunexWms/rmch56aLKMSHnQfCL4IQ1HY2WCzRwMPbYbm0cRYQbf7TUU07JfSsH6k7kiKpqAXZjqvRaGzB0QyW1PST2y4Cit076MaYkuKJPRB5/Qza3z5qIHmWYSgRjFgLm9dJv4oUEOX5OxJ/YndfZHnPJVHpFcfk3sN19WVUFh+bftD9v0be56YuUXbqz78QYK2IVoXw3/33Hd65m1kASp9lNZIirBVaFLn5tchXcGlGmVssgV2JwGQcN6LQc00ffxK5OXQOJELKWs7hFBroXnoAkQfKK+Z3xVm4td11c+nSElrt1MiDGtsoKvqqAMw4w16LjhymHVox9LJ0/Ng+gc91Qt7O0O6RBQB/iR9TaI0IG5YqpzMncKzOBF38Laqq91ellszOzUoqu4bYCSrdOGD8e5aXteQ8vUwwd0xhuj+FFFIr//3OgrFbj8+QoHIx+nioetGqoDDqBgfVnKkDKVUpWMjlKx+aXNVd9GmRE8sHwVXnpDYgy6YK3F6yB+5vdK7YYVNYG58a464h+UMb72Z9qVoAIE+G8fNhyXschtjb6x1AJN2BXU1tDAW1OkWf5YJxkBBcXPxWCeZToIDV0uKuFSKW8m0myDGV5YB1rH3xAS4GERTTf1SW8jwWlnENClQLV/tr4gGeXxxC667gf6TQW2WjPbIqi6Gssx7tgg1qrUebJyd5K7Z5UBNDc6RwM0=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR04MB8984.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(376014)(10070799003)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WTlmb1E3R2o0aXZkc2lpeGVmTFdVOGlXVnFsNk9tT25pRGN3bjN2eUdpWmNv?=
 =?utf-8?B?UDVIL29sbXkrMmxxc2VaWGEycHFFT3N5MFBuUVQyUnY3OUZVWUhEMlIvRXpr?=
 =?utf-8?B?NSt5R0ZKZE0yYmRsL0lVM1FRK0pKYXpRNUhnN0JVdTA0YWR4aXd2aWJxTkx3?=
 =?utf-8?B?Zm41WHVOUVZRSkJYNkliRjU3T1J2WGdEOG1UZGE0SXFHeSs3aERGZ3VIRXMv?=
 =?utf-8?B?NjBua0RwNFp6dlEyWkhRUzVhQ3lkU3RsRzl6QlB4eFl0aUVVVEJ6Q3AxUmp2?=
 =?utf-8?B?YXB0REpPRU1SSWM4WGJDdUFuUXpzRHVqUVl5d0pkSUhEUEJDdEFRaTFNc3k1?=
 =?utf-8?B?R21JRFJQY2ZZRTFacnpXdWVmbmgrNDkyR3VEcGhxK1VCdG9qYXRvTFRFMWVa?=
 =?utf-8?B?ZkdFaUlRMVhmbkRHOXVIODhYVlhTakdiNndNUTd5bE40MDMyZVh3Smh0L1NF?=
 =?utf-8?B?bE5mVENDYVlNby9JS1lQV2ltQ01MMFVHalNsdEhyTWh1ZzFpM3hNY3kvRlRK?=
 =?utf-8?B?NC81NmJHUmFKS3c0WXlvbHIrTVYyOUtrYXFZZmpuRno1L3N3TVdaRk8xQzE1?=
 =?utf-8?B?dkgxemVzNTNuN1VuOEY4NDlFSmVpeHFmYTlMdmlyMEdZSGx5VWJXQlU3RlQ4?=
 =?utf-8?B?U2ZEanJwK1JGNzNtL25jSEpUa3loaS8rYWZ2cTlHcFlpM2xhUndLRGJPcDlz?=
 =?utf-8?B?bFAweFlXamxrUGNGekhmUEZQMlNXU0cyRk5aZFhLUDNVVUFLc0hnaUE2Szcx?=
 =?utf-8?B?ZllkeEpSQ1dRVmI2bk1NcmNiTHNFdEIrRk55MHhjM0d3OHFpaHZ6YzgwNWUz?=
 =?utf-8?B?ZjhtWDByaFhKZ0tBOGh1TlZsUjZhN3FmWXlxc09mQVcwcERVWWt5UDhuM2c3?=
 =?utf-8?B?RXNUeGV4TWN2N3FjMG1FbEo3THMyODR0cmxYT09rWUhpdXhGWU1pakVEK21M?=
 =?utf-8?B?NmczeW5BemFiZUg5ODl0UmdqK0Z0bkNFOFVaZGQvbmk2WGc0T1VVYlU5YXAz?=
 =?utf-8?B?TXY4bE9vbE80NjBkaGNzYklvOS9kYlgvYkR5Y0xkMFZYQ1hLY2hoODVFVHpF?=
 =?utf-8?B?NGIzUCtSN0hDbi9EZHhBZ0w4MlFGQjV2RmZDc2FLd0dONkRWaHVuNkJldXJJ?=
 =?utf-8?B?bC9MSkd5eTdjcWMyek12WFo5OC9TWEtqM3RaUXZZSjBScExXMlcxVE1FSk9E?=
 =?utf-8?B?TXZMV3hFUHNjRmw2SmZENnRjREUyR1pCbU85STI2N2R4ZVpNQngwZVQvSFRt?=
 =?utf-8?B?bXFqNUxEUXFEa1Bqd3hwSjBqMTZZQlRLMlRxdTFzZTVYUUpYWHlXUEkrajFN?=
 =?utf-8?B?OW9yMDdkeXhuL0hNQjIrWW85Tkhqc0lYeVRJR2Y5aW5EWnhlODhoVVVabTBU?=
 =?utf-8?B?ZnI4WDRyS3BleXRjSXJmZGZEUFdtZDE3MDdsMTM1K05mdG5zT0NDY3hQYzNY?=
 =?utf-8?B?M1BlY0F0d3FvSm1IVEF2UGdhQWxXS1RGbkFQNDZTUUN2bEhSRTFMTGswV2Ur?=
 =?utf-8?B?d05TRUJvcERuOG1xS2hTQ3c3ZlNoQnFDeXZxcyt6bnNoMWJ3QWQ2YTF3MWpK?=
 =?utf-8?B?VEFmVm1NMzg3WWVNOTJBZHVmTjBqajg1Y2NITjBianZhaXBrRkFRU3lpUzNW?=
 =?utf-8?B?anBOTmdjT2MyU0djMEtQYWhyMG1yYWRwc0NlV1ZuQWJPMFpxYUM5bzdTaUF2?=
 =?utf-8?B?SkFCYUJrMXkxOUNEN1NnYjZQVmRKY1Z6UmJnd0xHL2dXd2VSVnpFTGJUS21T?=
 =?utf-8?B?aG9LeFZ5bEw0eGlUdFFuN3ZKSUdyamFYU0hMM3ZUY2RJV0dQVXIyZkxNbnNM?=
 =?utf-8?B?dXJHcVZGV0hXSUlhVXZsK0pGVzZTZ0xmUzREVjZmWlZ2cmF2a2tQSThWTFBn?=
 =?utf-8?B?NHhHZVNhcmlzUm1qc1pFdmNMbEMrTGR2R0pBWTkxM2pDUFZqS2FRN1NhSCtw?=
 =?utf-8?B?ck1ocFpKT1lDaGY3TEIxa1k0c1RKN3FhT2hncDJkRnN6TzdrWWVVZ1ZEU1Fw?=
 =?utf-8?B?ckRFTW5URjBtWjRkbXJjU0tQY2RUNzF6Q0tZS1pTeVo1WHJpTGRleEE2WTJx?=
 =?utf-8?B?Qkd3OCtWMHhGYjRMQjVJYlk3M2RocnhzUHN4ZlJ6WCtHMXMvVkxvYlY5U3Fx?=
 =?utf-8?B?d0cxMDNaQ01HczluaXpKNmhSMGZHWUttaFMzV3FtbkVSK2hyL3ArK3MzYThh?=
 =?utf-8?B?VHJIUTBHWndtZW5rcG4yVTFLU2xtaFdiZUpUTDR1dDVRQzZaZkkyQTBiR1dQ?=
 =?utf-8?B?WkwxaDQzNHhnWEJ0VHZqaXhEYk9RcnhYRWFMc3pxQWR0bEtPQUhxSERvNzQ2?=
 =?utf-8?B?YTdZVXlOWWh5cFpmbUo1aUh3Tk4yS29wRWJpZzVjVU85WWRQVXppWUU3dEwz?=
 =?utf-8?Q?OdCpb8rLq4NRddGN+K5FZ5lEL56r/uBbkaLLAtM0I3TMZ?=
x-ms-exchange-antispam-messagedata-1: PMydbgqTEIc/hB4K1qW5oC+j2OpdDsUQRps=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F14E183683C2064E98CA36B840D6CF3B@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ycEUdW63cUXAQkMletMClpcGhPxZ3uDXFXPXUJm4HTGTlqge6MgihuTChBZFBCwzulzV2xJXdCPfuggqWVb2Omtnxq1p54wPQHQDEMp9z+rXzFdUMKB20ojV9ZjvcdFqLrNLXp8C5vpOGvl752HS1qx9ZGLK32w2l+ryTIxcvsScHrl1yjWY3BTyTef0Y7T9k9qP2uMtSpuxx6ek28WwOruEHk7bMmnppPC+SwCxAhXhB8GbLZXGCpBFFWy8Oe1Q7CmxbUb4BfgWlFs07l0hdzKHsPjfAvLubw0T76CL7BBBXUSDuhoNsUEL9qMwF+xNQ8/Iru8uIkUmrh3Vvh71rUgazP0tqPoIUuNWwHT1RKPO37P0CvPaONlrcITHNRJ8XkcxDl2c9WHFulsFkBdNGdybH2g4mPGW+oRGjvV1Cvja72y5/fTed2SKjBx9t86yPE8BeRakp+H8WpOYu223fQiF2BzYrmXEpZ7H6bmrE0l5gw/90wTcRQObix43vNXTHGh5+I+oPp7henUfkqcOJZS1o/H8Iz56GTSOKEnuhgLkzRTNphw7R6lWsD4+OvJwRS1Yz7HWB2FrEYGE54ucspXMWE1poA34zPkiqBVwIRWeCE+pWAJfKClnNePELbzE
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV8PR04MB8984.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93482ce3-25e7-4291-7d6f-08de7b670232
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Mar 2026 09:59:08.1753
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4WBjtHHyCF71Ruz8jeh+jdzx4lfeDvSgMnEal3QzlKDdyaM31Mq0/yXmkXCatew6K0zk7IcPNQRynY6r6ltpuUSFoI46gFjUS+nrzoLdg4s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR04MB8989

TG9va3MgZ29vZCwNCg0KUmV2aWV3ZWQtYnk6IEpvaGFubmVzIFRodW1zaGlybiA8am9oYW5uZXMu
dGh1bXNoaXJuQHdkYy5jb20+DQoNCg==
