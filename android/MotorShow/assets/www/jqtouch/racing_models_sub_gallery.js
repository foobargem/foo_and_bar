
var RacingModelSubGallery = {

  updateSubGalleryButton: function(model) {
    if (model.photos_size > 0) {
      $("#model_show div.buttons-container").show();
    } else {
      $("#model_show div.buttons-container").hide();
    }
  },

  fetch_model_photos_and_update_sub_gallery: function() {

    var _url = SMS.API.RacingModel.photosURL(_model_id);

    jQuery.ajax({
      url: _url,
      type: 'GET',
      data: {
      },
      success: function(msg){
        RacingModelSubGallery.buildSubGallery(msg);
        RacingModelSubGallery.addEventListenerToSubGallery();
      }
    });
  },

  buildSubGallery: function(msg) {
    var li_eles = '';
    var li_class = '';
    //var has_next = msg.has_next;
    var has_next = "n";
    jQuery.each(msg, function(idx, obj){
      var photo = obj['photo'];

      li_className = '';
      if ((idx + 1) % 4 == 0) {
        li_className = 'line-break';
      }

      li_eles += '<li class="' + li_className + '"><a href="#model_photo" class="photo-link filp" data-url="' + photo.large_url + '"><img src="' + photo.thumb_url + '" /></a></li>';
    });

    if (has_next == "n") {
      last_page = true;
    } else {
      li_eles += '<li id="more" class="more"><a href="#">More</a></li>';
    }

    if (li_eles.trim() == "") {
      $("#model_sub_gallery div.thumbnail-container li#more").text("데이터가 없습니다");
    } else {
      $("#model_sub_gallery div.thumbnail-container li#more").replaceWith(li_eles);
    }

  },


  addEventListenerToSubGallery: function() {
    $("a.photo-link").bind("click", function(event){
      event.preventDefault();
      var photo_url = $(event.currentTarget).attr("data-url");
      //window.plugins.suddenlybuntCmd.debug(photo_id);
      RacingModelSubGallery.updateModelLargePhoto(photo_url);
    });
  },


  updateModelLargePhoto: function(url) {
    $("#model_large_image")[0].src = url;
  }

};


