
#ifndef _VPD_H_
#define _VPD_H_

#include <stdint.h>

#define True  1
#define False 0
#define Null  NULL

typedef uint8_t  u8;
typedef uint16_t u16;
typedef uint32_t u32;

#define PIP "TV4-MC142" /* PIP or TV-MCxxx */
#define MSN "142"       /* "machine" serial number, usually the PIP or TV4 number */

typedef struct {
    u16  length;        /* 0000: length of block0 */
    u16  version;       /* 0002: VPD version 2.41 */
    u16  block_length;  /* 0004: block length */
    u8   block_id;      /* 0006: block ID */
    u8   _res_1;        /* 0007: reserved, set to 0x00 */
    char vpd_id[2];     /* 0008: VPD ID */
    char pos_ext[2];    /* 000A: POS ID extension */
    char pos_id[2];     /* 000C: POS ID */
    char mtm[7];        /* 000E: machine type / model, left-justified, pad with 0x20 */
    char msn[7];        /* 0015: machine serial right-justified, pad with '0' */
    char asset_id[32];  /* 001C: asset ID, left-justified, pad with 0x20 */
    char card_pn[12];   /* 003C: card part number, left-justified, pad with 0x20 */
    char card_fru[12];  /* 0048: card FRU, left-justified, pad with 0x20 */
    char card_sn[6];    /* 0054: card serial number, right-justified, pad with '0' */
    char card_psn[6];   /* 005A: card serial number prefix, left-justified, pad with 0x20 */
    char mfg[4];        /* 0060: system manufacturer, left-justified, pad with 0x20 */
    u8   _res_2;        /* 0064: reserved, set to 0x00 */
    u8   hw_rev;        /* 0065: hardware revision */
    char phy_a;         /* 0066: physical characteristic: PCB raw card mfg */
    char phy_b[2];      /* 0067: physical characteristic: PCB raw material */
    u8   phy_c;         /* 0069: physical characteristic: PCB layers */
    u8   phy_d;         /* 006A: physical characteristic: PCB thickness, in mils */
    char mfg_dc[4];     /* 006B: MFG date card, YYWW */
    u8   emac[48];      /* 006F: Ethernet MAC (52:54:00:c4:a6:37) */
    u8   uuid[16];      /* 009F: UUID (123e4567-e89b-12d3-a456-426614174000) */
    char typecode;      /* 00AF: type code */
    char sciic[16];     /* 00B0: "static component internal interface characteristics" */
    u8   block[8];      /* 00C0: block0, use block1 if port I/F characteristics being used */
    u16  block1;        /* 00C8: block1 offset */
    u16  block2;        /* 00CA: block2 offset */
    u16  block3;        /* 00CC: block3 offset */
    u16  block4;        /* 00CE: block4 offset */
    u16  block5;        /* 00D0: block5 offset */
    u16  block6;        /* 00D2: block6 offset */
    u16  block7;        /* 00D4: block7 offset */
    u8   _res_3;        /* 00D6: reserved, set to 0x00 */
    u8   subcode;       /* 00D7: type subcode */
    u32  ina_en;        /* 00D8: INA enterprise number */
    u16  ina_pid;       /* 00DC: INA product ID */
    u8   _res_4[18];    /* 00DE: reserved, set to 0x00 */
    u16  consume;       /* 00F0: max power consumed in 1 watt increments */
    u16  produce;       /* 00F2: max power produced in 1 watt increments */
    u8   _res_5[12];    /* 00F4: reserved, set to 0x00 */
    char mfg_id[4];     /* 0100: subsystem mfg ID, left-justified, pad with 0x20 */
    u8   clei[10];      /* 0104: CLEI code assignment */
    char _res_6[370];   /* 010E: reserved, set to 0x00 */
    char oem_vpd[192];  /* 0280: OEM base VPD */
    char oem_ext[128];  /* 0340: OEM extended VPD */
    char _res_7[64];    /* 03C0: reserved, set to 0x00 */
} __attribute__((__packed__)) vpd_t;

char *vpd_label( void );
char *vpd_path( int wing );
void vpd_init( vpd_t *vpd );

/*
 * Convert non-null terminated ASCII field to something we can print
 */
#define S(field) s(field,sizeof field)
extern char *s( char *f, int l );

/*
 * Format null-terminated string to fixed-length field
 *   - F:  left-justified, pad with 0x20
 *   - N: right-justified, pad with '0' (for serial numbers)
 *   - Z: right-justified, pad with 0x00 (we'll never really use this)
 */
#define F(field,s) g(field,sizeof field,s,0x20)
#define N(field,s) f(field,sizeof field,s,'0')
#define Z(field,s) f(field,sizeof field,s,0)
extern void f( char *f, int l, char *s, char p );
extern void g( char *f, int l, char *s, char p );

#endif /*_VPD_H_*/
