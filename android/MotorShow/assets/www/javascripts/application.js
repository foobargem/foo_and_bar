// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var SMS = {
  // baseURL: "http://10.1.1.91:3000"
  baseURL: "http://2011sms.top-rider.com"
};

SMS.API = {
  EventApplicant: {
    newURL: function() {
      return SMS.baseURL + "/events/1/applicants";
    }
  },

  Banner: {
    baseAdURL: function() {
      return SMS.baseURL + "/banners/base_ad.json";
    }
  },

  Company: {
    indexURL: function(category) {
      return SMS.baseURL + '/companies.json?category=' + category;
    },
    showURL: function(id) {
      return SMS.baseURL + '/companies/' + id + '.json';
    }
  },

  Car: {
    indexURL: function() {
      return SMS.baseURL + "/cars.json";
    },
    galleryURL: function(company_id) {
      return SMS.API.Photo.indexURL('car');
    },
    showURL: function(id) {
      return SMS.baseURL + "/cars/" + id + ".json";
    },
    photosURL: function(id) {
      return SMS.baseURL + "/cars/photos.json?id=" + id;
    }
  },

  Video: {
    indexURL: function() {
      return SMS.baseURL + "/videos.json";
    }
  },

  Photo: {
    indexURL: function(category) {
      var path = '/photos.json?category=' + category;
      return SMS.baseURL + path;
    },
    indexURLWithModelsByCompany: function(company_id) {
      var path = '/photos/models_by_company.json?company_id=' + company_id;
      return SMS.baseURL + path;
    },
    indexURLByBooth: function(booth_code) {
      return SMS.baseURL + '/photos/by_company_booth_code.json?booth_code=' + booth_code;
    },
    showURL: function(id) {
      return SMS.baseURL + "/photos/" + id + ".json";
    }
  },

  RacingModel: {
    indexURL: function() {
      return SMS.baseURL + "/racing_models.json";
    },
    galleryURL: function() {
      return SMS.API.Photo.indexURL('racing_model');
    },
    showURL: function(id) {
      return SMS.baseURL + "/racing_models/" + id + ".json";
    }
  }

};



// banner

function Banner(element) {
  this.title = "";
  this.content = "";
  this.landing_url = "";
  this.embed_code = "";
  this.element = element;

  var that = this;

  /*
  if (!window.plugins || !window.plugins.childBrowser) {
    ChildBrowser.install();
  }
  */

  jQuery.ajax({
    url: SMS.API.Banner.baseAdURL(),
    type: 'GET',
    error: function() {
      return false;
    },
    success: function(msg){
      if (msg) {
        that.title = msg.title;
        that.content = msg.content;
        that.landing_url = msg.landing_url;
        that.embed_code = msg.embed_code;
        that.display();
      }
    }
  });
}


Banner.prototype.display = function() {
  $(this.element).html(this.embed_code);
  this.forceSetStyle();
  this.addEventListener();
}

Banner.prototype.forceSetStyle = function() {
  $(this.element).css("padding", 0);
}

Banner.prototype.addEventListener = function() {
  var that = this;
  $(this.element + " a").bind("click", this, function(event){
    event.preventDefault();
    window.plugins.childBrowser.showWebPage(that.landing_url);
  });
}

