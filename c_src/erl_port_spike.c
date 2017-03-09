#include "stdio.h"
#include "ctype.h"
#include "string.h"


typedef unsigned char byte;


/**
 * Read command into buffer
 */
int
read_cmd(byte *buf)
{
        int len;

        /* read 2 bytes and if 2 bytes aren't read, return error -1 */
        if (read_exact(buf, 2) != 2) {
                return -1;
        }

        /* the buffer now has 2 bytes */
        /* shift the left byte 8 bits and then OR that */
        /* with the second byte to replace the right 8 bits */
        /* resulting in 16 bit integer value */
        len = (buf[0] << 8) | buf[1];

        /* the command is read and the two size bytes are overritten */
        return read_exact(buf, len);
}

int
write_cmd(byte *buf, int len)
{
        byte li;

        li = (len >> 8) & 0xff;
        write_exact(&li, 1);

        li = len & 0xff;
        write_exact(&li, 1);

        return write_exact(buf, len);
}


/**
 * Read len bytes into buf from stdin
 */
int
read_exact(byte *buf, int len)
{
        int i, got=0;

        do {
                if ((i = read(0, buf+got, len-got)) <= 0) {
                        /* no more to read */
                        return i;
                }

                got += i;
        } while (got<len);

        return len;
}

int
write_exact(byte *buf, int len)
{
        int i, wrote = 0;

        do {
                if ((i = write(1, buf+wrote, len-wrote)) <= 0) {
                        return i;
                }

                wrote += i;
        } while (wrote<len);

        return len;
}


void
str_to_upper(char* str)
{
    while (*str++ = toupper(*str));
}

void
str_to_lower(char* str)
{
    while (*str++ = tolower(*str));
}


int
main() {
        int fn, arg;
        char* res;
        char* word;

        /* TODO according the protocol, the first 2 bytes of a command */
        /* indicate the length of the command, therefore the command */
        /* can be no longer than 65535/8 bytes long. */

        /* what is the best value to set this buffer to and what if the data is longer */
        /* than this buffer? */
        byte buf[100];

        int len = 0;

        /* continuously reads commands */
        while ((len = read_cmd(buf)) > 0) {
                /* the buffer now has the command in */
                fn = buf[0];
                word = &buf[1];

                if (fn == 1) {
                        str_to_upper(word);
                        res = word;
                } else if (fn == 2) {
                        str_to_lower(word);
                        res = word;
                } else {
                        res = "unknown_command";
                }

                write_cmd(res, len);
        }
}
