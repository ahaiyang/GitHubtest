PWD=$(cd `dirname $0`; pwd)
echo $PWD
cocos luacompile -s ${PWD}/src -d ${PWD}/src_et -e -k mXjv7U5dUl1aMTVV_xianlai -b SQLLiteData --disable-compile

# PACK_NAME=paopao.zip
PACK_NAME=jielong.zip

rm -f $PACK_NAME
# zip加密，不压缩所有贴图和声音，对应解密源码在XLZipFile::getFileData函数中
7z a -tzip $PACK_NAME -mx0 -ir\!res/*.png -ir\!res/*.ccz -ir\!res/*.jpg -xr\!res/*.mp4 -xr\!res/*.mp3 -xr\!res/*.wav -xr\!.DS_Store -p3c6e0b8a9c15224a8228b9a98ca1531d

# zip加密，压缩其他文件
7z u -tzip $PACK_NAME -mx9 res src_et -xr\!res/*.png -xr\!res/*.ccz -xr\!res/*.jpg -xr\!res/*.mp4 -xr\!res/*.mp3 -xr\!.DS_Store -xr\!res/*.mp4 -xr\!res/*.mp3 -xr\!res/*.wav -p3c6e0b8a9c15224a8228b9a98ca1531d

# 7z u -tzip $PACK_NAME -mx9 src -xr\!res/*.png -xr\!res/*.ccz -xr\!res/*.jpg -xr\!res/*.mp4 -xr\!res/*.mp3 -xr\!.DS_Store -xr\!res/*.mp4 -xr\!res/*.mp3 -xr\!res/*.wav -p3c6e0b8a9c15224a8228b9a98ca1531d
# zip包 应用简单的异或加密 (对应解密的源码在XLZipFile.cpp __fread_file_func函数中)

echo """
local bit = require'bit'
local _if,_of = io.open('$PACK_NAME','rb'),io.open('$PACK_NAME.assets','wb')
local KEY = 69
while true do
    local data = _if:read(256)
    if not data then break end
    local odata = {}
    for i=1, data:len() do
        local ochar = string.char(bit.bxor(data:byte(i),KEY))
        odata[#odata+1] = ochar
    end
    _of:write(table.concat(odata))
end
""" | luajit -

# 3c6e0b8a9c15224a8228b9a98ca1531d

# local _if,_of = io.open('$PACK_NAME','rb'),io.open('$PACK_NAME.enc','wb')