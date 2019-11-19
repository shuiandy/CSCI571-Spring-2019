const express = require("express");
const app = express();
const request = require("request");
const path = require("path");
const port = process.env.PORT || 3000;
const bodyParser = require("body-parser");
const ebay_api_key = "";
const google_search_engine = "";
const google_api_key = "";
const categoryDict = {
  "All Categories": "",
  Art: "550",
  Baby: "2984",
  Books: "267",
  "Clothing, Shoes & Accessories": "11450",
  "Computers/Tablets & Networking": "58058",
  "Health & Beauty": "26395",
  Music: "11233",
  "Video Games & Consoles": "1249"
};

app.use(express.static(__dirname));
app.use(function(req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header(
    "Access-Control-Allow-Headers",
    "Origin, X-Requested-With, Content-Type, Accept, Origin"
  );
  next();
});
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.get("/", (req, res) => res.sendFile(path.join(__dirname)));
app.listen(port);
app.get("/suggestion", function(req, res) {
  var locationKey = req.query.locationKey;
  var url =
    "http://api.geonames.org/postalCodeSearchJSON?postalcode_startsWith=" +
    locationKey +
    "&username=shuiandy&country=US&maxRows=5";
  request(
    {
      url: url,
      json: true
    },
    function(err, response, body) {
      if (response.statusCode === 200) {
        if (
          body.postalCodes != null &&
          body.postalCodes[0] != null &&
          body.postalCodes[0].postalCode != null
        ) {
          const result = [];
          var arr = body.postalCodes;
          arr.forEach(function(arr) {
            result.push(arr.postalCode);
          });
          res.send(result);
        } else {
          res.send("");
        }
      }
    }
  );
});

app.post("/search", function(req, res) {
  var i = 1;
  var keyword = req.body.keyword,
    category = req.body.category,
    conditions = req.body.conditions,
    shipping = req.body.shipping,
    location = req.body.location,
    condition = "",
    local = "",
    free = "",
    zip_code = "";

  if (category === "All Categories") {
    category = "";
  } else {
    category = "&categoryId=" + categoryDict[category];
  }

  if (shipping) {
    if (shipping[0] === false && shipping[1] === false) {
      local = "";
      free = "";
    } else {
      if (shipping[0] === true) {
        local =
          "&itemFilter(" +
          i +
          ").name=LocalPickupOnly&itemFilter(" +
          i++ +
          ").value=true";
      }
      if (shipping[1] === true) {
        free =
          "&itemFilter(" +
          i +
          ").name=FreeShippingOnly&itemFilter(" +
          i++ +
          ").value=true";
      }
    }
  }
  if (conditions) {
    if (
      conditions[0] === false &&
      conditions[1] === false &&
      conditions[2] === false
    ) {
      condition = "";
    } else {
      var j = 0;
      condition = "&itemFilter(" + i + ").name=Condition";
      if (conditions[0] === true) {
        condition += "&itemFilter(" + i + ").value(" + j++ + ")=New";
      }
      if (conditions[1] === true) {
        condition += "&itemFilter(" + i + ").value(" + j++ + ")=Used";
      }
      if (conditions[2] === true) {
        condition += "&itemFilter(" + i + ").value(" + j++ + ")=Unspecified";
      }
      i++;
    }
  }
  var distanceinput = req.body.distance === "" ? "10" : req.body.distance;
  var distance =
    "&itemFilter(" +
    i +
    ").name=MaxDistance&itemFilter(" +
    i++ +
    ").value=" +
    distanceinput;
  if (location === "other") {
    zip_code = "&buyerPostalCode=" + req.body.locationKey;
  } else {
    zip_code = "&buyerPostalCode=" + req.body.zip;
  }

  var search_url =
    "http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsAdvanced&SERVICE-VERSION=1.0.0&SECURITY-APPNAME=" +
    ebay_api_key +
    "&RESPONSE-DATA-FORMAT=JSON&REST-PAYLOAD&keywords=" +
    keyword +
    "&paginationInput.entriesPerPage=50" +
    category +
    "&itemFilter(0).name=HideDuplicateItems&itemFilter(0).value=true" +
    local +
    free +
    condition +
    distance +
    "&outputSelector(0)=SellerInfo&outputSelector(1)=StoreInfo" +
    zip_code;
  getSearchResult(search_url, res);
});

app.get("/itemdetails", function(req, res) {
  var itemid = req.query.id;
  var detail_url =
    "http://open.api.ebay.com/shopping?callname=GetSingleItem&responseencoding=JSON&appid=" +
    ebay_api_key +
    "&siteid=0&version=967&ItemID=" +
    itemid +
    "&IncludeSelector=Description,Details,ItemSpecifics";
  getDetails(detail_url, res);
});
app.get("/similar", function(req, res) {
  var itemid = req.query.id;
  var similar_url =
    "http://svcs.ebay.com/MerchandisingService?OPERATION-NAME=getSimilarItems&SERVICE-NAME=MerchandisingService&SERVICE-VERSION=1.1.0&CONSUMER-ID=" +
    ebay_api_key +
    "&RESPONSE-DATA-FORMAT=JSON&REST-PAYLOAD&itemId=" +
    itemid +
    "&maxResults=20";
  getSimilar(similar_url, res);
});

