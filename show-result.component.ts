import { Component, OnInit } from '@angular/core';
import { DataService } from '../data.service';
import { ActivatedRoute, Router } from '@angular/router';
import * as _ from 'lodash';
@Component({
  selector: 'app-show-result',
  templateUrl: './show-result.component.html',
  styleUrls: ['./show-result.component.css']
})
export class ShowResultComponent implements OnInit {
  wishlists;
  formData;
  results;
  page = 1;
  loc;
  error = false;
  pageSize = 10;
  constructor(
    public dataService: DataService,
    private router: Router,
    private route: ActivatedRoute
  ) {}

  ngOnInit() {
    this.route.paramMap.subscribe(params => {
      this.loc = params.get('loc');
    });
    this.dataService.currentData.subscribe(data => {
      this.formData = data;
      if (this.formData !== '') {
        this.dataService.changeLoad('loading');
        this.error = false;
        this.dataService.getSearchResult(this.formData).subscribe(response => {
          this.dataService.searchResultsSubject.next(response);
          this.results = response;
          if (this.results === null) {
            this.error = true;
          }
          this.dataService.changeLoad('');
        });
      } else {
        this.results = null;
      }
    });

    if (this.wishlists !== '') {
      this.dataService.wishlistSubject
        .asObservable()
        .subscribe((response: any[]) => {
          this.wishlists = response;
        });
    }
  }

  DisplayDetail(res: string) {
    for (let i = 35; i < res.length; i++) {
      if (res[i] === ' ') {
        return res.substring(0, i) + '...';
      }
    }
    return res;
  }

  HasSelectedResult() {
    return _.isEmpty(this.dataService.row);
  }
  ShowDetails(row, loc) {
    this.dataService.row = row;
    // this.dataService.getDetails(row);
    this.router.navigate(['show-detail', { loc }], {
      queryParams: row,
      skipLocationChange: true
    });
  }
  goForward(loc) {
    this.router.navigate(['show-detail', { loc }], {
      queryParams: this.dataService.row,
      skipLocationChange: true
    });
  }
}
