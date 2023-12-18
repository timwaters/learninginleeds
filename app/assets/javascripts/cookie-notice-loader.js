$( document ).on('turbolinks:load', function() {

  checkCookieAccept();

  function checkCookieAccept() {

    var consent = readCookie("cookies_consent");

    if (consent == null || consent == "" || consent == undefined) {
      // show notification bar
      $('#cookie_directive_container').show();
    }

  }

  $("#accept-button").click(function () {
    createCookie("cookies_consent", 1, 30)
    $('#cookie_directive_container').hide('fast');

  });

  $("#decline-button").click(function () {
    createCookie("cookies_consent", 0, 30)
    $('#cookie_directive_container').hide('fast');

  });

});


