
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <fcntl.h>
#include <string.h>
#include <ctype.h>
#include "vpd.h"

static void map_xy( vpd_t *vpd );

char *vpd_label( void ) {
    return "L0.6 Wafer Board for " PIP;
}

char *vpd_path( int n ) {
    return "/sys/devices/platform/amba/ff020000.i2c/i2c-0/0-0051/eeprom";
}

/*
 * Configuration: L0.6 Wafer Board
 *   - X,Y location is derived from the CVMM name
 */
void vpd_init( vpd_t *vpd ) {
    vpd->length       = 0x03FE;          /* 0000: length of block0 */
    vpd->version      = 0x0107;          /* 0002: VPD version 2.41 */
    vpd->block_length = 0x03FC;          /* 0004: block length */
    vpd->block_id     = 0x00;            /* 0006: block ID */
    vpd->_res_1       = 0x00;            /* 0007: reserved, set to 0x00 */

    F( vpd->vpd_id,   ""             );  /* 0008: VPD ID */
    F( vpd->pos_ext,  ""             );  /* 000A: (XX) POS ID extension */
    F( vpd->pos_id,   ""             );  /* 000C: (YY) POS ID */
    F( vpd->mtm,      ""             );  /* 000E: machine type / model, left-justified, pad with 0x20 */
    N( vpd->msn,      MSN            );  /* 0015: machine serial right-justified, pad with '0' */   /* PIP# */
    F( vpd->asset_id, ""             );  /* 001C: asset ID, left-justified, pad with 0x20 */
    F( vpd->card_pn,  "PIP WAFERBRD" );  /* 003C: card part number, left-justified, pad with 0x20 */
    F( vpd->card_fru, "C0-EC0"       );  /* 0048: card FRU, left-justified, pad with 0x20 */
    N( vpd->card_sn,  "5"            );  /* 0054: card serial number, right-justified, pad with '0' */
    F( vpd->card_psn, "011421"       );  /* 005A: card serial number prefix, left-justified, pad with 0x20 */
    F( vpd->mfg,      "COCO"         );  /* 0060: system manufacturer, left-justified, pad with 0x20 */

    vpd->_res_2       = 0x00;            /* 0064: reserved, set to 0x00 */
    vpd->hw_rev       = 0x3C;            /* 0065: hardware revision */
    vpd->phy_a        = 'T';             /* 0066: physical characteristic: PCB raw card mfg */

    F( vpd->phy_b,    "E8"           );  /* 0067: physical characteristic: PCB raw material */

    vpd->phy_c        = 6;               /* 0069: physical characteristic: PCB layers */
    vpd->phy_d        = 0x5D;            /* 006A: physical characteristic: PCB thickness, in mils */

    F( vpd->mfg_dc,   "2135"         );  /* 006B: MFG date card, YYWW */
    Z( vpd->emac,     ""             );  /* 006F: Ethernet MAC (52:54:00:c4:a6:37) */
    Z( vpd->uuid,     ""             );  /* 009F: UUID (123e4567-e89b-12d3-a456-426614174000) */

    vpd->typecode     = ' ';             /* 00AF: type code */

    F( vpd->sciic,    ""             );  /* 00B0: "static component internal interface characteristics" */
    Z( vpd->block,    ""             );  /* 00C0: block0, use block1 if port I/F characteristics being used */

    vpd->block1       = 0x0400;          /* 00C8: block1 offset */
    vpd->block2       = 0x0800;          /* 00CA: block2 offset */
    vpd->block3       = 0x0C00;          /* 00CC: block3 offset */
    vpd->block4       = 0x1000;          /* 00CE: block4 offset */
    vpd->block5       = 0x1400;          /* 00D0: block5 offset */
    vpd->block6       = 0x1800;          /* 00D2: block6 offset */
    vpd->block7       = 0x1C00;          /* 00D4: block7 offset */
    vpd->_res_3       = 0x00;            /* 00D6: reserved, set to 0x00 */
    vpd->subcode      = 0x00;            /* 00D7: type subcode */
    vpd->ina_en       = 0x00000000;      /* 00D8: INA enterprise number */
    vpd->ina_pid      = 0x0000;          /* 00DC: INA product ID */

    Z( vpd->_res_4,   ""             );  /* 00DE: reserved, set to 0x00 */

    vpd->consume      = 0x0001;          /* 00F0: max power consumed in 1 watt increments */
    vpd->produce      = 0x0000;          /* 00F2: max power produced in 1 watt increments */

    Z( vpd->_res_5,   ""             );  /* 00F4: reserved, set to 0x00 */

    F( vpd->mfg_id,   ""             );  /* 0100: subsystem mfg ID, left-justified, pad with 0x20 */

    Z( vpd->clei,     ""             );  /* 0104: CLEI code assignment */
    Z( vpd->_res_6,   ""             );  /* 010E: reserved, set to 0x00 */
    F( vpd->oem_vpd,  ""             );  /* 0280: OEM base VPD */
    F( vpd->oem_ext,  ""             );  /* 0340: OEM extended VPD */
    Z( vpd->_res_7,   ""             );  /* 03C0: reserved, set to 0x00 */

    map_xy( vpd );
}

