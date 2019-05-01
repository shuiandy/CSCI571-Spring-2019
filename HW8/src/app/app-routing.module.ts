import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { ShowResultComponent } from './show-result/show-result.component';
import { ShowDetailComponent } from './show-detail/show-detail.component';
import { WishlistComponent } from './wishlist/wishlist.component';
const routes: Routes = [
  {
    path: '',
    redirectTo: '/',
    pathMatch: 'full'
  },
  {
    path: 'show-result',
    component: ShowResultComponent,
    data: { animation: 'ShowResult' }
  },
  {
    path: 'show-detail',
    component: ShowDetailComponent,
    data: { animation: 'Detail' }
  },
  {
    path: 'wishlist',
    component: WishlistComponent,
    data: { animation: 'Wishlist' }
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule {}
