const winston = require('winston');
require('winston-daily-rotate-file');
require('date-utils');

const logger = winston.createLogger({
    level: 'info',
    // 파일저장
    transports: [
        new winston.transports.DailyRotateFile({
            filename: '/tmp/log/hamonikr-connect/vdi-session.log', // log 폴더에 system.log 이름으로 저장
            zippedArchive: true, // 압축여부
            maxsize: 104857600,
            maxFiles: 5,
            options: {
                mode: 0o777,
                flags: 'a'
            },
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