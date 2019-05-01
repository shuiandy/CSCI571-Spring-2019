import { HttpClientModule } from '@angular/common/http';
import { NgModule } from '@angular/core';
import { NgbModule } from '@ng-bootstrap/ng-bootstrap';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import {
  MatButtonModule,
  MatFormFieldModule,
  MatInputModule,
  MatListModule,
  MatCheckboxModule,
  MatPaginatorModule,
  MatTooltipModule,
  MatTabsModule,
  MatTableModule,
  MatAutocompleteModule,
  MatRippleModule
} from '@angular/material';
import { RoundProgressModule } from 'angular-svg-round-progressbar';
import { BrowserModule } from '@angular/platform-browser';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { SearchFormComponent } from './search-form/search-form.component';
import { ShowResultComponent } from './show-result/show-result.component';
import { ShowDetailComponent } from './show-detail/show-detail.component';
import { NoResultsComponent } from './no-results/no-results.component';
import { WishlistComponent } from './wishlist/wishlist.component';

@NgModule({
  declarations: [
    AppComponent,
    ShowResultComponent,
    SearchFormComponent,
    ShowDetailComponent,
    NoResultsComponent,
    WishlistComponent
  ],
  imports: [
    BrowserModule,
    FormsModule,
    NgbModule,
    RoundProgressModule,
    HttpClientModule,
    ReactiveFormsModule,
    MatTableModule,
    BrowserAnimationsModule,
    AppRoutingModule,
    MatTooltipModule,
    MatTabsModule,
    MatButtonModule,
    MatListModule,
    MatCheckboxModule,
    MatPaginatorModule,
    MatAutocompleteModule,
    MatFormFieldModule,
    MatInputModule,
    MatRippleModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule {}
