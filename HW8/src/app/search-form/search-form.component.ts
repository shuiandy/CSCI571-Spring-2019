import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators, FormArray } from '@angular/forms';
import { debounceTime } from 'rxjs/operators';
import { DataService } from '../data.service';
import { Location } from '../location';
import { Router } from '@angular/router';
@Component({
  selector: 'app-search-form',
  templateUrl: './search-form.component.html',
  styleUrls: ['./search-form.component.css']
})
export class SearchFormComponent implements OnInit {
  searchForm: FormGroup;
  results;
  options = [];
  constructor(
    private fb: FormBuilder,
    public dataService: DataService,
    private router: Router
  ) {}
  conditionsArr = [
    { selected: false, name: 'New' },
    { selected: false, name: 'Used' },
    { selected: false, name: 'Unspecified' }
  ];
  shippingArr = [
    { selected: false, name: 'Local Pickup' },
    { selected: false, name: 'Free Shipping' }
  ];
  categories = [
    'Art',
    'Baby',
    'Books',
    'Clothing, Shoes & Accessories',
    'Computers/Tablets & Networking',
    'Health & Beauty',
    'Music',
    'Video Games & Consoles'
  ];

  buildconditions(): FormArray {
    const arr = this.conditionsArr.map(condition => {
      return this.fb.control(condition.selected);
    });
    return this.fb.array(arr);
  }
  buildshipping(): FormArray {
    const arr = this.shippingArr.map(ship => {
      return this.fb.control(ship.selected);
    });
    return this.fb.array(arr);
  }
  ngOnInit() {
    this.searchForm = this.fb.group({
      keyword: ['', Validators.required],
      conditions: this.buildconditions(),
      shipping: this.buildshipping(),
      category: ['All Categories'],
      distance: ['', Validators.pattern('^[0-9]*$')],
      location: ['local'],
      zip: [''],
      locationKey: [{ value: '', disabled: true }]
    });
    this.searchForm
      .get('locationKey')
      .valueChanges.pipe(debounceTime(500))
      .subscribe(locationKeyChanged => {
        if (locationKeyChanged !== '') {
          this.dataService
            .getSuggestions(locationKeyChanged)
            .subscribe((data: any[]) => {
              this.options = data;
            });
        }
      });
    this.searchForm.get('location').valueChanges.subscribe(checkedValue => {
      const locationKey = this.searchForm.get('locationKey');
      if (checkedValue === 'local') {
        locationKey.disable();
      } else if (checkedValue === 'other') {
        locationKey.setValidators([
          Validators.required,
          Validators.pattern('^[0-9]{5}(?:-[0-9]{4})?$')
        ]);
        locationKey.enable();
      }
    });

    this.dataService.getCurrentLoc().subscribe((data: Location) => {
      this.searchForm.get('zip').setValue(data.zip);
    });
  }
  get shipping(): FormGroup {
    return this.searchForm.get('shipping') as FormGroup;
  }
  get conditions(): FormGroup {
    return this.searchForm.get('conditions') as FormGroup;
  }
  onSubmit() {
    if (this.searchForm.valid) {
      this.dataService.changeData(this.searchForm.value);
      this.dataService
        .getSearchResult(this.searchForm.value)
        .subscribe(response => {
          this.results = response;
        });
      this.dataService.changeLoc('');
      this.router.navigate(['show-result', { loc: 'result' }], {
        queryParams: this.searchForm.value,
        skipLocationChange: true
      });
    }
  }

  clear() {
    this.dataService.clearData();
    this.router.navigate(['show-result', { loc: 'results' }], {
      skipLocationChange: true
    });
    this.dataService.changeLoc('');
    this.ngOnInit();
    (document.getElementById(
      'locationKey'
    ) as HTMLInputElement).disabled = true;
  }
}
