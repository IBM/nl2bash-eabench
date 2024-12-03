/*
 * 00000000: 03 ef 01 07 03 fc 57 6f 72 6c 00 21 00 ff 61 3b  ......Worl.!..a;
 * 00000010: 6c 6b 73 64 6a 30 30 30 30 30 30 34 38 37 ff ff  lksdj000000487..
 * 00000020: 4f 50 00 00 00 00 00 00 ff ff ff ff ff ff ff ff  OP..............
 * 00000030: ff ff ff ff ff ff ff ff ff ff ff ff 53 4c 2d 49  ............SL-I
 * 00000040: ff ff ff ff ff ff ff ff 66 30 2d 45 43 33 38 00  ........f0-EC38.
 * 00000050: 00 00 00 00 30 30 30 31 34 00 38 30 35 31 33 34  ....00014.805134
 * 00000060: 42 45 49 52 ff 32 49 4d 36 16 75 32 30 33 38 38  BEIR.2IM6.u20388
 * 
 *                 Length: 03EF
 *                Version: 0107
 *           Block length: 03FC
 *          Serial number: 0000004
 *       Card part number: SL-I▒▒▒▒▒▒▒▒
 *               Card FRU: f0-EC38
 *               Card S/N: 00014
 *        Card prefix S/N: 805134
 *             System MFG: BEIR
 *      Hardware revision: 32
 *           PCB card MFG: I
 *      PCB card material: M6
 *        PCB card layers: 22
 *     PCB card thickness: 117
 *              Date code: 2038
 *  Max power consumption: 25
 *  Max power  production: 0
 */

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <fcntl.h>
#include <endian.h>
#include "vpd.h"

static char *card_sn = Null;
static int write_vpd = False;
static int wing = 1;

/*
 * extract non-null terminated ASCII field and convert to something we can print
 */
#define S(field) s(field,sizeof field)
char *s( char *f, int l ) {
    char *s = malloc( l+1 );
    int i;
    for( i=0; i<l; i++ ) s[i] = f[i];
    s[i] = '\0';
    return s;
}

/*
 * the other direction, null-terminated to fixed-length field
 *   - F: right-justified, pad with 0x20
 *   - N: right-justified, pad with '0' (for serial numbers)
 *   - Z: right-justified, pad with 0x00 (we'll never really use this)
 */
void f( char *f, int l, char *s, char p ) {
    int n = strlen(s);
    int i;
    assert( l>=n );
    for( i=0; i<l-n; i++ ) f[i] = p;
    for(    ; i<l;   i++ ) f[i] = *s++;
}

/*
 * the null-terminated to fixed-length field
 *   - G: left-justified, pad with 0x20
 */
void g( char *f, int l, char *s, char p ) {
    int n = strlen(s);
    int i;
    assert( l>=n );
    for( i=0; i<n; i++ ) f[i] = *s++;
    for(    ; i<l; i++ ) f[i] = p;
}


void xxd( void *buffer, int n ) {
    u8 *bp = buffer;
    int i, j;

    for( i=0; i<n; i+=16 ) {
        printf("%04X: ",i);
        for( j=0; j<16 && i+j<n; j++ ) {
            printf(" %02X",bp[i+j]);
        }
        for( ; j<16; j++ ) printf("   ");
        printf(" !");
        for( j=0; j<16 && i+j<n; j++ ) {
            char c = bp[i+j];
            if( c >= ' '  &&  c <= '~' ) {
                printf("%c",c);
            } else {
                printf(".");
            }
        }
        for( ; j<16; j++ ) printf(" ");
        printf("!\n");
    }
}

/*
 * endian conversion for the few fields that need it
 */
static void swap_endian( vpd_t *vpd ) {
    vpd->length       = be16toh( vpd->length       );
    vpd->version      = be16toh( vpd->version      );
    vpd->block_length = be16toh( vpd->block_length );
    vpd->block1       = be16toh( vpd->block1       );
    vpd->block2       = be16toh( vpd->block2       );
    vpd->block3       = be16toh( vpd->block3       );
    vpd->block4       = be16toh( vpd->block4       );
    vpd->block5       = be16toh( vpd->block5       );
    vpd->block6       = be16toh( vpd->block6       );
    vpd->block7       = be16toh( vpd->block7       );
    vpd->ina_en       = be32toh( vpd->ina_en       );
    vpd->ina_pid      = be16toh( vpd->ina_pid      );
    vpd->produce      = be16toh( vpd->produce      );
    vpd->consume      = be16toh( vpd->consume      );
}

