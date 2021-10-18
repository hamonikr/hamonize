const winston = require('winston');
require('winston-daily-rotate-file');
require('date-utils');
 
const logger = winston.createLogger({
    level: 'info', // 최소 레벨
    // 파일저장
    transports: [
        new winston.transports.DailyRotateFile({
            filename : '/var/log/hamonize/agentjob/agentjob.log', // log 폴더에 system.log 이름으로 저장
            zippedArchive: true, // 압축여부
            maxFiles: '4d',
            format: winston.format.printf(
                info => `${new Date().toFormat('YYYY-MM-DD HH24:MI:SS')} [${info.level.toUpperCase()}] - ${info.message}`)
        }),
        // 콘솔 출력
        new winston.transports.Console({
            format: winston.format.printf(
                info => `${new Date().toFormat('YYYY-MM-DD HH24:MI:SS')} [${info.level.toUpperCase()}] - ${info.message}`)
        })
    ]
});
 
module.exports = logger;


