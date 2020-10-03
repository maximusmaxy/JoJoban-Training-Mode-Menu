-- To generate the hitbox lua place the 10 file from the jojoban.zip into the same folder as this lua script and run it.

local k1 = 0x23323EE3
local k2 = 0x03021972

function rotateLeft(value, n) 
    local aux = bit.rshift(value, 16 - n)
    return bit.bor(bit.band(bit.lshift(value, n), 0xFFFF), aux) % 0x10000
end

function rotXor(val, xorval)
    local res = bit.band(val + rotateLeft(val, 2), 0xFFFF)
    res = bit.bxor(rotateLeft(res, 4), bit.band(res, bit.bxor(val, xorval)))
    return res
end

function mask(address, key1, key2)
    address = bit.bxor(address, key1)
    local val = bit.bxor(bit.band(address, 0xFFFF), 0xFFFF)
    val = rotXor(val, bit.band(key2, 0xFFFF))
    val = bit.bxor(val, bit.bxor(bit.rshift(address, 16), 0xFFFF))
    val = rotXor(val, bit.rshift(key2, 16)) 
    val = bit.bxor(val, bit.bxor(bit.band(address, 0xFFFF), bit.band(key2, 0xFFFF)))
    return bit.bor(val, bit.lshift(val, 16))
end

function createHitboxBin()
    local ten, err = io.open("10", "rb")
	if err then 
		print("Error reading 10 file")
		return
    end
    local bin, err = io.open("hitbox.bin", "wb")
    if err then
        print("Error writing hitbox.bin")
        return
    end
    local chars = {}
    addRange(ten, chars, 0x01DEE9E, 0x02150DC)
    addRange(ten, chars, 0x0700000, 0x07194FC)
    bin:write(table.concat(chars))
    ten:close()
    bin:close()
    print("hitbox.bin created")
end

function addRange(source, dest, start, fin)
    local chars = { 0, 0, 0, 0 }
    if start % 4 == 2 then --off center start
        source:seek("set", start - 2)
        getDecodedChars(start - 2, source, chars)
        dest[#dest+1] = string.char(chars[3], chars[4])
        start = start + 2
    else
        source:seek("set", start)
    end
    for offset = start, fin, 4 do
        getDecodedChars(offset, source, chars)
        dest[#dest+1] = string.char(chars[1], chars[2], chars[3], chars[4])
    end
end

function getDecodedChars(offset, source, chars)
    local bytes = source:read(4)
    if not bytes then
        print(offset)
        return
    end
    local hex = 0
    for i = 1, 4, 1 do
        hex = hex + bit.lshift(string.byte(bytes, i), (4 - i) * 8)
    end
    local xorMask = mask(0x6000000 + offset, k1, k2)
    hex = bit.bxor(hex, xorMask)
    for i = 1, 4, 1 do
        chars[i] = bit.band(bit.rshift(hex, (4 - i) * 8), 0xFF)
    end
end

createHitboxBin()