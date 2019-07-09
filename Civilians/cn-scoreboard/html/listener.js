$(function()
{
    window.addEventListener('message', function(event)
    {
        var item = event.data;
        var buf = $('#wrap');
		
		$('#spelare').html(event.data.spelare);
		
        if (item.meta && item.meta == 'close')
        {
            document.getElementById("ptbl").innerHTML = "";
            $('#wrap').hide();
            return;
        }
        document.getElementById("ptbl").innerHTML = "<tr class=\"logo\"><td colspan=\"3\"><img src=\"logo.png\"></td></tr><tr class=\"heading\"><td><h3 style='text-shadow: 2px 4px 6px #000000;'>Navn</td><td><h3 style='text-shadow: 2px 4px 6px #000000;'></td></tr>" + item.text;
        $('#wrap').show();
    }, false);
});