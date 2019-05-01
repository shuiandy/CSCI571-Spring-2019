import { Component, OnInit } from '@angular/core';
import { DataService } from '../data.service';
import { ActivatedRoute, Router } from '@angular/router';
import * as _ from 'lodash';
import {
  trigger,
  state,
  transition,
  animate,
  style
} from '@angular/animations';

@Component({
  selector: 'app-show-detail',
  templateUrl: './show-detail.component.html',
  styleUrls: ['./show-detail.component.css'],
  animations: [
    trigger('openClose', [
      // ...
      state(
        'open',
        style({
          opacity: 1,
          display: 'block'
        })
      ),
      state(
        'closed',
        style({
          opacity: 0,
          display: 'none'
        })
      ),
      transition('open => closed', [animate('0.2s ease-in-out')]),
      transition('closed => open', [animate('0.5s ease-in-out')])
    ]),
    trigger('fadeInOut', [
      transition(':enter', [
        style({ opacity: 0 }),
        animate('5s', style({ opacity: 1 }))
      ]),
      transition(':leave', [animate('5s', style({ opacity: 0 }))])
    ])
  ]
})
export class ShowDetailComponent implements OnInit {
  results;
  itemName = '';
  itemId = '';
  loading = false;
  // Photos
  image = {};
  haveimage = false;
  loc;
  link = '';

  // ProductDetails

  images = '';
  subtitle = '';
  price = '';
  local = '';
  return = '';
  specific = [];
  detailEmpty = false;

  // ShippingDetails

  cost = '';
  location = '';
  time = '';
  expedited = false;
  oneday = false;
  returnable = false;
  shipEmpty = true;

  // Sellers

  seller = '';
  score = '';
  popular = '';
  rating = '';
  ratingcolor = '';

  toprated = false;
  top = '';
  storename = '';
  buyat = '';
  haveseller = false;

  // Similars

  similars: any;
  show = 'Show More';
  defaultSimilars: any;
  currentCategory = 'default';
  order = 1;
  similarLoad = false;

  constructor(
    public dataService: DataService,
    private router: Router,
    private route: ActivatedRoute
  ) {}

  Facebook() {
    this.link = this.results.link;
    const URL = 'https://www.facebook.com/sharer/sharer?u=';
    const link =
      this.link +
      '&quote=Buy ' +
      this.itemName +
      ' at $' +
      this.price +
      ' from link blow';
    return encodeURI(URL + link);
  }

