#!/usr/bin/bash

# 2021 @Lateautumn mail:3487467850@qq.con

export PATH=bin:${PATH}

test1(){
    if [ $? -ne 0 ]; then
        echo "failed"
        exit 1
    fi
}

for i in system vendor product system_ext odm 
do    
    echo -e "\033[33m 生成${i}.img \033[0m"
    mkfs.erofs --mount-point /${i} --fs-config-file tmp/config/${i}_fs_config --file-contexts tmp/config/${i}_file_contexts out/${i}.img tmp/${i}
    test1
    
    echo -e "\033[33m 生成${i}.simg \033[0m"
    img2simg out/${i}.img out/${i}.simg
    test1 && rm out/${i}.img
    
    echo -e "\033[33m 生成${i}.new.dat \033[0m"
    img2sdat.py  out/${i}.simg -o out -v 4 -p ${i}
    test1 && rm out/${i}.simg
    
    echo -e "\033[33m 生成${i}.new.dat.br \033[0m"
    brotli -0 out/${i}.new.dat -o out/${i}.new.dat.br
    test1
    rm out/${i}.new.dat
done