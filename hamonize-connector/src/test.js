#!/usr/bin/env node

console.log("122222222222222222222");
console.log("1333333333333");

// case 1
// const { Command } = require('commander');
// const exec = require('child_process').exec;

// const program = new Command();

// program
//     // .option('-n, --name <name>', 'file name')
//     .option('--hamonizeInstall')
//     .option('--test')
//     .parse();

// // console.log(program.opts().n);
// // console.log(program.opts().name);
// console.log(program.opts().hamonizeInstall);

// if(program.opts().hamonizeInstall){
//     console.log("aaaaaaaaaaaaaa");
//     // exec('npm start', (error, stdout, stderr) => {
//         exec('./node_modules/electron/cli.js main.js', (error, stdout, stderr) => {
//         if (error) {
//             console.warn(error);
//         }else{
//             console.log("aaaaaaaaaaaaaaaaccccccccction");
//         }
//     });    
// }


// if(program.opts().test){
//     console.log("test option aaaaaaaaaaaaaaa");
// }

// case 2
// let triggered = false;
// const { Command } = require('commander');
// const inquirer = require('inquirer');
// const chalk = require('chalk');
// const program = new Command();
// program
// 	.version('0.1', '-v, --version')
// 	.usage('[options]')
// 	.command('quiz')
// 	.action(() => {
// 		triggered = true;
// 	});

// program.parse(process.argv);

// if(!triggered) {
// 	inquirer.prompt([{
// 		type: 'list',
// 		name: 'menu',
// 		message: 'CLI에 오신것을 환영합니다. 메뉴를 선택하세요.',
// 		choices: ['aa', 'bb'],
// 	}])
// 	.then((answers) => {
// 		console.log(chalk.green(answers.menu) + "를 선택하셨습니다.");
// 		selected(answers.menu);
// 	})
// }
