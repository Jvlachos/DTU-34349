#we need to calculate the result after 8 clock cycles
#8 bits per cycle * 8 cycles we get the first 64 bits
frame = [0x00,0x10,0xA4,0x7B,0xEA,0x80,0x00,0x12]
G     = [0,0,0,0,0,1,0,0,1,1,0,0,0,0,0,1,0,0,0,1,1,1,0,1,1,0,1,1,0,1,1,1]
toBinary = []
#convert to binary
for hex in frame:
    toBinary = toBinary + [int(x) for x in '{:08b}'.format(hex)]

#complement first 32 bits
for i in range (0,32):
    toBinary[i] = toBinary[i] ^ 1
octets = [toBinary[i:i+8] for i in range(0, len(toBinary), 8)]
R = [0] * 32

print(octets)
for octet in octets:
        R[0]  = R[24] ^ R[30] ^ octet[0]
        R[1]  = R[24] ^ R[25] ^ R[30] ^ R[31] ^ octet[1]
        R[2]  = R[24] ^ R[25] ^ R[26] ^ R[30] ^ R[31] ^ octet[2]
        R[3]  = R[25] ^ R[26] ^ R[27] ^ R[31] ^ octet[3]
        R[4]  = R[24] ^ R[26] ^ R[27] ^ R[28] ^ R[30] ^ octet[4]
        R[5]  = R[24] ^ R[25] ^ R[27] ^ R[28] ^ R[29] ^ R[30] ^ R[31] ^ octet[5]
        R[6]  = R[25] ^ R[26] ^ R[28] ^ R[29] ^ R[30] ^ R[31] ^ octet[6]
        R[7]  = R[24] ^ R[26] ^ R[27] ^ R[29] ^ R[31] ^ octet[7]
        R[8]  = R[0] ^ R[24] ^ R[25] ^ R[27] ^ R[28]
        R[9]  = R[1] ^ R[25] ^ R[26] ^ R[28] ^ R[29]
        R[10] = R[2] ^ R[24] ^ R[26] ^ R[27] ^ R[29]
        R[11] = R[3] ^ R[24] ^ R[25] ^ R[27] ^ R[28]
        R[12] = R[4] ^ R[24] ^ R[25] ^ R[26] ^ R[28] ^ R[29] ^ R[30]
        R[13] = R[5] ^ R[25] ^ R[26] ^ R[27] ^ R[29] ^ R[30] ^ R[31]
        R[14] = R[6] ^ R[26] ^ R[27] ^ R[28] ^ R[30] ^ R[31]
        R[15] = R[7] ^ R[27] ^ R[28] ^ R[29] ^ R[31]
        R[16] = R[8] ^ R[24] ^ R[28] ^ R[29]
        R[17] = R[9] ^ R[25] ^ R[29] ^ R[30]
        R[18] = R[10] ^ R[26] ^ R[30] ^ R[31]
        R[19] = R[11] ^ R[27] ^ R[31]
        R[20] = R[12] ^ R[28]
        R[21] = R[13] ^ R[29]
        R[22] = R[14] ^ R[24]
        R[23] = R[15] ^ R[24] ^ R[25] ^ R[30]
        R[24] = R[16] ^ R[25] ^ R[26] ^ R[31]
        R[25] = R[17] ^ R[26] ^ R[27]
        R[26] = R[18] ^ R[24] ^ R[27] ^ R[28] ^ R[30]
        R[27] = R[19] ^ R[25] ^ R[28] ^ R[29] ^ R[31]
        R[28] = R[20] ^ R[26] ^ R[29] ^ R[30]
        R[29] = R[21] ^ R[27] ^ R[30] ^ R[31]
        R[30] = R[22] ^ R[28] ^ R[31]
        R[31] = R[23] ^ R[29]

print(R)
