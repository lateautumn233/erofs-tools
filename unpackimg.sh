#!/usr/bin/bash

# 2021 @Lateautumn mail:3487467850@qq.con

export PATH=bin:${PATH}

test1(){
    if [ $? -ne 0 ]; then
        echo "failed"
        exit 1
    fi
}

decompresszip(){
mkdir out tmp
unzip *.zip -d tmp
if [ -e *.bin ]; then
    payload-dumper-go tmp/payload.bin -o tmp
    test1
    rm tmp/payload.bin
fi
rm *.zip
}

decompressimg(){
for i in system vendor product system_ext odm 
do 
    if [ -e *.br ];then
        echo -e "\033[32m  解压${i}.new.dat.br \033[0m"
        brotli -d tmp/${i}.new.dat.br -o tmp/${i}.new.dat
        test1 && rm tmp/${i}.new.dat.br
        
        echo -e "\033[33m 解压${i}.new.dat \033[0m"
        sdat2img.py tmp/${i}.transfer.list tmp/${i}.new.dat tmp/${i}.img
        test1 && rm tmp/${i}.transfer.list tmp/${i}.new.dat
    fi

    filetype=`file tmp/system.img | grep -o "data"`
    if [ ${filetype} == data ];then
        echo -e "\033[33m 解压${i}.img \033[0m"
        erofsunpack tmp/${i}.img tmp
        test1 && rm tmp/${i}.img
    else
        echo -e "\033[33m 解压${i}.img \033[0m"
        imgextractor.py tmp/${i}.img tmp/${!}
        test1 && rm tmp/${i}.img
    fi
done
}

decompresszip
decompressimg