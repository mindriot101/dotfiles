require(['base/js/namespace', 'base/js/events'], function(IPython, events) {
    events.on('app_initialized.NotebookApp', function() {
        // Do not autoclose brackets
        IPython.CodeCell.options_default.cm_config.autoCloseBrackets = false;

        // Wrap lines
        IPython.Cell.options_default.cm_config.lineWrapping = true;

        // Hide the toolbar and header bar
        $('div#maintoolbar').hide();
        $('div#header-container').hide();
    });
});

