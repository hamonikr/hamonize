const EventEmitter = require('events');
class Poller extends EventEmitter {
    constructor(timeout = 100) {
        super();
        this.timeout = timeout;
    }

    poll(setPollTime) {
        setTimeout(() => this.emit('poll'), setPollTime);
    }

    onPoll(cb) {
       this.on('poll', cb);
    }

}

module.exports = Poller;