import { Component, OnInit } from '@angular/core';
import { DataService } from '../data.service';
import { ActivatedRoute, Router } from '@angular/router';
import * as _ from 'lodash';
@Component({
  selector: 'app-wishlist',
  templateUrl: './wishlist.component.html',
  styleUrls: ['./wishlist.component.css']
})
export class WishlistComponent implements OnInit {
  loading = false;
  wishlists;
  loc = false;
  constructor(
    public dataService: DataService,
    private router: Router,
    private route: ActivatedRoute
  ) {}

  ngOnInit() {
    if (this.wishlists !== '') {
      this.dataService.wishlistSubject
        .asObservable()
        .subscribe((response: any[]) => {
          this.wishlists = response;
        });
    }
  }

  ShowDetails(wishlist) {
    this.dataService.wishlistrow = wishlist;
    this.router.navigate(['show-detail', { loc: 'wishlist' }], {
      queryParams: wishlist,
      skipLocationChange: true
    });
  }
  DisplayDetail(res: string) {
    for (let i = 35; i < res.length; i++) {
      if (res[i] === ' ') {
        return res.substring(0, i) + '...';
      }
    }
    return res;
  }
  getTotal() {
    let totalPrice = 0;
    for (const arr of this.wishlists) {
      totalPrice += Number(arr.price);
    }
    return totalPrice;
  }
  isEmpty() {
    return this.dataService.WishlistEmpty();
  }
  HasSelectedResult() {
    return _.isEmpty(this.dataService.wishlistrow);
  }
  goForward(loc) {
    this.router.navigate(['show-detail', { loc }], {
      queryParams: this.dataService.wishlistrow,
      skipLocationChange: true
    });
  }
}
