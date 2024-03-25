
document.addEventListener("turbolinks:before-cache", function () {
  var sliders = document.querySelectorAll('.slick-initialized');
  sliders.forEach(slider => {
    $(slider).slick('unslick');
  })
});

$( document ).on('turbolinks:load', function (event) {

  $(".news-slider").not('.slick-initialized').slick({
    slidesToShow: 4,
    slidesToScroll: 1,
    initialSlide: 0,
    inifite: true,
    dots: false,
    cssEase: 'ease-in-out',
    autoplay: false,
    prevArrow: "<button type='button' class='slick-prev pull-left' role='img' aria-label='Previous arrow'></button>",
    nextArrow: "<button type='button' class='slick-next pull-right' role='img' aria-label='Next arrow'></button>",
    regionLabel: "news carousel",
    arrowsPlacement: "split",
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


  $(".story-slider").not('.slick-initialized').slick({
    slidesToShow: 4,
    slidesToScroll: 1,
    initialSlide: 0,
    inifite: true,
    dots: false,
    cssEase: 'ease-in-out',
    autoplay: false,
    prevArrow: "<button type='button' class='slick-prev pull-left' role='img' aria-label='Previous arrow'></button>",
    nextArrow: "<button type='button' class='slick-next pull-right' role='img' aria-label='Next arrow'></button>",
    regionLabel: "Learner stories carousel",
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
