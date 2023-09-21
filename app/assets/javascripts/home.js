
$( document ).on('turbolinks:load', function (event) {

  $(".news-slider").not('.slick-initialized').slick({
    slidesToShow: 4,
    slidesToScroll: 1,
    initialSlide: 0,
    inifite: true,
    dots: false,
    cssEase: 'ease-in-out',
    autoplay: false,
    prevArrow: "<button type='button' class='slick-prev pull-left' aria-label='Previous arrow'></button>",
    nextArrow: "<button type='button' class='slick-next pull-right' aria-label='Next arrow'></button>",
    responsive: [
      {
        breakpoint: 1200,
        settings: {
          slidesToShow: 4
        }
      },
      {
        breakpoint: 992,
        settings: {
          slidesToShow: 3
        }
      },
      {
        breakpoint: 768,
        settings: {
          slidesToShow: 2
        }
      },
      {
        breakpoint: 480,
        settings: {
          slidesToShow: 1
        }
      }
    ]
  });

});