app.get("/photos", function(req, res) {
  var title = encodeURI(req.query.title);
  var photo_url =
    "https://www.googleapis.com/customsearch/v1?q=" +
    title +
    "&cx=" +
    google_search_engine +
    "&imgSize=huge&imgType=news&num=8&searchType=image&key=" +
    google_api_key;
  getPhoto(photo_url, res);
});

function getSearchResult(search_url, res) {
  request(
    {
      url: search_url,
      json: true
    },
    function(err, response, body) {
      if (response.statusCode === 200) {
        if (
          body.findItemsAdvancedResponse &&
          body.findItemsAdvancedResponse[0] != null &&
          body.findItemsAdvancedResponse[0].searchResult &&
          body.findItemsAdvancedResponse[0].searchResult[0].item != null
        ) {
          const results = [];
          var i = 0;
          var arr = body.findItemsAdvancedResponse[0].searchResult[0].item;
          arr.forEach(function(arr) {
            arr.wishlist = false;
            results.push({
              index: i++,
              itemId: arr.itemId,
              image: arr.galleryURL,
              link: arr.viewItemURL,
              title: arr.title,
              price: arr.sellingStatus[0].currentPrice[0].__value__,
              shipping: arr.shippingInfo[0].shippingType,
              return: arr.returnsAccepted,
              zip: arr.postalCode,
              seller: arr.sellerInfo[0].sellerUserName,
              wishlist: arr.wishlist,

              shippingcost:
                arr.shippingInfo[0].shippingServiceCost[0].__value__ === "0.0"
                  ? "Free Shipping"
                  : "$" + arr.shippingInfo[0].shippingServiceCost[0].__value__,
              shippinglocation: arr.shippingInfo[0].shipToLocations
                ? arr.shippingInfo[0].shipToLocations
                : "",
              handlingtime: arr.shippingInfo[0].handlingTime,
              expeditedshipping: arr.shippingInfo[0].expeditedShipping,
              oneday: arr.shippingInfo[0].oneDayShippingAvailable,

              feedbackscore: arr.sellerInfo[0].feedbackScore,
              popularity: arr.sellerInfo[0].positiveFeedbackPercent,
              feedbackrating: arr.sellerInfo[0].feedbackRatingStar,
              toprated: arr.sellerInfo[0].topRatedSeller,
              storename: arr.storeInfo ? arr.storeInfo[0].storeName : "",
              buyat: arr.storeInfo ? arr.storeInfo[0].storeURL : ""
            });
          });

          res.send(results);
        } else {
          res.send("");
        }
      }
    }
  );
}
function getDetails(detail_url, res) {
  request(
    {
      url: detail_url,
      json: true
    },
    function(err, response, body) {
      if (response.statusCode === 200) {
        if (body.Ack === "Success" && body.Item != null) {
          const details = [];
          var arr = body.Item;
          details.push({
            title: arr.Title,
            images: arr.PictureURL,
            subtitle: arr.Subtitle,
            price: arr.CurrentPrice.Value,
            location: arr.Location,
            return: arr.ReturnPolicy.ReturnsAccepted,
            specific: arr.ItemSpecifics
          });
          res.send(details);
        } else {
          res.send("");
        }
      }
    }
  );
}
function getSimilar(similar_url, res) {
  request(
    {
      url: similar_url,
      json: false
    },
    function(err, response, body) {
      if (response.statusCode === 200) {
        body = JSON.parse(body);
        if (
          body.getSimilarItemsResponse.ack === "Success" &&
          body.getSimilarItemsResponse.itemRecommendations.item !== null
        ) {
          const similar = [];
          var arr = body.getSimilarItemsResponse.itemRecommendations.item;
          arr.forEach(function(arr) {
            let times = "";
            if (arr.timeLeft) {
              for (var i = 0; i < arr.timeLeft.length; i++) {
                if (arr.timeLeft.charAt(i) === "P") {
                  for (var j = i + 1; j < arr.timeLeft.length; j++) {
                    if (arr.timeLeft.charAt(j) === "D") {
                      times = arr.timeLeft.substring(i + 1, j);
                      break;
                    }
                  }
                  break;
                }
              }
            } else {
              times = "";
            }
            similar.push({
              itemid: arr.itemId,
              image: arr.imageURL,
              title: arr.title,
              link: arr.viewItemURL,
              price: arr.buyItNowPrice.__value__,
              cost: arr.shippingCost.__value__,
              time: times
            });
          });
          res.send(similar);
        } else {
          res.send("");
        }
      }
    }
  );
}
function getPhoto(photo_url, res) {
  request(
    {
      url: photo_url,
      json: true
    },
    function(err, response, body) {
      if (response.statusCode === 200) {
        if (body.items) {
          const photos = [];
          let arr = body.items;
          arr.forEach(function(arr) {
            photos.push({
              photo: arr.link
            });
          });
          res.send(photos);
        } else {
          res.send("");
        }
      }
    }
  );
}
