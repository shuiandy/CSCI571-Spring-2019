import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ShowResultComponent } from './show-result.component';

describe('ShowResultComponent', () => {
  let component: ShowResultComponent;
  let fixture: ComponentFixture<ShowResultComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ShowResultComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ShowResultComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
