import { Component, OnInit } from '@angular/core';
import { DataService } from './data.service';
import { slideInAnimation } from './animation';
import { ActivatedRoute, Router, RouterOutlet } from '@angular/router';
@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css'],
  animations: [slideInAnimation]
})
export class AppComponent implements OnInit {
  title = 'HW8';
  loading = false;
  loc = false;
  constructor(
    public dataService: DataService,
    private router: Router,
    private route: ActivatedRoute
  ) {}
  ngOnInit() {
    this.dataService.currentLoc.subscribe(
      data => (this.loc = data === 'wishlist')
    );
    this.dataService.currentLoad.subscribe(
      data => (this.loading = data === 'loading')
    );
  }
  prepareRoute(outlet: RouterOutlet) {
    return (
      outlet &&
      outlet.activatedRouteData &&
      outlet.activatedRouteData.animation
    );
  }

  showList(loc) {
    this.loc = loc === 'wishlist';
    if (!this.loc) {
      this.router.navigate(['show-result', { loc }], {
        skipLocationChange: true
      });
    } else {
      this.router.navigate(['wishlist', { loc }], {
        skipLocationChange: true
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
  isEmpty() {
    return this.dataService.WishlistEmpty();
  }
}
