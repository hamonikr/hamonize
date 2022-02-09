#!/usr/bin/env node

// const { Command } = require('commander');
// const program = new Command();

// program
//     // .option('-n, --name <name>', 'file name')
//     .option('--hamonizeInstall')
//     .option('--test')
//     .parse();

// console.log(program.opts().test);
// console.log(program.opts().hamonizeInstall);

// if(program.opts().hamonizeInstall){
//     console.log("aaaaaaaaaaaaaa");
// }

// if(program.opts().test){
//     console.log("test option aaaaaaaaaaaaaaa");
// }


// var commander = require('commander');
// commander
//     .arguments('<count>')
//     .option('-u, --username <username>', 'Your Github name')
//     .option('-e, --email <email>', 'Your Email Address')
//     .action(function (count) {
//         for (var i = 0; i < count; i++) {
//             console.log('user: %s, email: %s, print count: %s',
//                 commander.username,
//                 commander.email,
//                 count);
//         }
//     })
//     .parse(process.argv);


const { Command } = require('commander');

const program = new Command();

program
    .option('-n, --name <name>', 'file name')
    .option('-c, --compress', 'compress')
    .parse();

console.log(program.opts().n);
console.log(program.opts().name);
console.log(program.opts().compress);


