$(document).ready(function () {
    setInterval(refreshPartial, 20000)
});

function refreshPartial() {
    $.ajax({
    url: "/load_active"
    })

    $.ajax({
        url: "/load_available"
    })
}