  ngOnInit() {
    this.dataService.currentLoad.subscribe(
      data => (this.loading = data === 'loading')
    );

    this.route.queryParams.subscribe(queryParams => {
      this.itemName = queryParams.title[0];
      this.itemId = queryParams.itemId[0];
      this.results = queryParams;
    });
    this.getDetails(this.itemId);
    this.getSimilar(this.itemId);
    this.getPhotos(this.itemName);
    this.getSeller();
    this.getShipping();
  }
  getDetails(id) {
    this.dataService.changeLoad('loading');
    this.route.paramMap.subscribe(params => {
      this.loc = params.get('loc');
    });
    this.dataService.DetailsInfo(id).subscribe(temp => {
      let htmltext = '';
      if (temp) {
        if (temp[0].images) {
          this.images = temp[0].images;
          htmltext += '<tr id="rows">';
          htmltext +=
            '<th style="padding:10px; width:25%;" scope="row" id="col-md-3">Product Images</th>';
          htmltext +=
            '<td><a href="#photomodal" data-toggle="modal" data-target="#photomodal">View Product Images Here</a></td>';
          htmltext += '</tr>';
        }
        if (temp[0].subtitle) {
          this.subtitle = temp[0].subtitle;
          htmltext += '<tr id="rows">';
          htmltext +=
            '<th style="padding:10px; width:25%;" scope="row" id="col-md-3">Subtitle</th>';
          htmltext += '<td>' + this.subtitle + '</td>';
          htmltext += '</tr>';
        }
        if (temp[0].price) {
          this.price = temp[0].price;
          htmltext += '<tr id="rows">';
          htmltext +=
            '<th style="padding:10px; width:25%;" scope="row" id="col-md-3">Price</th>';
          htmltext += '<td>$' + this.price + '</td>';
          htmltext += '</tr>';
        }
        if (temp[0].location) {
          this.location = temp[0].location;
          htmltext += '<tr id="rows">';
          htmltext +=
            '<th style="padding:10px; width:25%;" scope="row" id="col-md-3">Location</th>';
          htmltext += '<td>' + this.location + '</td>';
          htmltext += '</tr>';
        }
        if (temp[0].return) {
          this.return = temp[0].return;
          htmltext += '<tr id="rows">';
          htmltext +=
            '<th style="padding:10px; width:25%;" scope="row" id="col-md-3">Return Policy</th>';
          htmltext += '<td>' + this.return + '</td>';
          htmltext += '</tr>';
        }
        if (temp[0].specific) {
          this.specific = temp[0].specific.NameValueList;
          for (const arr of this.specific) {
            htmltext += '<tr id="rows">';
            htmltext +=
              '<th style="padding:10px; width:25%;" scope="row" id="col-md-3">' +
              arr.Name +
              '</th>';
            htmltext += '<td>' + arr.Value[0] + '</td>';
            htmltext += '</tr>';
          }
        }
        document.getElementById('table').innerHTML = htmltext;
      } else {
        this.detailEmpty = true;
      }
    });
  }
  getPhotos(itemName) {
    this.dataService.getGooglePhoto(itemName).subscribe((response: any[]) => {
      this.image = response;
      this.image !== '' && this.image !== null
        ? (this.haveimage = true)
        : (this.haveimage = false);
    });
  }
  getSeller() {
    if (this.results !== null) {
      this.haveseller = true;
      if (this.results.seller) {
        this.seller = this.results.seller.toString().toUpperCase();
      }
      if (this.results.feedbackscore) {
        this.score += this.results.feedbackscore;
      }
      if (this.results.popularity) {
        this.results.popularity[0] === '100.0'
          ? (this.popular = '100')
          : (this.popular = this.results.popularity);
      }
      if (this.results.feedbackrating) {
        this.ratingcolor += this.results.feedbackrating;
        if (this.ratingcolor.includes('Shooting')) {
          this.rating = 'stars';
          this.ratingcolor = this.ratingcolor.replace('Shooting', '');
        } else {
          this.rating = 'star_border';
        }
      }
      if (this.results.toprated[0] === 'true') {
        this.toprated = true;
      }
      if (this.results.storename) {
        this.storename = this.results.storename;
      }
      if (this.results.buyat) {
        this.buyat = this.results.buyat;
      }
    }
  }
  getShipping() {
    if (this.results !== '') {
      if (
        this.results.shippingcost === '0.0' ||
        this.results.shippingcost === 'Free Shipping'
      ) {
        this.cost += 'Free Shipping';
      } else {
        this.cost += this.results.shippingcost;
      }
      if (this.results.shippinglocation) {
        this.local = this.results.shippinglocation[0];
      }
      if (this.results.handlingtime) {
        this.time =
          this.results.handlingtime[0] === '1' ||
          this.results.handlingtime[0] === '0'
            ? this.results.handlingtime[0] + ' Day'
            : this.results.handlingtime[0] + ' Days';
      }
      if (this.results.expeditedshipping) {
        this.results.expeditedshipping[0] === 'true'
          ? (this.expedited = true)
          : (this.expedited = false);
      }
    }
    if (this.results.oneday) {
      this.results.oneday[0] === 'true'
        ? (this.oneday = true)
        : (this.oneday = false);
    }
    if (this.results.return) {
      this.results.return[0] === 'true'
        ? (this.returnable = true)
        : (this.returnable = false);
    }
    this.shipEmpty = false;
    this.dataService.changeLoad('');
  }
  getSimilar(id) {
    this.dataService.getSimilar(id).subscribe((temp: any[]) => {
      this.similars = _.cloneDeep(temp);
      this.defaultSimilars = _.cloneDeep(temp);
      this.currentCategory = 'default';
      this.order = 1;
      this.similarLoad = true;
    });
  }

  isEmpty() {
    return this.haveseller;
  }
  applyColors() {
    const styles = { color: this.ratingcolor, 'font-size': '35px' };
    return styles;
  }
  popValue() {
    const styles = this.popular;
    return styles;
  }
  toggleShow(): void {
    if (this.show === 'Show More') {
      this.show = 'Show Less';
      return;
    }
    this.show = 'Show More';
  }

  Reverse(stringOrder: string) {
    stringOrder === 'ascending' ? (this.order = 1) : (this.order = -1);
    this.Sort(this.currentCategory);
  }

  Sort(category: string) {
    this.currentCategory = category;
    if (category === 'default') {
      this.similars = _.cloneDeep(this.defaultSimilars);
    } else {
      this.similars = this.similars.sort((a: {}, b: {}) => {
        return a[category].localeCompare(b[category]) * this.order;
      });
    }
  }
  goback() {
    if (this.loc === 'results') {
      this.router.navigate(['show-result', { loc: this.loc }], {
        skipLocationChange: true
      });
    } else {
      this.router.navigate(['wishlist', { loc: this.loc }], {
        skipLocationChange: true
      });
    }
  }
}
