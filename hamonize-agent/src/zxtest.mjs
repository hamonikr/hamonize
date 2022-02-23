#! /usr/bin/env node
import { $, sleep } from "zx";

$.verbose = false;

// let a = await $`ufw status > /tmp/ufw`;
// console.log(a);

// let b = await $`cat /tmp/ufw |grep 11`
// console.log(b);


const ufwStatus = await $`ufw status`;
// console.log(ufwStatus.stdout);

const ufwData = ufwStatus.stdout;

const portlist = ["8080", "1111", "13", "14"];
const reloadPort = new Array();
for (let i = 0; i < portlist.length; i++) {
    if (ufwData.indexOf(portlist[i]) < 0) {
        console.log("portlist[i]==========++" + portlist[i]);
        reloadPort.push(portlist[i]);
    }
}

for (let i = 0; i < reloadPort.length; i++) {
    let aaa = reloadPort[i];
    let p = await $`ufw allow ${aaa}`
    console.log(p.stdout);
    // console.log("checkUfwPort===" + aaa);
    await sleep(1000);
}


await $`ufw reload`
