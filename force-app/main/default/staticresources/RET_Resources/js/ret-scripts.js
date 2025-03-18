var messages = {
    showError: function(heading, msg) {
        document.getElementById('ret-message-heading').innerHTML = heading;
        document.getElementById('ret-message-body').innerHTML = msg;
        document.getElementById('ret-message-container').className = 'ret-message';
    },
    hide: function() {
        document.getElementById('ret-message-container').className = 'hidden';
    }
}

