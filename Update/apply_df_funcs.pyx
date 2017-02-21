cdef unsigned long long b22(unsigned char[:] x) except? -2:
    return int(x, 2)

cdef unsigned long long b16(unsigned char[:] x) except? -2:
    return int(x, 16)

cdef unsigned char[:] hextobin(unsigned char[:] h):
    return bin(int(h, 16))[2:].zfill(len(h) * 4)