void display( vpd_t *vpd ) {
    printf("                Length: %04X\n",vpd->length);
    printf("               Version: %04X\n",vpd->version);
    printf("          Block length: %04X\n",vpd->block_length);
    printf("                 (X,Y): %s,%s\n",S(vpd->pos_ext),S(vpd->pos_id));
    printf("         Serial number: %s\n",S(vpd->msn));
    printf("      Card part number: %s\n",S(vpd->card_pn));
    printf("              Card FRU: %s\n",S(vpd->card_fru));
    printf("              Card S/N: %s\n",S(vpd->card_sn));
    printf("       Card prefix S/N: %s\n",S(vpd->card_psn));
    printf("            System MFG: %s\n",S(vpd->mfg));
    printf("     Hardware revision: %02X\n",vpd->hw_rev);
    printf("          PCB card MFG: %c\n",vpd->phy_a);
    printf("     PCB card material: %s\n",S(vpd->phy_b));
    printf("       PCB card layers: %u\n",vpd->phy_c);
    printf("    PCB card thickness: %u\n",vpd->phy_d);
    printf("             Date code: %s\n",S(vpd->mfg_dc));
    printf(" Max power consumption: %u\n",vpd->consume);
    printf(" Max power  production: %u\n",vpd->produce);
}

char *pgm;

void print_usage( char *fmt, char *arg ) {
    printf("%s [<flags>] [<serial>]\n",pgm);
    printf("  <flags>:\n");
    printf("    -w<n>   wing card, 1 to 8\n");
    exit(1);
}

int getargs( int argc, char *argv[] ) {
    int i;
    pgm = argv[0];
    for( i=1; i<argc; i++ ) {
        if( argv[i][0] == '-' ) {
            switch( argv[i][1] ) {
                case 'w': {
                    wing = atoi( argv[i]+2 );
                    if( wing < 1 || wing > 8 ) {
                        print_usage( "Invalide wing number: %s\n", argv[i]+2 );
                    }
                    break;
                }
                default:
                    print_usage( "Unknown flag: %s\n", argv[i] );
            }
        } else {
            static int n = 0;
            switch( n++ ) {
                case 0:
                    card_sn = argv[i];
                    if( strlen(card_sn) == 0 ) {
                        print_usage( "Missing card serial number: %s\n", argv[i] );
                    }
                    if( strlen(card_sn) > sizeof ((vpd_t*)(0))->card_sn ) {
                        print_usage( "Card serial number exceeds field length\n", card_sn );
                    }
                    write_vpd = True;
                    break;
                default:
                    print_usage( "Too many arguments: %s\n", argv[i] );
            }
        }
    }
}

void main( int argc, char *argv[] ) {

    getargs( argc, argv );
    
    char *fn = vpd_path( wing );  /* only vpd_wing cares about "wing" */
    int fd = open( fn, O_RDWR );
    if( fd < 0 ) {
        perror( fn );
        exit(1);
    }

    vpd_t vpd;

    if( write_vpd ) {
        int n;
        vpd_init( &vpd );
        N( vpd.card_sn, card_sn );
        display( &vpd );
        swap_endian( &vpd );
        n = write( fd, &vpd, sizeof vpd );
        if( n < 0 ) {
            perror( "write" );
        } else {
            if( n != sizeof vpd ) {
                printf("incomplete write: %d bytes written\n",n);
            } else {
                puts(vpd_label());
                printf("Wrote VPD (%d bytes)\n",n);
            }
        }
    } else {
        int n = read( fd, &vpd, sizeof vpd );
        if( n < 0 ) {
            perror( "read" );
            exit(1);
        }

        swap_endian( &vpd );

        printf("    %s\n",vpd_label());
        display( &vpd );
    }
}