struct {
    char x, y;
} map[] = {     /*  X    Y  */
    /* CVMM00 */ { '0', '0' },  /* dummy entry */
    /* CVMM01 */ { '7', '1' },
    /* CVMM02 */ { '6', '3' },
    /* CVMM03 */ { '8', '2' },
    /* CVMM04 */ { '8', '3' },    /*    W8        W7        W6        W5     */
    /* CVMM05 */ { '8', '4' },    
    /* CVMM06 */ { '4', '3' },    /*             (3,8)   (5,8)               */
    /* CVMM07 */ { '5', '1' },    /*              C30     C27                */
    /* CVMM08 */ { '5', '0' },    
    /* CVMM09 */ { '6', '4' },    /*     (1,7)   (3,7)   (5,7)   (7,7)       */
    /* CVMM10 */ { '6', '2' },    /*      C35     C31     C26     C23        */
    /* CVMM11 */ { '2', '3' },    
    /* CVMM12 */ { '2', '2' },    /*  (0,6)   (2,6)   (4,6)   (6,6)   (8,6)  */
    /* CVMM13 */ { '3', '1' },    /*   C36     C34     C29     C24     C22   */
    /* CVMM14 */ { '4', '2' },    
    /* CVMM15 */ { '3', '0' },    /*  (0,5)   (2,5)   (4,5)   (6,5)   (8,5)  */
    /* CVMM16 */ { '0', '4' },    /*   C37     C33     C32     C25     C21   */
    /* CVMM17 */ { '0', '3' },    
    /* CVMM18 */ { '0', '2' },    /*  (0,4)   (2,4)   (4,4)   (6,4)   (8,4)  */
    /* CVMM19 */ { '2', '4' },    /*   C16     C19     C28     C_9     C_5   */
    /* CVMM20 */ { '1', '1' },    
    /* CVMM21 */ { '8', '5' },    /*  (0,3)   (2,3)   (4,3)   (6,3)   (8,3)  */
    /* CVMM22 */ { '8', '6' },    /*   C17     C11     C_6     C_2     C_4   */
    /* CVMM23 */ { '7', '7' },    
    /* CVMM24 */ { '6', '6' },    /*  (0,2)   (2,2)   (4,2)   (6,2)   (8,2)  */
    /* CVMM25 */ { '6', '5' },    /*   C18     C12     C14     C10     C_3   */
    /* CVMM26 */ { '5', '7' },    
    /* CVMM27 */ { '5', '8' },    /*     (1,1)   (3,1)   (5,1)   (7,1)       */
    /* CVMM28 */ { '4', '4' },    /*      C20     C13     C_7     C_1        */
    /* CVMM29 */ { '4', '6' },    
    /* CVMM30 */ { '3', '8' },    /*             (3,0)   (5,0)               */
    /* CVMM31 */ { '3', '7' },    /*              C15     C_8                */
    /* CVMM32 */ { '4', '5' },    
    /* CVMM33 */ { '2', '5' },    /*    W4        W3        W1        W1     */
    /* CVMM34 */ { '2', '6' },
    /* CVMM35 */ { '1', '7' },
    /* CVMM36 */ { '0', '6' },
    /* CVMM37 */ { '0', '5' }
};

static void map_xy( vpd_t *vpd ) {
    char host[32];

    if( gethostname(host,sizeof host) ) {
        perror("gethostname");
        printf("Unable to find hostname, aborting...\n");
        exit(1);
    }

    int i;
    for( i=0; i<strlen(host); i++ ) {
        host[i] = tolower( host[i] );
    }

    int cvmm = 99;
    int n = sscanf( host, "cvmm%u", &cvmm );

    if( n == 0 ) {
        printf("Unable to parse \"%s\", aborting...\n",host);
        exit(1);
    }

    if( cvmm < 1 || cvmm > 37 ) {
        printf("Didn't parese a valid CVMM position: %u, aborting...\n",cvmm);
        exit(1);
    }

    /*
     * Counts on earlier code to set the two-char field to 0x20
     *   - this just fills in the single-digit position
     */
    vpd->pos_ext[1] = map[cvmm].x;
    vpd->pos_id[1]  = map[cvmm].y;
}
