import { TestBed, async } from '@angular/core/testing';
import { RouterTestingModule } from '@angular/router/testing';
import { AppComponent } from './app.component';
import { DataService } from './data.service';
import { WishlistComponent } from './wishlist/wishlist.component';
import { NoResultsComponent } from './no-results/no-results.component';
import { ShowDetailComponent } from './show-detail/show-detail.component';
import { ShowResultComponent } from './show-result/show-result.component';
import { SearchFormComponent } from './search-form/search-form.component';

describe('AppComponent', () => {
  beforeEach(async(() => {
    TestBed.configureTestingModule({
      imports: [RouterTestingModule],
      declarations: [
        AppComponent,
        WishlistComponent,
        NoResultsComponent,
        ShowDetailComponent,
        DataService,
        ShowResultComponent,
        SearchFormComponent
      ]
    }).compileComponents();
  }));

  it('should create the app', () => {
    const fixture = TestBed.createComponent(AppComponent);
    const app = fixture.debugElement.componentInstance;
    expect(app).toBeTruthy();
  });

  it(`should have as title 'HW8'`, () => {
    const fixture = TestBed.createComponent(AppComponent);
    const app = fixture.debugElement.componentInstance;
    expect(app.title).toEqual('HW8');
  });

  it('should render title in a h1 tag', () => {
    const fixture = TestBed.createComponent(AppComponent);
    fixture.detectChanges();
    const compiled = fixture.debugElement.nativeElement;
    expect(compiled.querySelector('h1').textContent).toContain(
      'Welcome to HW8!'
    );
  });
});
