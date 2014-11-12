(function() {
  var root;

  root = typeof window !== "undefined" && window !== null ? window : global;

  jQuery(function() {
    var loading_posts;
    if ($('#infinite-scrolling').size() > 0) {
      $(root).bindWithDelay('scroll', function() {
        var more_posts_url;
        more_posts_url = $('.pagination .next_page a').attr('href');
        if (more_posts_url && $(root).scrollTop() > $(document).height() - $(root).height() - 60) {
          $('.pagination').html('<img src="/assets/ajax-loader.gif" alt="Loading..." title="Loading..." />');
          $.getScript(more_posts_url);
        }
      }, 100);
    }
    if ($('#with-button').size() > 0) {
      $('.pagination').hide();
      loading_posts = false;
      $('#load_more_posts').show().click(function() {
        var $this, more_posts_url;
        if (!loading_posts) {
          more_posts_url = $('.pagination .next_page a').attr('href');
          $this = $(this);
          $this.html('<img src="/assets/ajax-loader.gif" alt="Loading..." title="Loading..." />').addClass('disabled');
          loading_posts = true;
          $.getScript(more_posts_url, function() {
            if ($this) {
              $this.text('More').removeClass('disabled');
            }
            return loading_posts = false;
          });
        }
      });
    }
  });

}).call(this);
