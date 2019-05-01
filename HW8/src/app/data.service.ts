import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';
import * as _ from 'lodash';
import { Location } from './location';
import { HttpClient } from '@angular/common/http';
@Injectable({
  providedIn: 'root'
})
export class DataService {
  public formData = new BehaviorSubject<any>('');
  private loc = new BehaviorSubject<any>('');
  private loading = new BehaviorSubject<any>('');
  public searchResultsSubject = new BehaviorSubject<any>('');
  public wishlistSubject = new BehaviorSubject([]);
  // host = '';
  host = 'http://localhost:3000';
  currentData = this.formData.asObservable();
  currentLoad = this.loading.asObservable();
  currentLoc = this.loc.asObservable();
  public servicesIsBusy = false;
  public row = [];
  public wishlistrow = [];
  public currentSearchId = [];
  public currentTitle = [];
  public currentSearchResult = {};
  constructor(private http: HttpClient) {
    this.InitializeWishlist();
  }
  public changeLoc(loc) {
    this.loc.next(loc);
  }
  public changeLoad(load) {
    this.loading.next(load);
  }
  public clearData() {
    this.formData.next('');
    this.searchResultsSubject.next('');
  }
  private GetWishlist() {
    return JSON.parse(localStorage.getItem('wishlist'));
  }

  private SetWishlist(wishlist: any[]) {
    localStorage.setItem('wishlist', JSON.stringify(wishlist));
    this.wishlistSubject.next(wishlist);
  }

  private InitializeWishlist() {
    if (_.isEmpty(this.GetWishlist())) {
      this.SetWishlist([]);
    } else {
      this.SetWishlist(this.GetWishlist());
    }
  }

  WishlistEmpty() {
    return _.isEmpty(JSON.parse(localStorage.getItem('wishlist')));
  }

  Wishlisted(row) {
    const wishlist = this.GetWishlist();
    const index = this.isWished(row);
    if (index) {
      wishlist.splice(index - 1, 1);
      this.wishlistrow = [];
    } else {
      wishlist.push(row);
    }
    this.SetWishlist(wishlist);
  }

  isWished(row) {
    const wishlist = this.GetWishlist();
    for (let i = 0; i < wishlist.length; i++) {
      if (_.isEqual(wishlist[i], row)) {
        return i + 1;
      }
    }
    return 0;
  }

  public getCurrentLoc() {
    return this.http.get<Location>('http://ip-api.com/json');
  }
  public changeData(data) {
    this.formData.next(data);
  }
  public getSearchResult(formData: any) {
    return this.http.post(this.host + '/search', formData);
  }
  public getDetails(row) {
    this.currentSearchId = row.itemId;
    this.currentTitle = row.title;
    this.currentSearchResult = row;
  }
  public DetailsInfo(id) {
    return this.http.get(this.host + '/itemdetails?id=' + id);
  }

  public getSimilar(id) {
    return this.http.get(this.host + '/similar?id=' + id);
  }
  public getGooglePhoto(title) {
    return this.http.get(this.host + '/photos?title=' + title);
  }
  public getSuggestions(locationKey: string) {
    return this.http.get(this.host + '/suggestion?locationKey=' + locationKey);
  }

  IsEmpty(data) {
    return _.isEmpty(data);
  }
}
